-- Violation: UPDATE multi-tables sans WHERE
UPDATE t1 
SET t1.Status = 'Processed'
FROM Table1 t1
JOIN Table2 t2 ON t1.Id = t2.Table1Id;

-- Violation: Wildcard dans une CTE
WITH EmployeeCTE AS (
    SELECT *
    FROM Employees
    WHERE DepartmentId = 5
)
SELECT e.Name, d.DepartmentName
FROM EmployeeCTE e
JOIN Departments d ON e.DepartmentId = d.Id;

-- triggers.sql
CREATE TRIGGER AfterInsertEmployee
ON Employees
AFTER INSERT
AS
BEGIN
    -- Violation: UPDATE sans WHERE dans un trigger
    UPDATE EmployeeAudit
    SET LastModified = GETDATE();
    
    -- Violation: Wildcard dans une jointure
    SELECT i.*, d.*
    FROM inserted i
    JOIN Departments d ON i.DepartmentId = d.Id;
END;
GO