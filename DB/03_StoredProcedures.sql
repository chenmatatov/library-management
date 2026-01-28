USE LibraryDB;
GO

CREATE PROCEDURE Books_GetById
    @Id INT = 1
AS
BEGIN
    SELECT 
        b.ID,
        b.Title,
        b.Author,
        b.Category,
        b.Description,
        b.PublishYear,
        b.AvailableCopies,
        s.Name AS StatusName,
        l.LocationName,
        b.StatusId,
        b.LocationId
    FROM Books b
    JOIN Statuses s ON b.StatusId = s.ID 
    JOIN Locations l ON b.LocationId = l.ID
    WHERE b.ID = @Id;
END
GO

CREATE PROCEDURE Books_GetAll
    @SearchText VARCHAR(255) = NULL
AS
BEGIN
    SELECT 
        b.ID,
        b.Title,
        b.Author,
        b.Category,
        b.Description,
        b.PublishYear,
        b.AvailableCopies,
        s.Name AS StatusName,
        l.LocationName
    FROM Books b
    JOIN Statuses s ON b.StatusId = s.ID 
    JOIN Locations l ON b.LocationId = l.ID
    WHERE (@SearchText IS NULL OR b.Title LIKE '%' + @SearchText + '%' 
           OR b.Author LIKE '%' + @SearchText + '%')
END
GO

CREATE PROCEDURE Books_Create
    @Title VARCHAR(255),
    @Author VARCHAR(255),
    @Category VARCHAR(100),
    @Description VARCHAR(999),
    @StatusId INT,
    @PublishYear INT,
    @AvailableCopies INT,
    @LocationId INT
AS
BEGIN
    INSERT INTO Books (Title, Author, Category, Description, StatusId, PublishYear, AvailableCopies, LocationId)
    VALUES (@Title, @Author, @Category, @Description, @StatusId, @PublishYear, @AvailableCopies, @LocationId)
    
    SELECT SCOPE_IDENTITY() AS NewBookId
END
GO

CREATE PROCEDURE UpdateBook
    @BookId INT,
    @Title VARCHAR(255),
    @Author VARCHAR(255),
    @Category VARCHAR(100),
    @Description VARCHAR(999),
    @StatusId INT,
    @PublishYear INT,
    @AvailableCopies INT,
    @LocationId INT
AS
BEGIN
    UPDATE Books
    SET 
        Title = @Title,
        Author = @Author,
        Category = @Category,
        Description = @Description,
        StatusId = @StatusId,
        PublishYear = @PublishYear,
        AvailableCopies = @AvailableCopies,
        LocationId = @LocationId
    WHERE ID = @BookId;
END
GO

CREATE PROCEDURE DeleteBook
    @BookId INT
AS
BEGIN
    DELETE FROM Books
    WHERE ID = @BookId;
END
GO

CREATE PROCEDURE ChangeStatus
    @BookID INT,
    @NewStatusID INT
AS
BEGIN
    UPDATE Books
    SET StatusId = @NewStatusID
    WHERE ID = @BookID;
END
GO

CREATE PROCEDURE Statuses_GetAll
AS
BEGIN
    SELECT ID, Name, Description
    FROM Statuses
END
GO

CREATE PROCEDURE Locations_GetAll
AS
BEGIN
    SELECT ID, LocationName, Description
    FROM Locations
END
GO

EXEC Books_GetAll;
EXEC Statuses_GetAll;
EXEC Locations_GetAll;
EXEC Books_GetById @Id = 1;