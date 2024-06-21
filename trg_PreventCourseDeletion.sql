CREATE TRIGGER trg_PreventCourseDeletion
ON Course
INSTEAD OF DELETE
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Exam WHERE Course_ID IN (SELECT ID FROM deleted))
    BEGIN
        RAISERROR ('Cannot delete course with associated exams.', 16, 1);
        ROLLBACK;
        RETURN;
    END

    DELETE FROM Course WHERE ID IN (SELECT ID FROM deleted);
END;
GO