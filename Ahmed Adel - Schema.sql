USE Examination_System_DB

--Training_Manager(ID, Name, Email, Password)

CREATE TABLE Training_Manager(ID INT Primary Key, Name VARCHAR(50), Email VARCHAR(50), Password VARCHAR(50));

--Student(ID, St_Fname, St_Lname, St_Address, St_Age, Track, Branch, Email, Password, Training_Mgr_ID, Dept_ID)

CREATE TABLE Student(ID INT Primary Key, F_Name VARCHAR(25), L_Name VARCHAR(25), Address VARCHAR(25), Age INT, Track VARCHAR(25), Branch VARCHAR(25), Email VARCHAR(50), Password VARCHAR(50), Training_Mgr_ID INT, Dept_ID INT);

--Student_Course(St_ID, Course_ID)

CREATE TABLE Student_Course(St_ID INT, Course_ID INT)

--Instructor_Student_Exam(Inst_ID, St_ID, Exam_ID, Start_Date)

CREATE TABLE Instructor_Student_Exam(Inst_ID INT Primary Key, St_ID INT, Exam_ID INT, Exam_Start_Date DATE)