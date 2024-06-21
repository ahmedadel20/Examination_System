CREATE OR ALTER PROCEDURE CreateExam
    @InstructorID INT,
    @CourseID INT,
    @Allowance INT,
    @Intake NVARCHAR(50),
    @Branch NVARCHAR(50),
    @Track NVARCHAR(50),
    @StartTime DATETIME,
    @EndTime DATETIME,
    @ExamType VARCHAR(10)
AS
BEGIN
    DECLARE @InstructorCourseCount INT;

    -- Check if the instructor teaches the course
    SELECT @InstructorCourseCount = COUNT(*)
    FROM Course
    WHERE ID = @CourseID AND Instructor_ID = @InstructorID;

    IF @InstructorCourseCount = 0
    BEGIN
        RAISERROR ('Instructor does not teach this course', 16, 1);
        RETURN;
    END

	IF LOWER(@ExamType) = 'exam'
	BEGIN
		SET @ExamType = 'Exam';
	END
	ELSE IF LOWER(@ExamType) = 'corrective'
	BEGIN
		SET @ExamType = 'Corrective';
	END
	ELSE
	BEGIN
		PRINT 'Please enter a valid Exam Type'
		RETURN;
	END

    -- Create the exam
    INSERT INTO Exam (Intake, Branch, Track, Start_time, End_time, Exam_Type, Course_ID)
    VALUES (@Intake, @Branch, @Track, @StartTime, @EndTime, @ExamType, @CourseID);
END;
GO