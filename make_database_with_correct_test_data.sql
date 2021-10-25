-- for linux (og måske også dødelige?) https://docs.microsoft.com/en-us/sql/ssms/scripting/sqlcmd-run-transact-sql-script-files?view=sql-server-ver15
-- CLI OPTIONS: https://docs.microsoft.com/en-us/sql/tools/sqlcmd-utility?view=sql-server-ver15
--sqlcmd -S localhost -i myScript.sql -u SA -p "password"

CREATE DATABASE Hive
GO
USE Hive

SELECT Name from sys.databases --https://chartio.com/resources/tutorials/sql-server-list-tables-how-to-show-all-tables/


-------------CREATE TABLES------------------------------------------------------

CREATE TABLE Citizens (
	Id int PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[Email] varchar(63),
	[PhoneNo] varchar(255),
	[Name] varchar(255) NOT NULL,
	[IsBlocked] BIT NOT NULL,
	CONSTRAINT Citizens_LoginInformation_UQ UNIQUE([Email], [PhoneNo]),
	CONSTRAINT Citizens_LoginInformation_CK CHECK(
		([Email] IS NOT NULL AND [PhoneNo] IS NULL) OR
		([Email] IS NULL AND [PhoneNo] IS NOT NULL)
	)
)
CREATE TABLE Categories (
	Id int PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[Name] varchar(63) NOT NULL
)
CREATE TABLE SubCategories (
	Id int IDENTITY(1,1) NOT NULL,
	CategoryId int NOT NULL FOREIGN KEY REFERENCES Categories(Id),
	[Name] varchar(63) NOT NULL,
	CONSTRAINT PK_IdCategoryId PRIMARY KEY NONCLUSTERED ([Id], [CategoryId])
)
CREATE TABLE IssueStates (
	Id int PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[Name] varchar(255) NOT NULL
)
CREATE TABLE Municipalities (
	Id int PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[Name] varchar(255) NOT NULL
)
CREATE TABLE MunicipalityUsers (
	Id int PRIMARY KEY IDENTITY(1,1) NOT NULL,
	Email varchar(255) NOT NULL UNIQUE, 
	[Password] varchar(255) NOT NULL,
	[Name] varchar(255) NOT NULL,
	MunicipalityId int NOT NULL FOREIGN KEY REFERENCES Municipalities(Id)
)
CREATE TABLE Issues (
	Id int PRIMARY KEY IDENTITY(1,1) NOT NULL,
	CitizenId int NOT NULL FOREIGN KEY REFERENCES Citizens(Id),
	MunicipalityId int NOT NULL FOREIGN KEY REFERENCES Municipalities(Id),
	IssueStateId int NOT NULL FOREIGN KEY REFERENCES IssueStates(Id),
	CategoryId int NOT NULL,
	SubCategoryId int NOT NULL,
	[Description] varchar(255) NOT NULL,
	DateCreated datetime NOT NULL,
	[Location] geography NOT NULL,
	Picture1 varchar(max),
	Picture2 varchar(max),
	Picture3 varchar(max),
	FOREIGN KEY(SubCategoryId, CategoryId) REFERENCES SubCategories(Id, CategoryId)
)
CREATE TABLE MunicipalityResponses (
	Id int PRIMARY KEY IDENTITY(1,1) NOT NULL,
	IssueId int NOT NULL FOREIGN KEY REFERENCES Issues(Id),
	MunicipalityUserId int NOT NULL FOREIGN KEY REFERENCES MunicipalityUsers(Id),
	Response varchar(255) NOT NULL,
	DateCreated datetime NOT NULL
)
CREATE TABLE ReportCategories (
	Id int PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[Name] varchar(255) NOT NULL
)
CREATE TABLE Reports (
	Id int PRIMARY KEY IDENTITY(1,1) NOT NULL,
	IssueId int NOT NULL FOREIGN KEY REFERENCES Issues(Id),
	ReportCategoryId int NOT NULL FOREIGN KEY REFERENCES ReportCategories(Id),
	TypeCounter int NOT NULL
)
GO

----------------------INSERT DATA--------------------------------------------------

INSERT INTO Citizens (Email, PhoneNo, [Name], IsBlocked)
	VALUES
		('email@email.dk', NULL, 'Hans', 0),
		(NULL, '12345678', 'Birte', 0),
		('Anders@email.dk', NULL, 'Anders', 0)

INSERT INTO Categories ([Name]) --https://www.mssqltips.com/sqlservertip/6724/insert-into-sql/
	VALUES
		('Sidewalk'),
		('Road')

INSERT INTO SubCategories(CategoryId, [Name])
	VALUES
		(1, 'Hole in sidewalk'),
		(1, 'Slippery sidewalk'),
		(2, 'Tree on road'),
		(2, 'Hole on road')

INSERT INTO IssueStates([Name])
	VALUES
		('Created'),
		('Approved'),
		('Resolved')

INSERT INTO Municipalities([Name])
	VALUES
		('Aalborg'),
		('Vesthimmerland'),
		('Randers')

INSERT INTO MunicipalityUsers(MunicipalityId, Email, [Password], [Name])
	VALUES
		(1, 'Grete@Aalborg.dk', '12345678', 'Grete'),
		(2, 'Bente@Vesthimmerland.dk', '12345678', 'Bente'),
		(3, 'Anette@Randers.dk', '12345678', 'Anette')

INSERT INTO Issues(CitizenId, MunicipalityId, IssueStateId, CategoryId, SubcategoryId, [Description], DateCreated, [Location])
	VALUES
		(1, 1, 1, 1, 1, 'Jeg hader huller på fortorvet', '2021-10-21 13:44:15', geography::Point(57.012218, 9.994330, 4326)),
		(2, 2, 2, 1, 2, 'Jeg hader glatte fortorv', '2021-10-21 13:44:15', geography::Point(56.952687, 9.241946, 4326)),
		(3, 3, 3, 2, 3, 'Jeg hader træer på vejen', '2021-10-21 13:44:15', geography::Point(56.456943, 10.029387, 4326))

INSERT INTO MunicipalityResponses(IssueId, MunicipalityUserId, Response, DateCreated)
	VALUES
		(2, 2, 'Det kigger vi på straks, der skal nok komme salt på fortorvet', '2021-10-22 13:44:15'),
		(3, 3, 'Vi har taget os af det meget farlige træ', '2021-10-22 13:44:15')

INSERT INTO ReportCategories([Name])
	VALUES
		('Ikke relevant')

INSERT INTO Reports(IssueId, ReportCategoryId, TypeCounter)
	VALUES
		(1, 1, 1)

GO

--------------------------DELETE EVERYTHING AGAIN-------------------------------

--USE [master];

--DECLARE @kill varchar(8000) = '';  
--SELECT @kill = @kill + 'kill ' + CONVERT(varchar(5), session_id) + ';'  
--FROM sys.dm_exec_sessions
--WHERE database_id  = db_id('Hive')

--EXEC(@kill);

--USE master
--DROP DATABASE Hive
--GO
