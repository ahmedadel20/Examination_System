CREATE OR ALTER PROCEDURE SaveStudentAnswer
    @StudentID INT,
    @Exam_ID INT,
    @Answers VARCHAR(MAX)
AS
BEGIN
	DECLARE @StartTime DATETIME;
	DECLARE @EndTime DATETIME;
	DECLARE @NumOfQuestions INT;
	DECLARE @QuestionID INT;

	-- Temporary table to hold answers
    DECLARE @AnswersTable TABLE (Answer VARCHAR(50), RowNum INT);

	DECLARE @QuestionIDs TABLE (QID INT, RowNum INT);

	-- Getting the exam time
	SELECT @StartTime = Start_time, @EndTime = End_time 
    FROM Exam 
    WHERE ID = @Exam_ID;

	-- Check if the student is registered for the exam
    IF NOT EXISTS (SELECT 1 FROM Instructor_Student_Exam WHERE Student_ID = @StudentID AND Exam_ID = @Exam_ID)
    BEGIN
        PRINT 'You are not registered for this Exam.';
        RETURN;
    END

    -- Check if the current time is within the exam time window
    IF GETDATE() NOT BETWEEN @StartTime AND @EndTime
    BEGIN
        PRINT 'The Exam is not currently available.';
        RETURN;
    END

	SELECT @NumOfQuestions = COUNT(ExamID) FROM Exam_Question WHERE ExamID = @Exam_ID

	IF (@NumOfQuestions = 0)
	BEGIN
		PRINT 'This Exam has no questions, wait till the Instructor finishes making this exam';
		RETURN;
	END

	-- The student was able to enter the exam successfully

    PRINT 'You have entered the Exam.';

	-- Split and insert Answers into @AnswersTable with row numbers
    INSERT INTO @AnswersTable (Answer, RowNum)
    SELECT TRIM(value) AS Answer, ROW_NUMBER() OVER (ORDER BY (SELECT 1))
    FROM STRING_SPLIT(@Answers, ',') AS s;

    -- Insert Question IDs into @QuestionIDs with row numbers
    INSERT INTO @QuestionIDs (QID, RowNum)
    SELECT QuestionID, ROW_NUMBER() OVER (ORDER BY QuestionID)
    FROM Exam_Question
    WHERE ExamID = @Exam_ID;

    -- Ensure the number of answers matches the number of questions
    IF (SELECT COUNT(*) FROM @AnswersTable) != (SELECT COUNT(*) FROM @QuestionIDs)
    BEGIN
        PRINT 'The number of answers does not match the number of questions.';
        RETURN;
    END

    -- Insert answers into Student_Answer table with correct Question_ID
    INSERT INTO Student_Answer (Student_ID, Exam_ID, Question_ID, Answer)
    SELECT @StudentID, @Exam_ID, q.QID, a.Answer
    FROM @AnswersTable AS a
    JOIN @QuestionIDs AS q ON a.RowNum = q.RowNum;

    PRINT 'Answers saved successfully.';

END;
GO