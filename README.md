# relational-db-analysis-oracle
Oracle SQL 기반 관계형 데이터베이스 설계, 고급 질의, 다차원 집계 및 데이터 분석 프로젝트

# Oracle SQL 기반 데이터 엔지니어링 및 관계형 데이터 분석 프로젝트

## Overview

Oracle RDBMS 환경에서 관계형 데이터베이스를 직접 설계하고,
복합 비즈니스 로직 및 분석 질의를 SQL 기반으로 구현한 프로젝트입니다.

본 프로젝트에서는 단순 CRUD를 넘어:

- 관계형 스키마 설계
- 참조 무결성 관리
- 고급 JOIN 및 서브쿼리
- 다차원 집계(PIVOT / ROLLUP)
- 윈도우 함수 기반 분석
- 계층형 질의(CONNECT BY)

등의 기능을 활용하여 데이터 처리 및 분석 흐름을 구현하였습니다.

---

## Tech Stack

| Category | Skills |
|---|---|
| DBMS | Oracle Database |
| Query Language | Oracle SQL |
| Tool | SQL Developer |
| Database Design | PK/FK, CHECK, CASCADE |
| Data Processing | JOIN, Subquery, Aggregation |
| Advanced SQL | RANK, ROLLUP, CONNECT BY |

---

## Project Structure


---

## Core Engineering Tasks

### 1. Relational Database Modeling

- 부모-자식 테이블 구조 설계
- PK/FK 기반 참조 무결성 구성
- CHECK 제약조건을 통한 데이터 검증
- ON DELETE CASCADE 기반 데이터 정합성 유지

---

### 2. Analytical SQL Processing

- BMI 파생 변수 생성
- CASE 기반 Pivot 집계
- Inline View 기반 데이터 정제
- 다차원 그룹 집계 구현

---

### 3. Advanced Query Engineering

- OUTER JOIN 기반 결측 데이터 처리
- Non-Equi Join 기반 범위 매핑
- EXISTS 기반 연관 서브쿼리 구현

---

### 4. Hierarchical & Ranking Analysis

- DENSE_RANK 기반 순위 분석
- ROLLUP / GROUPING SETS 기반 집계
- CONNECT BY 기반 조직 계층 탐색

---

## Engineering Insights

### Query Optimization Awareness

실습 데이터셋에서는 성능 차이가 크지 않았으나,
대용량 환경에서는 실행 계획 및 인덱스 전략이
쿼리 성능에 직접적인 영향을 준다는 점을 확인하였습니다.

### Data Integrity vs Operational Flexibility

참조 무결성을 강하게 유지하는 구조와,
실제 운영 환경에서 요구되는 복구 가능성 및 이력 관리 사이에는
Trade-off가 존재함을 학습하였습니다.

### SQL Structuring

복잡한 분석 질의는 단순 동작 여부뿐 아니라
가독성 및 유지보수성까지 고려해야 하며,
CTE 및 Inline View 기반 구조화의 중요성을 인지하였습니다.
