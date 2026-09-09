--=============================================================
-- FIFA WORLD CUP 2026 DATABASE
-- Database Development 281 - Project
--=============================================================
--Group 32
--Group Members : Aden Jansen          : 603442
--                Louis Nel            : 605094
--                Tumelo               : 604239
--                Nduna Ntshalintshali : 605054
--=============================================================

-- SECTION 1: Database Creation (DDL)
--=============================================================
USE master;
GO
 
-- Drop and recreate for a clean run
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'SoccerWorldCup2026')
BEGIN
    ALTER DATABASE SoccerWorldCup2026 SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE SoccerWorldCup2026;
END
GO
 
CREATE DATABASE SoccerWorldCup2026
ON PRIMARY 
(
    NAME=PlayerData1,
    FILENAME='C:\Users\Public\Documents\SQLAssigmentDBD281.mdf', 
    SIZE=5MB,
    MAXSIZE=15GB,
    FILEGROWTH=15MB
),
FILEGROUP SECONDARY
(
    NAME=PlayerData2,
    FILENAME='C:\Users\Public\Documents\SQLAssigmentDBD281.ndf', 
    SIZE=5MB,
    MAXSIZE=10GB,
    FILEGROWTH=8MB
)
LOG ON
(
    NAME=PlayerLog1,
    FILENAME='C:\Users\Public\Documents\SQLAssigmentDBD281.ldf', 
    SIZE=5MB,
    MAXSIZE=10GB,
    FILEGROWTH=4MB
)
GO

USE [SoccerWorldCup2026]
GO

--=============================================================
-- Section 2: Table Creation and Population
--=============================================================

-- Countries Table --
CREATE TABLE Countries
(
CountryID INT PRIMARY KEY,
CountryName NVARCHAR(100),
Continent NVARCHAR(70)
);
GO

INSERT INTO Countries (CountryID, CountryName, Continent)
VALUES
(1, 'United States', 'North America'),
(2, 'Mexico', 'North America'),
(3, 'Spain', 'Europe'),
(4, 'Argentina', 'South America'),
(5, 'France', 'Europe');
GO
-- Team Table --
CREATE TABLE TeamTable
(
TeamID INT PRIMARY KEY,
CountryID INT NOT NULL,
TeamName NVARCHAR(100) NOT NULL,
CoachName NVARCHAR(50) NOT NULL,
Ranking INT DEFAULT 0 NOT NULL,

CONSTRAINT FK_Team_Countires FOREIGN KEY (CountryID)
REFERENCES Countries(CountryID)
);
GO

INSERT INTO TeamTable(TeamID, CountryID, TeamName, CoachName, Ranking) VALUES
(10, 1, 'USA', 'Mauricio Pochettino', 18),
(20, 2, 'Mexico', 'Javier Aguirre', 31),
(30, 3, 'Spain', 'Luis de la Fuente', 35),
(40, 4, 'Argentina', 'Lionel Scaloni', 1),
(50, 5, 'France', 'Didier Deschamps', 2)
GO

-- Players Table --
CREATE TABLE Players
(
PlayerID INT PRIMARY KEY,
TeamID INT,
FirstName NVARCHAR(50) NOT NULL,
LastName NVARCHAR(50) NOT NULL,
DateOfBirth DATE,
JerseyNumber INT,

CONSTRAINT FK_Players_Team FOREIGN KEY (TeamID)
REFERENCES TeamTable(TeamID)
);
GO

INSERT INTO Players(PlayerID, TeamID, FirstName, LastName, DateOfBirth, JerseyNumber) 
VALUES
(101, 10, 'Christian', 'Pulisic', '1998-09-18', 10),
(102, 40, 'Vinícius', 'Júnior', '2000-07-12', 7),
(103, 50, 'Kylian', 'Mbappé', '2003-06-29', 10),
(104, 30, 'Pedri', 'González', '2000-01-14', 9),
(105, 20, 'Santiago', 'Giménez', '2001-04-18', 11);
GO

-- Staff Table --
CREATE TABLE Staff
(
StaffID INT PRIMARY KEY,
TeamID INT,
FirstName NVARCHAR(50) NOT NULL,
LastName NVARCHAR(50) NOT NULL,
RoleOfStaff NVARCHAR(70),

CONSTRAINT FK_Staff_Team FOREIGN KEY (TeamID)
REFERENCES TeamTable(TeamID)
);
GO

INSERT INTO Staff(StaffID, TeamID, FirstName, LastName, RoleOfStaff) 
VALUES
(501, 10, 'Anthony', 'Hudson', 'Assistant Coach'),
(502, 40, 'Claudio', 'Taffarel', 'Goalkeeping Coach'),
(503, 50, 'Anthony', 'Barry', 'Technical Coach'),
(504, 30, 'Ewan', 'Sharp', 'Performance Analyst'),
(505, 20, 'Rafael', 'Marquez', 'Assistant Coach')
GO

--Stadium Table --
CREATE TABLE Stadium
(
StadiumID INT PRIMARY KEY,
CountryID INT,
StadiumName NVARCHAR(50) NOT NULL,
City NVARCHAR(80),
Capacity INT,

CONSTRAINT FK_Stadium_Countries FOREIGN KEY (CountryID)
REFERENCES Countries(CountryID)
);
GO

INSERT INTO Stadium(StadiumID, CountryID, StadiumName, City, Capacity) 
VALUES
(701, 1, 'SoFi Stadium', 'Los Angeles', 70240),
(702, 2, 'Estadio BBVA', 'Monterrey', 53500),
(703, 3, 'BMO Field', 'Toronto', 45000),
(704, 1, 'AT&T Stadium', 'Arlington', 80000),
(705, 2, 'Estadio Akron', 'Guadalajara', 48071)
GO

--Matches Table --
CREATE TABLE Matches
(
MatchID INT PRIMARY KEY,
HomeTeamID INT,
AwayTeamID INT,
StadiumID INT,
Stage NVARCHAR(50),
HomeScore INT,
AwayScore INT,
HostCity NVARCHAR(100),
MatchDate DATETIME

CONSTRAINT FK_Matches_HomeTeam FOREIGN KEY (HomeTeamID) REFERENCES TeamTable(TeamID),
CONSTRAINT FK_Matches_AwayTeam FOREIGN KEY (AwayTeamID) REFERENCES TeamTable(TeamID),
CONSTRAINT FK_Matches_Stadium FOREIGN KEY (StadiumID) REFERENCES Stadium(StadiumID)
);
GO

INSERT INTO Matches(MatchID, HomeTeamID, AwayTeamID, StadiumID, Stage, HomeScore, AwayScore, HostCity, MatchDate)
VALUES
(1001, 10, 20, 701, 'Group Stage', 2, 1, 'Los Angeles', '2026-06-12 18:00:00'),
(1002, 40, 50, 704, 'Quarter-Final', 0, 3, 'Monterrey', '2026-06-13 20:00:00'),
(1003, 30, 10, 703, 'Group Stage', 1, 1, 'Toronto', '2026-06-14 18:00:00'),
(1004, 50, 20, 705, 'Round of 16', 2, 0, 'Arlington', '2026-06-15 20:00:00'),
(1005, 40, 30, 702, 'Group Stage', 0, 2, 'Guadalajara', '2026-06-16 18:00:00')
GO

--PlayerMatchStats Table --
CREATE TABLE PlayerMatchStats
(
MatchID INT,
PlayerID INT,
Primary Key (MatchID, PlayerID),
GoalsScored INT DEFAULT 0,
Assists INT DEFAULT 0,
YellowCards INT DEFAULT 0,
RedCards INT DEFAULT 0,
MinutesPlayed INT DEFAULT 0,

CONSTRAINT FK_PlayerMatchStats_Matches FOREIGN KEY (MatchID) REFERENCES Matches(MatchID),
CONSTRAINT FK_PlayerMatchStats_Players FOREIGN KEY (PlayerID) REFERENCES Players(PlayerID)
);
GO

INSERT INTO PlayerMatchStats(MatchID, PlayerID, GoalsScored, Assists, YellowCards, RedCards, MinutesPlayed)
VALUES
(1001, 101, 1, 1, 0, 0, 90),
(1001, 105, 2, 0, 1, 0, 85),
(1002, 102, 1, 0, 0, 0, 120),
(1004, 103, 1, 2, 0, 0, 90),
(1005, 102, 2, 1, 0, 0, 75);
GO

--Fans Table --
CREATE TABLE Fans
(
FanID INT PRIMARY KEY,
CountryID INT,
FirstName NVARCHAR(50) NOT NULL,
LastName NVARCHAR(50) NOT NULL,
Email NVARCHAR(40) NOT NULL UNIQUE,
PhoneNumber NVARCHAR(20),
EmailEncrypted VARBINARY(256) NULL,

CONSTRAINT FK_Fans_Countries FOREIGN KEY (CountryID)
REFERENCES Countries(CountryID)
);
GO

INSERT INTO Fans(FanID, CountryID, FirstName, LastName, Email, PhoneNumber)
VALUES
(9001, 1, 'Marcus', 'Jordan', 'm.jordan@usa-mail.com', '+1-213-555-0101'),
(9002, 4, 'Adriana', 'Lima', 'alima@brazil-fan.br', '+55-11-9988-7766'),
(9003, 5, 'Oliver', 'Smith', 'osmith88@uk-web.co.uk', '+44-20-7946-0123'),
(9004, 2, 'Ximena', 'Navarrete', 'ximena.n@mexico.mx', '+52-55-1234-5678'),
(9005, 3, 'Kyle', 'Lowry', 'klowry@canada-sports.ca', '+1-416-555-0987');
GO

--TicketSales Table --
CREATE TABLE TicketSales
(
TicketID INT PRIMARY KEY,
MatchID INT,
FanID INT,
PurchaseDate DATETIME,
TicketPrice DECIMAL(10, 2),
SeatNumber NVARCHAR(10),

CONSTRAINT FK_TicketSales_Matches FOREIGN KEY (MatchID) REFERENCES Matches(MatchID),
CONSTRAINT FK_TicketSales_Fans FOREIGN KEY (FanID) REFERENCES Fans(FanID),
CONSTRAINT UQ_TicketSales_Seat UNIQUE (MatchID, SeatNumber)
);
GO

INSERT INTO TicketSales(TicketID, MatchID, FanID, PurchaseDate, TicketPrice, SeatNumber)
VALUES
(8001, 1001, 9001, '2026-01-10 09:00', 250.00, 'SEC101-A1'),
(8002, 1002, 9002, '2026-03-15 14:30', 450.00, 'VIP-B12'),
(8003, 1003, 9005, '2026-02-12 11:15', 180.00, 'SEC204-C5'),
(8004, 1004, 9003, '2026-04-01 16:45', 320.00, 'SEC110-G19'),
(8005, 1005, 9004, '2026-02-20 10:00', 150.00, 'SEC305-R10');
GO


--=============================================================
-- Section 3: Queries and Data Manipulation (DML)
--=============================================================

-- ============================================================
-- 3a. Join Queries (Inner, Left, Right)
-- ============================================================

-- ------------------------------------------------------------
-- Join 1: Inner Join
-- Show only players who have match statistics recorded.
-- Players with no stats are excluded.
-- ------------------------------------------------------------
SELECT p.FirstName + ' ' + p.LastName AS PlayerName, t.TeamName, pms.MatchID, pms.GoalsScored, pms.Assists, pms.MinutesPlayed
FROM Players p
INNER JOIN TeamTable t ON p.TeamID = t.TeamID
INNER JOIN PlayerMatchStats pms ON p.PlayerID = pms.PlayerID
ORDER BY pms.GoalsScored DESC;
GO

-- ------------------------------------------------------------
-- Join 2: Left Join
-- Show ALL matches with their stadium and team names.
-- Matches without tickets still appear.
-- ------------------------------------------------------------
SELECT m.MatchID, ht.TeamName AS HomeTeam, awt.TeamName AS AwayTeam, m.Stage, m.HomeScore, m.AwayScore, s.StadiumName, s.City, m.MatchDate, COUNT(ts.TicketID) AS TicketsSold
FROM Matches m
LEFT JOIN TeamTable ht ON m.HomeTeamID = ht.TeamID
LEFT JOIN TeamTable awt ON m.AwayTeamID = awt.TeamID
LEFT JOIN Stadium s ON m.StadiumID = s.StadiumID
LEFT JOIN TicketSales ts ON m.MatchID = ts.MatchID
GROUP BY m.MatchID, ht.TeamName, awt.TeamName, m.Stage, m.HomeScore, m.AwayScore, s.StadiumName, s.City, m.MatchDate
ORDER BY m.MatchDate;
GO

-- ------------------------------------------------------------
-- Join 3: Right Join
-- Show ALL fans and any tickets they have purchased.
-- Fans who have not yet bought a ticket still appear
-- ------------------------------------------------------------
SELECT f.FanID, f.FirstName + ' ' + f.LastName AS FanName, f.Email, f.PhoneNumber, c.CountryName AS FanCountry, ts.MatchID, ts.PurchaseDate, ts.TicketPrice, ts.SeatNumber
FROM TicketSales ts
RIGHT JOIN Fans f ON ts.FanID = f.FanID
RIGHT JOIN Countries c ON f.CountryID = c.CountryID
ORDER BY f.FanID;
GO

-- ============================================================
-- 3b. SubQueries
-- ============================================================

-- ------------------------------------------------------------
-- SUBQUERY 1: Correlated subquery
-- Find players who scored more goals than the average
-- goals scored per player across the entire tournament.
-- ------------------------------------------------------------
SELECT p.FirstName + ' ' + p.LastName AS PlayerName, t.TeamName, 
(SELECT SUM(GoalsScored) FROM PlayerMatchStats pms WHERE pms.PlayerID = p.PlayerID) AS TotalGoals
FROM Players p
JOIN TeamTable t ON p.TeamID = t.TeamID
WHERE (SELECT SUM(GoalsScored) FROM PlayerMatchStats pms WHERE pms.PlayerID = p.PlayerID) > (SELECT AVG(GoalsScored) FROM PlayerMatchStats);
GO

-- ------------------------------------------------------------
-- SUBQUERY 2: IN subquery
-- Retrieve all matches that were played at stadiums
-- located in Mexico (CountryID = 2).
-- ------------------------------------------------------------
SELECT m.MatchID, m.Stage, m.HomeScore, m.AwayScore, m.MatchDate, c.CountryName, s.StadiumName, s.City
FROM Matches m
JOIN Stadium s ON m.StadiumID = s.StadiumID
JOIN Countries c ON s.CountryID = c.CountryID
WHERE m.StadiumID IN (SELECT StadiumID FROM Stadium WHERE CountryID = 2); 
GO

-- ------------------------------------------------------------
-- SUBQUERY 3: EXISTS subquery
-- List all teams that have at least one player
-- with a recorded yellow card in any match.
-- ------------------------------------------------------------
SELECT t.TeamName, t.CoachName
FROM TeamTable t
WHERE EXISTS (
    SELECT 1
    FROM Players p
    JOIN PlayerMatchStats pms ON p.PlayerID = pms.PlayerID
    WHERE p.TeamID = t.TeamID AND pms.YellowCards > 0
);
GO

-- ============================================================
-- 3c. CASE STATEMENTS
-- ============================================================

-- ------------------------------------------------------------
-- CASE 1: Determine match outcome for each fixture
-- ------------------------------------------------------------
SELECT m.MatchID, ht.TeamName AS HomeTeam, awt.TeamName AS AwayTeam, m.HomeScore, m.AwayScore,
    CASE 
        WHEN m.HomeScore > m.AwayScore THEN 'Home Win'
        WHEN m.HomeScore < m.AwayScore THEN 'Away Win'
        ELSE 'Draw'
    END AS MatchOutcome
FROM Matches m
LEFT JOIN TeamTable ht ON m.HomeTeamID = ht.TeamID
LEFT JOIN TeamTable awt ON m.AwayTeamID = awt.TeamID;
GO

-- ------------------------------------------------------------
-- CASE 2: Classify players by performance level
-- based on total goals scored in the tournament
-- ------------------------------------------------------------
SELECT p.FirstName + ' ' + p.LastName AS PlayerName, t.TeamName, SUM(pms.GoalsScored) AS TotalGoals,
    CASE
        WHEN SUM(pms.GoalsScored) >= 3 THEN 'Elite Scorer'
        WHEN SUM(pms.GoalsScored) >= 2 THEN 'Strong Scorer'
        WHEN SUM(pms.GoalsScored) >= 1 THEN 'Contributor'
        ELSE 'Yet to Score'
        END AS PerformanceLevel
FROM PlayerMatchStats pms
JOIN Players p ON pms.PlayerID = p.PlayerID
JOIN TeamTable t ON p.TeamID = t.TeamID
GROUP BY p.PlayerID, p.FirstName, p.LastName, t.TeamName
ORDER BY TotalGoals DESC;
GO

-- ------------------------------------------------------------
-- CASE 3: Categorise ticket price into affordability tiers
-- ------------------------------------------------------------
SELECT ts.TicketID, f.FirstName + ' ' + f.LastName AS FanName, ht.TeamName AS HomeTeam, awt.TeamName AS AwayTeam, ts.TicketPrice,
    CASE
        WHEN ts.TicketPrice >= 400 THEN 'Premium'
        WHEN ts.TicketPrice >= 200 THEN 'Standard'
        ELSE 'Budget'
    END AS PriceCategory
FROM TicketSales ts
JOIN Fans f ON ts.FanID = f.FanID
JOIN Matches m ON ts.MatchID = m.MatchID
JOIN TeamTable ht ON m.HomeTeamID = ht.TeamID
JOIN TeamTable awt ON m.AwayTeamID = awt.TeamID
ORDER BY ts.TicketPrice DESC;
GO

-- ============================================================
-- 3d. CTEs (Common Table Expressions)
-- ============================================================

-- ------------------------------------------------------------
-- CTE 1: Total team performance across all matches
-- -----------------------------------------------------------
WITH TeamPerformance AS (
    SELECT p.TeamID, SUM(pms.GoalsScored) AS TotalTeamGoals, SUM(pms.Assists) AS TotalTeamAssists, COUNT(pms.MatchID) AS MatchesPlayed
    FROM PlayerMatchStats pms
    INNER JOIN Players p ON pms.PlayerID = p.PlayerID
    GROUP BY p.TeamID
)
SELECT t.TeamName, tp.TotalTeamGoals, tp.TotalTeamAssists, tp.MatchesPlayed
FROM TeamPerformance tp
JOIN TeamTable t ON tp.TeamID = t.TeamID
ORDER BY tp.TotalTeamGoals DESC;
GO

-- ------------------------------------------------------------
-- CTE 2: Top scorers leaderboard with ranking
-- ------------------------------------------------------------
WITH ScorerTotals AS
(
SELECT p.PlayerID, p.FirstName + ' ' + p.LastName AS PlayerName, t.TeamName, SUM(pms.GoalsScored) AS TotalGoals, 
SUM(pms.Assists) AS TotalAssists, SUM(pms.MinutesPlayed) AS TotalMinutes
FROM PlayerMatchStats pms
JOIN Players p ON pms.PlayerID = p.PlayerID
JOIN TeamTable t ON p.TeamID = t.TeamID
GROUP BY p.PlayerID, p.FirstName, p.LastName, t.TeamName
)
SELECT RANK() OVER (ORDER BY TotalGoals DESC) AS GoalRank, PlayerName, TeamName, TotalGoals, TotalAssists, TotalMinutes
FROM ScorerTotals
ORDER BY GoalRank;
GO

-- ------------------------------------------------------------
-- CTE 3: Match revenue report — total ticket income per match
-- ------------------------------------------------------------
WITH MatchRevenue AS
(
SELECT ts.MatchID, COUNT(ts.TicketID) AS TicketsSold, SUM(ts.TicketPrice) AS TotalRevenue, AVG(ts.TicketPrice) AS AverageTicketPrice
FROM TicketSales ts
GROUP BY ts.MatchID
)
SELECT m.MatchID, ht.TeamName AS HomeTeam, awt.TeamName AS AwayTeam, m.Stage, s.StadiumName, mr.TicketsSold, mr.TotalRevenue, mr.AverageTicketPrice
FROM Matches m
LEFT JOIN TeamTable ht ON m.HomeTeamID = ht.TeamID
LEFT JOIN TeamTable awt ON m.AwayTeamID = awt.TeamID
LEFT JOIN Stadium s ON m.StadiumID = s.StadiumID
LEFT JOIN MatchRevenue mr ON m.MatchID = mr.MatchID
ORDER BY mr.TotalRevenue DESC;
GO

-- ============================================================
-- Section 4: Programability (Stored Procedures, Functions, Triggers)
-- ============================================================

-- ============================================================
-- Section 4 a: Stored Procedures
-- ============================================================

-- ------------------------------------------------------------
-- SP1: Get full schedule and results for a given team
-- Usage: EXEC usp_GetTeamSchedule @TeamID = 40
-- ------------------------------------------------------------
CREATE PROCEDURE sp_GetTeamSchedule
    @TeamID INT
AS
BEGIN
  SELECT m.MatchID, m.Stage, 
  CASE 
    WHEN m.HomeTeamID = @TeamID THEN 'Home'
    ELSE 'Away'
    END AS Venue,
    CASE 
    WHEN m.HomeTeamID = @TeamID THEN awt.TeamName
    ELSE ht.TeamName
    END AS Opponent,
m.HomeScore, m.AwayScore,
    CASE
    WHEN m.HomeScore > m.AwayScore THEN 'Home Win'
    WHEN m.HomeScore < m.AwayScore THEN 'Away Win'
    ELSE 'Draw'
    END AS MatchOutcome,
    s.StadiumName, s.City, m.MatchDate
FROM Matches m
LEFT JOIN TeamTable ht ON m.HomeTeamID = ht.TeamID
LEFT JOIN TeamTable awt ON m.AwayTeamID = awt.TeamID
LEFT JOIN Stadium s ON m.StadiumID = s.StadiumID
WHERE m.HomeTeamID = @TeamID OR m.AwayTeamID = @TeamID
ORDER BY m.MatchDate;
END;
GO

EXEC sp_GetTeamSchedule @TeamID = 40;
GO

-- ------------------------------------------------------------
-- SP2: Get all players registered to a specific team
-- Usage: EXEC sp_GetTeamPlayers @TeamID = 10
-- ------------------------------------------------------------
CREATE PROCEDURE sp_GetTeamPlayers
    @TeamID INT
    AS
    BEGIN
    SET NOCOUNT ON;
    IF NOT EXISTS (SELECT 1 FROM TeamTable WHERE TeamID = @TeamID)
    BEGIN
        RAISERROR('Error: TeamID %d does not exist.', 16, 1, @TeamID);
        RETURN;
    END
    SELECT
        p.PlayerID,
        p.FirstName + ' ' + p.LastName     AS PlayerName,
        p.JerseyNumber,
        p.DateOfBirth,
        t.TeamName,
        t.CoachName
    FROM Players p
    JOIN TeamTable   t ON p.TeamID = t.TeamID
    WHERE p.TeamID = @TeamID
    ORDER BY p.JerseyNumber;
END;
GO

EXEC sp_GetTeamPlayers @TeamID = 10; -- USA
GO

-- ------------------------------------------------------------
-- SP3: Get all tickets purchased for a specific match
-- Usage: EXEC sp_GetMatchTickets @MatchID = 1001
-- ------------------------------------------------------------
CREATE PROCEDURE sp_GetMatchTickets
    @MatchID INT
AS 
BEGIN
    SET NOCOUNT ON;
 
    IF NOT EXISTS (SELECT 1 FROM Matches WHERE MatchID = @MatchID)
    BEGIN
        RAISERROR('Error: MatchID %d does not exist.', 16, 1, @MatchID);
        RETURN;
    END
    SELECT
        ts.TicketID,
        f.FirstName + ' ' + f.LastName     AS FanName,
        f.Email,
        ts.SeatNumber,
        ts.TicketPrice,
        ts.PurchaseDate
    FROM TicketSales ts
    JOIN Fans    f ON ts.FanID = f.FanID
    WHERE ts.MatchID = @MatchID
    ORDER BY ts.SeatNumber;
END;
GO

EXEC sp_GetMatchTickets @MatchID = 1001;
GO

-- ============================================================
-- Section 4 b: User-Defined Functions
-- ============================================================

-- ------------------------------------------------------------
-- FN1: Scalar - calculate a player's age at tournament start
-- Usage: SELECT dbo.fn_PlayerAge(101)
-- ------------------------------------------------------------
USE [SoccerWorldCup2026]
GO

CREATE FUNCTION fn_PlayerAge
(
    @PlayerID INT
)
RETURNS INT
AS 
BEGIN
    DECLARE @DOB DATE;
    DECLARE @TournamentStart DATE = '2026-06-11';
    DECLARE @Age INT;

    SELECT @DOB = DateOfBirth FROM Players WHERE PlayerID = @PlayerID;

    IF @DOB IS NULL
    BEGIN
        RETURN NULL; -- Player not found
    END
    SET @Age = DATEDIFF(YEAR, @DOB, @TournamentStart)
    RETURN @Age;
END;
GO

SELECT PlayerID, FirstName + ' ' + LastName AS PlayerName, DateOfBirth, dbo.fn_PlayerAge(PlayerID) AS AgeAtTournamentStart
FROM Players
ORDER BY AgeAtTournamentStart;
GO

-- ------------------------------------------------------------
-- FN2: Table-valued - return all players registered to a team
-- Usage: SELECT * FROM dbo.fn_GetSquad(40)
-- ------------------------------------------------------------
CREATE FUNCTION fn_GetSquad
(
    @TeamID INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT
        p.PlayerID,
        p.FirstName + ' ' + p.LastName AS PlayerName,
        p.JerseyNumber,
        p.DateOfBirth
    FROM Players p
    WHERE p.TeamID = @TeamID
);
GO

SELECT * FROM dbo.fn_GetSquad(40) -- Argentina
ORDER BY JerseyNumber;
GO

-- ============================================================
-- Section 4 c: Views
-- ============================================================
 
-- ------------------------------------------------------------
-- V1: Full match results with outcome label
-- ------------------------------------------------------------
USE SoccerWorldCup2026
GO
CREATE VIEW vw_MatchResults
AS
SELECT m.MatchID, ht.TeamName AS HomeTeam, awt.TeamName AS AwayTeam, m.Stage, m.HomeScore, m.AwayScore,
    CASE 
        WHEN m.HomeScore > m.AwayScore THEN 'Home Win'
        WHEN m.HomeScore < m.AwayScore THEN 'Away Win'
        ELSE 'Draw'
    END AS MatchOutcome,
    s.StadiumName, s.City, m.MatchDate, c.CountryName AS HostCountry
FROM Matches m
LEFT JOIN TeamTable ht ON m.HomeTeamID = ht.TeamID
LEFT JOIN TeamTable awt ON m.AwayTeamID = awt.TeamID
LEFT JOIN Stadium s ON m.StadiumID = s.StadiumID
LEFT JOIN Countries c ON s.CountryID = c.CountryID;
GO

SELECT * FROM vw_MatchResults
GO

-- ------------------------------------------------------------
-- V2: Tournament top scorers leaderboard *
-- ------------------------------------------------------------
CREATE VIEW vw_TopScorers
AS
SELECT p.PlayerID, p.FirstName + ' ' + p.LastName AS PlayerName, t.TeamName, SUM(pms.GoalsScored) AS TotalGoals,
SUM(pms.Assists) AS TotalAssists, SUM(pms.MinutesPlayed) AS TotalMinutes
FROM PlayerMatchStats pms
JOIN Players p ON pms.PlayerID = p.PlayerID
JOIN TeamTable t ON p.TeamID = t.TeamID
GROUP BY p.PlayerID, p.FirstName, p.LastName, t.TeamName
GO

SELECT * FROM vw_TopScorers
GO

-- ------------------------------------------------------------
-- V3: Ticket sales and revenue summary per match
-- ------------------------------------------------------------
CREATE VIEW vw_TicketSales
AS
SELECT m.MatchID, ht.TeamName AS HomeTeam, awt.TeamName AS AwayTeam, m.Stage, s.StadiumName, COUNT(ts.TicketID) AS TicketsSold, SUM(ts.TicketPrice) AS TotalRevenue
FROM Matches m
LEFT JOIN TeamTable ht ON m.HomeTeamID = ht.TeamID
LEFT JOIN TeamTable awt ON m.AwayTeamID = awt.TeamID
LEFT JOIN Stadium s ON m.StadiumID = s.StadiumID
LEFT JOIN TicketSales ts ON m.MatchID = ts.MatchID
GROUP BY m.MatchID, ht.TeamName, awt.TeamName, m.Stage, s.StadiumName
GO

SELECT * FROM vw_TicketSales
ORDER BY TotalRevenue DESC;
GO

-- ============================================================
-- Section 5: Advanced T-SQL Concepts
-- ============================================================

-- ============================================================
-- Section 5 a: TRIGGERS
-- ============================================================

-- ------------------------------------------------------------
-- TRG1: Enforce business rule 13 - every team must have a coach
-- ------------------------------------------------------------
CREATE TRIGGER trg_EnforceCoach
ON TeamTable
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (
        SELECT 1
        FROM inserted i
        WHERE i.CoachName IS NULL OR LTRIM(RTRIM(i.CoachName)) = ''
    )
    BEGIN
        RAISERROR('Error: Every team must have a coach. Insert/update failed.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

-- ------------------------------------------------------------
-- TRG2: Enforce business rule 10 - tickets cannot exceed capacity
-- ------------------------------------------------------------
CREATE TRIGGER trg_EnforceStadiumCapacity
ON TicketSales
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN Matches m ON i.MatchID = m.MatchID
        JOIN Stadium s ON m.StadiumID = s.StadiumID
        WHERE (SELECT COUNT(*) FROM TicketSales WHERE MatchID = i.MatchID) > s.Capacity
    )
    BEGIN
        RAISERROR('Error: Ticket sales exceed stadium capacity. Insert failed.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

-- ------------------------------------------------------------
-- TRG3: Prevent duplicate jersey numbers within the same team.
--       Fires on INSERT or UPDATE of PlayerTable.
-- ------------------------------------------------------------
CREATE TRIGGER trg_UniqueJerseyNumbers
ON Players
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN Players p ON i.TeamID = p.TeamID AND i.JerseyNumber = p.JerseyNumber
        WHERE i.PlayerID <> p.PlayerID
    )
    BEGIN
        RAISERROR('Error: Duplicate jersey number within the same team. Insert/update failed.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

-- ============================================================
-- Section 5 b: CURSOR
-- ============================================================
-- Print a formatted match summary report for all fixtures
PRINT '========== MATCH SUMMARY REPORT ==========';
PRINT '';
 
DECLARE
    @CurMatchID   INT,
    @CurStage     NVARCHAR(50),
    @CurHomeTeam  NVARCHAR(100),
    @CurAwayTeam  NVARCHAR(100),
    @CurHomeScore INT,
    @CurAwayScore INT,
    @CurStadium   NVARCHAR(100),
    @CurCity      NVARCHAR(100),
    @CurResult    NVARCHAR(50);
 
DECLARE cur_MatchReport CURSOR FOR
    SELECT
        m.MatchID,
        m.Stage,
        ht.TeamName,
        awt.TeamName,
        m.HomeScore,
        m.AwayScore,
        s.StadiumName,
        s.City
    FROM Matches m
    LEFT JOIN TeamTable    ht  ON m.HomeTeamID = ht.TeamID
    LEFT JOIN TeamTable    awt ON m.AwayTeamID = awt.TeamID
    LEFT JOIN Stadium s   ON m.StadiumID  = s.StadiumID
    ORDER BY m.MatchDate;
 
OPEN cur_MatchReport;
 
FETCH NEXT FROM cur_MatchReport
INTO @CurMatchID, @CurStage, @CurHomeTeam, @CurAwayTeam,
     @CurHomeScore, @CurAwayScore, @CurStadium, @CurCity;
 
WHILE @@FETCH_STATUS = 0
BEGIN
    SET @CurResult =
        CASE
            WHEN @CurHomeScore > @CurAwayScore THEN @CurHomeTeam + ' Win'
            WHEN @CurAwayScore > @CurHomeScore THEN @CurAwayTeam + ' Win'
            ELSE 'Draw'
        END;
 
    PRINT 'Match ' + CAST(@CurMatchID AS VARCHAR) + ' | ' + @CurStage;
    PRINT '  ' + @CurHomeTeam + ' ' + CAST(@CurHomeScore AS VARCHAR) +
          ' - ' + CAST(@CurAwayScore AS VARCHAR) + ' ' + @CurAwayTeam;
    PRINT '  Result : ' + @CurResult;
    PRINT '  Venue  : ' + @CurStadium + ', ' + @CurCity;
    PRINT '';
 
    FETCH NEXT FROM cur_MatchReport
    INTO @CurMatchID, @CurStage, @CurHomeTeam, @CurAwayTeam,
         @CurHomeScore, @CurAwayScore, @CurStadium, @CurCity;
END;
 
CLOSE cur_MatchReport;
DEALLOCATE cur_MatchReport;
 
PRINT '========== END OF REPORT ==========';
GO

-- ------------------------------------------------------------
-- Cursor 2: Print each fan's name and how many tickets
--           they have purchased
-- ------------------------------------------------------------
PRINT '========== FAN TICKET SUMMARY ==========';
PRINT '';
 
DECLARE
    @CurFanID    INT,
    @CurFanName  NVARCHAR(100),
    @CurCount    INT;
 
DECLARE cur_FanTickets CURSOR FOR
    SELECT
        f.FanID,
        f.FirstName + ' ' + f.LastName,
        COUNT(ts.TicketID)
    FROM Fans    f
    LEFT JOIN TicketSales ts ON f.FanID = ts.FanID                       
    GROUP BY f.FanID, f.FirstName, f.LastName
    ORDER BY f.FanID;
 
OPEN cur_FanTickets;
 
FETCH NEXT FROM cur_FanTickets
INTO @CurFanID, @CurFanName, @CurCount;
 
WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT 'Fan: ' + @CurFanName +
          '  |  Tickets Purchased: ' + CAST(@CurCount AS VARCHAR);
 
    FETCH NEXT FROM cur_FanTickets
    INTO @CurFanID, @CurFanName, @CurCount;
END;
 
CLOSE cur_FanTickets;
DEALLOCATE cur_FanTickets;
 
PRINT '';
PRINT '========== END OF SUMMARY ==========';
GO

-- ============================================================
-- Section 5 c: Transactions
-- ============================================================

-- ------------------------------------------------------------
-- TXN1: Cancel a ticket with full rollback on failure
-- Usage: EXEC usp_CancelTicket @TicketID = 8001
-- ------------------------------------------------------------
CREATE PROCEDURE usp_CancelTicket
    @TicketID INT
AS
BEGIN
    BEGIN TRANSACTION;
    BEGIN TRY
        -- Check if the ticket exists
        IF NOT EXISTS (SELECT 1 FROM TicketSales WHERE TicketID = @TicketID)
        BEGIN
            RAISERROR('Error: TicketID %d does not exist. Cancellation failed.', 16, 1, @TicketID);
            ROLLBACK TRANSACTION;
            RETURN;
        END
        -- Delete the ticket
        DELETE FROM TicketSales WHERE TicketID = @TicketID;
        -- If we reach here, commit the transaction
        COMMIT TRANSACTION;
        PRINT 'Ticket cancellation successful for TicketID ' + CAST(@TicketID AS VARCHAR);
    END TRY
    BEGIN CATCH
        -- Rollback transaction on error
        ROLLBACK TRANSACTION;
        PRINT 'An error occurred during ticket cancellation: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

--EXEC usp_CancelTicket @TicketID = 8001; -- Cancel ticket for FanID 9001
--GO

-- ------------------------------------------------------------
-- TXN2: Transfer a player to another team atomically
-- Usage: EXEC usp_TransferPlayer @PlayerID=101,
--            @NewTeamID=40, @NewJersey=88
-- ------------------------------------------------------------
CREATE PROCEDURE usp_TransferPlayer
    @PlayerID INT,
    @NewTeamID INT,
    @NewJersey INT
AS 
BEGIN 
    BEGIN TRANSACTION;
    BEGIN TRY
        -- Check if player exists
        IF NOT EXISTS (SELECT 1 FROM Players WHERE PlayerID = @PlayerID)
        BEGIN
            RAISERROR('Error: PlayerID %d does not exist. Transfer failed.', 16, 1, @PlayerID);
            ROLLBACK TRANSACTION;
            RETURN;
        END
        -- Check if new team exists
        IF NOT EXISTS (SELECT 1 FROM TeamTable WHERE TeamID = @NewTeamID)
        BEGIN
            RAISERROR('Error: TeamID %d does not exist. Transfer failed.', 16, 1, @NewTeamID);
            ROLLBACK TRANSACTION;
            RETURN;
        END
        -- Check for jersey number conflict in new team
        IF EXISTS (SELECT 1 FROM Players WHERE TeamID = @NewTeamID AND JerseyNumber = @NewJersey)
        BEGIN
            RAISERROR('Error: Jersey number %d already taken in the new team. Transfer failed.', 16, 1, @NewJersey);
            ROLLBACK TRANSACTION;
            RETURN;
        END
        -- Perform the transfer
        UPDATE Players 
        SET TeamID = @NewTeamID, JerseyNumber = @NewJersey 
        WHERE PlayerID = @PlayerID;
        
        COMMIT TRANSACTION;
        PRINT 'Player transfer successful for PlayerID ' + CAST(@PlayerID AS VARCHAR);
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        PRINT 'An error occurred during player transfer: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- ------------------------------------------------------------
-- TXN3: Update a fan's email address safely.
--       Rolls back if the new email is already in use.
-- Usage: EXEC usp_UpdateFanEmail @FanID=9001,
--            @NewEmail='new.email@example.com'
-- ------------------------------------------------------------
CREATE PROCEDURE usp_UpdateFanEmail
    @FanID INT,
    @NewEmail NVARCHAR(40)
AS
BEGIN 
    BEGIN TRANSACTION;
    BEGIN TRY
        -- Check if fan exists
        IF NOT EXISTS (SELECT 1 FROM Fans WHERE FanID = @FanID)
        BEGIN
            RAISERROR('Error: FanID %d does not exist. Email update failed.', 16, 1, @FanID);
            ROLLBACK TRANSACTION;
            RETURN;
        END
        -- Check if new email is already in use
        IF EXISTS (SELECT 1 FROM Fans WHERE Email = @NewEmail)
        BEGIN
            RAISERROR('Error: Email %s is already in use. Email update failed.', 16, 1, @NewEmail);
            ROLLBACK TRANSACTION;
            RETURN;
        END
        -- Update the email address
        UPDATE Fans 
        SET Email = @NewEmail 
        WHERE FanID = @FanID;
        
        COMMIT TRANSACTION;
        PRINT 'Email update successful for FanID ' + CAST(@FanID AS VARCHAR);
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        PRINT 'An error occurred during email update: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

--EXEC usp_UpdateFanEmail @FanID = 9001, @NewEmail = 'marcus.jordan@newmail.com';
--GO

-- ============================================================
-- Section 6: Security 
-- ============================================================

-- ------------------------------------------------------------
-- 6 a. Authentication - Logins, Users, Roles & Permissions
-- ------------------------------------------------------------
USE SoccerWorldCup2026
GO

-- SQL Server Logins
IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = 'TournamentAdmin')
    CREATE LOGIN TournamentAdmin WITH PASSWORD = 'Admin@WorldCup2026!';
GO
IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = 'MatchOfficial')
    CREATE LOGIN MatchOfficial   WITH PASSWORD = 'Official@WorldCup2026!';
GO
IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = 'TicketingStaff')
    CREATE LOGIN TicketingStaff  WITH PASSWORD = 'Ticketing@WorldCup2026!';
GO

-- Database users
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'TournamentAdmin')
    CREATE USER TournamentAdmin FOR LOGIN TournamentAdmin;
GO
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'MatchOfficial')
    CREATE USER MatchOfficial   FOR LOGIN MatchOfficial;
GO
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'TicketingStaff')
    CREATE USER TicketingStaff  FOR LOGIN TicketingStaff;
GO

-- Database roles
IF NOT EXISTS (SELECT 1 FROM sys.database_principals
               WHERE name = 'AdminRole' AND type = 'R')
    CREATE ROLE AdminRole;
GO
IF NOT EXISTS (SELECT 1 FROM sys.database_principals
               WHERE name = 'MatchOfficialRole' AND type = 'R')
    CREATE ROLE MatchOfficialRole;
GO
IF NOT EXISTS (SELECT 1 FROM sys.database_principals
               WHERE name = 'TicketingRole' AND type = 'R')
    CREATE ROLE TicketingRole;
GO

-- Assign users to roles
ALTER ROLE AdminRole ADD MEMBER TournamentAdmin;
ALTER ROLE MatchOfficialRole ADD MEMBER MatchOfficial;
ALTER ROLE TicketingRole ADD MEMBER TicketingStaff;
GO

-- AdminRole: full access to all tables and procedures
GRANT SELECT, INSERT, UPDATE, DELETE ON Countries TO AdminRole;
GRANT SELECT, INSERT, UPDATE, DELETE ON TeamTable TO AdminRole;
GRANT SELECT, INSERT, UPDATE, DELETE ON Players TO AdminRole;
GRANT SELECT, INSERT, UPDATE, DELETE ON Staff TO AdminRole;
GRANT SELECT, INSERT, UPDATE, DELETE ON Stadium TO AdminRole;
GRANT SELECT, INSERT, UPDATE, DELETE ON Matches TO AdminRole;
GRANT SELECT, INSERT, UPDATE, DELETE ON PlayerMatchStats TO AdminRole;
GRANT SELECT, INSERT, UPDATE, DELETE ON Fans TO AdminRole;
GRANT SELECT, INSERT, UPDATE, DELETE ON TicketSales TO AdminRole;
GRANT EXECUTE ON sp_GetTeamSchedule TO AdminRole;
GRANT EXECUTE ON sp_GetTeamPlayers TO AdminRole;
GRANT EXECUTE ON sp_GetMatchTickets TO AdminRole;
GRANT EXECUTE ON usp_CancelTicket TO AdminRole;
GRANT EXECUTE ON usp_TransferPlayer TO AdminRole;
GO

-- MatchOfficialRole: read access + update match scores and stats
GRANT SELECT ON Matches TO MatchOfficialRole;
GRANT SELECT ON TeamTable TO MatchOfficialRole;
GRANT SELECT ON Stadium TO MatchOfficialRole;
GRANT SELECT ON Players TO MatchOfficialRole;
GRANT SELECT, INSERT, UPDATE ON PlayerMatchStats TO MatchOfficialRole;
GRANT EXECUTE ON sp_GetTeamSchedule TO MatchOfficialRole;
GRANT EXECUTE ON sp_GetTeamPlayers TO MatchOfficialRole;
GO

-- TicketingRole: manage fans and tickets only
GRANT SELECT, INSERT, UPDATE ON Fans TO TicketingRole;
GRANT SELECT, INSERT, UPDATE ON TicketSales TO TicketingRole;
GRANT SELECT ON Matches TO TicketingRole;
GRANT EXECUTE ON sp_GetMatchTickets TO TicketingRole;
GRANT EXECUTE ON usp_CancelTicket TO TicketingRole;
 
-- Deny sensitive tables to ticketing staff
DENY SELECT ON Players TO TicketingRole;
DENY SELECT ON Staff TO TicketingRole;
GO
 

-- ------------------------------------------------------------
-- 6 b. Encryption - AES-256 encryption on fan email addresses
-- ------------------------------------------------------------

-- Step 1: Database Master Key
IF NOT EXISTS (
    SELECT 1 FROM sys.symmetric_keys
    WHERE name = '##MS_DatabaseMasterKey##'
)
BEGIN
    CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'MasterKey@FIFA2026!Secure#';
END;
GO

-- Step 2: Certificate to protect the symmetric key
IF NOT EXISTS (SELECT 1 FROM sys.certificates WHERE name = 'FanDataCertificate')
BEGIN
    CREATE CERTIFICATE FanDataCertificate
    WITH SUBJECT = 'Certificate for encrypting fan personal data';
END;
GO

-- Step 3: Symmetric key using AES-256
IF NOT EXISTS (SELECT 1 FROM sys.symmetric_keys WHERE name = 'FanEmailKey')
BEGIN
    CREATE SYMMETRIC KEY FanEmailKey
    WITH ALGORITHM = AES_256
    ENCRYPTION BY CERTIFICATE FanDataCertificate;
END;
GO

-- Step 4: Encrypt existing fan email values

OPEN SYMMETRIC KEY FanEmailKey DECRYPTION BY CERTIFICATE FanDataCertificate;
 
UPDATE Fans
SET EmailEncrypted = ENCRYPTBYKEY(KEY_GUID('FanEmailKey'), Email);
 
CLOSE SYMMETRIC KEY FanEmailKey;
GO

-- Step 5: Demonstrate decryption (authorised users only)
OPEN SYMMETRIC KEY FanEmailKey DECRYPTION BY CERTIFICATE FanDataCertificate;
 
SELECT
    FanID,
    FirstName + ' ' + LastName                           AS FanName,
    CONVERT(NVARCHAR(200), DECRYPTBYKEY(EmailEncrypted)) AS DecryptedEmail,
    EmailEncrypted                                       AS EncryptedEmailBinary
FROM Fans;
 
CLOSE SYMMETRIC KEY FanEmailKey;
GO

-- ============================================================
-- Section 7: DataBase Backup
-- ============================================================
-- Full database backup

BACKUP DATABASE [SoccerWorldCup2026]
TO DISK = 'C:\Users\Public\Documents\SoccerWorldCup2026_Full.bak'
WITH
    FORMAT,
    INIT,
    NAME = 'SoccerWorldCup2026 - Full Backup',
    DESCRIPTION = 'Full backup of the FIFA World Cup 2026 tournament database',
    STATS = 10;
GO

-- Verify the backup is readable before trusting it
RESTORE VERIFYONLY
FROM DISK = 'C:\Users\Public\Documents\SoccerWorldCup2026_Full.bak';
GO
 
PRINT 'SoccerWorldCup2026 database built and backed up successfully.';
GO

-- ============================================================
--                           END 
-- ============================================================