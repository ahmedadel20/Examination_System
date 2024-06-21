---------- Update Instructor ----------------
EXEC UpdateInstructor
    @ID = 3 ,
    @Name = 'Youssef',
	@Email = 'youssef@gmail.com',
	@Password = '123456',
    @Salary = 4000,
    @Address = 'Heliopolis',
    @Bonus = 3000
----------- Update Exam Time ----------------------------------
EXEC UpdateExamTime
    @InstructorID = 1,
    @ExamID = 1,
	@StartTime = '2024-06-12 11:00:00',
	@EndTime = '2024-06-13 23:00:00'
------------ Save Student Answer ---------------------------------
EXEC SaveStudentAnswer
    @StudentID = 1,
    @Exam_ID  = 1,
    @Answers = 'Paris, Tokyo, Mars, William Shakespeare, Nile, Lenoardo Davinci, Michael Jackson, Anything';
--------------Insert Into Department -----------------------------
EXEC InsertIntoDepartment
    @Name = 'Software Engineering',
	@Track = 'Java-Backend',
	@branch = 'Smart-Village',
	@training_managerID = 1 ,
	@student_ID = 1;
------------- Training Manager Test Insert -----------------------------------------------------
INSERT INTO Training_Manager(Name, Email, Password) VALUES ('Omar', 'omar@gmail.com', '123456');
------------- Insert Student Data --------------------------------------------------------------
INSERT INTO Student(F_Name, L_Name, Address, Age, Track, Branch, Email, Password, Training_Mngr_ID, Dept_ID)
			VALUES ('Ahmed', 'Adel', 'Heliopolis', 24, 'Java-Backend', 'Smart-Village', 'ahmed@gmail.com', '123456', NULL, NULL);

INSERT INTO Student(F_Name, L_Name, Address, Age, Track, Branch, Email, Password, Training_Mngr_ID, Dept_ID)
			VALUES ('Bassant', 'Fakhry', 'Heliopolis', 24, 'DotNet-Backend', 'Smart-Village', 'bassant@gmail.com', '123456', NULL, NULL);

INSERT INTO Student(F_Name, L_Name, Address, Age, Track, Branch, Email, Password, Training_Mngr_ID, Dept_ID)
			VALUES ('Youssef', 'Fawzy', 'Heliopolis', 24, 'React-Frontend', 'Smart-Village', 'youssef@gmail.com', '123456', NULL, NULL);
---------------Delete Course Assigned To Student--------------------------------------------------------------------------------------------------------
EXEC DeleteCourseAssignedToStudent 
	@StudentID = 1,
	@Course_ID = 2
----------------Create Exam--------------------------------------
EXEC CreateExam
    @InstructorID = 2,
    @CourseID = 2,
    @Allowance = 50,
    @Intake = 'Sept 2024',
    @Branch = 'Cairo',
    @Track ='Dotnet - Backend',
    @StartTime = '2024-6-12 21:00:00',
    @EndTime = '2024-6-13 23:00:00',
    @ExamType  ='exam';
-----------------Calculate Student Score in an Exam------------------------------------------------
DECLARE @TotalScore INT;

EXEC CalculateStudentScore @StudentID = 1, @ExamID = 1, @TotalScore = @TotalScore OUTPUT;

PRINT 'The student''s total score is: ' + CAST(@TotalScore AS VARCHAR(10));
------------------Assign Students To Exam------------------------------------------------------------
EXEC AssignStudentsToExam
    @ExamID = 4,
    @InstructorID = 1,
    @StudentIDs = '1, 2, 3'  -- Comma-separated list of student IDs
------------------Assign Course To Student-----------------------------------------------------------
EXEC AssignCourseToStudent 
	@StudentID = 2,
	@Course_ID = 2
-------------------Instructor Adds Random Questions To an Exam----------------------------------------
EXEC AddRandomQuestionsToExam
    @ExamID = 1,
    @NumberOfMCQs  = 1,
    @NumberOfTrueFalse  = 0,
    @NumberOfText  = 0,
	@DegreeMCQ = 5,
    @DegreeTrueFalse = 7,
    @DegreeText = 20;
---------------------Instuctor Adds Question To an Exam manually----------------------------------------------------------------------------------
EXEC AddQuestionToExam
	@ExamID  = 1,
    @QuestionID = 10,
    @Degree = 10
----------------------View Exam Questions---------------------------------------------------
EXEC ViewExamQuestions
	@StudentID = 1,
    @ExamID = 1

----------------------Create an Exam manually--------------------------------------------
EXEC CreateExamManually
	@Instructor_ID = 1,
    @CourseID = 1,
	@Intake = 'Blah',
	@Branch = 'Cairo',
	@Track = 'Java-Backend',
	@Start_Time = '2024-9-20 13:00:00',
	@End_Time = '2024-9-20 16:00:00',
	@Exam_Type = 'corrective',
    @Questions = '[{"QuestionID": 1, "Degree": 10}, {"QuestionID": 3, "Degree": 5}]';

-------------------------------------------------------------------------------------------
--Populate Course
INSERT INTO Course(Course_Name, Min_Degree, Max_Degree, Description, Instructor_ID) VALUES('SQL-Basics', 50, 100, 'This course teaches SQL Basics', 1);
INSERT INTO Course(Course_Name, Min_Degree, Max_Degree, Description, Instructor_ID) VALUES('C#-Basics', 50, 100, 'This course teaches C# Basics', 2);


--Populate Instructor
INSERT INTO Instructor (Name, Email, Password, Salary, Address, Bonus) 
VALUES ('Ahmed', 'ahmed@gmail.com', '123456', 6000, 'Heliopolis', 2000);

INSERT INTO Instructor (Name, Email, Password, Salary, Address, Bonus) 
VALUES ('Bassant', 'bassant@gmail.com', '123456', 7000, 'Heliopolis', 1000);

INSERT INTO Instructor (Name, Email, Password, Salary, Address, Bonus) 
VALUES ('Youssef', 'ahmed@gmail.com', '123456', 4000, 'Heliopolis', 3000);

INSERT INTO Instructor (Name, Email, Password, Salary, Address, Bonus) 
VALUES ('Omar', 'omar@gmail.com', '123456', 10000, 'Heliopolis', 1500);


--Populate Exam
INSERT INTO Exam (Intake, Branch, Track, Start_time, End_time, Exam_Type, Course_ID) VALUES 
(60, 'Sept-2024', 'Cairo', 'Java-Backend', '2024-9-20 13:00:00', '2024-9-20 16:00:00', 'Exam', 1);

INSERT INTO Exam (Intake, Branch, Track, Start_time, End_time, Exam_Type, Course_ID) VALUES 
(60, 'Sept-2024', 'Cairo', 'DotNet Backend', '2024-9-20 15:00:00', '2024-9-20 18:00:00', 'Exam', 2);

INSERT INTO Exam (Intake, Branch, Track, Start_time, End_time, Exam_Type, Course_ID) VALUES
(60, 'Sept-2024', 'Cairo', 'NodeJS Backend', '2024-9-20 15:00:00', '2024-9-20 18:00:00', 'Exam', 2);


--Populate the Questions Table
--CHOICES
INSERT INTO Question (QuestionText, QuestionType, CorrectAnswer) VALUES ('What is the capital of France?', 'MCQ', 'Paris');
INSERT INTO Question (QuestionText, QuestionType, CorrectAnswer) VALUES ('What is the capital city of Japan?', 'MCQ', 'Tokyo');
INSERT INTO Question (QuestionText, QuestionType, CorrectAnswer) VALUES ('Which planet is known as the Red Planet?', 'MCQ', 'Mars');
INSERT INTO Question (QuestionText, QuestionType, CorrectAnswer) VALUES ('Who wrote the play "Romeo and Juliet"?', 'MCQ', 'William Shakespeare');
INSERT INTO Question (QuestionText, QuestionType, CorrectAnswer) VALUES ('Which is the longest river in the world?', 'MCQ', 'Nile');
INSERT INTO Question (QuestionText, QuestionType, CorrectAnswer) VALUES ('What is the smallest continent?', 'MCQ', 'Antarctica');
INSERT INTO Question (QuestionText, QuestionType, CorrectAnswer) VALUES ('Who painted the "Mona Lisa"?', 'MCQ', 'Leonardo da Vinci');
INSERT INTO Question (QuestionText, QuestionType, CorrectAnswer) VALUES ('Who is known as the "King of Pop"?', 'MCQ', 'Michael Jackson');
INSERT INTO Question (QuestionText, QuestionType, CorrectAnswer) VALUES ('What is the value of ? (pi) up to two decimal places?', 'MCQ', '3.14');
INSERT INTO Question (QuestionText, QuestionType, CorrectAnswer) VALUES ('Who was the first President of the United States?', 'MCQ', 'George Washington');

--TRUE / FALSE
INSERT INTO Question (QuestionText, QuestionType, CorrectAnswer) VALUES ('The Earth is the third planet from the Sun.', 'True/False', 'True');
INSERT INTO Question (QuestionText, QuestionType, CorrectAnswer) VALUES ('Water boils at 100 degrees Celsius at sea level.', 'True/False', 'True');
INSERT INTO Question (QuestionText, QuestionType, CorrectAnswer) VALUES ('Cats are herbivores.', 'True/False', 'False');
INSERT INTO Question (QuestionText, QuestionType, CorrectAnswer) VALUES ('The capital of France is Berlin.', 'True/False', 'False');
INSERT INTO Question (QuestionText, QuestionType, CorrectAnswer) VALUES ('A year has 365 days.', 'True/False', 'True');


--Populate the Choices Table
INSERT INTO Choice (Question_ID, ChoiceNumber, ChoiceText) VALUES
(1, 1, 'Berlin'),
(1, 2, 'Paris'),
(1, 3, 'Madrid'),
(1, 4, 'Rome');

INSERT INTO Choice (Question_ID, ChoiceNumber, ChoiceText) VALUES
(2, 1, 'Beijin'),
(2, 2, 'Seoul'),
(2, 3, 'Tokyo'),
(2, 4, 'Bangkok');

INSERT INTO Choice (Question_ID, ChoiceNumber, ChoiceText) VALUES
(3, 1, 'Earth'),
(3, 2, 'Mars'),
(3, 3, 'Jupiter'),
(3, 4, 'Venus');

INSERT INTO Choice (Question_ID, ChoiceNumber, ChoiceText) VALUES
(4, 1, 'William Shakespeare'),
(4, 2, 'Charles Dickens'),
(4, 3, 'Mark Twain'),
(4, 4, 'Jane Austen');

INSERT INTO Choice (Question_ID, ChoiceNumber, ChoiceText) VALUES
(5, 1, 'Amazon'),
(5, 2, 'Yangtze'),
(5, 3, 'Mississipi'),
(5, 4, 'Nile');

INSERT INTO Choice (Question_ID, ChoiceNumber, ChoiceText) VALUES
(6, 1, 'Africa'),
(6, 2, 'Asia'),
(6, 3, 'Australia'),
(6, 4, 'Antarctica');

INSERT INTO Choice (Question_ID, ChoiceNumber, ChoiceText) VALUES
(7, 1, 'Vincent van Gogh'),
(7, 2, 'Pablo Picasso'),
(7, 3, 'Leonardo da Vinci'),
(7, 4, 'Claude Monet');

INSERT INTO Choice (Question_ID, ChoiceNumber, ChoiceText) VALUES
(8, 1, 'Elvis Presley'),
(8, 2, 'Michael Jackson'),
(8, 3, 'Prince'),
(8, 4, 'Freddie Mercury');

INSERT INTO Choice (Question_ID, ChoiceNumber, ChoiceText) VALUES
(9, 1, '2.14'),
(9, 2, '3.14'),
(9, 3, '2.71'),
(9, 4, '2.45');

INSERT INTO Choice (Question_ID, ChoiceNumber, ChoiceText) VALUES
(10, 1, 'Thomas Jefferson'),
(10, 2, 'Abraham Lincoln'),
(10, 3, 'George Washington'),
(10, 4, 'John Adams');
