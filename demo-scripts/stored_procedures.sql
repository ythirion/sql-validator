CREATE OR ALTER PROCEDURE UpdateUserSettings
AS
BEGIN
    -- Violation: UPDATE sans WHERE
    UPDATE UserSettings 
    SET LastLoginDate = GETDATE();
    
    -- Violation: Utilisation de wildcard
    SELECT * FROM UserSettings;
    
    -- Requête valide
    SELECT UserId, SettingName, SettingValue 
    FROM UserSettings 
    WHERE UserId > 1000;
END;
GO

CREATE OR ALTER PROCEDURE ProcessDailyMaintenance
    @Department VARCHAR(50)
AS
BEGIN
    -- Violation: UPDATE sans WHERE imbriqué dans une condition
    IF @Department = 'IT'
        UPDATE EmployeeAccess
        SET AccessLevel = 'Standard';
    
    -- Violation: Wildcard dans une sous-requête
    SELECT e.EmployeeId, e.Name,
           (SELECT * 
            FROM EmployeeDetails 
            WHERE EmployeeId = e.EmployeeId) as Details
    FROM Employees e;
END;
GO