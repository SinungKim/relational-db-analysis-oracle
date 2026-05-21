# SQL Summary

## 1. DDL: Schema Definition

DDL(Data Definition Language)은 데이터베이스 객체를 정의하거나 수정하는 SQL 명령어입니다.

### Key Commands

| Command | Purpose |
|---|---|
| `CREATE TABLE` | 테이블 생성 |
| `ALTER TABLE` | 테이블 구조 변경 |
| `DROP TABLE` | 테이블 삭제 |
| `CONSTRAINT` | 제약조건 정의 |

### Applied Concepts

- Primary Key를 통한 고유 식별자 설정
- Foreign Key를 통한 참조 무결성 유지
- CHECK Constraint를 통한 입력값 제한
- ON DELETE CASCADE를 통한 연쇄 삭제 처리

---

## 2. DML: Data Manipulation

DML(Data Manipulation Language)은 테이블 내 데이터를 삽입, 수정, 삭제, 조회하는 명령어입니다.

### Key Commands

| Command | Purpose |
|---|---|
| `INSERT` | 데이터 삽입 |
| `UPDATE` | 데이터 수정 |
| `DELETE` | 데이터 삭제 |
| `SELECT` | 데이터 조회 |

### Applied Concepts

- 다중 행 INSERT
- 조건 기반 UPDATE
- DISTINCT를 활용한 중복 제거
- LIKE, IN, AND, OR 기반 조건 필터링

---

## 3. JOIN

JOIN은 여러 테이블에 분산된 데이터를 관계 조건에 따라 결합하는 기능입니다.

### Join Types

| Join Type | Purpose |
|---|---|
| `INNER JOIN` | 양쪽 테이블 모두 조건을 만족하는 행만 반환 |
| `LEFT OUTER JOIN` | 왼쪽 테이블의 모든 행을 유지 |
| `CROSS JOIN` | 가능한 모든 조합 생성 |
| `Non-Equi Join` | 등호가 아닌 범위 조건 기반 결합 |

### Applied Concepts

- PLAYER와 TEAM 테이블 결합
- PLAYER, TEAM, STADIUM 3개 테이블 조인
- 키/몸무게 범위 기반 Non-Equi Join
- Oracle Legacy Outer Join `(+)` 문법 비교

---

## 4. Subquery & View

Subquery는 하나의 SQL문 안에 포함된 또 다른 SQL문입니다.  
View는 자주 사용하는 질의를 가상 테이블 형태로 저장하는 객체입니다.

### Key Concepts

| Concept | Description |
|---|---|
| `EXISTS` | 서브쿼리 결과 존재 여부 확인 |
| Correlated Subquery | 메인 쿼리의 값을 참조하는 서브쿼리 |
| `CREATE VIEW` | 재사용 가능한 질의 구조 정의 |
| `MINUS` | 두 결과 집합의 차집합 반환 |

### Applied Concepts

- 경기 일정이 존재하는 경기장 조회
- 소속 구단 평균 키보다 작은 선수 조회
- PLAYER와 TEAM 정보를 결합한 View 생성
- MINUS와 NOT EXISTS를 이용한 차집합 비교

---

## 5. Aggregation

집계 함수는 여러 행을 요약하여 하나의 결과값 또는 그룹별 결과값을 생성합니다.

### Key Functions

| Function | Purpose |
|---|---|
| `COUNT(*)` | NULL 포함 전체 행 수 계산 |
| `COUNT(column)` | NULL 제외 행 수 계산 |
| `AVG()` | 평균 계산 |
| `SUM()` | 합계 계산 |
| `MAX()` / `MIN()` | 최대/최소값 계산 |

### Applied Concepts

- 포지션별 선수 수 집계
- TEAM_ID 기준 GROUP BY
- HAVING을 활용한 그룹 필터링
- CASE 기반 조건부 집계

---

## 6. Advanced Aggregation

고급 집계 기능은 단순 GROUP BY보다 복잡한 요약 구조를 만들 때 사용됩니다.

### Key Features

| Feature | Purpose |
|---|---|
| `ROLLUP` | 계층적 소계 및 총계 생성 |
| `GROUPING SETS` | 지정한 조합별 집계 생성 |
| `PIVOT` | 행 데이터를 열 방향으로 변환 |
| `GROUPING()` | 소계/총계 행 식별 |

### Applied Concepts

- 부서/직무별 급여 소계 계산
- 원하는 조합만 선택한 GROUPING SETS 집계
- 부서별 급여 합계를 PIVOT 테이블로 변환

---

## 7. Window Function

Window Function은 행 정보를 유지하면서 그룹 내 순위나 누적값을 계산할 수 있는 분석 함수입니다.

### Key Functions

| Function | Purpose |
|---|---|
| `RANK()` | 동일 순위 발생 시 다음 순위 건너뜀 |
| `DENSE_RANK()` | 동일 순위 발생 시 다음 순위 유지 |
| `ROW_NUMBER()` | 각 행에 고유 순번 부여 |
| `SUM() OVER()` | 윈도우 범위 내 누적 합계 계산 |

### Applied Concepts

- 직무별 급여 순위 산출
- 관리자별 급여 순위 산출
- RANGE UNBOUNDED PRECEDING 기반 누적 급여 계산

---

## 8. Hierarchical Query

Oracle의 계층형 질의는 트리 구조 데이터를 탐색할 때 사용됩니다.

### Key Clauses

| Clause | Purpose |
|---|---|
| `START WITH` | 루트 노드 지정 |
| `CONNECT BY` | 부모-자식 관계 정의 |
| `PRIOR` | 이전 계층의 값을 참조 |
| `LEVEL` | 현재 계층 깊이 반환 |
| `SYS_CONNECT_BY_PATH` | 루트부터 현재 노드까지 경로 출력 |

### Applied Concepts

- 최상위 관리자부터 말단 사원까지의 조직 구조 탐색
- Leaf Node 식별
- 계층 경로 문자열 생성

---

## 9. Transaction Control

Transaction Control은 데이터 변경 작업의 확정과 취소를 관리합니다.

### Key Commands

| Command | Purpose |
|---|---|
| `COMMIT` | 변경 사항 확정 |
| `ROLLBACK` | 변경 사항 취소 |
| `SAVEPOINT` | 중간 복구 지점 설정 |
| `ROLLBACK TO` | 특정 SAVEPOINT까지 되돌림 |

### Applied Concepts

- INSERT 후 COMMIT
- UPDATE 후 ROLLBACK
- SAVEPOINT 기반 부분 롤백
- 트랜잭션 단위 데이터 안정성 관리

---

## 10. Privilege Management

권한 관리는 사용자별 데이터 접근과 작업 범위를 제어하는 기능입니다.

### Key Commands

| Command | Purpose |
|---|---|
| `CREATE USER` | 사용자 생성 |
| `CREATE ROLE` | 역할 생성 |
| `GRANT` | 권한 부여 |
| `REVOKE` | 권한 회수 |

### Applied Concepts

- 사용자 A, B 생성
- ROLE 기반 권한 구성
- 테이블 조회 권한 부여 및 회수
