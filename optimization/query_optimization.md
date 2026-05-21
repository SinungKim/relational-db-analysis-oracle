# Query Optimization Notes

## Overview

본 문서는 Oracle SQL 기반 데이터 처리 과정에서 고려한
쿼리 최적화(Query Optimization) 및 성능 관련 개념들을 정리한 문서입니다.

실습 데이터셋은 비교적 소규모였기 때문에
실행 속도 차이가 크게 드러나지는 않았으나,
대규모 데이터 환경에서는 실행 계획(Execution Plan),
인덱스(Index), JOIN 전략 등이 성능에 직접적인 영향을 준다는 점을 확인하였습니다.

---

# 1. JOIN Performance

## INNER JOIN

INNER JOIN은 가장 일반적인 조인 방식으로,
양쪽 테이블에서 조건을 만족하는 행만 반환합니다.

```sql
SELECT *
FROM PLAYER P
JOIN TEAM T
ON P.TEAM_ID = T.TEAM_ID;
```

### Optimization Considerations

- JOIN 대상 컬럼에 Index가 없을 경우 Full Table Scan 발생 가능
- 대용량 환경에서는 JOIN 순서가 실행 비용에 영향
- 선택도가 높은 조건을 먼저 적용하는 것이 유리할 수 있음

---

# 2. Non-Equi Join

Non-Equi Join은 등호(=)가 아닌 범위 조건을 사용하는 조인입니다.

```sql
SELECT *
FROM PLAYER P
JOIN PHYSICAL_RANGES R
ON P.HEIGHT BETWEEN R.MIN_HEIGHT AND R.MAX_HEIGHT;
```

### Optimization Considerations

- 범위 조건 기반 JOIN은 일반 Equality Join보다 비용이 높을 수 있음
- 범위 테이블이 작은 경우 Broadcast 성격으로 처리될 가능성 존재
- 인덱스 활용이 제한될 수 있음

---

# 3. EXISTS vs IN

## EXISTS

```sql
SELECT *
FROM STADIUM A
WHERE EXISTS (
    SELECT 1
    FROM SCHEDULE X
    WHERE X.STADIUM_ID = A.STADIUM_ID
);
```

### Characteristics

- 존재 여부만 확인
- 조건 만족 시 즉시 탐색 종료 가능
- 대량 데이터 환경에서 유리할 수 있음

---

## IN

```sql
SELECT *
FROM STADIUM
WHERE STADIUM_ID IN (
    SELECT STADIUM_ID
    FROM SCHEDULE
);
```

### Characteristics

- 결과 집합 전체를 비교
- 데이터 크기에 따라 비용 증가 가능
- 작은 데이터셋에서는 가독성이 높음

---

# 4. Correlated Subquery

연관 서브쿼리는 메인 쿼리의 값을 참조하는 서브쿼리입니다.

```sql
SELECT PLAYER_NAME
FROM PLAYER A
WHERE HEIGHT < (
    SELECT AVG(X.HEIGHT)
    FROM PLAYER X
    WHERE X.TEAM_ID = A.TEAM_ID
);
```

### Optimization Considerations

- 행마다 서브쿼리가 반복 수행될 수 있음
- 대규모 환경에서는 성능 저하 가능
- JOIN 또는 Inline View 방식으로 재작성 가능

---

# 5. Aggregate Function Optimization

집계 함수는 GROUP BY 수행 시 정렬 및 메모리 비용이 증가할 수 있습니다.

```sql
SELECT TEAM_ID, COUNT(*)
FROM PLAYER
GROUP BY TEAM_ID;
```

### Optimization Considerations

- GROUP BY 대상 컬럼 Cardinality 중요
- 집계 이전 WHERE 필터링으로 처리 데이터 감소 가능
- 불필요한 GROUP BY 최소화 필요

---

# 6. Window Function Cost

Window Function은 행 정보를 유지하면서 분석이 가능하지만,
정렬 비용(Sort Cost)이 증가할 수 있습니다.

```sql
SELECT
    JOB,
    ENAME,
    SAL,
    DENSE_RANK() OVER (
        PARTITION BY JOB
        ORDER BY SAL DESC
    )
FROM EMP;
```

### Optimization Considerations

- PARTITION 및 ORDER BY 수행 비용 존재
- 데이터 규모가 클수록 Sort 연산 증가
- 메모리 사용량 증가 가능

---

# 7. PIVOT Aggregation

PIVOT은 다차원 집계를 직관적으로 표현할 수 있습니다.

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

### Optimization Considerations

- 내부적으로 GROUP BY 기반 집계 수행
- 다수의 Pivot Column 사용 시 비용 증가 가능
- 복잡한 Pivot은 유지보수성이 낮아질 수 있음

---

# 8. Hierarchical Query Performance

Oracle의 CONNECT BY는 계층 구조 탐색에 특화되어 있습니다.

```sql
SELECT LEVEL, EMPNO
FROM EMP
START WITH MGR IS NULL
CONNECT BY MGR = PRIOR EMPNO;
```

### Optimization Considerations

- 계층 깊이가 깊을수록 탐색 비용 증가
- 순환(Cycle) 구조 발생 시 문제 가능
- CONNECT_BY_ISLEAF 등 추가 함수 사용 시 비용 증가 가능

---

# 9. Transaction Control

트랜잭션은 데이터 일관성을 유지하는 핵심 기능입니다.

```sql
SAVEPOINT A;

UPDATE EMP
SET SAL = SAL + 200;

ROLLBACK TO A;
```

### Optimization Considerations

- 장시간 Transaction은 Lock 유지 시간 증가 가능
- 불필요한 COMMIT 지연은 동시성 문제 유발 가능
- 적절한 SAVEPOINT 사용은 부분 복구에 유리

---

# 10. Engineering Insight

본 프로젝트를 통해 단순 SQL 문법 학습을 넘어:

- 데이터 무결성 유지
- JOIN 비용 구조 이해
- 실행 계획 기반 최적화 필요성
- 분석용 SQL과 운영용 SQL의 차이
- 유지보수 가능한 질의 구조 설계

등이 실제 데이터 엔지니어링 환경에서 중요하다는 점을 학습하였습니다.
