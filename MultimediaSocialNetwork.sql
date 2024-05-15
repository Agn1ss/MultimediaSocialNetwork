USE master; 
GO

DROP DATABASE IF EXISTS MSocNetwork;
GO

CREATE DATABASE MSocNetwork; 
GO

USE MSocNetwork; 
GO

-- Создание таблиц узлов
CREATE TABLE Users (
    UserID INT IDENTITY NOT NULL,
    UserName NVARCHAR(100) NOT NULL,
    Age INT NOT NULL,
    City NVARCHAR(100) NOT NULL,
    CONSTRAINT PK_Users PRIMARY KEY (UserID)
) AS NODE;
GO

CREATE TABLE Books (
    BookID INT IDENTITY NOT NULL,
    BookTitle NVARCHAR(100) NOT NULL,
    Author NVARCHAR(100) NOT NULL,
    Genre NVARCHAR(100) NOT NULL,
    CONSTRAINT PK_Books PRIMARY KEY (BookID)
) AS NODE;
GO

CREATE TABLE Movies (
    MovieID INT IDENTITY NOT NULL,
    MovieTitle NVARCHAR(100) NOT NULL,
    Director NVARCHAR(100) NOT NULL,
    Genre NVARCHAR(100) NOT NULL,
    CONSTRAINT PK_Movies PRIMARY KEY (MovieID)
) AS NODE;
GO

CREATE TABLE Cities (
    CityID INT IDENTITY NOT NULL,
    CityName NVARCHAR(100) NOT NULL,
    Country NVARCHAR(100) NOT NULL,
    CONSTRAINT PK_Cities PRIMARY KEY (CityID)
) AS NODE;
GO

-- Создание таблиц ребер
CREATE TABLE Follows AS EDGE;
GO
ALTER TABLE Follows ADD CONSTRAINT EC_Follows CONNECTION (Users to Users);

CREATE TABLE Reads AS EDGE;
GO
ALTER TABLE Reads ADD CONSTRAINT EC_Reads CONNECTION (Users to Books);

CREATE TABLE Watches AS EDGE;
GO
ALTER TABLE Watches ADD CONSTRAINT EC_Watches CONNECTION (Users to Movies);

CREATE TABLE ResidesIn AS EDGE;
GO
ALTER TABLE ResidesIn ADD CONSTRAINT EC_ResidesIn CONNECTION (Users to Cities);


-- Заполнение таблиц узлов
INSERT INTO Users (UserName, Age, City)
VALUES ('John Smith', 25, 'New York'),
       ('Emily Johnson', 30, 'Los Angeles'),
       ('Michael Davis', 40, 'Chicago'),
       ('Jessica Wilson', 28, 'San Francisco'),
       ('David Taylor', 35, 'Houston'),
       ('Emma Anderson', 27, 'Miami'),
       ('Christopher Clark', 32, 'Seattle'),
       ('Olivia Martinez', 29, 'Boston'),
       ('Daniel Rodriguez', 33, 'Dallas'),
       ('Sophia Lee', 31, 'Atlanta');

INSERT INTO Books (BookTitle, Author, Genre)
VALUES ('The Great Gatsby', 'F. Scott Fitzgerald', 'Classic'),
       ('To Kill a Mockingbird', 'Harper Lee', 'Fiction'),
       ('1984', 'George Orwell', 'Dystopian'),
       ('Pride and Prejudice', 'Jane Austen', 'Romance'),
       ('The Catcher in the Rye', 'J.D. Salinger', 'Coming-of-age'),
       ('The Lord of the Rings', 'J.R.R. Tolkien', 'Fantasy'),
       ('Harry Potter and the Sorcerer''s Stone', 'J.K. Rowling', 'Fantasy'),
       ('The Da Vinci Code', 'Dan Brown', 'Thriller'),
       ('The Hobbit', 'J.R.R. Tolkien', 'Fantasy'),
       ('To the Lighthouse', 'Virginia Woolf', 'Modernist');

INSERT INTO Movies (MovieTitle, Director, Genre)
VALUES ('The Shawshank Redemption', 'Frank Darabont', 'Drama'),
       ('The Godfather', 'Francis Ford Coppola', 'Crime'),
       ('The Dark Knight', 'Christopher Nolan', 'Action'),
       ('Pulp Fiction', 'Quentin Tarantino', 'Crime'),
       ('Fight Club', 'David Fincher', 'Drama'),
       ('Inception', 'Christopher Nolan', 'Sci-Fi'),
       ('The Matrix', 'Lana Wachowski, Lilly Wachowski', 'Action'),
       ('Forrest Gump', 'Robert Zemeckis', 'Drama'),
       ('Goodfellas', 'Martin Scorsese', 'Crime'),
       ('The Lord of the Rings: The Fellowship of the Ring', 'Peter Jackson', 'Fantasy');

INSERT INTO Cities (CityName, Country)
VALUES ('New York', 'United States'),
		('London', 'United Kingdom'),
		('Paris', 'France'),
		('Tokyo', 'Japan'),
		('Sydney', 'Australia'),
		('Rome', 'Italy'),
		('Moscow', 'Russia'),
		('Los Angeles', 'United States'),
		('Chicago', 'United States'),
		('Houston', 'United States');



INSERT INTO Follows ($from_id, $to_id)
VALUES
	(
		(SELECT $node_id FROM Users WHERE UserID = 1), -- John Smith
		(SELECT $node_id FROM Users WHERE UserID = 2) -- Emily Johnson
	),
	(
		(SELECT $node_id FROM Users WHERE UserID = 1), -- John Smith
		(SELECT $node_id FROM Users WHERE UserID = 3) -- Michael Davis
	),	
	(
		(SELECT $node_id FROM Users WHERE UserID = 3), -- Michael Davis
		(SELECT $node_id FROM Users WHERE UserID = 4) -- Jessica Wilson
	),	
	(
		(SELECT $node_id FROM Users WHERE UserID = 5), -- David Taylor
		(SELECT $node_id FROM Users WHERE UserID = 6) -- Emma Anderson
	),
	(
		(SELECT $node_id FROM Users WHERE UserID = 5), -- David Taylor
		(SELECT $node_id FROM Users WHERE UserID = 7) -- Christopher Clark
	),
	(
		(SELECT $node_id FROM Users WHERE UserID = 8), -- Olivia Martinez
		(SELECT $node_id FROM Users WHERE UserID = 9) -- Daniel Rodriguez
	),
	(
		(SELECT $node_id FROM Users WHERE UserID = 10), -- Sophia Lee
		(SELECT $node_id FROM Users WHERE UserID = 8) -- Olivia Martinez
	),
	(
		(SELECT $node_id FROM Users WHERE UserID = 10), -- Sophia Lee
		(SELECT $node_id FROM Users WHERE UserID = 1) -- John Smith
	),
	(
		(SELECT $node_id FROM Users WHERE UserID = 10), -- Sophia Lee
		(SELECT $node_id FROM Users WHERE UserID = 3) -- Michael Davis
	),
	(
		(SELECT $node_id FROM Users WHERE UserID = 10), -- Sophia Lee
		(SELECT $node_id FROM Users WHERE UserID = 5) -- David Taylor
	),
	(
		(SELECT $node_id FROM Users WHERE UserID = 2),
		(SELECT $node_id FROM Users WHERE UserID = 5)
	)

;

INSERT INTO Reads ($from_id, $to_id)
VALUES
	(
		(SELECT $node_id FROM Users WHERE UserID = 1), -- John Smith
		(SELECT $node_id FROM Books WHERE BookID = 1) -- The Great Gatsby
	),
	(
		(SELECT $node_id FROM Users WHERE UserID = 2), -- Emily Johnson
		(SELECT $node_id FROM Books WHERE BookID = 2) -- To Kill a Mockingbird
	),
	(
		(SELECT $node_id FROM Users WHERE UserID = 3), -- Michael Davis
		(SELECT $node_id FROM Books WHERE BookID = 3) -- 1984
	),
	(
		(SELECT $node_id FROM Users WHERE UserID = 4), -- Jessica Wilson
		(SELECT $node_id FROM Books WHERE BookID = 4) -- Pride and Prejudice
	),
	(
		(SELECT $node_id FROM Users WHERE UserID = 5), -- David Taylor
		(SELECT $node_id FROM Books WHERE BookID = 5) -- The Catcher in the Rye
	),
	(
		(SELECT $node_id FROM Users WHERE UserID = 6), -- Emma Anderson
		(SELECT $node_id FROM Books WHERE BookID = 6) -- The Lord of the Rings
	),
	(
		(SELECT $node_id FROM Users WHERE UserID = 7), -- Christopher Clark
		(SELECT $node_id FROM Books WHERE BookID = 7) -- Harry Potter and the Sorcerer's Stone
	),
	(
		(SELECT $node_id FROM Users WHERE UserID = 8), -- Olivia Martinez
		(SELECT $node_id FROM Books WHERE BookID = 8) -- The Da Vinci Code
	),
	(
		(SELECT $node_id FROM Users WHERE UserID = 9), -- Daniel Rodriguez
		(SELECT $node_id FROM Books WHERE BookID = 9) -- The Hobbit
	),
	(
		(SELECT $node_id FROM Users WHERE UserID = 10), -- Sophia Lee
		(SELECT $node_id FROM Books WHERE BookID = 10) -- To the Lighthouse
	),
	(
		(SELECT $node_id FROM Users WHERE UserID = 3), -- Michael Davis
		(SELECT $node_id FROM Books WHERE BookID = 7) -- Harry Potter and the Sorcerer's Stone
	),
	(
		(SELECT $node_id FROM Users WHERE UserID = 3), -- Michael Davis
		(SELECT $node_id FROM Books WHERE BookID = 6) -- The Lord of the Rings
	)
;

INSERT INTO Watches ($from_id, $to_id)
VALUES
	(
		(SELECT $node_id FROM Users WHERE UserID = 1), -- John Smith
		(SELECT $node_id FROM Movies WHERE MovieID = 1) -- The Shawshank Redemption
	),
	(
		(SELECT $node_id FROM Users WHERE UserID = 2), -- Emily Johnson
		(SELECT $node_id FROM Movies WHERE MovieID = 2) -- The Godfather
	),
	(
		(SELECT $node_id FROM Users WHERE UserID = 3), -- Michael Davis
		(SELECT $node_id FROM Movies WHERE MovieID = 3) -- The Dark Knight
	),
	(
		(SELECT $node_id FROM Users WHERE UserID = 4), -- Jessica Wilson
		(SELECT $node_id FROM Movies WHERE MovieID = 4) -- Pulp Fiction
	),
	(
		(SELECT $node_id FROM Users WHERE UserID = 5), -- David Taylor
		(SELECT $node_id FROM Movies WHERE MovieID = 5) -- Fight Club
	),
	(
		(SELECT $node_id FROM Users WHERE UserID = 6), -- Emma Anderson
		(SELECT $node_id FROM Movies WHERE MovieID = 6) -- Inception
	),
	(
		(SELECT $node_id FROM Users WHERE UserID = 7), -- Christopher Clark
		(SELECT $node_id FROM Movies WHERE MovieID = 7) -- The Matrix
	),
	(
		(SELECT $node_id FROM Users WHERE UserID = 8), -- Olivia Martinez
		(SELECT $node_id FROM Movies WHERE MovieID = 8) -- Forrest Gump
	),
	(
		(SELECT $node_id FROM Users WHERE UserID = 9), -- Daniel Rodriguez
		(SELECT $node_id FROM Movies WHERE MovieID = 9) -- Goodfellas
	),
	(
		(SELECT $node_id FROM Users WHERE UserID = 10), -- Sophia Lee
		(SELECT $node_id FROM Movies WHERE MovieID = 10) -- The Lord of the Rings: The Fellowship of the Ring
	),
	(
		(SELECT $node_id FROM Users WHERE UserID = 3), -- Michael Davis
		(SELECT $node_id FROM Movies WHERE MovieID = 10) -- The Lord of the Rings: The Fellowship of the Ring
	),
	(
		(SELECT $node_id FROM Users WHERE UserID = 7),-- Christopher Clark
		(SELECT $node_id FROM Movies WHERE MovieID = 1) -- The Lord of the Rings: The Fellowship of the Ring
	),
	(
		(SELECT $node_id FROM Users WHERE UserID = 3), -- Michael Davis
		(SELECT $node_id FROM Movies WHERE MovieID = 9) -- Goodfellas
	)
;

INSERT INTO ResidesIn ($from_id, $to_id)
VALUES
	(
		(SELECT $node_id FROM Users WHERE UserID = 1), -- John Smith
		(SELECT $node_id FROM Cities WHERE CityID = 10) -- New York
	),
	(
		(SELECT $node_id FROM Users WHERE UserID = 2), -- Emily Johnson
		(SELECT $node_id FROM Cities WHERE CityID = 9) -- London
	),
	(
		(SELECT $node_id FROM Users WHERE UserID = 3), -- Michael Davis
		(SELECT $node_id FROM Cities WHERE CityID = 8) -- Paris
	),
	(
		(SELECT $node_id FROM Users WHERE UserID = 4), -- Jessica Wilson
		(SELECT $node_id FROM Cities WHERE CityID = 7) -- Tokyo
	),
	(
		(SELECT $node_id FROM Users WHERE UserID = 5), -- David Taylor
		(SELECT $node_id FROM Cities WHERE CityID = 6) -- Sydney
	),
	(
		(SELECT $node_id FROM Users WHERE UserID = 6), -- Emma Anderson
		(SELECT $node_id FROM Cities WHERE CityID = 5) -- Rome
	),
	(
		(SELECT $node_id FROM Users WHERE UserID = 7), -- Christopher Clark
		(SELECT $node_id FROM Cities WHERE CityID = 4) -- Moscow
	),
	(
		(SELECT $node_id FROM Users WHERE UserID = 8), -- Olivia Martinez
		(SELECT $node_id FROM Cities WHERE CityID = 3) -- Rio de Janeiro
	),
	(
		(SELECT $node_id FROM Users WHERE UserID = 9), -- Daniel Rodriguez
		(SELECT $node_id FROM Cities WHERE CityID = 2) -- Cairo
	),
	(
		(SELECT $node_id FROM Users WHERE UserID = 10), -- Sophia Lee
		(SELECT $node_id FROM Cities WHERE CityID = 1) -- Cape Town
	)
;


-- 5. Запросы с функцией MATCH

-- пользователи, смотревшие "Властелина колец":
SELECT U.UserName AS [Имя пользователя]
FROM Users AS U,
	 Watches AS W, 
	 Movies AS M
WHERE MATCH (U-(W)->M) 
	  AND M.MovieTitle = 'The Lord of the Rings: The Fellowship of the Ring'


-- пользователи, подписанные на Майкла Девиса:
SELECT U1.UserName AS [Имя пользователя]
FROM Users AS U1, 
	 Follows AS S, 
	 Users AS U2
WHERE MATCH (U1-(S)->U2) 
	  AND U2.UserName = 'Michael Davis';	


-- фильмы, которые посмотрел Майкл Девис
SELECT M.MovieTitle AS [фильм]
FROM Users AS U, 
	Watches AS W, 
	Movies AS M
WHERE MATCH (U-(W)->M) 
	AND U.UserName = 'Michael Davis';


-- пользователи, живущие в городах New York, London и Tokyo
SELECT U.UserName AS [Имя пользователя]
FROM Users AS U, 
	ResidesIn AS R, 
	Cities AS C
WHERE MATCH (U-(R)->C)
      AND C.CityName IN ('New York', 'London', 'Tokyo');


-- пользователи, живущие в Америке
SELECT U.UserName AS [Имя пользователя]
FROM Users AS U, 
	ResidesIn AS R, 
	Cities AS C
WHERE MATCH (U-(R)->C)
	AND C.Country = 'United States'


-- 6. Запросы с функцией SHORTEST_PATH

--кратчайший путь от пользователя David Taylor к другим пользователям, где длина пути составляет от 1 до 5
SELECT U1.UserName AS UserName1,
	STRING_AGG(U2.UserName, '->') WITHIN GROUP (GRAPH PATH) AS UserPath
FROM Users AS U1,
	Users FOR PATH AS U2,
	Follows FOR PATH AS F
WHERE MATCH(SHORTEST_PATH(U1(-(F)->U2){1,5}))
	and U1.UserName = 'David Taylor';

-- кратчайший путь от пользователя Michael Davis к другим пользователям любой длины
SELECT U1.UserName AS UserName1,
	STRING_AGG(U2.UserName, '->') WITHIN GROUP (GRAPH PATH) AS UserPath
FROM Users AS U1,
	Users FOR PATH AS U2,
	Follows FOR PATH AS F
WHERE MATCH(SHORTEST_PATH(U1(-(F)->U2)+))
	and U1.UserName = 'Michael Davis';





