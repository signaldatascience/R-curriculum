CREATE TABLE records AS
    SELECT "Ben Bitdiddle" as Name, "Computer" as Division, "Wizard" as Title, 60000 as Salary, "Oliver Warbucks" as Supervisor UNION
    SELECT "Alyssa P Hacker",       "Computer",             "Programmer",      40000,           "Ben Bitdiddle" UNION
    SELECT "Cy D Fect",             "Computer",             "Programmer",      35000,           "Ben Bitdiddle" UNION
    SELECT "Lem E Tweakit",         "Computer",             "Technician",      25000,           "Ben Bitdiddle" UNION
    SELECT "Louis Reasoner",        "Computer",             "Programmer Trainee", 30000,        "Alyssa P Hacker" UNION
    SELECT "Oliver Warbucks",       "Administration",       "Big Wheel",       150000,          "Oliver Warbucks" UNION
    SELECT "DeWitt Aull",           "Administration",       "Secretary",       25000,           "Oliver Warbucks" UNION
    SELECT "Eben Scrooge",          "Accounting",           "Chief Accountant", 75000,          "Oliver Warbucks" UNION
    SELECT "Robert Cratchet",       "Accounting",           "Scrivener",       18000,           "Eben Scrooge";
