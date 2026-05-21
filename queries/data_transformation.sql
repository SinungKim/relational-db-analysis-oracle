/*
    File: queries/data_transformation.sql
    Purpose:
        Demonstrate data transformation using Oracle SQL functions.
        This script covers string functions, numeric functions,
        date extraction, CASE, DECODE, NULL handling, and MERGE.
*/

-- =========================================================
-- 1. String Function Filtering
-- =========================================================
-- Retrieve Korean player names starting with '고'
-- whose English player name length is greater than 12.

SELECT
    PLAYER_NAME
FROM PLAYER
WHERE PLAYER_NAME LIKE '고%'
  AND LENGTH(E_PLAYER_NAME) > 12;


-- =========================================================
-- 2. Numeric Function: BMI Calculation
-- =========================================================
-- Calculate BMI using height and weight.
-- BMI = weight / height(m)^2

SELECT
    PLAYER_NAME,
    WEIGHT,
    HEIGHT,
    ROUND((WEIGHT / POWER(HEIGHT / 100, 2)), 1) AS BMI
FROM PLAYER
WHERE ROUND((WEIGHT / POWER(HEIGHT / 100, 2)), 1) BETWEEN 18 AND 28;


-- =========================================================
-- 3. Date Function: Extract Year
-- =========================================================
-- Extract year from birth_date and use it for conditional filtering.

SELECT
    PLAYER_NAME,
    WEIGHT,
    JOIN_YYYY,
    BIRTH_DATE
FROM PLAYER
WHERE EXTRACT(YEAR FROM BIRTH_DATE) + 20 > 0;


-- =========================================================
-- 4. Conditional Transformation: CASE
-- =========================================================
-- Convert position code into Korean position label.

SELECT
    PLAYER_NAME,
    POSITION,
    CASE
        WHEN POSITION = 'DF' THEN '수비수'
        ELSE 'ETC'
    END AS POSITION_KOR
FROM PLAYER;


-- =========================================================
-- 5. Conditional Transformation: DECODE
-- =========================================================
-- Oracle-specific alternative to CASE.

SELECT
    PLAYER_NAME,
    POSITION,
    DECODE(POSITION, 'DF', '수비수', '기타') AS POSITION_KOR
FROM PLAYER;


-- =========================================================
-- 6. NULL Handling: NVL
-- =========================================================
-- Replace NULL height values with 0.

SELECT
    PLAYER_NAME,
    HEIGHT,
    NVL(HEIGHT, 0) AS HEIGHT_NULL_REPLACED
FROM PLAYER;


-- =========================================================
-- 7. NULL Handling: NULLIF
-- =========================================================
-- Return NULL when height equals 180.

SELECT
    PLAYER_NAME,
    HEIGHT,
    NULLIF(HEIGHT, 180) AS HEIGHT_NULL_IF_180
FROM PLAYER;


-- =========================================================
-- 8. MERGE Operation
-- =========================================================
-- Create a temporary source table and merge new player data
-- into the PLAYER table.

DROP TABLE NEW_PLAYER;

CREATE TABLE NEW_PLAYER (
    PLAYER_ID      CHAR(7) NOT NULL,
    PLAYER_NAME    VARCHAR2(20) NOT NULL,
    TEAM_ID        CHAR(3) NOT NULL,
    E_PLAYER_NAME  VARCHAR2(40),
    NICKNAME       VARCHAR2(30),
    JOIN_YYYY      CHAR(4),
    POSITION       VARCHAR2(10),
    BACK_NO        NUMBER(2),
    NATION         VARCHAR2(20),
    BIRTH_DATE     DATE,
    SOLAR          CHAR(1),
    HEIGHT         NUMBER(3),
    WEIGHT         NUMBER(3),

    CONSTRAINT NEW_PLAYER_PK PRIMARY KEY (PLAYER_ID)
);

INSERT INTO NEW_PLAYER
VALUES (
    '2999999',
    '우르모브',
    'K06',
    NULL,
    NULL,
    '2025',
    'GK',
    99,
    '몽골',
    TO_DATE('2002-08-30', 'YYYY-MM-DD'),
    '1',
    189,
    80
);

INSERT INTO NEW_PLAYER
VALUES (
    '2888888',
    '윤희준',
    'K06',
    NULL,
    NULL,
    '2025',
    'GK',
    88,
    NULL,
    TO_DATE('2002-11-01', 'YYYY-MM-DD'),
    '1',
    182,
    74
);

MERGE INTO PLAYER P
USING NEW_PLAYER N
ON (P.PLAYER_ID = N.PLAYER_ID)
WHEN MATCHED THEN
    UPDATE SET
        P.JOIN_YYYY = N.JOIN_YYYY,
        P.BIRTH_DATE = N.BIRTH_DATE
WHEN NOT MATCHED THEN
    INSERT (
        PLAYER_ID,
        PLAYER_NAME,
        BIRTH_DATE,
        TEAM_ID
    )
    VALUES (
        N.PLAYER_ID,
        N.PLAYER_NAME,
        N.BIRTH_DATE,
        N.TEAM_ID
    );
