-- for linux (og måske også dødelige?) https://docs.microsoft.com/en-us/sql/ssms/scripting/sqlcmd-run-transact-sql-script-files?view=sql-server-ver15
-- CLI OPTIONS: https://docs.microsoft.com/en-us/sql/tools/sqlcmd-utility?view=sql-server-ver15
--sqlcmd -S localhost -i make_database_v9.sql -U SA -P "Passw0rd"

CREATE DATABASE Hive
GO
USE Hive

SELECT Name from sys.databases --https://chartio.com/resources/tutorials/sql-server-list-tables-how-to-show-all-tables/


-------------CREATE TABLES------------------------------------------------------

CREATE TABLE Municipalities (
	Id int PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[Name] varchar(255) NOT NULL
)
CREATE TABLE Citizens (
	Id int PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[Email] varchar(255),
	[PhoneNo] varchar(255),
	[Name] varchar(255) NOT NULL,
	[IsBlocked] BIT NOT NULL,
	MunicipalityId int NOT NULL FOREIGN KEY REFERENCES Municipalities(Id),
	CONSTRAINT Citizens_LoginInformation_UQ UNIQUE([Email], [PhoneNo]),
	CONSTRAINT Citizens_LoginInformation_CK CHECK(
		([Email] IS NOT NULL AND [PhoneNo] IS NULL) OR
		([Email] IS NULL AND [PhoneNo] IS NOT NULL)
	)
)
CREATE TABLE Categories (
	Id int PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[Name] varchar(255) NOT NULL
)
CREATE TABLE SubCategories (
	Id int IDENTITY(1,1) NOT NULL,
	CategoryId int NOT NULL FOREIGN KEY REFERENCES Categories(Id),
	[Name] varchar(255) NOT NULL,
	CONSTRAINT PK_IdCategoryId PRIMARY KEY NONCLUSTERED ([Id], [CategoryId])
)
CREATE TABLE IssueStates (
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
	DateEdited datetime,
	[Location] geography NOT NULL,
	[Address] varchar(255) Not Null,
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
	DateCreated datetime NOT NULL,
	DateEdited datetime
)
CREATE TABLE ReportCategories (
	Id int PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[Name] varchar(255) NOT NULL
)
CREATE TABLE Reports (
	Id int PRIMARY KEY IDENTITY(1,1) NOT NULL,
	IssueId int NOT NULL FOREIGN KEY REFERENCES Issues(Id),
	ReportCategoryId int NOT NULL FOREIGN KEY REFERENCES ReportCategories(Id),
	TypeCounter int NOT NULL,
	CONSTRAINT Reports_UQ UNIQUE([IssueId], [ReportCategoryId]),
)
CREATE TABLE Verifications (
	Id int PRIMARY KEY IDENTITY(1,1) NOT NULL,
	IssueId int NOT NULL FOREIGN KEY REFERENCES Issues(Id),
	CitizenId int NOT NULL FOREIGN KEY REFERENCES Citizens(Id),
	CONSTRAINT IssueVerifications_UQ UNIQUE(IssueId, CitizenId)
)
GO

----------------------INSERT DATA--------------------------------------------------

INSERT INTO Municipalities([Name])
	VALUES
		('Aalborg'),
		('Brønderslev'),
		('Vesthimmerland'),
		('Rebild'),
		('Albertslund'),
		('Allerød'),
		('Ballerup'),
		('Bornholm'),
		('Brøndby'),
		('Dragør'),
		('Egedal'),
		('Fredensborg'),
		('Frederiksberg'),
		('Frederikssund'),
		('Furesø'),
		('Gentofte'),
		('Gladsaxe'),
		('Glostrup'),
		('Gribskov'),
		('Halsnæs'),
		('Helsingør'),
		('Herlev'),
		('Hillerød'),
		('Hvidovre'),
		('Høje-Taastrup'),
		('Hørsholm'),
		('Ishøj'),
		('København'),
		('Lyngby-Taarbæk'),
		('Rudersdal'),
		('Rødovre'),
		('Tårnby'),
		('Vallensbæk'),
		('Favrskov'),
		('Hedensted'),
		('Herning'),
		('Holstebro'),
		('Horsens'),
		('Ikast-Brande'),
		('Lemvig'),
		('Norddjurs'),
		('Odder'),
		('Randers'),
		('Ringkøbing-Skjern'),
		('Samsø'),
		('Silkeborg'),
		('Skanderborg'),
		('Skive'),
		('Struer'),
		('Syddjurs'),
		('Viborg'),
		('Aarhus'),
		('Frederikshavn'),
		('Hjørring'),
		('Jammerbugt'),
		('Læsø'),
		('Mariagerfjord'),
		('Morsø'),
		('Thisted'),
		('Faxe'),
		('Greve'),
		('Guldborgsund'),
		('Holbæk'),
		('Kalundborg'),
		('Køge'),
		('Lejre'),
		('Lolland'),
		('Næstved'),
		('Odsherred'),
		('Ringsted'),
		('Roskilde'),
		('Slagelse'),
		('Solrød'),
		('Sorø'),
		('Stevns'),
		('Vordingborg'),
		('Assens'),
		('Billund'),
		('Esbjerg'),
		('Fanø'),
		('Fredericia'),
		('Faaborg-Midtfyn'),
		('Haderslev'),
		('Kerteminde'),
		('Kolding'),
		('Langeland'),
		('Middelfart'),
		('Nordfyn'),
		('Nyborg'),
		('Odense'),
		('Svendborg'),
		('Sønderborg'),
		('Tønder'),
		('Varde'),
		('Vejen'),
		('Vejle'),
		('Ærø'),
		('Aabenraa')
		
INSERT INTO Citizens (Email, PhoneNo, [Name], IsBlocked, MunicipalityId)
	VALUES
		('email@email.dk', NULL, 'Hans', 0, 1),
		(NULL, '12345678', 'Birte', 0, 2),
		('anders@email.dk', NULL, 'Anders', 0, 1),
		('sporvogn@live.com', NULL, 'Jakob', 0, 1),
		(NULL, '87654321', 'Alma', 0, 2),
		('Bo@email.dk', NULL, 'Bo', 1, 3),
		('Ella@email.dk', NULL, 'Ella', 0, 3),
		(NULL, '30360633', 'Jacob', 1, 1),
		('Karla@email.dk', NULL, 'Karla', 0, 1),
		('Olivia@email.dk', NULL, 'Olivia', 0, 1),
		('japr@tarp.dk', NULL, 'japr', 0, 1)

INSERT INTO Categories ([Name]) --https://www.mssqltips.com/sqlservertip/6724/insert-into-sql/
	VALUES
		('Vej'),
		('Rabat'),
		('Fortov'),
		('Sti'),
		('Cykelsti'),
		('Byudstyr'),
		('Tekniske anlæg'),
		('Parkinventar og lign.'),
		('Parker og grønne områder'),
		('Skove og naturområder'),
		('Bjørneklo og ander invasive arter')

INSERT INTO SubCategories(CategoryId, [Name])
	VALUES
		(1, 'Hul i vej'),
		(1, 'Rendestenbrønde'),
		(1, 'Skiltning'),
		(1, 'Vejtræer'),
		(1, 'Vand på vejen'),
		(1, 'Døde dyr'),
		(1, 'Andet'),
		(2, 'Hul i rabat'),
		(2, 'Andet'),
		(3, 'Skade på fortov'),
		(3, 'Løse fliser'),
		(3, 'Opspring i flise >3 cm'),
		(3, 'Flise krakkeleret'),
		(3, 'Skiltning'),
		(3, 'Ukrudt'),
		(3, 'Andet'),
		(4, 'hul i sti'),
		(4, 'Rendestensbrønde'),
		(4, 'Skiltning'),
		(4, 'Vand på stien'),
		(4, 'Andet'),
		(5, 'Hul i cykelsti'),
		(5, 'Rendestensbrønde'),
		(5, 'Skiltning'),
		(5, 'Vand på cykelstien'),
		(5, 'Andet'),
		(6, 'Borde / Bænke'),
		(6, 'Affaldsstativ / beholdere'),
		(6, 'Cykelstativ'),
		(6, 'Pullert'),
		(6, 'Hegn - fodhegn'),
		(6, 'Andet'),
		(7, 'Fejl på gadebelysning'),
		(7, 'Fejl på signalanlæg'),
		(7, 'Andet'),
		(8, 'Borde / Bænke'),
		(8, 'Legeplads'),
		(8, 'Affaldsstativ / beholdere'),
		(8, 'Springvand'),
		(8, 'Infotavler'),
		(8, 'Toiletbygninger'),
		(8, 'Shelter / bålpladser'),
		(8, 'Andet'),
		(9, 'Træer'),
		(9, 'Græs'),
		(9, 'Beplantning i øvrigt'),
		(9, 'Søer'),
		(9, 'Stier'),
		(9, 'Andet'),
		(10, 'Træer'),
		(10, 'Øvrig beplantning'),
		(10, 'Fortidsminder'),
		(10, 'Dyrehegn'),
		(10, 'Afmærkede stier / ruter'),
		(10, 'Andet'),
		(11, 'Kæmpe bjørneklo'),
		(11, 'Andet')


INSERT INTO IssueStates([Name])
	VALUES
		('Oprettet'),
		('Godkendt'),
		('Løst'),
		('Ikke løst')

INSERT INTO MunicipalityUsers(MunicipalityId, Email, [Password], [Name])
	VALUES
		(1, 'Grete@Aalborg.dk', '12345678', 'Grete'),
		(2, 'Bente@Brønderslev.dk', '12345678', 'Bente'),
		(3, 'Anette@Vesthimmerland.dk', '12345678', 'Anette'),
		(4, 'Jens@Rebild.dk', '12345678', 'Jens')

INSERT INTO Issues(CitizenId, MunicipalityId, IssueStateId, CategoryId, SubcategoryId, [Description], DateCreated, DateEdited, [Location], [Address])
	VALUES
		(1, 1, 1, 3, 11, 'Der er en løs flise', '2021-10-21 13:44:15', NULL, geography::Point(57.012218, 9.994330, 4326), 'Alfred Nobels Vej 27, 9200 Aalborg, Danmark'),
		(2, 3, 2, 11, 56, 'Der er en bjørneklo', '2021-10-21 13:44:15', NULL, geography::Point(56.952687, 9.241946, 4326), 'Sjægten 1, 9670 Løgstør, Danmark'),
		(3, 4, 2, 8, 36, 'Bænken er i stykker', '2021-10-21 13:44:15', NULL, geography::Point(56.884232, 9.838250, 4326), 'Hobrovej 126, 9530 Støvring, Danmark'),
		(5, 2, 2, 1, 4, 'Der er et træ på vejen', '2021-10-21 13:44:15', NULL, geography::Point(57.251672, 9.963336, 4326), 'Erhvervsparken 11, 9700 Brønderslev, Danmark'),
		(8, 1, 1, 2, 8, 'Der er hul i rabatten', '2021-10-21 13:44:15', '2021-10-23 11:44:15', geography::Point(57.017079, 9.977111, 4326), 'Fibigerstræde 14 9220 Alborg, Danmark'),
		(8, 1, 2, 4, 20, 'Der er vand på stien', '2021-10-21 13:44:15', NULL, geography::Point(57.016892, 9.974708, 4326), 'Pontoppidanstræde 97B, 9220 Aalborg, Danmark'),
		(11, 1, 1, 5, 24, 'Der er dårlig skiltning', '2021-10-21 13:44:15', NULL, geography::Point(57.015113, 9.983903, 4326), 'Fredrik Bajers Vej 3, 9220 Aalborg, Danmark'),
		(11, 1, 3, 6, 28, 'Affaldsstativ er i stykker', '2021-10-21 13:44:15', '2021-11-02 08:02:15', geography::Point(57.014108, 9.989868, 4326), 'Department of Mathematical Sciences, 9220 Aalborg, Danmark'),
		(4, 1, 1, 7, 33, 'Gade lyset er gået i stykker', '2021-10-21 13:44:15', NULL, geography::Point(57.012168, 9.989825, 4326), 'Selma lagerløfts Vej 300, 9220 Aalborg, Danmark'),
		(4, 1, 2, 8, 40, 'Der er graffiti på informations tavlen', '2021-10-21 13:44:15', '2021-09-28 16:33:25', geography::Point(57.012355, 9.986220, 4326), 'Niels Jernes Vej 10, 9220 Aalborg, Danmark'),
		(4, 1, 4, 9, 47, 'Søen lugter', '2021-10-21 13:44:15', '2021-09-24 20:55:15', geography::Point(57.012542, 9.982057, 4326), 'Halldor laxness Vej 2, 9220 Aalborg, Danmark'),
		(4, 1, 1, 10, 53, 'Dyrehegnet er i stykker', '2021-09-21 13:44:15', '2021-09-25 18:44:15', geography::Point(57.013640, 9.974161, 4326), 'Thomas manns Vej 20, 9220 Aalborg, Danmark'),
		(4, 1, 2, 11, 57, 'Der er meget ukrudt', '2021-09-21 13:44:15', '2021-09-22 03:44:15', geography::Point(57.014971, 9.975491, 4326), 'Pontoppidanstræde 105, 9220 Aalborg, Danmark'),
		(4, 1, 2, 3, 11, 'Der er en løs flise', '2021-09-21 13:44:15', NULL, geography::Point(57.017704, 9.982100, 4326), 'Fredrik Bajers Vej 128, 9220 Aalborg, Danmark'),
		(4, 1, 1, 3, 11, 'Der er en løs flise', '2021-09-21 13:44:15', NULL, geography::Point(57.014643, 9.988966, 4326), 'Fredrik bajers Vej 7F, 9220 Aalborg, Danmark'),
		(1, 1, 2, 3, 11, 'Der er en løs flise', '2021-09-21 13:44:15', NULL, geography::Point(57.014362, 9.990253, 4326), 'Bertil Ohlins Vej 198, 9220 Aalborg, Danmark'),
		(1, 1, 3, 3, 11, 'Der er en løs flise', '2021-09-21 13:44:15', NULL, geography::Point(57.015273, 9.985404, 4326), 'Fredrik Bajers Vej 3, 9220 Aalborg, Danmark')

INSERT INTO MunicipalityResponses(IssueId, MunicipalityUserId, Response, DateCreated, DateEdited)
	VALUES
		(2, 3, 'Det kigger vi på straks', '2021-10-22 13:44:15', NULL),
		(3, 4, 'Der er blevet anskaffet en ny bænk. En kommer ud og erstatter den', '2021-10-22 13:44:15', NULL),
		(4, 2, 'Der kommer nogen ud med det samme', '2021-10-22 13:44:15', NULL),
		(5, 2, 'Rettelse: Dette problem er blevet udskudt', '2021-10-22 13:44:15', '2021-10-23 12:22:08'),
		(6, 1, 'Dette er ikke et relevant problem', '2021-10-22 13:44:15', NULL),
		(8, 1, 'Vi køber et nyt', '2021-10-22 13:44:15', NULL),
		(8, 1, 'Der er nu blevet sat et nyt affaldsstativ op', '2021-10-23 13:44:15', NULL),
		(9, 1, 'Vi har desværre ikke resurser til at løse dette problem på nuværende tidspunkt', '2021-10-22 13:44:15', '2021-11-17 00:35:22'),
		(10, 1, 'Vi kommer ud og kigger på det', '2021-10-22 13:44:15', NULL),
		(11, 1, 'Vi kigger på det', '2021-10-22 13:44:15', NULL),
		(11, 1, 'Vi kan desværre ikke løse dette problem lige nu, derfor sætter vi det som løst', '2021-10-22 13:44:15', NULL),
		(12, 3, 'Problemet tager længere tid end forventet', '2021-10-22 13:44:15', '2021-10-29 04:55:30'),
		(13, 1, 'Vi ser lige om der er andre områder der også har brug for ukrudts fjerning', '2021-10-22 13:44:15', NULL),
		(13, 1, 'Vi kommer ud og fjerne det om en uge', '2021-10-25 13:44:15', NULL),
		(17, 1, 'Vi har sat den på plads', '2021-10-22 13:44:15', NULL)

INSERT INTO ReportCategories([Name])
	VALUES
		('Nøgenhed'),
		('Vold'),
		('Chikane'),
		('Falske oplysninger'),
		('Spam'),
		('Uautoriseret salg'),
		('Hadefuld retorik'),
		('Terrorisme'),
		('Andet')

INSERT INTO Reports(IssueId, ReportCategoryId, TypeCounter)
	VALUES
		(10, 2, 1),
		(6, 3, 1),
		(5, 4, 5),
		(6, 5, 1),		
		(6, 4, 1)

INSERT INTO Verifications(IssueId, CitizenId)
	VALUES
		(1, 2),
		(2, 1),
		(3,6),
		(14,3),
		(14,4),
		(14,5),
		(14,6),
		(14,10),
		(14,8),
		(10,9),
		(10,11),
		(10,4),
		(10,5),
		(1,7),
		(2,7),
		(3,7),
		(4,7),
		(5,7),
		(6,7),
		(7,7),
		(8,7),
		(9,7),
		(10,7),
		(11,7),
		(12,7),
		(13,7),
		(14,7),
		(15,7)

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
