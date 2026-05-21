/*
    File: queries/hierarchical_query.sql
    Purpose:
        Demonstrate hierarchical query operations in Oracle SQL.
        This script covers START WITH, CONNECT BY, LEVEL,
        CONNECT_BY_ISLEAF, and SYS_CONNECT_BY_PATH.
*/

-- =========================================================
-- 1. Leaf Node Paths
-- =========================================================
-- Retrieve paths from the top-level manager to leaf employees only.

SELECT
    LEVEL AS HIERARCHY_LEVEL,
    SYS_CONNECT_BY_PATH(EMPNO, '/') AS EMP_PATH
FROM EMP
WHERE CONNECT_BY_ISLEAF = 1
START WITH MGR IS NULL
CONNECT BY MGR = PRIOR EMPNO;


-- =========================================================
-- 2. Hierarchical Tree with Leaf Indicator
-- =========================================================
-- Display employee hierarchy levels and whether each node is a leaf.

SELECT
    LEVEL AS HIERARCHY_LEVEL,
    EMPNO,
    MGR,
    CONNECT_BY_ISLEAF AS IS_LEAF
FROM EMP
START WITH MGR IS NULL
CONNECT BY MGR = PRIOR EMPNO;


-- =========================================================
-- 3. Full Hierarchical Path
-- =========================================================
-- Display full path from root manager to each employee.

SELECT
    SYS_CONNECT_BY_PATH(EMPNO, '/') AS EMP_PATH,
    EMPNO,
    MGR
FROM EMP
START WITH MGR IS NULL
CONNECT BY MGR = PRIOR EMPNO;


-- =========================================================
-- 4. Level and Path Summary
-- =========================================================
-- Display hierarchy level and path together.

SELECT
    LEVEL AS HIERARCHY_LEVEL,
    SYS_CONNECT_BY_PATH(EMPNO, '/') AS EMP_PATH
FROM EMP
START WITH MGR IS NULL
CONNECT BY MGR = PRIOR EMPNO;
