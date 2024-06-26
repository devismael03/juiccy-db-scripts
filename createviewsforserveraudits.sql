GO
CREATE VIEW ServerLevelPermissions AS
SELECT sys.server_permissions.class
        , sys.server_permissions.class_desc
        , sys.server_permissions.major_id
        , sys.server_permissions.minor_id
        , sys.server_permissions.grantee_principal_id
        , sys.server_permissions.grantor_principal_id
        , sys.server_permissions.type
        , sys.server_permissions.permission_name
        , sys.server_permissions.state
        , sys.server_permissions.state_desc
        , granteeserverprincipal.name AS grantee_principal_name
        , granteeserverprincipal.type_desc AS grantee_principal_type_desc
        , grantorserverprinicipal.name AS grantor_name
        , CASE 
            WHEN sys.server_permissions.state = N'W'
                THEN N'GRANT'
            ELSE sys.server_permissions.state_desc
            END + N' ' + sys.server_permissions.permission_name COLLATE SQL_Latin1_General_CP1_CI_AS + N' TO ' + QUOTENAME(granteeserverprincipal.name) AS permissionstatement
FROM sys.server_principals AS granteeserverprincipal
INNER JOIN sys.server_permissions
    ON sys.server_permissions.grantee_principal_id = granteeserverprincipal.principal_id
INNER JOIN sys.server_principals AS grantorserverprinicipal
    ON grantorserverprinicipal.principal_id = sys.server_permissions.grantor_principal_id;


GO
CREATE VIEW ServerLevelMemberships AS
SELECT roles.name AS server_role_name
    , roles.principal_id
    , roles.type AS role_type
    , roles.type_desc AS role_type_desc
    , roles.is_fixed_role AS role_is_fixed_role
    , memberserverprincipal.name AS member_principal_name
    , memberserverprincipal.principal_id AS member_principal_id
    , memberserverprincipal.type AS member_principal_type
    , memberserverprincipal.type_desc AS member_principal_type_desc
    , memberserverprincipal.is_fixed_role AS member_is_fixed_role
    , N'ALTER SERVER ROLE ' + QUOTENAME(roles.name) + N' ADD MEMBER ' + QUOTENAME(memberserverprincipal.name) AS AddRoleMembersStatement
FROM sys.server_principals AS roles
INNER JOIN sys.server_role_members
    ON sys.server_role_members.role_principal_id = roles.principal_id
INNER JOIN sys.server_principals AS memberserverprincipal
    ON memberserverprincipal.principal_id = sys.server_role_members.member_principal_id
WHERE roles.type = N'R';


GO

SELECT * FROM ServerLevelMemberships;


SELECT * FROM ServerLevelPermissions;