CREATE DATABASE SIMS_DB;
GO
USE SIMS_DB;
GO

-- 1. Bảng Khoa (Department)
CREATE TABLE Departments (
    Id INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(100) NOT NULL -- Khoa CNTT, Khoa Kinh tế
);

-- 2. Bảng Môn học (Subject)
CREATE TABLE Subjects (
    Id INT PRIMARY KEY IDENTITY(1,1),
    SubjectCode NVARCHAR(20) UNIQUE, -- CS101
    Title NVARCHAR(200) NOT NULL,    -- Lập trình cơ bản
    Credits INT DEFAULT 3,
    DepartmentId INT FOREIGN KEY REFERENCES Departments(Id)
);

-- 3. Bảng Giảng viên (Faculty)
CREATE TABLE Faculties (
    Id INT PRIMARY KEY IDENTITY(1,1),
    FacultyCode NVARCHAR(20) UNIQUE, -- GV001
    FullName NVARCHAR(100),
    Email NVARCHAR(100),
    UserId NVARCHAR(450), -- Liên kết với Identity User
    DepartmentId INT FOREIGN KEY REFERENCES Departments(Id)
);

-- 4. Bảng Lớp học phần (Course Instance)
CREATE TABLE Courses (
    Id INT PRIMARY KEY IDENTITY(1,1),
    CourseCode NVARCHAR(50) UNIQUE, -- LTCB-SP20-01
    SubjectId INT FOREIGN KEY REFERENCES Subjects(Id),
    FacultyId INT FOREIGN KEY REFERENCES Faculties(Id),
    Semester NVARCHAR(20) -- SP20, SU20, FA20
);

-- 5. Bảng Sinh viên (Student)
CREATE TABLE Students (
    Id INT PRIMARY KEY IDENTITY(1,1),
    StudentCode NVARCHAR(20) UNIQUE, -- SE001
    FullName NVARCHAR(100),
    UserId NVARCHAR(450), -- Liên kết với Identity User
    DepartmentId INT FOREIGN KEY REFERENCES Departments(Id)
);

-- 6. Bảng Đăng ký môn học (Enrollment) - Quan hệ n-n giữa Student và Course
CREATE TABLE Enrollments (
    StudentId INT FOREIGN KEY REFERENCES Students(Id),
    CourseId INT FOREIGN KEY REFERENCES Courses(Id),
    EnrollDate DATETIME DEFAULT GETDATE(),
    PRIMARY KEY (StudentId, CourseId)
);

-- 7. Bảng Bài tập (Assignment)
CREATE TABLE Assignments (
    Id INT PRIMARY KEY IDENTITY(1,1),
    Title NVARCHAR(200), -- Bài tập 1, Bài tập 2
    MaxPoints FLOAT DEFAULT 10,
    CourseId INT FOREIGN KEY REFERENCES Courses(Id)
);

-- 8. Bảng Điểm (Grade)
CREATE TABLE Grades (
    Id INT PRIMARY KEY IDENTITY(1,1),
    AssignmentId INT FOREIGN KEY REFERENCES Assignments(Id),
    StudentId INT FOREIGN KEY REFERENCES Students(Id),
    Score FLOAT, -- Điểm số (8.5, 9.0)
    UpdatedAt DATETIME DEFAULT GETDATE()
);