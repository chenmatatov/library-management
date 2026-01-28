# מערכת ניהול ספרייה 📚
# מגישות שירה מרנשטיין רבקה לבלנק וחן מטאטוב
## תיאור הפרויקט
מערכת ניהול ספרייה מתקדמת הבנויה עם Angular ו-.NET Core, המאפשרת ניהול יעיל של ספרים, מיקומים וסטטוסים.

## טכנולוגיות
- **Frontend**: Angular 17+ עם TypeScript
- **Backend**: .NET Core Web API
- **Database**: SQL Server
- **UI**: CSS3 עם Responsive Design

## תכונות עיקריות
✅ הצגת רשימת ספרים עם חיפוש מתקדם  
✅ הוספה ועריכה של ספרים  
✅ צפייה בפרטי ספר מלאים  
✅ ניהול סטטוסים ומיקומים דינמי  
✅ ממשק משתמש רספונסיבי  
✅ ולידציה מתקדמת בטפסים  

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

## הרצת הפרויקט

### שרת Backend:
1. פתח את `api/LibraryAPI/LibraryAPI.sln` ב-Visual Studio
2. הגדר connection string במסד הנתונים
3. הרץ את הפרויקט (F5)
4. השרת יעלה על: `https://localhost:7141`

### לקוח Frontend:
1. נווט לתיקיית `client/`
2. הרץ: `ng serve`
3. פתח דפדפן: `http://localhost:4200`

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

## מאפיינים טכניים

### Frontend:
- **Angular 17+** עם Control Flow החדש (@if, @for)
- **TypeScript** עם typing מלא
- **Reactive Forms** עם ולידציה
- **RxJS** לניהול נתונים אסינכרוני
- **CSS Grid & Flexbox** לעיצוב רספונסיבי

### Backend:
- **.NET Core Web API** עם ארכיטקטורה נקייה
- **Entity Framework** או **ADO.NET** לגישה למסד נתונים
- **Stored Procedures** לביצועים מיטביים
- **CORS** מוגדר לפיתוח

## מבנה הפרויקט
```
mini_project/
├── client/                 # Angular Frontend
│   ├── src/app/
│   │   ├── components/     # קומפוננטים
│   │   ├── services/       # שירותים
│   │   └── models/         # מודלים
│   └── ...
├── api/                    # .NET Backend
│   └── LibraryAPI/
└── README.md
```
