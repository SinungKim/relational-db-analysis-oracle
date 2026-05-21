/*
    File: queries/ranking_analysis.sql
    Purpose:
        Demonstrate advanced aggregation and analytical functions
        in Oracle SQL. This script covers ROLLUP, GROUPING SETS,
        ranking functions, and window-based cumulative aggregation.
*/

-- =========================================================
-- 1. ROLLUP with GROUPING and CASE
-- =========================================================
-- Generate department/job-level subtotals and grand totals.
-- GROUPING() is used to label subtotal rows clearly.

SELECT
    CASE
        WHEN GROUPING(B.DNAME) = 1 THEN 'ALL DEPARTMENTS'
        ELSE B.DNAME
    END AS DNAME,
    CASE
        WHEN GROUPING(A.JOB) = 1 THEN 'ALL JOBS'
        ELSE A.JOB
    END AS JOB,
    COUNT(*) AS EMP_COUNT,
    SUM(A.SAL) AS SALARY_SUM
FROM EMP A
JOIN DEPT B
    ON B.DEPTNO = A.DEPTNO
GROUP BY ROLLUP(B.DNAME, A.JOB)
ORDER BY B.DNAME, A.JOB;


-- =========================================================
-- 2. GROUPING SETS
-- =========================================================
-- Generate only selected aggregation combinations.

SELECT
    B.DNAME,
    A.JOB,
    A.MGR,
    COUNT(*) AS EMP_COUNT,
    SUM(A.SAL) AS SALARY_SUM
FROM EMP A
JOIN DEPT B
    ON B.DEPTNO = A.DEPTNO
GROUP BY GROUPING SETS (
    (B.DNAME, A.JOB, A.MGR),
    (B.DNAME, A.JOB),
    (A.JOB, A.MGR)
);


-- =========================================================
-- 3. DENSE_RANK with Inline View
-- =========================================================
-- Rank employees by salary within each job group.
-- DENSE_RANK does not skip ranking numbers after ties.

SELECT
    JOB,
    ENAME,
    SAL,
    JOB_RANK
FROM (
    SELECT
        JOB,
        ENAME,
        SAL,
        DENSE_RANK() OVER (
            PARTITION BY JOB
            ORDER BY SAL DESC
        ) AS JOB_RANK
    FROM EMP
)
ORDER BY JOB, JOB_RANK;


-- =========================================================
-- 4. RANK by Manager Group
-- =========================================================
-- Rank employees by salary within each manager group.

SELECT
    MGR,
    ENAME,
    SAL,
    SALARY_RANK
FROM (
    SELECT
        MGR,
        ENAME,
        SAL,
        RANK() OVER (
            PARTITION BY MGR
            ORDER BY SAL DESC
        ) AS SALARY_RANK
    FROM EMP
)
ORDER BY MGR, SALARY_RANK;


-- =========================================================
-- 5. Window-Based Cumulative Sum
-- =========================================================
-- Calculate cumulative salary sum within each manager group.

SELECT
    MGR,
    ENAME,
    SAL,
    SUM(SAL) OVER (
        PARTITION BY MGR
        ORDER BY SAL
        RANGE UNBOUNDED PRECEDING
    ) AS CUMULATIVE_SALARY
FROM EMP
ORDER BY MGR, SAL;
