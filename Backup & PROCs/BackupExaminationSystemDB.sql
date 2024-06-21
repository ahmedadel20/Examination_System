CREATE PROCEDURE BackupExaminationSystemDB
AS
BEGIN
    DECLARE @BackupPath NVARCHAR(255);
    SET @BackupPath = N'C:\Backups\Examination_System_DB_' + CONVERT(NVARCHAR(20), GETDATE(), 112) + '.bak';

    BACKUP DATABASE [Examination_System_DB]
    TO DISK = @BackupPath
    WITH FORMAT,
         NAME = N'Full Backup of Examination_System_DB';

    PRINT 'Backup completed successfully.';
END;
GO