USE Examination_System_DB
---------------------------------
CREATE TABLE Training_Manager(
	ID INT PRIMARY KEY IDENTITY,
	Name VARCHAR(50),
	Email VARCHAR(50) UNIQUE,
	Password VARCHAR(50));

CREATE TABLE Student(
	ID INT PRIMARY KEY IDENTITY,
	F_Name VARCHAR(25),
	L_Name VARCHAR(25),
	Address VARCHAR(50),
	Age INT,
	Track VARCHAR(25),
	Branch VARCHAR(25),
	Email VARCHAR(50) UNIQUE,
	Password VARCHAR(25),
	Training_Mngr_ID INT,
	Dept_ID INT

	--FOREIGN KEY (Training_Mngr_ID) REFERENCES Training_Manager(ID),
	--FOREIGN KEY (Dept_ID) REFERENCES Department(id)
	);

CREATE TABLE Department(
	ID INT PRIMARY KEY IDENTITY, 
	Dept_name VARCHAR (50), 
	Branch VARCHAR(25), 
	Track VARCHAR (25), 
	Training_Mngr_ID INT,
	--Student_ID INT,

	--FOREIGN KEY (Training_Mngr_ID) REFERENCES Training_Manager(ID),
	--FOREIGN KEY (Student_ID) REFERENCES Student(ID)
	);

CREATE TABLE Course(
    ID INT PRIMARY KEY IDENTITY,
    Course_Name NVARCHAR(50) NULL,
    Min_Degree INT NULL,
    Max_Degree INT NULL,
    Description NVARCHAR(50) NULL,
    Instructor_ID INT NULL,
	--Exam_ID INT NULL,

	--FOREIGN KEY (Inst_ID) REFERENCES Instructor(id)
	--FOREIGN KEY (Exam_ID) REFERENCES Exam(ID)
	);

CREATE TABLE Exam(
    ID INT PRIMARY KEY IDENTITY,
    Allowance INT,
    --Total_time NVARCHAR(50) NULL,
    Intake NVARCHAR(50) NULL,
    Branch NVARCHAR(50) NULL,
    Track NVARCHAR(50) NULL,
    Start_time DATETIME NULL,
    End_time DATETIME NULL,
    Exam_Type VARCHAR(10) NOT NULL CHECK (Exam_Type IN ('Corrective', 'Exam')),
	Course_ID INT NULL,
	
	--FOREIGN KEY (Course_ID) REFERENCES Course(id)
	);

CREATE TABLE Instructor(
	ID INT PRIMARY KEY IDENTITY,
	Name VARCHAR(50),
	Email VARCHAR(50) UNIQUE,
	Password VARCHAR(25),
	Salary FLOAT,
	Address VARCHAR(50),
	Bonus FLOAT, 
	--Course_ID INT, 
	--Exam_ID INT,
	
	--FOREIGN KEY (course_id) REFERENCES Course(id),
	--FOREIGN KEY (exam_id) REFERENCES Exam(id)               NOT CORRECT / REMOVED
	);


CREATE TABLE Student_Course(
	Student_ID INT,
	Course_ID INT
	
	--FOREIGN KEY (Student_ID) REFERENCES Student(ID),
	--FOREIGN KEY (Course_ID) REFERENCES Course(id),
	PRIMARY KEY (Student_ID, Course_ID));

CREATE TABLE Instructor_Student_Exam(
	Instructor_ID INT,
	Student_ID INT,
	Exam_ID INT,
	Exam_Start_Date DATE,
	Score INT,
	
	--FOREIGN KEY (Instructor_ID) REFERENCES Instructor(id),
	--FOREIGN KEY (Student_ID) REFERENCES Student(ID),
	--FOREIGN KEY (Exam_ID) REFERENCES Exam(id),
	PRIMARY KEY (Instructor_ID, Student_ID, Exam_ID));

CREATE TABLE Question (
	ID INT PRIMARY KEY IDENTITY,
	QuestionText TEXT,
	QuestionType VARCHAR(10) NOT NULL CHECK (QuestionType IN ('MCQ', 'True/False', 'Text')),
	CorrectAnswer VARCHAR(20));

CREATE TABLE Exam_Question (
    ExamID INT,
    QuestionID INT,
    Degree INT,
    FOREIGN KEY (ExamID) REFERENCES Exam(id),
    FOREIGN KEY (QuestionID) REFERENCES Question(ID),
	PRIMARY KEY(ExamID, QuestionID)
);

--CREATE TABLE Exam_Question (
--    ExamQuestionID INT PRIMARY KEY IDENTITY,
--    ExamID INT,
--    QuestionID INT,
--    Degree INT,
--    FOREIGN KEY (ExamID) REFERENCES Exam(id),
--    FOREIGN KEY (QuestionID) REFERENCES Question(ID)
--);

CREATE TABLE Choice (
    ChoiceID INT PRIMARY KEY IDENTITY,
    Question_ID INT,
    ChoiceNumber TINYINT CHECK (ChoiceNumber BETWEEN 1 AND 4),
    ChoiceText TEXT NOT NULL,
    FOREIGN KEY (Question_ID) REFERENCES Question(ID)
);

CREATE TABLE Student_Answer (
    Student_ID INT,
    Exam_ID INT,
    Question_ID INT,
    Answer VARCHAR(100),
    PRIMARY KEY (Student_ID, Exam_ID, Question_ID),
    FOREIGN KEY (Student_ID) REFERENCES Student(ID),
    FOREIGN KEY (Exam_ID) REFERENCES Exam(ID),
    FOREIGN KEY (Question_ID) REFERENCES Question(ID)
);
-------------------------------------------------------
-------------------------------------------------------
-- Foreign Key References
-------------------------------------------------------
--Student Table FKs

ALTER TABLE Student

ADD CONSTRAINT fk_TrainingMngr_Student
FOREIGN KEY (Training_Mngr_ID) REFERENCES Training_Manager(ID),

CONSTRAINT fk_Department_Student
FOREIGN KEY (Dept_ID) REFERENCES Department(id);


--Department FKs

ALTER TABLE Department

ADD CONSTRAINT fk_TrainingMngr_Department
FOREIGN KEY (Training_Mngr_ID) REFERENCES Training_Manager(ID);

--CONSTRAINT fk_Student_Department
--FOREIGN KEY (Student_ID) REFERENCES Student(ID);


--Course FKs

ALTER TABLE Course

ADD CONSTRAINT fk_Instructor_Course
FOREIGN KEY (Instructor_ID) REFERENCES Instructor(id);

--CONSTRAINT fk_Exam_Course
--FOREIGN KEY (Exam_ID) REFERENCES Exam(ID);


--Exam FKs

ALTER TABLE Exam

ADD CONSTRAINT fk_Course_Exam
FOREIGN KEY (Course_ID) REFERENCES Course(id);


--Student_Course

ALTER TABLE Student_Course

ADD CONSTRAINT fk_Student_Exam
FOREIGN KEY (Student_ID) REFERENCES Student(ID),

CONSTRAINT fk_Course_StudentCourse
FOREIGN KEY (Course_ID) REFERENCES Course(ID);


--Instructor_Student_Exam

ALTER TABLE Instructor_Student_Exam

ADD CONSTRAINT fk_Instructor_InstructorStudentExam
FOREIGN KEY (Instructor_ID) REFERENCES Instructor(ID),

CONSTRAINT fk_Student_InstructorStudentExam
FOREIGN KEY (Student_ID) REFERENCES Student(ID),

CONSTRAINT fk_Exam_InstructorStudentExam
FOREIGN KEY (Exam_ID) REFERENCES Exam(id);

--ALTER TABLE Training_Manager
--ADD CONSTRAINT Unique_Email UNIQUE(Email);

--ALTER TABLE Student
--ADD CONSTRAINT Unique_Student_Email UNIQUE(Email);

--ALTER TABLE Instructor
--ADD CONSTRAINT Unique_Instructor_Email UNIQUE(Email);