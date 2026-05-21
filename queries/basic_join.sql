/*
    File: queries/basic_join.sql
    Purpose:
        Demonstrate join operations in Oracle SQL.
        This script covers standard joins, non-equi joins,
        multi-table joins, cross joins, and outer joins.
*/

-- =========================================================
-- 1. Supporting Table for Non-Equi Join
-- =========================================================
-- This table defines physical grade ranges based on height and weight.

DROP TABLE PHYSICAL_RANGES;

CREATE TABLE PHYSICAL_RANGES (
    GRADE       VARCHAR2(1) PRIMARY KEY,
    MIN_HEIGHT  NUMBER NOT NULL,
    MAX_HEIGHT  NUMBER NOT NULL,
    MIN_WEIGHT  NUMBER NOT NULL,
    MAX_WEIGHT  NUMBER NOT NULL
);

INSERT INTO PHYSICAL_RANGES VALUES ('A', 190, 300, 85, 150);
INSERT INTO PHYSICAL_RANGES VALUES ('B', 185, 189, 78, 84);
INSERT INTO PHYSICAL_RANGES VALUES ('C', 180, 184, 70, 77);
INSERT INTO PHYSICAL_RANGES VALUES ('D', 175, 179, 65, 69);
INSERT INTO PHYSICAL_RANGES VALUES ('E', 0, 174, 0, 64);


-- =========================================================
-- 2. Standard Join with GROUP BY and HAVING
-- =========================================================
-- Count players by region and retrieve regions with more than two players.

SELECT
    T.REGION_NAME AS REGION_NAME,
    COUNT(P.PLAYER_ID) AS PLAYER_COUNT,
    MAX(P.JOIN_YYYY) AS LATEST_JOIN_YEAR
FROM PLAYER P
JOIN TEAM T
    ON P.TEAM_ID = T.TEAM_ID
GROUP BY T.REGION_NAME
HAVING COUNT(P.PLAYER_ID) > 2;


-- =========================================================
-- 3. Non-Equi Join with Range Conditions
-- =========================================================
-- Match players to physical grade ranges based on height.
-- Also filter players whose weight exceeds the grade's max weight.

SELECT
    P.PLAYER_NAME AS PLAYER_NAME,
    P.HEIGHT AS HEIGHT,
    P.WEIGHT AS WEIGHT,
    R.GRADE AS PHYSICAL_GRADE
FROM PLAYER P
JOIN PHYSICAL_RANGES R
    ON P.HEIGHT BETWEEN R.MIN_HEIGHT AND R.MAX_HEIGHT
   AND P.WEIGHT > R.MAX_WEIGHT;


-- =========================================================
-- 4. Three-Table Join
-- =========================================================
-- Join PLAYER, TEAM, and STADIUM using team and stadium relationships.

SELECT
    P.PLAYER_NAME,
    P.TEAM_ID,
    T.TEAM_NAME,
    T.ORIG_YYYY,
    S.STADIUM_NAME
FROM PLAYER P
JOIN TEAM T
    ON P.TEAM_ID = T.TEAM_ID
   AND P.JOIN_YYYY > T.ORIG_YYYY
JOIN STADIUM S
    ON S.STADIUM_ID = T.STADIUM_ID;


-- =========================================================
-- 5. CROSS JOIN
-- =========================================================
-- Generate all possible combinations of teams and stadiums.

SELECT
    S.STADIUM_NAME AS STADIUM_NAME,
    T.TEAM_NAME AS TEAM_NAME
FROM TEAM T
CROSS JOIN STADIUM S;


-- =========================================================
-- 6. LEFT OUTER JOIN
-- =========================================================
-- Preserve all team records and attach qualifying player records if present.

SELECT
    T.TEAM_NAME AS TEAM_NAME,
    T.ORIG_YYYY AS ORIGIN_YEAR,
    P.PLAYER_NAME AS PLAYER_NAME,
    P.JOIN_YYYY AS PLAYER_JOIN_YEAR,
    P.HEIGHT AS HEIGHT
FROM TEAM T
LEFT OUTER JOIN PLAYER P
    ON T.TEAM_ID = P.TEAM_ID
   AND P.JOIN_YYYY >= T.ORIG_YYYY
   AND P.HEIGHT >= 185;


-- =========================================================
-- 7. Oracle Legacy Outer Join Syntax
-- =========================================================
-- Same logic as the LEFT OUTER JOIN above, written with Oracle (+) syntax.

SELECT
    T.TEAM_NAME AS TEAM_NAME,
    T.ORIG_YYYY AS ORIGIN_YEAR,
    P.PLAYER_NAME AS PLAYER_NAME,
    P.JOIN_YYYY AS PLAYER_JOIN_YEAR,
    P.HEIGHT AS HEIGHT
FROM TEAM T, PLAYER P
WHERE T.TEAM_ID = P.TEAM_ID(+)
  AND P.JOIN_YYYY(+) >= T.ORIG_YYYY
  AND P.HEIGHT(+) >= 185;
