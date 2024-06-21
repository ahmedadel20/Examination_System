CREATE OR ALTER PROCEDURE ViewExamQuestions
	@StudentID INT,
    @ExamID INT
AS
BEGIN
	DECLARE @NumOfQuestions INT;
	DECLARE @Questions TABLE (Question_ID INT, QuestionText TEXT, QuestionType VARCHAR(10),Degree INT);
	DECLARE @Choices TABLE (Question_ID INT, C_1 TEXT, C_2 TEXT, C_3 TEXT, C_4 TEXT);

	IF NOT EXISTS (SELECT 1 FROM Instructor_Student_Exam WHERE Exam_ID = @ExamID AND Student_ID = @StudentID)
	BEGIN
		PRINT'You are not assigned this exam';
		RETURN;
	END

	SELECT @NumOfQuestions = COUNT(QuestionID) FROM Exam_Question WHERE ExamID = @ExamID

	IF ( @NumOfQuestions = 0)
	BEGIN
		PRINT'This exam does not have questions yet';
	END

	INSERT INTO @Questions(Question_ID, QuestionText, QuestionType ,Degree)
	SELECT eq.QuestionID,q.QuestionText, q.QuestionType, eq.Degree
	FROM Exam_Question eq
	INNER JOIN Question q ON eq.QuestionID = q.ID 
	WHERE eq.ExamID = @ExamID;

	SELECT *
	FROM @Questions


	--Change the DataType TO VARCHAR(MAX)

	INSERT INTO @Choices (Question_ID, C_1, C_2, C_3, C_4)
	SELECT
    q.Question_ID,
    MAX(CASE WHEN c.ChoiceNumber = 1 THEN c.ChoiceText END) AS C_1,
    MAX(CASE WHEN c.ChoiceNumber = 2 THEN c.ChoiceText END) AS C_2,
    MAX(CASE WHEN c.ChoiceNumber = 3 THEN c.ChoiceText END) AS C_3,
    MAX(CASE WHEN c.ChoiceNumber = 4 THEN c.ChoiceText END) AS C_4
	FROM
    @Questions q
    INNER JOIN Choice c ON q.Question_ID = c.Question_ID
	WHERE
    q.QuestionType = 'MCQ'
	GROUP BY
    q.Question_ID;

-- Select to verify the result
	SELECT * FROM @Choices;

	--SELECT ID, ChoiceText
	--FROM @Questions qs
	--INNER JOIN Question q
	--ON qs.Question_ID = q.ID
	--INNER JOIN Choice c ON c.ChoiceID = q.ID
	--WHERE qs.QuestionType = 'MCQ'

END;