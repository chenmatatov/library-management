USE LibraryDB;
GO

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

SELECT * FROM Books;

SELECT * FROM Locations;

SELECT * FROM Statuses;



