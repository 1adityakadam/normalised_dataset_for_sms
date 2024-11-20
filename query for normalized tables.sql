CREATE DATABASE IF NOT EXISTS sms;
USE sms;

-- Student_Performance table
CREATE TABLE IF NOT EXISTS Student_Performance (
    Student_ID INT NOT NULL PRIMARY KEY,
    Score INT NOT NULL,
    Study_Hours_Per_Week INT NOT NULL,
    Attendance_Rate INT NOT NULL,
    Assignments_Completed INT NOT NULL
);

-- Student_Background table
CREATE TABLE IF NOT EXISTS Student_Background (
    Student_ID INT NOT NULL PRIMARY KEY,
    Extra_Tutorials VARCHAR(3) NOT NULL,
    Access_To_Learning_Materials VARCHAR(3) NOT NULL,
    Parent_Involvement VARCHAR(10) NOT NULL,
    IT_Knowledge VARCHAR(10) NOT NULL,
    Socioeconomic_Status VARCHAR(10) NOT NULL,
    Parent_Education_Level VARCHAR(10) NOT NULL,
    FOREIGN KEY (Student_ID) REFERENCES Student_Performance(Student_ID)
);

-- Student_Demographics table
CREATE TABLE IF NOT EXISTS Student_Demographics (
    Student_ID INT NOT NULL PRIMARY KEY,
    Age INT NOT NULL,
    Gender VARCHAR(10) NOT NULL,
    FOREIGN KEY (Student_ID) REFERENCES Student_Performance(Student_ID)
);

-- School_Information table
CREATE TABLE IF NOT EXISTS School_Information (
    School_ID INT NOT NULL PRIMARY KEY,
    School_Type VARCHAR(10) NOT NULL,
    School_Location VARCHAR(10) NOT NULL
);

-- Teacher_Information table
CREATE TABLE IF NOT EXISTS Teacher_Information (
    Teacher_ID INT NOT NULL PRIMARY KEY,
    Teacher_Quality INT NOT NULL
);

-- Student_School_Relation table
CREATE TABLE IF NOT EXISTS Student_School_Relation (
    Student_ID INT NOT NULL,
    School_ID INT NOT NULL,
    Distance_To_School DECIMAL(4,1) NOT NULL,
    PRIMARY KEY (Student_ID, School_ID),
    FOREIGN KEY (Student_ID) REFERENCES Student_Performance(Student_ID),
    FOREIGN KEY (School_ID) REFERENCES School_Information(School_ID)
);

-- Student_Teacher_Relation table
CREATE TABLE IF NOT EXISTS Student_Teacher_Relation (
    Student_ID INT NOT NULL,
    Teacher_ID INT NOT NULL,
    PRIMARY KEY (Student_ID, Teacher_ID),
    FOREIGN KEY (Student_ID) REFERENCES Student_Performance(Student_ID),
    FOREIGN KEY (Teacher_ID) REFERENCES Teacher_Information(Teacher_ID)
);

-- Insert data into Student_Performance
INSERT INTO Student_Performance (
    Student_ID,
    Score,
    Study_Hours_Per_Week,
    Attendance_Rate,
    Assignments_Completed
)
SELECT 
    @row_number := @row_number + 1 AS Student_ID,
    192 + (@row_number % 100) AS Score,
    22 + (@row_number % 10) AS Study_Hours_Per_Week,
    78 + (@row_number % 20) AS Attendance_Rate,
    1 + (@row_number % 5) AS Assignments_Completed
FROM 
    (SELECT @row_number := 0) AS init,
    (SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL 
     SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9 UNION ALL SELECT 10) AS t1,
    (SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL 
     SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9 UNION ALL SELECT 10) AS t2,
    (SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL 
     SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9 UNION ALL SELECT 10) AS t3
LIMIT 1000;

-- Insert data into Student_Background
INSERT INTO Student_Background (
    Student_ID,
    Extra_Tutorials,
    Access_To_Learning_Materials,
    Parent_Involvement,
    IT_Knowledge,
    Socioeconomic_Status,
    Parent_Education_Level
)
SELECT 
    Student_ID,
    CASE WHEN Student_ID % 2 = 0 THEN 'Yes' ELSE 'No' END AS Extra_Tutorials,
    CASE WHEN Student_ID % 2 = 0 THEN 'Yes' ELSE 'No' END AS Access_To_Learning_Materials,
    CASE Student_ID % 3
        WHEN 0 THEN 'High'
        WHEN 1 THEN 'Medium'
        ELSE 'Low'
    END AS Parent_Involvement,
    CASE Student_ID % 3
        WHEN 0 THEN 'High'
        WHEN 1 THEN 'Medium'
        ELSE 'Low'
    END AS IT_Knowledge,
    CASE Student_ID % 3
        WHEN 0 THEN 'High'
        WHEN 1 THEN 'Medium'
        ELSE 'Low'
    END AS Socioeconomic_Status,
    CASE Student_ID % 4
        WHEN 0 THEN 'None'
        WHEN 1 THEN 'Primary'
        WHEN 2 THEN 'Secondary'
        ELSE 'Tertiary'
    END AS Parent_Education_Level
FROM Student_Performance;

-- Insert data into Student_Demographics
INSERT INTO Student_Demographics (
    Student_ID,
    Age,
    Gender
)
SELECT 
    Student_ID,
    17 + (Student_ID % 6) AS Age,
    CASE WHEN Student_ID % 2 = 0 THEN 'Male' ELSE 'Female' END AS Gender
FROM Student_Performance;

-- Insert data into School_Information
INSERT INTO School_Information (
    School_ID,
    School_Type,
    School_Location
)
SELECT 
    @row_number := @row_number + 1 AS School_ID,
    CASE WHEN @row_number % 2 = 0 THEN 'Public' ELSE 'Private' END AS School_Type,
    CASE WHEN @row_number % 2 = 0 THEN 'Urban' ELSE 'Rural' END AS School_Location
FROM 
    (SELECT @row_number := 0) AS init,
    (SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5) AS t1
LIMIT 5;

-- Insert data into Teacher_Information
INSERT INTO Teacher_Information (
    Teacher_ID,
    Teacher_Quality
)
SELECT 
    @row_number := @row_number + 1 AS Teacher_ID,
    1 + (@row_number % 5) AS Teacher_Quality
FROM 
    (SELECT @row_number := 0) AS init,
    (SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5) AS t1
LIMIT 5;

-- Insert data into Student_School_Relation
INSERT INTO Student_School_Relation (
    Student_ID,
    School_ID,
    Distance_To_School
)
SELECT 
    sp.Student_ID,
    (sp.Student_ID % 5) + 1 AS School_ID,
    ROUND(12.4 + (sp.Student_ID % 10), 1) AS Distance_To_School
FROM Student_Performance sp;

-- Insert data into Student_Teacher_Relation
INSERT INTO Student_Teacher_Relation (
    Student_ID,
    Teacher_ID
)
SELECT 
    sp.Student_ID,
    (sp.Student_ID % 5) + 1 AS Teacher_ID
FROM Student_Performance sp;

-- Verify the insertion
SELECT * FROM Student_Performance;
SELECT * FROM Student_Background;
SELECT * FROM Student_Demographics;
SELECT * FROM School_Information;
SELECT * FROM Teacher_Information;
SELECT * FROM Student_School_Relation;
SELECT * FROM Student_Teacher_Relation;