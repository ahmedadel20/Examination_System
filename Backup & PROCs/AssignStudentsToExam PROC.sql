CREATE OR ALTER PROCEDURE AssignStudentsToExam
    @ExamID INT,
    @InstructorID INT,
    @StudentIDs VARCHAR(MAX),  -- Comma-separated list of student IDs
    @ExamStartDate DATETIME,
    @ExamEndDate DATETIME
AS
BEGIN
    -- Temporary table to hold selected student IDs
    DECLARE @TempStudentIDs TABLE (StudentID INT);

    -- Insert student IDs into the temporary table
    INSERT INTO @TempStudentIDs (StudentID)
    SELECT value
    FROM STRING_SPLIT(@StudentIDs, ',');

    -- Check if the exam exists
    IF NOT EXISTS (SELECT 1 FROM Exam WHERE ID = @ExamID)
    BEGIN
        RAISERROR ('Exam with the specified ID does not exist.', 16, 1);
        RETURN;
    END

    -- Insert each student into the Instructor_Student_Exam table
    INSERT INTO Instructor_Student_Exam (Instructor_ID, Student_ID, Exam_ID, Exam_Start_Date)
    SELECT @InstructorID, StudentID, @ExamID, @ExamStartDate
    FROM @TempStudentIDs;

    -- Update exam details
    UPDATE Exam
    SET Start_time = @ExamStartDate,
        End_time = @ExamEndDate
    WHERE ID = @ExamID;
END;
GO
