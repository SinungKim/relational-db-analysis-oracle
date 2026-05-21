/*
    File: schema/create_tables.sql
    Purpose:
        Define parent-child table structures using Oracle SQL.
        This script creates relational tables with primary key,
        foreign key, check constraint, default value, and cascade delete.
*/

-- =========================================================
-- 1. Parent Table: Fruit
-- =========================================================
-- Fruit table stores basic fruit information.
-- FruitId is used as the primary key and referenced by Store.

CREATE TABLE Fruit (
    FruitId     CHAR(10),
    FruitName   VARCHAR2(100) DEFAULT 'NULL_NAME' NOT NULL,
    Sweetness   VARCHAR2(10),
    Indate      DATE,

    CONSTRAINT Fruit_PK PRIMARY KEY (FruitId),
    CONSTRAINT Fruit_Sweetness_CK
        CHECK (Sweetness IN ('Very High', 'High', 'Middle', 'Low', 'Very Low'))
);

-- =========================================================
-- 2. Child Table: Store
-- =========================================================
-- Store table stores inventory information.
-- StoreId references FruitId to maintain referential integrity.

CREATE TABLE Store (
    StoreId     CHAR(10),
    Stock       INTEGER,
    Locate      VARCHAR2(100),
    WhereFrom   VARCHAR2(100) DEFAULT 'NULL_TITLE' NOT NULL,

    CONSTRAINT Store_PK PRIMARY KEY (StoreId),
    CONSTRAINT Store_Fruit_FK
        FOREIGN KEY (StoreId)
        REFERENCES Fruit(FruitId)
        ON DELETE CASCADE
);
