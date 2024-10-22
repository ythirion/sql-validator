CREATE PROCEDURE DynamicUpdate
    @TableName NVARCHAR(128)
AS
BEGIN
    -- Violation: UPDATE sans WHERE dans du SQL dynamique
    DECLARE @SQL NVARCHAR(MAX)
    SET @SQL = 'UPDATE ' + @TableName + ' SET Status = ''Archived'';'
    EXEC sp_executesql @SQL;
    
    -- Violation: Wildcard dans du SQL dynamique
    SET @SQL = 'SELECT * FROM ' + @TableName;
    EXEC sp_executesql @SQL;
END;
GO