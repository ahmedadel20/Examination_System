CREATE OR ALTER PROCEDURE AddRandomQuestionsToExam
    @ExamID INT,
    @NumberOfMCQs INT,
    @NumberOfTrueFalse INT,
    @NumberOfText INT,
    @DegreeMCQ INT,
    @DegreeTrueFalse INT,
    @DegreeText INT
AS
BEGIN
    DECLARE @CurrentDegree INT = 0;
    DECLARE @MaxDegree INT;

    -- Get the Max_Degree from the Course table
    SELECT @MaxDegree = c.Max_Degree
    FROM Exam e
    JOIN Course c ON e.Course_ID = c.ID
    WHERE e.ID = @ExamID;

    -- Temporary table to hold selected question IDs and their types
    CREATE TABLE TempSelectedQuestions (
        QuestionID INT PRIMARY KEY,
        QuestionType VARCHAR(10)
    );

    -- Add MCQs
    INSERT INTO TempSelectedQuestions (QuestionID, QuestionType)
    SELECT TOP (@NumberOfMCQs) ID, 'MCQ'
    FROM Question
    WHERE QuestionType = 'MCQ' AND ID NOT IN (SELECT QuestionID FROM Exam_Question WHERE ExamID = @ExamID)
    ORDER BY NEWID();

    -- Add True/False Questions
    INSERT INTO TempSelectedQuestions (QuestionID, QuestionType)
    SELECT TOP (@NumberOfTrueFalse) ID, 'True/False'
    FROM Question
    WHERE QuestionType = 'True/False' AND ID NOT IN (SELECT QuestionID FROM Exam_Question WHERE ExamID = @ExamID)
    ORDER BY NEWID();

    -- Add Text Questions
    INSERT INTO TempSelectedQuestions (QuestionID, QuestionType)
    SELECT TOP (@NumberOfText) ID, 'Text'
    FROM Question
    WHERE QuestionType = 'Text' AND ID NOT IN (SELECT QuestionID FROM Exam_Question WHERE ExamID = @ExamID)
    ORDER BY NEWID();

    -- Insert questions into Exam_Question with specified degrees
    INSERT INTO Exam_Question (ExamID, QuestionID, Degree)
    SELECT @ExamID, QuestionID,
           CASE
               WHEN QuestionType = 'MCQ' THEN @DegreeMCQ
               WHEN QuestionType = 'True/False' THEN @DegreeTrueFalse
               WHEN QuestionType = 'Text' THEN @DegreeText
           END
    FROM TempSelectedQuestions;

    -- Calculate total degree
    SELECT @CurrentDegree = SUM(Degree) 
    FROM Exam_Question 
    WHERE ExamID = @ExamID;

    IF @CurrentDegree > @MaxDegree
    BEGIN
        RAISERROR ('Total degree exceeds course maximum', 16, 1);
        RETURN;
    END

    -- Cleanup
    DROP TABLE TempSelectedQuestions;
END;
GO