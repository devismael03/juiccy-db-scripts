DECLARE @dbName NVARCHAR(255)
DECLARE @sql NVARCHAR(MAX)

-- Cursor to loop through each user database
DECLARE db_cursor CURSOR FOR
SELECT name 
FROM sys.databases 
WHERE name NOT IN ('master', 'tempdb', 'model', 'msdb') 
  AND state_desc = 'ONLINE'

OPEN db_cursor
FETCH NEXT FROM db_cursor INTO @dbName

WHILE @@FETCH_STATUS = 0
BEGIN
    -- Generate the dynamic SQL to create the view
    SET @sql = '
    USE ' + QUOTENAME(@dbName) + ';
    IF OBJECT_ID(''dbo.RoleMemberView'', ''V'') IS NOT NULL
    DROP VIEW dbo.RoleMemberView;
    EXEC(''CREATE VIEW dbo.RoleMemberView AS
    SELECT roles.name AS role_name
        , roles.principal_id
        , roles.type AS role_type
        , roles.type_desc AS role_type_desc
        , roles.is_fixed_role AS role_is_fixed_role
        , memberdatabaseprincipal.name AS member_name
        , memberdatabaseprincipal.principal_id AS member_principal_id
        , memberdatabaseprincipal.type AS member_type
        , memberdatabaseprincipal.type_desc AS member_type_desc
        , memberdatabaseprincipal.is_fixed_role AS member_is_fixed_role
        , memberserverprincipal.name AS member_principal_name
        , memberserverprincipal.type_desc AS member_principal_type_desc
        , N''''ALTER ROLE '''' + QUOTENAME(roles.name) + N'''' ADD MEMBER '''' + QUOTENAME(memberdatabaseprincipal.name) AS AddRoleMembersStatement
    FROM sys.database_principals AS roles
    INNER JOIN sys.database_role_members
        ON sys.database_role_members.role_principal_id = roles.principal_id
    INNER JOIN sys.database_principals AS memberdatabaseprincipal
        ON memberdatabaseprincipal.principal_id = sys.database_role_members.member_principal_id
    LEFT OUTER JOIN sys.server_principals AS memberserverprincipal
        ON memberserverprincipal.sid = memberdatabaseprincipal.sid'')';
    
    -- Execute the dynamic SQL
    EXEC sp_executesql @sql

    FETCH NEXT FROM db_cursor INTO @dbName
END

CLOSE db_cursor
DEALLOCATE db_cursor


SELECT * FROM [report].[dbo].[RoleMemberView];

SELECT * FROM [staging].[dbo].[RoleMemberView];

SELECT * FROM [core].[dbo].[RoleMemberView];