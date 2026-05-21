/*
    File: queries/pivot_analysis.sql
    Purpose:
        Demonstrate pivot-based multidimensional aggregation
        in Oracle SQL.
*/

-- =========================================================
-- 1. Salary Pivot by Year, Job, and Department
-- =========================================================
-- Convert department-level salary totals into pivoted columns.

SELECT *
FROM (
    SELECT
        TO_CHAR(HIREDATE, 'YYYY') AS HIRE_YEAR,
        JOB,
        DEPTNO,
        SAL
    FROM EMP
)
PIVOT (
    SUM(SAL)
    FOR DEPTNO IN (
        10 AS DEPT_10,
        20 AS DEPT_20,
        30 AS DEPT_30
    )
)
ORDER BY HIRE_YEAR, JOB;
