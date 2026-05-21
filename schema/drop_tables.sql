/*
    File: schema/drop_tables.sql
    Purpose:
        Safely remove relational tables by handling foreign key constraints.
        This script demonstrates table cleanup in a parent-child schema.
*/

-- =========================================================
-- 1. Drop Foreign Key Constraint
-- =========================================================
-- Remove the foreign key constraint before dropping related tables.

ALTER TABLE Store
DROP CONSTRAINT Store_Fruit_FK;


-- =========================================================
-- 2. Drop Child Table
-- =========================================================
-- Drop the child table first to avoid referential integrity errors.

DROP TABLE Store;


-- =========================================================
-- 3. Drop Parent Table
-- =========================================================
-- Drop the parent table after the child table has been removed.

DROP TABLE Fruit;
