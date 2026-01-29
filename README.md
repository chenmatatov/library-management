# מערכת ניהול ספרייה 📚

## תיאור הפרויקט
מערכת ניהול ספרייה מתקדמת הבנויה עם Angular ו-.NET Core, המאפשרת ניהול יעיל של ספרים, מיקומים וסטטוסים.

**מגישות:** שירה מרנשטיין, רבקה לבלנק וחן מטאטוב

## טכנולוגיות
- **Frontend**: Angular 17+ עם TypeScript
- **Backend**: .NET Core Web API
- **Database**: SQL Server
- **UI**: CSS3 עם Responsive Design

## מבנה מסד הנתונים

### טבלאות עיקריות:

**Books** - טבלת הספרים הראשית
```sql
ID, Title, Author, Category, Description, 
StatusId, PublishYear, AvailableCopies, LocationId, CreatedAt
```

**Statuses** - סטטוסי ספרים
```sql
ID, Name, Description
```

**Locations** - מיקומי ספרים
```sql
ID, LocationName, Description
```

### Stored Procedures:
- `Books_Create` - יצירת ספר חדש
- `UpdateBook` - עדכון ספר קיים  
- `Books_GetById` - שליפת ספר לפי ID
- `Books_GetAll` - שליפת כל הספרים + חיפוש
- `Statuses_GetAll` - שליפת כל הסטטוסים
- `Locations_GetAll` - שליפת כל המיקומים
- `ChangeStatus` - שינוי סטטוס ספר
- `DeleteBook` - מחיקת ספר

## הרצת הפרויקט

### 1. הכנת מסד הנתונים:
```sql
-- הרץ את הקבצים בסדר הבא:
1. DB/00_RESET_Database.sql
2. DB/03_StoredProcedures.sql
```

### 2. שרת Backend:
```bash
cd api/LibararyAPI
dotnet run
```
השרת יעלה על: `https://localhost:7141`

### 3. לקוח Frontend:
```bash
cd client
npm install
ng serve
```
פתח דפדפן: `http://localhost:4200`

## מסכי המערכת

### 🏠 מסך רשימת ספרים
- הצגת כל הספרים בטבלה רספונסיבית
- חיפוש טקסט חופשי לפי כותרת/מחבר
- כפתורי צפייה ועריכה לכל ספר
- תצוגת כרטיסים במובייל

### ➕ מסך הוספה/עריכה
- טופס Reactive Forms עם ולידציה מלאה
- רשימות בחירה דינמיות לסטטוס ומיקום
- הודעות משוב למשתמש
- תמיכה במצבי יצירה ועריכה

### 👁️ מסך פרטי ספר
- הצגת כל פרטי הספר בפורמט נקי
- שמות ידידותיים לסטטוס ומיקום
- כפתורי עריכה וחזרה
- טעינה דינמית של נתונים

## ארכיטקטורה

### Backend (.NET Core):
- **Controller יחיד**: `ExecuteController`
- **Endpoint יחיד**: `POST /api/exec`
- **מודל Request**:
```json
{
  "procedureName": "Books_GetById",
  "parameters": {
    "id": 5
  }
}
```

### Frontend (Angular):
- **Service יחיד**: `ApiService` - מתקשר רק עם `/api/exec`
- **3 קומפוננטים**: book-list, book-form, book-details
- **Reactive Forms** עם ולידציה מלאה
- **RxJS** לניהול נתונים אסינכרוני

## מבנה הפרויקט
```
library-management/
├── client/                 # Angular Frontend
│   ├── src/app/
│   │   ├── components/     # קומפוננטים
│   │   ├── services/       # שירותים
│   │   └── models/         # מודלים
├── api/                    # .NET Backend
│   └── LibararyAPI/
├── DB/                     # SQL Scripts
│   ├── 00_RESET_Database.sql
│   └── 03_StoredProcedures.sql
└── README.md
```

## תכונות עיקריות
✅ הצגת רשימת ספרים עם חיפוש מתקדם  
✅ הוספה ועריכה של ספרים  
✅ צפייה בפרטי ספר מלאים  
✅ ניהול סטטוסים ומיקומים דינמי  
✅ ממשק משתמש רספונסיבי  
✅ ולידציה מתקדמת בטפסים  
✅ ארכיטקטורה נקייה עם Stored Procedures בלבד

## דרישות מערכת
- Node.js 18+
- .NET Core 8+
- SQL Server
- Angular CLI

## הערות פיתוח
- כל התקשורת עם מסד הנתונים מתבצעת באמצעות Stored Procedures בלבד
- ה-API משמש כ"צינור" בין Angular ל-SQL Server
- הקוד נקי ומותאם לסטנדרטים של Angular ו-.NET