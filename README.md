# SoccerWorldCupDatabase
# FIFA World Cup 2026 Tournament Database

A relational database system built in Microsoft SQL Server (T-SQL) for managing the 2026 FIFA World Cup tournament — teams, players, coaching staff, stadiums, matches, fans, and ticket sales.

## Project Overview

The database supports the core operations of a football tournament: registering teams and their coaching staff, tracking players and their match statistics, scheduling matches across stadiums, and managing fan ticket bookings. It was designed from the ground up (0NF → 3NF) to eliminate redundancy and enforce data integrity, using Microsoft SQL Server and T-SQL.

## Repository Contents

| File | Description |
|---|---|
| `ProjectDBDmain.sql` | Full T-SQL script — database/table creation, sample data, stored procedures, functions, views, triggers, reports, and security roles |
| `SoccerWorldCup2026_Full.bak` | SQL Server backup file of the populated database |
| `DBD281_Project_.pdf` | Project documentation — normalization steps (0NF–3NF), business rules, ERD diagram, and ERD table |

## Database Schema

The database is normalized to Third Normal Form (3NF) and consists of the following tables:

- **Countries** — country reference data
- **TeamTable** — national teams, linked to a country and coach
- **Players** — squad members, linked to a team
- **Staff** — coaching staff, linked to a team
- **Stadium** — venues, linked to a country
- **Matches** — fixtures between two teams at a stadium
- **PlayerMatchStats** — per-player statistics per match (goals, assists, cards, minutes played)
- **Fans** — fan/spectator records, linked to a country
- **TicketSales** — ticket bookings, linked to a match and a fan

See the ERD diagram and full attribute/key breakdown in `DBD281_Project_.pdf`.

### Key Business Rules

- Each team must have a unique ID and exactly one coach.
- A match must involve exactly two different teams (a team cannot play itself).
- Each match takes place at exactly one stadium, and has a scheduled date/time.
- Ticket sales for a match cannot exceed that stadium's capacity.
- Every ticket price must be greater than 0.
- Every player, coach, ticket, and booking must reference valid, existing records (referential integrity enforced via foreign keys).

## Database Objects

Beyond the core tables, `ProjectDBDmain.sql` implements:

**Stored Procedures**
- `sp_GetTeamSchedule` — returns a team's fixture list
- `sp_GetTeamPlayers` — returns a team's squad
- `sp_GetMatchTickets` — returns tickets sold for a match
- `usp_CancelTicket` — cancels a ticket booking
- `usp_TransferPlayer` — transfers a player between teams
- `usp_UpdateFanEmail` — updates a fan's contact email

**Functions**
- `fn_PlayerAge` — calculates a player's age from date of birth
- `fn_GetSquad` — returns a team's full squad list

**Views**
- `vw_MatchResults` — match results overview
- `vw_TopScorers` — top goal scorers
- `vw_TicketSales` — ticket sales summary

**Triggers**
- `trg_EnforceCoach` — ensures every team has a coach
- `trg_EnforceStadiumCapacity` — prevents ticket sales exceeding stadium capacity
- `trg_UniqueJerseyNumbers` — prevents duplicate jersey numbers within a team

**Security**
- Custom SQL Server logins, users, and roles (`AdminRole`, `MatchOfficialRole`, `TicketingRole`) with permissions scoped to each role's responsibilities.

**Reports**
- Printed match summary report and fan ticket summary report.

## Getting Started

1. Open **SQL Server Management Studio (SSMS)**.
2. Open `ProjectDBDmain.sql`.
3. Update the file paths in the `CREATE DATABASE` statement (Section 1) to a valid location on your machine if needed.
4. Execute the script — it will drop and recreate the `SoccerWorldCup2026` database, create all tables, insert sample data, and set up procedures, functions, views, triggers, and security roles.

Alternatively, restore `SoccerWorldCup2026_Full.bak` directly in SSMS via **Databases → Restore Database** to get a ready-populated copy of the database.

## Tech Stack

- Microsoft SQL Server
- T-SQL
- SQL Server Management Studio (SSMS)
