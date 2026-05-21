/*
    File: queries/transaction_control.sql
    Purpose:
        Demonstrate transaction control and privilege management
        in Oracle SQL. This script covers COMMIT, ROLLBACK,
        SAVEPOINT, user creation, role assignment, GRANT, and REVOKE.
*/

-- =========================================================
-- 1. COMMIT and ROLLBACK
-- =========================================================
-- Insert a new employee, commit the insert,
-- then update salaries and roll back the update.

INSERT INTO EMP
VALUES (
    7840,
    'ALLAN',
    'WALKER',
    7839,
    TO_DATE('1982-12-26', 'YYYY-MM-DD'),
    400,
    NULL,
    20
);

COMMIT;

UPDATE EMP
SET SAL = SAL + 200
WHERE DEPTNO = 20;

ROLLBACK;


-- =========================================================
-- 2. SAVEPOINT and Partial Rollback
-- =========================================================
-- Demonstrate staged rollback using SAVEPOINT.

SAVEPOINT A;

UPDATE EMP
SET SAL = SAL + 200
WHERE DEPTNO = 20;

SAVEPOINT B;

UPDATE EMP
SET SAL = SAL + 200
WHERE MGR = 7839;

ROLLBACK TO B;

ROLLBACK TO A;

COMMIT;


-- =========================================================
-- 3. User Creation and Basic Privileges
-- =========================================================
-- These commands require SYSDBA privileges.

CONN SYS/1111 AS SYSDBA;

ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE;

CREATE USER A IDENTIFIED BY 1111;

GRANT CONNECT, RESOURCE TO A;

ALTER USER A QUOTA UNLIMITED ON USERS;


-- =========================================================
-- 4. Create Table as User A
-- =========================================================

CONN A/1111;

CREATE TABLE T_A (
    EMPNO NUMBER(4)
);

INSERT INTO T_A VALUES (1234);
INSERT INTO T_A VALUES (5678);

COMMIT;


-- =========================================================
-- 5. Role Creation and Assignment
-- =========================================================
-- Create user B and assign privileges through a role.

CONN SYS/1111 AS SYSDBA;

CREATE USER B IDENTIFIED BY 1111;

GRANT CONNECT, RESOURCE TO B;

ALTER USER B QUOTA UNLIMITED ON USERS;

CREATE ROLE BASE;

GRANT CREATE SESSION, CREATE TABLE TO BASE;

GRANT BASE TO B;


-- =========================================================
-- 6. Privilege Grant and Revoke
-- =========================================================
-- Grant SELECT privilege on A.T_A to B and then revoke it.

CONN A/1111;

GRANT SELECT ON A.T_A TO B;

CONN B/1111;

SELECT * FROM A.T_A;

CONN A/1111;

REVOKE SELECT ON A.T_A FROM B;

CONN B/1111;

SELECT * FROM A.T_A;
