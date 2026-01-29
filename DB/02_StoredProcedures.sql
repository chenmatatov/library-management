USE LibraryDB;
GO

CREATE PROCEDURE Books_GetById
    @Id INT
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
        b.StatusId,
        s.Name AS StatusName,
        b.LocationId,
        l.LocationName
    FROM Books b
    LEFT JOIN Statuses s ON b.StatusId = s.ID
    LEFT JOIN Locations l ON b.LocationId = l.ID
    WHERE b.ID = @Id;
END
GO

CREATE OR ALTER PROCEDURE Books_GetAll
    @SearchText NVARCHAR(255) = NULL
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
        b.StatusId,
        s.Name AS StatusName,
        b.LocationId,
        l.LocationName,
        b.CreatedAt  -- <-- הוספתי את CreatedAt
    FROM Books b
    LEFT JOIN Statuses s ON b.StatusId = s.ID
    LEFT JOIN Locations l ON b.LocationId = l.ID
    WHERE @SearchText IS NULL 
          OR b.Title LIKE N'%' + @SearchText + '%'
          OR b.Author LIKE N'%' + @SearchText + '%'
          OR b.Category LIKE N'%' + @SearchText + '%'
          OR b.Description LIKE N'%' + @SearchText + '%'
    ORDER BY b.Title;
END
GO


CREATE OR ALTER PROCEDURE Books_Create
    @Title NVARCHAR(255),
    @Author NVARCHAR(255),
    @Category NVARCHAR(100),
    @Description NVARCHAR(999),
    @StatusId INT,
    @PublishYear INT,
    @AvailableCopies INT,
    @LocationId INT
AS
BEGIN
    INSERT INTO Books (Title, Author, Category, Description, StatusId, PublishYear, AvailableCopies, LocationId)
    VALUES (@Title, @Author, @Category, @Description, @StatusId, @PublishYear, @AvailableCopies, @LocationId);

    SELECT * FROM Books WHERE ID = SCOPE_IDENTITY();
END;
GO



CREATE PROCEDURE UpdateBook
    @BookId INT,
    @Title NVARCHAR(255),
    @Author NVARCHAR(255),
    @Category NVARCHAR(100),
    @Description NVARCHAR(1000) = NULL,
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
    FROM Statuses;
END
GO

CREATE PROCEDURE Locations_GetAll
AS
BEGIN
    SELECT ID, LocationName, Description
    FROM Locations;
END
GO

CREATE PROCEDURE GetAllCategories
AS
BEGIN
    SELECT DISTINCT Category
    FROM Books
    WHERE Category IS NOT NULL
    ORDER BY Category;
END
GO


EXEC Books_Create @Title=N'תניא', @Author=N'רבי שניאור זלמן', @Category=N'ספרי קודש', @Description=N'ספר יסוד חסידי, ספר תורת החסידות', @StatusId=1, @PublishYear=1800, @AvailableCopies=5, @LocationId=4;
EXEC Books_Create @Title=N'חומש עם תרגום', @Author=N'רבי חיים עוזר', @Category=N'ספרי קודש', @Description=N'חומש עם תרגום ופרשנות', @StatusId=1, @PublishYear=1940, @AvailableCopies=10, @LocationId=1;
EXEC Books_Create @Title=N'סידור תפילה', @Author=N'רבי דוד כהן', @Category=N'ספרי קודש', @Description=N'סידור תפילה על פי שיטת החסידות', @StatusId=1, @PublishYear=1960, @AvailableCopies=8, @LocationId=1;
EXEC Books_Create @Title=N'השליחות', @Author=N'רבי מנחם מנדל', @Category=N'ספרי חסידות', @Description=N'ספר חסידי עם סיפורי מוסר והדרכה', @StatusId=2, @PublishYear=1995, @AvailableCopies=3, @LocationId=4;
EXEC Books_Create @Title=N'הדרך למנוחה', @Author=N'רבי יצחק אייזיק', @Category=N'ספרי חסידות', @Description=N'ספר המדריך למציאת מנוחה רוחנית', @StatusId=1, @PublishYear=1980, @AvailableCopies=6, @LocationId=4;
EXEC Books_Create @Title=N'החינוך היהודי', @Author=N'רבי יואל', @Category=N'ספרי חינוך', @Description=N'ספר חינוך על פי דרכי התורה היהודית', @StatusId=2, @PublishYear=1990, @AvailableCopies=7, @LocationId=2;
EXEC Books_Create @Title=N'הסיפור של יוסי', @Author=N'נחמן קרמר', @Category=N'ספרי ילדים', @Description=N'סיפור ילדים על התמודדות עם קשיים', @StatusId=1, @PublishYear=2015, @AvailableCopies=20, @LocationId=3;
EXEC Books_Create @Title=N'שיעורי תורה לילדים', @Author=N'רבי יוסף יצחק', @Category=N'ספרי ילדים', @Description=N'ספר לימוד תורה לילדים בגילאים צעירים', @StatusId=1, @PublishYear=2000, @AvailableCopies=15, @LocationId=3;
EXEC Books_Create @Title=N'הנסיך והנשמה', @Author=N'משה אפרים', @Category=N'ספרי קריאה', @Description=N'סיפור עוסק בתכנים רוחניים ופילוסופיים מתורת ברסלב', @StatusId=3, @PublishYear=2005, @AvailableCopies=8, @LocationId=5;
EXEC Books_Create @Title=N'ההצלחה בתפילה', @Author=N'רבי חיים', @Category=N'ספרי חינוך', @Description=N'ספר המסביר את הדרך להצלחה בתפילה', @StatusId=1, @PublishYear=1990, @AvailableCopies=12, @LocationId=2;
EXEC Books_Create @Title=N'ספר הילדים המושלם', @Author=N'רבקה אלקיים', @Category=N'ספרי ילדים', @Description=N'ספר לילדים עם סיפורים חינוכיים', @StatusId=1, @PublishYear=2008, @AvailableCopies=18, @LocationId=3;
EXEC Books_Create @Title=N'ספר המדרש', @Author=N'רבי שמעון', @Category=N'ספרי קודש', @Description=N'ספר מדרש עתיק מלא בסיפורים וחוכמה יהודית', @StatusId=2, @PublishYear=1820, @AvailableCopies=4, @LocationId=1;
EXEC Books_Create @Title=N'חינוך על פי התורה', @Author=N'רבי דוד בן חיים', @Category=N'ספרי חינוך', @Description=N'ספר המדריך להורות נכונה על פי התורה', @StatusId=3, @PublishYear=2010, @AvailableCopies=9, @LocationId=2;
EXEC Books_Create @Title=N'ברכות ושיעורים', @Author=N'הרב יצחק', @Category=N'ספרי קריאה', @Description=N'סיפור על ברכות ושיעורים בהלכה', @StatusId=1, @PublishYear=2003, @AvailableCopies=6, @LocationId=5;
EXEC Books_Create @Title=N'מאבק פנימי', @Author=N'יוסי ברוך', @Category=N'ספרי קריאה', @Description=N'סיפור שמסביר על מאבקים פנימיים בחיים הרוחניים', @StatusId=1, @PublishYear=2012, @AvailableCopies=5, @LocationId=5;
EXEC Books_Create @Title=N'סיפור חסידי', @Author=N'רבקה מלכה', @Category=N'ספרי חסידות', @Description=N'סיפור חסידי עם מוסר השכל ושיעור רוחני', @StatusId=1, @PublishYear=1998, @AvailableCopies=7, @LocationId=4;
EXEC Books_Create @Title=N'מפתח לבריאות רוחנית', @Author=N'רבי אברהם', @Category=N'ספרי חינוך', @Description=N'ספר המסביר כיצד לשמור על בריאות רוחנית בעידן המודרני', @StatusId=1, @PublishYear=2020, @AvailableCopies=5, @LocationId=2;
EXEC Books_Create @Title=N'לימוד תורה לילדים', @Author=N'חיים חיים', @Category=N'ספרי ילדים', @Description=N'ספר לימוד שמיועד לילדים בגילאי 6-9', @StatusId=1, @PublishYear=2007, @AvailableCopies=15, @LocationId=3;
EXEC Books_Create @Title=N'ההתחלה מחדש', @Author=N'רבי נתן', @Category=N'ספרי קריאה', @Description=N'ספר אישי שמסביר על הדרך להתחיל מחדש על פי תורה', @StatusId=2, @PublishYear=2018, @AvailableCopies=10, @LocationId=5;
GO


EXEC Books_GetById @Id = 1;
GO

EXEC Books_GetAll;
GO

EXEC Books_GetAll @SearchText = N'נתן';
GO

EXEC UpdateBook
    @BookId = 1,
    @Title = N'ספר לדוגמה - מעודכן',
    @Author = N'חן לוי',
    @Category = N'ספרות מודרנית',
    @Description = N'תיאור מעודכן',
    @StatusId = 2,
    @PublishYear = 2024,
    @AvailableCopies = 10,
    @LocationId = 1;
GO

EXEC ChangeStatus @BookID = 1, @NewStatusID = 3;
GO

EXEC Statuses_GetAll;
GO

EXEC Locations_GetAll;
GO

EXEC GetAllCategories;
GO

EXEC DeleteBook @BookId = 1;
GO

EXEC Books_GetAll;
GO