-- Exemple de requêtes valides
UPDATE Employees 
SET salary = 50000 
WHERE employee_id = 123;

SELECT id, name, department 
FROM Employees 
WHERE department = 'IT';

CREATE PROCEDURE UpdateSalary
    @EmployeeId INT,
    @NewSalary DECIMAL(10,2)
AS
BEGIN
    UPDATE Employees 
    SET salary = @NewSalary 
    WHERE employee_id = @EmployeeId;
END;
