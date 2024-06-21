--EXEC CreateExamManually 
--    @CourseID = 101, 
--    @InstructorID = 1, 
--    @Questions = '[{"QuestionID": 1, "Degree": 10.00}, {"QuestionID": 2, "Degree": 5.00}]';

CREATE OR ALTER PROCEDURE CreateExamManually
    @Instructor_ID INT,
    @CourseID INT,
    @Intake VARCHAR(20),
    @Branch VARCHAR(20),
    @Track VARCHAR(20),
    @Start_Time DATETIME,
    @End_Time DATETIME,
    @Exam_Type VARCHAR(20),
    @Questions NVARCHAR(MAX) -- A JSON string with question IDs and degrees
AS
BEGIN
    DECLARE @ExamID INT;
    DECLARE @TotalDegree INT = 0;
    DECLARE @CourseMaxDegree INT;

    -- Check if the instructor teaches this course
    IF NOT EXISTS (
        SELECT 1 
        FROM Course 
        WHERE ID = @CourseID AND Instructor_ID = @Instructor_ID
    )
    BEGIN
        PRINT 'You do not teach this course';
        RETURN;
    END
    
    -- Get the CourseMaxDegree
    SELECT @CourseMaxDegree = Max_Degree 
    FROM Course 
    WHERE ID = @CourseID;
    
    -- Create the Exam
    INSERT INTO Exam (Intake, Branch, Track, Start_time, End_time, Exam_Type, Course_ID) 
    VALUES (@Intake, @Branch, @Track, @Start_Time, @End_Time, @Exam_Type, @CourseID);
    SET @ExamID = SCOPE_IDENTITY();
    
    -- Insert Questions and Calculate Total Degree
    DECLARE @QuestionID INT, @Degree INT;
    DECLARE @QuestionsTable TABLE (QuestionID INT, Degree INT);
    INSERT INTO @QuestionsTable (QuestionID, Degree)
    SELECT QuestionID, Degree 
    FROM OPENJSON(@Questions)
    WITH (QuestionID INT, Degree INT);
    
    DECLARE QuestionCursor CURSOR FOR 
    SELECT QuestionID, Degree FROM @QuestionsTable;
    
    OPEN QuestionCursor;
    FETCH NEXT FROM QuestionCursor INTO @QuestionID, @Degree;
    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @TotalDegree = @TotalDegree + CAST(@Degree AS INT);
        IF @TotalDegree > @CourseMaxDegree
        BEGIN
            RAISERROR('Total degree exceeds course maximum degree.', 16, 1);
            ROLLBACK;
            RETURN;
        END
        INSERT INTO Exam_Question (ExamID, QuestionID, Degree)
        VALUES (@ExamID, @QuestionID, CAST(@Degree AS INT));
        FETCH NEXT FROM QuestionCursor INTO @QuestionID, @Degree;
    END
    
    CLOSE QuestionCursor;
    DEALLOCATE QuestionCursor;
END;
GO

