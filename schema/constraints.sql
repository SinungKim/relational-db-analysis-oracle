/*
    File: schema/constraints.sql
    Purpose:
        Document key integrity constraints used in the schema.
        This file explains primary key, foreign key, check constraint,
        default value, and cascade delete rules.
*/

-- =========================================================
-- 1. Primary Key Constraint
-- =========================================================
-- Ensures that each fruit has a unique identifier.

ALTER TABLE Fruit
ADD CONSTRAINT Fruit_PK PRIMARY KEY (FruitId);


-- =========================================================
-- 2. Check Constraint
-- =========================================================
-- Restricts Sweetness values to predefined categories.

ALTER TABLE Fruit
ADD CONSTRAINT Fruit_Sweetness_CK
CHECK (Sweetness IN ('Very High', 'High', 'Middle', 'Low', 'Very Low'));


-- =========================================================
-- 3. Primary Key Constraint for Store
-- =========================================================
-- Ensures that each store record has a unique identifier.

ALTER TABLE Store
ADD CONSTRAINT Store_PK PRIMARY KEY (StoreId);


-- =========================================================
-- 4. Foreign Key Constraint with Cascade Delete
-- =========================================================
-- Maintains referential integrity between Store and Fruit.
-- If a parent Fruit record is deleted, related Store records
-- are automatically deleted to prevent orphan records.

ALTER TABLE Store
ADD CONSTRAINT Store_Fruit_FK
FOREIGN KEY (StoreId)
REFERENCES Fruit(FruitId)
ON DELETE CASCADE;
