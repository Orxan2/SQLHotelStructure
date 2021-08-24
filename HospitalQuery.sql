CREATE DATABASE Hospital

USE Hospital
CREATE TABLE Departments
(
Id int primary key identity,
[Name] nvarchar(50),
)
CREATE TABLE Doctors
(
Id int primary key identity,
[Name] nvarchar(50),
[Surname] nvarchar(50),
[Age] int,
[Salary] decimal(10,2),
[Department] int FOREIGN KEY  REFERENCES Departments(Id)
)

CREATE TABLE Patients
(
Id int primary key identity,
[Name] nvarchar(50),
[Surname] nvarchar(50),
[Age] int
)
CREATE TABLE Diseases
(
Id int primary key identity,
[Name] nvarchar(50)
)

CREATE TABLE RoomTypes
(
Id int primary key identity,
[Name] nvarchar(50)
)

CREATE TABLE Rooms
(
Id int primary key identity,
[Name] nvarchar(50),
[RoomTypeId] int FOREIGN KEY REFERENCES RoomTypes(Id)
)

CREATE TABLE Meetings
(
Id int primary key identity,
[DoctorId] int FOREIGN KEY REFERENCES Doctors(Id),
[PatientId] int FOREIGN KEY REFERENCES Patients(Id),
[RoomId] int FOREIGN KEY REFERENCES Rooms(Id),
[DiseasId] int FOREIGN KEY REFERENCES Diseases(Id),
[Date] DATETIME,
[Price] DECIMAL (10,2),
IsHealed BIT
)

INSERT INTO RoomTypes
VALUES('Operation'),('Meeting')

INSERT INTO Rooms
VALUES('O1',1),('M1',2),('O2',1),('M2',2)

INSERT INTO Departments
VALUES('Ortopediya'),('Travmatologiya'),('Stomatolog')

INSERT INTO Doctors
VALUES(N'Alim',N'Abasov',45,1000,2),
      (N'Eldar',N'Kərimov',36,1200,1),
      (N'Sərxan',N'Talıbov',52,900,3)
	  	  
INSERT INTO Patients
VALUES(N'Əli',N'Eminli',25),
      (N'Sənan',N'Səttarov',19),
      (N'Kamal',N'Yunusov',30)
	  	  
INSERT INTO Diseases
VALUES(N'diş çürüyüb'),
      (N'qol çıxıb'),
      (N'göz zəifliyi')

INSERT INTO Meetings
VALUES(2,3,1,3,'2021-08-08',400,'False'),
      (1,2,3,3,'2021-01-25',600,'True'),
      (3,1,2,1,'2020-10-09',500,'False')
      

CREATE VIEW CallMEttings 
AS
SELECT m.Id,pat.Name [Patient Name],pat.Surname [Patient Surname], doc.Name [Doctor],dep.Name [Department],dis.Name [Diseases],m.Date,m.Price,m.IsHealed,r.Name [Room], rt.Name [Room Type] FROM Meetings m
JOIN Doctors doc 
on doc.Id = m.DoctorId
JOIN Departments dep 
on dep.Id = doc.Department
JOIN Diseases dis 
on dis.Id = m.DiseasId
JOIN Patients pat 
on pat.Id = m.PatientId
JOIN Rooms r 
on r.Id = m.RoomId
JOIN RoomTypes rt
on rt.Id = r.RoomTypeId


SELECT * from CallMEttings