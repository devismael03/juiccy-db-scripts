DECLARE @TableName NVARCHAR(128);
DECLARE @IndexName NVARCHAR(128);
DECLARE @Fragmentation FLOAT;
DECLARE @SQL NVARCHAR(MAX);

DECLARE IndexCursor CURSOR FOR
SELECT 
    OBJECT_NAME(ips.OBJECT_ID) AS TableName,
    si.name AS IndexName,
    ips.avg_fragmentation_in_percent AS Fragmentation
FROM 
    sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'LIMITED') ips
    INNER JOIN sys.indexes si ON ips.OBJECT_ID = si.OBJECT_ID AND ips.index_id = si.index_id
WHERE 
    ips.avg_fragmentation_in_percent > 5;

OPEN IndexCursor;
FETCH NEXT FROM IndexCursor INTO @TableName, @IndexName, @Fragmentation;

WHILE @@FETCH_STATUS = 0
BEGIN
    IF @Fragmentation >= 30
    BEGIN
        SET @SQL = 'ALTER INDEX ' + QUOTENAME(@IndexName) + ' ON ' + QUOTENAME(@TableName) + ' REBUILD WITH (ONLINE = ON);';
        EXEC sp_executesql @SQL;
    END
    ELSE IF @Fragmentation BETWEEN 5 AND 30
    BEGIN
        SET @SQL = 'ALTER INDEX ' + QUOTENAME(@IndexName) + ' ON ' + QUOTENAME(@TableName) + ' REORGANIZE;';
        EXEC sp_executesql @SQL;
        SET @SQL = 'UPDATE STATISTICS ' + QUOTENAME(@TableName) + ' ' + QUOTENAME(@IndexName) + ';';
        EXEC sp_executesql @SQL;
    END
    ELSE
    BEGIN
        SET @SQL = 'UPDATE STATISTICS ' + QUOTENAME(@TableName) + ' ' + QUOTENAME(@IndexName) + ';';
        EXEC sp_executesql @SQL;
    END

    FETCH NEXT FROM IndexCursor INTO @TableName, @IndexName, @Fragmentation;
END;

CLOSE IndexCursor;
DEALLOCATE IndexCursor;
