CREATE OR ALTER PROCEDURE UpdateExamTime
    @InstructorID INT,
    @ExamID INT,
    @StartTime DATETIME,
    @EndTime DATETIME
AS
BEGIN
    DECLARE @CourseID INT;

    -- Check if the instructor has created the exam through the Course_ID
    SELECT @CourseID = e.Course_ID
    FROM Exam e
    INNER JOIN Course c ON e.Course_ID = c.ID
    WHERE e.ID = @ExamID
      AND c.Instructor_ID = @InstructorID;

    -- If @CourseID is NULL, it means the instructor did not create this exam
    IF @CourseID IS NULL
    BEGIN
        PRINT 'You are not authorized to update this exam.';
        RETURN;
    END

    -- Update the exam start and end times
    UPDATE Exam
    SET Start_time = @StartTime,
        End_time = @EndTime
    WHERE ID = @ExamID;
END