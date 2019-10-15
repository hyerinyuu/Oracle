-- 여기는 user3 화면입니다

CREATE TABLE tbl_score (
    s_num	VARCHAR2(3)		PRIMARY KEY,
    s_kor	NUMBER(3),		
    s_eng	NUMBER(3),		
    s_math	NUMBER(3)
) ;

DESC tbl_score ;

INSERT INTO tbl_score(s_num, s_kor, s_eng, s_math)
VALUES ('001', 90, 80, 70) ;

INSERT INTO tbl_score(s_num, s_kor, s_eng, s_math)
VALUES ('002', 90, 80, 70) ;

INSERT INTO tbl_score(s_num, s_kor, s_eng, s_math)
VALUES ('003', 90, 80, 70) ;

INSERT INTO tbl_score(s_num, s_kor, s_eng, s_math)
VALUES ('004', 90, 80, 70) ;

INSERT INTO tbl_score(s_num, s_kor, s_eng, s_math)
VALUES ('005', 90, 80, 70) ;

INSERT INTO tbl_score(s_num, s_kor, s_eng, s_math)
VALUES ('006', 90, 80, 70) ;

INSERT INTO tbl_score(s_num, s_kor, s_eng, s_math)
VALUES ('007', 90, 80, 70) ;

INSERT INTO tbl_score(s_num, s_kor, s_eng, s_math)
VALUES ('008', 90, 80, 70) ;

SELECT * FROM tbl_score ;

-- 성적의 총점, 평균 구하기

SELECT s_kor, s_eng, s_math, 
    s_kor + s_eng + s_math AS 총점,
    (s_kor + s_eng + s_math) / 3 AS 평균
FROM tbl_score ;

-- DBMS_RANDOM(50,100) ==> 50이상 100미만의 임의의 정수 생성
-- ROUND ,0 ==> 소수점 이하 0번째 자리까지 == 소숫점이하 버려라
UPDATE tbl_score
SET s_kor = ROUND( DBMS_RANDOM.VALUE(50,100),0 ),
    s_eng = ROUND( DBMS_RANDOM.VALUE(50,100),0 ),
    s_math = ROUND( DBMS_RANDOM.VALUE(50,100),0 ) ;

SELECT * FROM tbl_score ;

UPDATE tbl_score
SET s_math = 100
WHERE s_num = '003';

SELECT s_num, s_kor, s_eng, s_math,
        s_kor + s_eng + s_math AS 총점,
        (s_kor + s_eng + s_math) / 3 AS 평균
FROM tbl_score ;

SELECT s_num, s_kor, s_eng, s_math,
        s_kor + s_eng + s_math AS 총점,
        ROUND((s_kor + s_eng + s_math)/3,0) AS 평균
FROM tbl_score ;


SELECT s_num, s_kor, s_eng, s_math,
        s_kor + s_eng + s_math AS 총점,
        ROUND((s_kor + s_eng + s_math)/3,0) AS 평균
FROM tbl_score 
WHERE (s_kor + s_eng + s_math)/3 >= 80 ;

SELECT s_num, s_kor, s_eng, s_math,
        s_kor + s_eng + s_math AS 총점,
        ROUND((s_kor + s_eng + s_math)/3,0) AS 평균
FROM tbl_score 
-- 계산한 결과(총점)이 70부터 80까지인 경우만 표시
WHERE (s_kor + s_eng + s_math)/3 BETWEEN 70 AND 80 ;

-- 통계, 집계함수
-- SUM(), COUNT(), AVG(), MAX(), MIN()

-- 전체리스트의 각 과목별 총점 계산하고 싶을때
SELECT SUM(s_kor)--국어점수합계 계산
FROM tbl_score ;

SELECT SUM(s_kor) AS 국어총점,
       SUM(s_eng) AS 영어총점,
       SUM(s_math) AS 수학총점
FROM tbl_score ;


SELECT SUM(s_kor) AS 국어총점,
       SUM(s_eng) AS 영어총점,
       SUM(s_math) AS 수학총점,
       SUM(s_kor + s_eng + s_math) AS 전체총점
FROM tbl_score ;

SELECT SUM(s_kor) AS 국어총점,
       SUM(s_eng) AS 영어총점,
       SUM(s_math) AS 수학총점,
       SUM(s_kor + s_eng + s_math) AS 전체총점,
       ROUND(AVG((s_kor + s_eng + s_math)/3),0) AS 전체평균
FROM tbl_score ;


SELECT COUNT(*) -- 이때는 * 사용가능
FROM tbl_score ;

-- *를 사용하나 count를 사용하나 똑같다
SELECT COUNT(s_kor), COUNT(s_eng), (s_math)
FROM tbl_score;

SELECT MIN(s_kor + s_eng + s_math) AS 최저점
FROM tbl_score ;

SELECT MAX(s_kor + s_eng + s_math) AS 최고점,
       MIN(s_kor + s_eng + s_math) AS 최저점
FROM tbl_score ;

SELECT s_kor, s_eng, s_math,
        (s_kor + s_eng + s_math) AS 총점
FROM tbl_score ;

-- 개인총점이 200점 이상인 리스트 보여라
SELECT SUM(s_kor) AS 국어총점,
       SUM(s_eng) AS 영어총점,
       SUM(s_math) AS 수학총점,
       SUM(s_kor + s_eng + s_math) AS 전체총점,
       ROUND(AVG((s_kor + s_eng + s_math)/3),0) AS 전체평균
FROM tbl_score 
WHERE s_kor + s_eng + s_math >= 200;

-- 개인별 평균이 70 이상인 리스트들의 집계
SELECT SUM(s_kor) AS 국어총점,
       SUM(s_eng) AS 영어총점,
       SUM(s_math) AS 수학총점,
       SUM(s_kor + s_eng + s_math) AS 전체총점,
       ROUND(AVG((s_kor + s_eng + s_math)/3),0) AS 전체평균
FROM tbl_score 
WHERE (s_kor + s_eng + s_math) /3  >= 70;

SELECT s_num, s_kor + s_eng + s_math AS 총점
FROM tbl_score;


SELECT s_num, s_kor + s_eng + s_math AS 총점,
    RANK() OVER ( ORDER BY (s_kor + s_eng + s_math) DESC ) AS 석차  -- RANK = 오라클에서만
FROM tbl_score;

SELECT s_num, s_kor + s_eng + s_math AS 총점
FROM tbl_score
ORDER BY(s_kor + s_eng + s_math) DESC;

-- 1. (s_kor + s_eng + s_math)를 계산하고
-- 2. 계산결과를 내림차순으로 정렬하고
-- 3. 순서대로 값을 매겨라
SELECT s_num, s_kor + s_eng + s_math AS 총점,
    RANK() OVER ( ORDER BY (s_kor + s_eng + s_math) DESC ) AS 석차  
FROM tbl_score
ORDER BY s_num ;


-- DENSE_RANK : 만약 중복값이 있으면 중복값 처리를 해라
-- RANK () : 동점자가 있을 때 순위를 건너뛰고 표시
-- DENSE_RANK : 동점자가 있어도 다음 값을 연속해서 표시
/*
EX >>

값      RANK()        DENSE_RANK()
------------------------------------
200       1                1
190       2                2
190       2                2
180       4                3
170       5                5
160       6                6 
------------------------------------
*/
SELECT s_num, s_kor + s_eng + s_math AS 총점,
    DENSE_RANK() OVER ( ORDER BY (s_kor + s_eng + s_math) DESC ) AS 석차  
FROM tbl_score
ORDER BY s_num ;


CREATE TABLE tbl_dept (
    d_num	VARCHAR2(3)		PRIMARY KEY, 
    d_name	VARCHAR2(20)	NOT NULL,
    d_pro	VARCHAR(3)		
);




