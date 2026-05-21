/*
    File: queries/aggregation.sql
    Purpose:
        Demonstrate aggregation and grouped analysis in Oracle SQL.
        This script covers aggregate functions, NULL-aware counting,
        conditional aggregation, HAVING, GROUP BY, and ORDER BY.
*/

-- =========================================================
-- 1. Basic Aggregate Functions
-- =========================================================
-- COUNT(*) includes NULL rows, while COUNT(column) excludes NULL values.

SELECT
    COUNT(*) AS TOTAL_ROWS,
    COUNT(WEIGHT) AS WEIGHT_COUNT,
    ROUND(AVG(WEIGHT), 2) AS AVG_WEIGHT,
    ROUND(SUM(WEIGHT) / COUNT(WEIGHT), 2) AS AVG_WEIGHT_MANUAL
FROM PLAYER;


-- =========================================================
-- 2. Conditional Aggregation by Team
-- =========================================================
-- Count players by position for each team using CASE expressions.

SELECT
    TEAM_ID,
    NVL(SUM(CASE WHEN POSITION = 'FW' THEN 1 ELSE 0 END), 0) AS FW,
    NVL(SUM(CASE WHEN POSITION = 'MF' THEN 1 ELSE 0 END), 0) AS MF,
    NVL(SUM(CASE WHEN POSITION = 'DF' THEN 1 ELSE 0 END), 0) AS DF,
    NVL(SUM(CASE WHEN POSITION = 'GK' THEN 1 ELSE 0 END), 0) AS GK
FROM PLAYER
WHERE TEAM_ID LIKE 'K0%'
GROUP BY TEAM_ID;


-- =========================================================
-- 3. HAVING Clause
-- =========================================================
-- Retrieve teams with more than one midfielder.

SELECT
    TEAM_ID,
    NVL(SUM(CASE WHEN POSITION = 'FW' THEN 1 ELSE 0 END), 0) AS FW,
    NVL(SUM(CASE WHEN POSITION = 'MF' THEN 1 ELSE 0 END), 0) AS MF,
    NVL(SUM(CASE WHEN POSITION = 'DF' THEN 1 ELSE 0 END), 0) AS DF,
    NVL(SUM(CASE WHEN POSITION = 'GK' THEN 1 ELSE 0 END), 0) AS GK
FROM PLAYER
GROUP BY TEAM_ID
HAVING NVL(SUM(CASE WHEN POSITION = 'MF' THEN 1 ELSE 0 END), 0) > 1;


-- =========================================================
-- 4. Multi-Category Position Summary
-- =========================================================
-- Summarize position counts by team.

SELECT
    TEAM_ID,
    NVL(SUM(CASE WHEN POSITION = 'FW' THEN 1 ELSE 0 END), 0) AS FW,
    NVL(SUM(CASE WHEN POSITION = 'MF' THEN 1 ELSE 0 END), 0) AS MF,
    NVL(SUM(CASE WHEN POSITION = 'DF' THEN 1 ELSE 0 END), 0) AS DF,
    NVL(SUM(CASE WHEN POSITION = 'GK' THEN 1 ELSE 0 END), 0) AS GK
FROM PLAYER
GROUP BY TEAM_ID;


-- =========================================================
-- 5. Filtering and Sorting
-- =========================================================
-- Retrieve tall players and sort by height descending,
-- then by back number ascending.

SELECT
    PLAYER_NAME AS PLAYER_NAME,
    POSITION AS POSITION,
    BACK_NO AS BACK_NO,
    HEIGHT AS HEIGHT
FROM PLAYER
WHERE HEIGHT > 190
ORDER BY HEIGHT DESC, BACK_NO ASC;
