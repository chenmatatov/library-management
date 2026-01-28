IF EXISTS (SELECT name FROM sys.databases WHERE name = 'LibraryDB')
BEGIN
    ALTER DATABASE LibraryDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE LibraryDB;
END

CREATE DATABASE LibraryDB;
GO

USE LibraryDB;
GO

CREATE TABLE Statuses (
    ID INT PRIMARY KEY, 
    Name VARCHAR(100),   
    Description VARCHAR(999)  
);

CREATE TABLE Locations (
    ID INT PRIMARY KEY,           
    LocationName VARCHAR(255),     
    Description TEXT             
);

CREATE TABLE Books (
    ID INT PRIMARY KEY,
    Title VARCHAR(255),
    Author VARCHAR(255),
    Category VARCHAR(100),
    Description VARCHAR(999),
    StatusId INT,
    PublishYear INT,
    AvailableCopies INT,
    LocationId INT,
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (LocationId) REFERENCES Locations(ID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (StatusId) REFERENCES Statuses(ID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Borrowings (
    ID INT PRIMARY KEY, 
    MemberID INT,
    BookID INT, 
    BorrowDate DATE, 
    ReturnDate DATE, 
    BookCondition VARCHAR(100),
    FOREIGN KEY (BookID) REFERENCES Books(ID) ON DELETE CASCADE ON UPDATE CASCADE 
);

INSERT INTO Statuses (ID, Name, Description) VALUES
(1, 'זמין', 'הספר זמין להשאלה'),
(2, 'לא זמין', 'הספר לא זמין להשאלה'),
(3, 'ממתין להשאלה', 'הספר נמצא בתור להשאלה');

INSERT INTO Locations (ID, LocationName, Description) VALUES
(1, 'מדף ספרי קודש', 'מדף בו נמצאים ספרי קודש כמו תורניות'),
(2, 'מדף ספרי חינוך', 'מדף בו נמצאים ספרי חינוך והדרכה'),
(3, 'מדף ספרי ילדים', 'מדף עם ספרים לילדים'),
(4, 'מדף ספרי חסידות', 'מדף המוקדש לספרי חסידות'),
(5, 'מדף ספרי קריאה', 'מדף עם ספרי קריאה כלליים'),
(6, 'חדר קריאה', 'חדר בו ניתן לשבת ולקרוא ספרים');

INSERT INTO Books (ID, Title, Author, Category, Description, StatusId, PublishYear, AvailableCopies, LocationId) VALUES
(1, 'תניא', 'רבי שניאור זלמן', 'ספרי קודש', 'ספר יסוד חסידי, ספר תורת החסידות', 1, 1800, 5, 4),
(2, 'חומש עם תרגום', 'רבי חיים עוזר', 'ספרי קודש', 'חומש עם תרגום ופרשנות', 1, 1940, 10, 1),
(3, 'סידור תפילה', 'רבי דוד כהן', 'ספרי קודש', 'סידור תפילה על פי שיטת החסידות', 1, 1960, 8, 1),
(4, 'השליחות', 'רבי מנחם מנדל', 'ספרי חסידות', 'ספר חסידי עם סיפורי מוסר והדרכה', 2, 1995, 3, 4),
(5, 'הדרך למנוחה', 'רבי יצחק אייזיק', 'ספרי חסידות', 'ספר המדריך למציאת מנוחה רוחנית', 1, 1980, 6, 4),
(6, 'החינוך היהודי', 'רבי יואל', 'ספרי חינוך', 'ספר חינוך על פי דרכי התורה היהודית', 2, 1990, 7, 2),
(7, 'הסיפור של יוסי', 'נחמן קרמר', 'ספרי ילדים', 'סיפור ילדים על התמודדות עם קשיים', 1, 2015, 20, 3),
(8, 'שיעורי תורה לילדים', 'רבי יוסף יצחק', 'ספרי ילדים', 'ספר לימוד תורה לילדים בגילאים צעירים', 1, 2000, 15, 3),
(9, 'הנסיך והנשמה', 'משה אפרים', 'ספרי קריאה', 'סיפור עוסק בתכנים רוחניים ופילוסופיים מתורת ברסלv', 3, 2005, 8, 5),
(10, 'ההצלחה בתפילה', 'רבי חיים', 'ספרי חינוך', 'ספר המסביר את הדרך להצלחה בתפילה', 1, 1990, 12, 2),
(11, 'ספר הילדים המושלם', 'רבקה אלקיים', 'ספרי ילדים', 'ספר לילדים עם סיפורים חינוכיים', 1, 2008, 18, 3),
(12, 'ספר המדרש', 'רבי שמעון', 'ספרי קודש', 'ספר מדרש עתיק מלא בסיפורים וחוכמה יהודית', 2, 1820, 4, 1),
(13, 'חינוך על פי התורה', 'רבי דוד בר חיים', 'ספרי חינוך', 'ספר המדריך להורות נכונה על פי התורה', 3, 2010, 9, 2),
(14, 'ברכות ושיעורים', 'הרב יצחק', 'ספרי קריאה', 'ספר על ברכות ושיעורים בהלכה', 1, 2003, 6, 5),
(15, 'מאבק פנימי', 'יוסי ברוך', 'ספרי קריאה', 'ספר שמסביר על מאבקים פנימיים בחיים הרוחניים', 1, 2012, 5, 5),
(16, 'סיפור חסידי', 'רבקה מלכה', 'ספרי חסידות', 'סיפור חסידי עם מוסר השכל ושיעור רוחני', 1, 1998, 7, 4),
(17, 'מפתח לבריאות רוחנית', 'רבי אברהם', 'ספרי חינוך', 'ספר המסביר כיצד לשמור על בריאות רוחנית בעידן המודרני', 1, 2020, 5, 2),
(18, 'לימוד תורה לילדים', 'חיים חיים', 'ספרי ילדים', 'ספר לימוד שמיועד לילדים בגילאי 6-9', 1, 2007, 15, 3),
(19, 'ההתחלה מחדש', 'רבי נתן', 'ספרי קריאה', 'ספר אישי שמסביר על הדרך להתחיל מחדש על פי תורה', 2, 2018, 10, 5);

SELECT COUNT(*) AS BooksCount FROM Books;
SELECT COUNT(*) AS StatusesCount FROM Statuses;
SELECT COUNT(*) AS LocationsCount FROM Locations;
