DECLARE @dbowner NVARCHAR(128);
DECLARE @dbname NVARCHAR(128);
DECLARE @changedDBs NVARCHAR(MAX) = ''; 
DECLARE @changeCount INT = 0;

DECLARE db_cursor CURSOR FOR  
SELECT name 
FROM sys.databases 
WHERE owner_sid != SUSER_SID('sa') AND name NOT IN ('master', 'tempdb', 'model', 'msdb');
OPEN db_cursor;  
FETCH NEXT FROM db_cursor INTO @dbname;  

WHILE @@FETCH_STATUS = 0  
BEGIN  
	EXEC('ALTER AUTHORIZATION ON DATABASE::[' + @dbname + '] TO sa;');
	SET @changedDBs = @changedDBs + @dbname + '; ';
	SET @changeCount = @changeCount + 1;
	FETCH NEXT FROM db_cursor INTO @dbname;  
END;  

CLOSE db_cursor;  
DEALLOCATE db_cursor;

IF @changeCount > 0
BEGIN
	DECLARE @messageBody NVARCHAR(MAX);
	SET @messageBody = CAST(@changeCount AS NVARCHAR) + ' database(s) ownership changed from SA! (but recovered to SA automatically) : ' + @changedDBs;
    

	EXEC msdb.dbo.sp_send_dbmail
        
		@profile_name = 'BhosOutlookProfile', 
		@recipients = 'mamedzade030@gmail.com', 
		@subject = 'Database Ownership Changed!',
        
		@body = @messageBody;

END