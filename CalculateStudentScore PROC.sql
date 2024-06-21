CREATE OR ALTER PROCEDURE CalculateStudentScore
    @StudentID INT,
    @ExamID INT,
    @TotalScore INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    -- Calculate the total score
    SELECT @TotalScore = SUM(eq.Degree)
    FROM Student_Answer sa
    JOIN Exam_Question eq ON sa.Exam_ID = eq.ExamID AND sa.Question_ID = eq.QuestionID
    JOIN Question q ON sa.Question_ID = q.ID
    WHERE sa.Student_ID = @StudentID
      AND sa.Exam_ID = @ExamID
      AND sa.Answer = q.CorrectAnswer;

    -- If there are no answers or no correct answers, set the score to 0
    IF @TotalScore IS NULL
    BEGIN
        SET @TotalScore = 0;
    END

	UPDATE Instructor_Student_Exam SET Score = @TotalScore WHERE Exam_ID = @ExamID AND Student_ID = @StudentID

    PRINT 'Total Score: ' + CAST(@TotalScore AS VARCHAR(10));
END;
GO