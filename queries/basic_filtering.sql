/*
    File: queries/basic_filtering.sql
    Purpose:
        Demonstrate basic DML and filtering operations in Oracle SQL.
        This script covers INSERT, UPDATE, DISTINCT, LIKE,
        logical conditions, and date-based filtering.
*/

-- =========================================================
-- 1. Insert Sample Data
-- =========================================================
-- Insert fruit records into the parent table.

INSERT INTO Fruit (FruitId, FruitName, Sweetness, Indate)
VALUES ('1', 'apple', 'High', TO_DATE('2025-01-11', 'YYYY-MM-DD'));

INSERT INTO Fruit (FruitId, FruitName, Sweetness, Indate)
VALUES ('2', 'banana', 'Very High', TO_DATE('2025-01-12', 'YYYY-MM-DD'));

INSERT INTO Fruit (FruitId, FruitName, Sweetness, Indate)
VALUES ('3', 'cherry', 'High', TO_DATE('2025-01-13', 'YYYY-MM-DD'));

INSERT INTO Fruit (FruitId, FruitName, Sweetness, Indate)
VALUES ('4', 'durian', 'Very High', TO_DATE('2025-01-14', 'YYYY-MM-DD'));

INSERT INTO Fruit (FruitId, FruitName, Sweetness, Indate)
VALUES ('5', 'eggplant', 'Very Low', TO_DATE('2025-01-15', 'YYYY-MM-DD'));


-- Insert inventory records into the child table.

INSERT INTO Store (StoreId, Stock, Locate, WhereFrom)
VALUES ('1', 1, 'first shelf', 'the Balkans');

INSERT INTO Store (StoreId, Stock, Locate, WhereFrom)
VALUES ('2', 2, 'second shelf', 'India');

INSERT INTO Store (StoreId, Stock, Locate, WhereFrom)
VALUES ('3', 3, 'third shelf', 'Western Asia');

INSERT INTO Store (StoreId, Stock, Locate, WhereFrom)
VALUES ('4', 4, 'fourth shelf', 'Malaysia');

INSERT INTO Store (StoreId, Stock, Locate, WhereFrom)
VALUES ('5', 5, 'fifth shelf', 'India');


-- =========================================================
-- 2. Update Multiple Rows
-- =========================================================
-- Increase stock by 5 for all items imported from India.

UPDATE Store
SET Stock = Stock + 5
WHERE WhereFrom = 'India';


-- =========================================================
-- 3. Filtering with DISTINCT, LIKE, and AND
-- =========================================================
-- Retrieve distinct origins where origin matches India
-- and stock is greater than 2.

SELECT DISTINCT
    WhereFrom
FROM Store
WHERE WhereFrom LIKE 'India'
  AND Stock > 2;


-- =========================================================
-- 4. Filtering with OR, IN, and Date Condition
-- =========================================================
-- Retrieve fruit records based on date and sweetness conditions.

SELECT
    FruitId,
    FruitName,
    Sweetness,
    Indate
FROM Fruit
WHERE (Indate < TO_DATE('2025-01-13', 'YYYY-MM-DD')
       OR Sweetness IN ('Very High'))
  AND FruitId >= '2';
