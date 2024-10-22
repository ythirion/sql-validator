-- Exemple de requêtes invalides
UPDATE Customers 
SET status = 'INACTIVE';

SELECT * 
FROM Employees 
WHERE department = 'IT';

CREATE PROCEDURE GetAllData
AS
BEGIN
    SELECT * 
    FROM Employees;
    
    UPDATE UserPreferences 
    SET theme = 'dark';
END;
