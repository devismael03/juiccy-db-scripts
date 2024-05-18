USE [master]
GO

GO
EXEC [core].sys.sp_addextendedproperty @name=N'StorageTier', @value=N'hot' 
GO

GO
EXEC [staging].sys.sp_addextendedproperty @name=N'StorageTier', @value=N'archive' 
GO

GO
EXEC [report].sys.sp_addextendedproperty @name=N'StorageTier', @value=N'cold' 
GO


-- Script to set recovery models based on StorageTier extended property value

DECLARE @DatabaseName NVARCHAR(128);
DECLARE @StorageTier NVARCHAR(128);
DECLARE @SQL NVARCHAR(MAX);

-- Cursor to iterate over the specified databases
DECLARE db_cursor CURSOR FOR
SELECT name 
FROM sys.databases 
WHERE name IN ('core', 'report', 'staging');

OPEN db_cursor;
FETCH NEXT FROM db_cursor INTO @DatabaseName;

WHILE @@FETCH_STATUS = 0
BEGIN
    -- Initialize @StorageTier
    SET @StorageTier = NULL;

    -- Switch context to the target database
    SET @SQL = 'USE [' + @DatabaseName + '];';

    -- Add the SQL to fetch the StorageTier value
    SET @SQL = @SQL + '
    SELECT @StorageTierOUT = CAST(value AS NVARCHAR(128))
    FROM sys.extended_properties
    WHERE class = 0 AND name = ''StorageTier'';';

    -- Prepare a variable to hold the StorageTier value
    DECLARE @StorageTierOUT NVARCHAR(128);

    -- Execute the SQL in the context of the target database
    EXEC sp_executesql @SQL, N'@StorageTierOUT NVARCHAR(128) OUTPUT', @StorageTierOUT OUTPUT;

    -- Set the recovery model based on the StorageTier value
    IF @StorageTierOUT IS NOT NULL
    BEGIN
        IF @StorageTierOUT = 'hot'
        BEGIN
            SET @SQL = 'ALTER DATABASE [' + @DatabaseName + '] SET RECOVERY FULL;';
        END
        ELSE IF @StorageTierOUT IN ('archive', 'cold')
        BEGIN
            SET @SQL = 'ALTER DATABASE [' + @DatabaseName + '] SET RECOVERY SIMPLE;';
        END

        -- Execute the SQL command to set the recovery model
        EXEC sp_executesql @SQL;
    END

    FETCH NEXT FROM db_cursor INTO @DatabaseName;
END

CLOSE db_cursor;
DEALLOCATE db_cursor;
