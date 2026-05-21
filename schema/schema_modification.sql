/*
    File: schema/schema_modification.sql
    Purpose:
        Demonstrate schema evolution using ALTER TABLE statements.
        This script covers adding columns, dropping columns,
        renaming columns, and modifying column definitions.
*/

-- =========================================================
-- 1. Add a New Column
-- =========================================================
-- Adds a temporary point column to the Fruit table.

ALTER TABLE Fruit
ADD point NUMBER(3);


-- =========================================================
-- 2. Drop an Existing Column
-- =========================================================
-- Removes the temporary point column from the Fruit table.

ALTER TABLE Fruit
DROP COLUMN point;


-- =========================================================
-- 3. Rename Column
-- =========================================================
-- Renames Stock column to ItemCount for clearer inventory semantics.

ALTER TABLE Store
RENAME COLUMN Stock TO ItemCount;


-- =========================================================
-- 4. Modify Column Definitions
-- =========================================================
-- Changes ItemCount to NOT NULL and extends Locate column length.

ALTER TABLE Store
MODIFY (
    ItemCount NUMBER(10) NOT NULL,
    Locate    VARCHAR2(200)
);
