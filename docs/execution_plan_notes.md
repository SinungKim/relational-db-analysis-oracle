# Execution Plan Notes

## Overview

본 문서는 Oracle SQL 환경에서 질의 실행 계획(Execution Plan)과
쿼리 성능 분석 시 고려한 핵심 개념들을 정리한 문서입니다.

실습 환경에서는 대규모 데이터셋을 사용하지 않았기 때문에
실제 성능 차이가 크게 드러나지는 않았으나,
실무 환경에서는 실행 계획 분석이 쿼리 최적화의 핵심 과정이라는 점을 학습하였습니다.

---

# 1. Execution Plan

Execution Plan은 SQL 문장이 실제로 어떤 순서와 방식으로 수행되는지를 나타내는 내부 실행 전략입니다.

Oracle Optimizer는:

- 테이블 크기
- 인덱스 존재 여부
- 조건 선택도(Selectivity)
- JOIN 구조

등을 기반으로 최적 실행 경로를 결정합니다.

---

# 2. Full Table Scan

## Concept

테이블 전체를 순차적으로 탐색하는 방식입니다.

```sql
SELECT *
FROM PLAYER
WHERE HEIGHT > 190;
```

## Characteristics

- 인덱스가 없을 경우 발생 가능
- 데이터 규모가 작을 경우 효율적일 수 있음
- 대용량 환경에서는 비용 증가 가능

---

# 3. Index Scan

## Concept

인덱스를 활용하여 필요한 데이터만 탐색하는 방식입니다.

```sql
SELECT *
FROM PLAYER
WHERE PLAYER_ID = '2000001';
```

## Characteristics

- Equality 조건에서 효율적일 가능성 높음
- 데이터 선택도가 높을수록 유리
- 인덱스 유지 비용 존재

---

# 4. Nested Loop Join

## Concept

한 테이블의 각 행마다 다른 테이블을 반복 탐색하는 JOIN 방식입니다.

```sql
SELECT *
FROM PLAYER P
JOIN TEAM T
ON P.TEAM_ID = T.TEAM_ID;
```

## Characteristics

- 작은 데이터셋에서 효율적일 수 있음
- 인덱스 존재 시 성능 향상 가능
- 대규모 환경에서는 반복 비용 증가 가능

---

# 5. Hash Join

## Concept

Hash Table을 생성하여 JOIN을 수행하는 방식입니다.

## Characteristics

- 대규모 데이터셋에서 효율적일 수 있음
- Equality Join에서 자주 사용
- 메모리 사용량 증가 가능

---

# 6. Sort Operation

## Concept

ORDER BY, GROUP BY, Window Function 수행 시 정렬 작업이 발생할 수 있습니다.

```sql
SELECT
    JOB,
    DENSE_RANK() OVER (
        PARTITION BY JOB
        ORDER BY SAL DESC
    )
FROM EMP;
```

## Characteristics

- 데이터 규모가 커질수록 비용 증가 가능
- TEMP 영역 사용 가능성 존재
- Window Function 수행 시 빈번하게 발생

---

# 7. Aggregation Strategy

집계 수행 방식은 데이터 분포와 Cardinality에 영향을 받습니다.

```sql
SELECT TEAM_ID, COUNT(*)
FROM PLAYER
GROUP BY TEAM_ID;
```

## Characteristics

- GROUP BY 대상 컬럼 Cardinality 중요
- 집계 이전 필터링이 성능에 도움 가능
- 다수의 그룹 생성 시 메모리 비용 증가 가능

---

# 8. Correlated Subquery Cost

연관 서브쿼리는 메인 쿼리의 각 행마다 반복 수행될 가능성이 있습니다.

```sql
SELECT PLAYER_NAME
FROM PLAYER A
WHERE HEIGHT < (
    SELECT AVG(X.HEIGHT)
    FROM PLAYER X
    WHERE X.TEAM_ID = A.TEAM_ID
);
```

## Characteristics

- 반복 수행 비용 증가 가능
- 대규모 환경에서는 JOIN 기반 재작성 고려 가능
- 가독성은 높을 수 있음

---

# 9. PIVOT and Window Function Cost

## PIVOT

```sql
SELECT *
FROM (
    SELECT JOB, DEPTNO, SAL
    FROM EMP
)
PIVOT (
    SUM(SAL)
    FOR DEPTNO IN (10,20,30)
);
```

### Characteristics

- 내부적으로 집계 연산 수행
- Pivot Column 증가 시 비용 증가 가능

---

## Window Function

```sql
SELECT
    DENSE_RANK() OVER (
        PARTITION BY JOB
        ORDER BY SAL DESC
    )
FROM EMP;
```

### Characteristics

- 정렬 비용 발생 가능
- PARTITION 기준 증가 시 메모리 사용량 증가 가능

---

# 10. Engineering Insight

본 프로젝트를 통해 SQL은 단순 문법 작성이 아니라:

- 데이터 접근 비용
- JOIN 전략
- 정렬 비용
- 인덱스 활용
- 집계 구조
- 실행 계획 분석

등을 함께 고려해야 하는 엔지니어링 영역이라는 점을 학습하였습니다.

또한 동일한 결과를 생성하더라도,
질의 구조와 실행 전략에 따라 성능 차이가 크게 발생할 수 있음을 확인하였습니다.
