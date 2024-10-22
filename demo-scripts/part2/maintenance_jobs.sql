UPDATE LogEntries
SET Processed = 1;

UPDATE AuditTrail
SET ReviewStatus = 'Pending';

UPDATE SystemSettings
SET MaintenanceMode = 0;

-- Violation: Multiples utilisations de wildcard
SELECT * FROM LogEntries WHERE Date > GETDATE() - 30;
SELECT l.*, u.* FROM LogEntries l JOIN Users u ON l.UserId = u.Id;
SELECT * FROM AuditTrail ORDER BY CreatedDate DESC;