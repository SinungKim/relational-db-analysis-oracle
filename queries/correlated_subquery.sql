/*
    File: queries/correlated_subquery.sql
    Purpose:
        Demonstrate subqueries, correlated subqueries, views,
        set operations, and anti-join logic in Oracle SQL.
*/

-- =========================================================
-- 1. EXISTS Subquery
-- =========================================================
-- Retrieve stadiums that have scheduled matches
-- between 2012-05-01 and 2012-05-02.

SELECT
    A.STADIUM_ID AS STADIUM_ID,
    A.STADIUM_NAME AS STADIUM_NAME
FROM STADIUM A
WHERE EXISTS (
    SELECT 1
    FROM SCHEDULE X
    WHERE X.STADIUM_ID = A.STADIUM_ID
      AND X.SCHE_DATE BETWEEN '20120501' AND '20120502'
);


-- =========================================================
-- 2. Correlated Subquery
-- =========================================================
-- Retrieve players whose height is below
-- the average height of their own team.

SELECT
    B.TEAM_NAME AS TEAM_NAME,
    A.PLAYER_NAME AS PLAYER_NAME,
    A.POSITION AS POSITION,
    A.BACK_NO AS BACK_NO,
    A.HEIGHT AS HEIGHT
FROM PLAYER A
JOIN TEAM B
    ON B.TEAM_ID = A.TEAM_ID
WHERE A.HEIGHT < (
    SELECT AVG(X.HEIGHT)
    FROM PLAYER X
    WHERE X.TEAM_ID = A.TEAM_ID
)
ORDER BY A.PLAYER_NAME;


-- =========================================================
-- 3. View Definition
-- =========================================================
-- Create a reusable view that combines player and team information.

CREATE OR REPLACE VIEW V_PLAYER_TEAM AS
SELECT
    A.PLAYER_NAME,
    A.POSITION,
    A.BACK_NO,
    B.TEAM_ID,
    B.TEAM_NAME
FROM PLAYER A
JOIN TEAM B
    ON B.TEAM_ID = A.TEAM_ID;


-- Query the created view.

SELECT
    PLAYER_NAME,
    POSITION,
    BACK_NO,
    TEAM_ID,
    TEAM_NAME
FROM V_PLAYER_TEAM
WHERE PLAYER_NAME LIKE '황%';


-- =========================================================
-- 4. Derived View
-- =========================================================
-- Create another view based on the existing player-team view.

CREATE OR REPLACE VIEW V_PLAYER_TEAM_FILTER AS
SELECT
    PLAYER_NAME,
    POSITION,
    BACK_NO,
    TEAM_NAME
FROM V_PLAYER_TEAM
WHERE POSITION IN ('GK', 'MF');


-- =========================================================
-- 5. Set Difference with MINUS
-- =========================================================
-- Retrieve players in team K02 except midfielders.

SELECT
    TEAM_ID AS TEAM_ID,
    PLAYER_NAME AS PLAYER_NAME,
    POSITION AS POSITION,
    BACK_NO AS BACK_NO,
    HEIGHT AS HEIGHT
FROM PLAYER
WHERE TEAM_ID = 'K02'

MINUS

SELECT
    TEAM_ID AS TEAM_ID,
    PLAYER_NAME AS PLAYER_NAME,
    POSITION AS POSITION,
    BACK_NO AS BACK_NO,
    HEIGHT AS HEIGHT
FROM PLAYER
WHERE POSITION = 'MF'
ORDER BY 1, 2, 3, 4, 5;


-- =========================================================
-- 6. Anti-Join with NOT EXISTS
-- =========================================================
-- Same logic as MINUS, implemented using NOT EXISTS.

SELECT DISTINCT
    A.TEAM_ID AS TEAM_ID,
    A.PLAYER_NAME AS PLAYER_NAME,
    A.POSITION AS POSITION,
    A.BACK_NO AS BACK_NO,
    A.HEIGHT AS HEIGHT
FROM PLAYER A
WHERE A.TEAM_ID = 'K02'
  AND NOT EXISTS (
      SELECT 1
      FROM PLAYER X
      WHERE X.PLAYER_ID = A.PLAYER_ID
        AND X.POSITION = 'MF'
  )
ORDER BY 1, 2, 3, 4, 5;
