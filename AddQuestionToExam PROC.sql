CREATE OR ALTER PROCEDURE AddQuestionToExam
    @ExamID INT,
    @QuestionID INT,
    @Degree INT
AS
BEGIN
    DECLARE @CourseID INT;
    DECLARE @CurrentDegree INT;
	DECLARE @QuestionExists INT;

	IF NOT EXISTS (SELECT 1 FROM Exam WHERE ID = @ExamID)
    BEGIN
        RAISERROR ('Exam with the specified ID does not exist', 16, 1);
        RETURN;
    END

    -- Get the course ID associated with the exam
    SELECT @CourseID = Course_ID FROM Exam WHERE ID = @ExamID;

    -- Check current total degree for the exam
    SELECT @CurrentDegree = SUM(Degree) 
    FROM Exam_Question 
    WHERE ExamID = @ExamID;

    -- Check if adding this question exceeds the course maximum degree
    IF (@CurrentDegree + @Degree) > (SELECT Max_Degree FROM Course WHERE ID = @CourseID)
    BEGIN
        RAISERROR ('Adding this question exceeds the course maximum degree', 16, 1);
        RETURN;
    END

	SELECT @QuestionExists = COUNT(ID)
	FROM Question
	WHERE ID = @QuestionID

	IF ( @QuestionExists = 0 )
	BEGIN
		RAISERROR ('This question with this ID does not exist', 16, 1);
        RETURN;
    END

    -- Add the question to the exam
    INSERT INTO Exam_Question (ExamID, QuestionID, Degree)
    VALUES (@ExamID, @QuestionID, @Degree);
END;