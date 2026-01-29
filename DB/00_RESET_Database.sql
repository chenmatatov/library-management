USE LibraryDB;
GO



-- מחיקת כל FK שמפנים ל-Books
DECLARE @sql NVARCHAR(MAX) = N'';
SELECT @sql += 'ALTER TABLE ' + QUOTENAME(OBJECT_NAME(parent_object_id)) +
               ' DROP CONSTRAINT ' + QUOTENAME(name) + ';' + CHAR(13)
FROM sys.foreign_keys
WHERE referenced_object_id = OBJECT_ID('Books');
EXEC sp_executesql @sql;

-- מחיקת כל FK שמפנים ל-Locations
SET @sql = N'';
SELECT @sql += 'ALTER TABLE ' + QUOTENAME(OBJECT_NAME(parent_object_id)) +
               ' DROP CONSTRAINT ' + QUOTENAME(name) + ';' + CHAR(13)
FROM sys.foreign_keys
WHERE referenced_object_id = OBJECT_ID('Locations');
EXEC sp_executesql @sql;

-- מחיקת כל FK שמפנים ל-Statuses
SET @sql = N'';
SELECT @sql += 'ALTER TABLE ' + QUOTENAME(OBJECT_NAME(parent_object_id)) +
               ' DROP CONSTRAINT ' + QUOTENAME(name) + ';' + CHAR(13)
FROM sys.foreign_keys
WHERE referenced_object_id = OBJECT_ID('Statuses');
EXEC sp_executesql @sql;


DROP TABLE IF EXISTS Books;
DROP TABLE IF EXISTS Locations;
DROP TABLE IF EXISTS Statuses;

CREATE TABLE Statuses (
    ID INT PRIMARY KEY,
    Name NVARCHAR(100),
    Description NVARCHAR(999)
);

CREATE TABLE Locations (
    ID INT PRIMARY KEY,
    LocationName NVARCHAR(255),
    Description NTEXT
);

CREATE TABLE Books (
   ID INT IDENTITY(1,1) PRIMARY KEY,
    Title NVARCHAR(255),
    Author NVARCHAR(255),
    Category NVARCHAR(100),
    Description NVARCHAR(999),
    StatusId INT,
    PublishYear INT,
    AvailableCopies INT,
    LocationId INT,
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (LocationId) REFERENCES Locations(ID),
    FOREIGN KEY (StatusId) REFERENCES Statuses(ID)
);


INSERT INTO Statuses (ID, Name, Description) VALUES
(1, N'זמין', N'הספר זמין להשאלה'),
(2, N'לא זמין', N'הספר לא זמין כרגע'),
(3, N'ממתין להשאלה', N'הספר ממתין להשאלה');

INSERT INTO Locations (ID, LocationName, Description) VALUES
(1, N'מדף ספרי קודש', N'המדף הראשון בספרייה'),
(2, N'מדף ספרי חינוך', N'המדף השני בספרייה'),
(3, N'מדף ספרי ילדים', N'המדף השלישי'),
(4, N'מדף ספרי חסידות', N'המדף הרביעי'),
(5, N'מדף ספרי קריאה', N'המדף החמישי'),
(6, N'ארכיון', N'ספרים בארכיון');

-- שליפת כל הנתונים מטבלת Books
SELECT * FROM Books;

-- שליפת כל הנתונים מטבלת Locations
SELECT * FROM Locations;

-- שליפת כל הנתונים מטבלת Statuses
SELECT * FROM Statuses;

USE LibraryDB;
GO

DELETE FROM Books;
-- אם רוצים גם לאפס את הספירה של ה-ID:
DBCC CHECKIDENT ('Books', RESEED, 0);

