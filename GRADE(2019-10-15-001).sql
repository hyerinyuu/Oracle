/*
tablespace를 새로 생성한 후 
접속창에서 +기호를 눌러 NAME을 지정해주고 ID와 비밀번호 입력 후 저장/테스트/접속순으로 하면 됨
*/
-- 여기는 GRADE화면

-- PK 지정방법을 칼럼에 PRIMARY KEY를 지정하지 않고
-- 별도로 CONSTRAINT 추가 방식으로 지정
-- 표준 SQL에서는 PK지정방식을 칼럼에 PRIMARY KEY 키워드 지정 방식으로 사용하는데,
-- 간혹 표준 SQL의 PK 지정방식이 안되는 DBMS가 있다.
-- 이때는 별도의 CONSTRAINT 추가 방식으로 지정해야 한다.
-- 이 방식은 다수의 칼럼으로 PK를 지정할때도 사용한다.
CREATE TABLE tbl_score
(
    s_id	NUMBER,
    s_std	nVARCHAR2(50)	NOT NULL,	
    s_subject	nVARCHAR2(50)	NOT NULL,	
    s_score	NUMBER(3)	NOT NULL,	
    s_rem	nVARCHAR2(50),
    CONSTRAINT pk_score PRIMARY KEY(s_id) 
);
DROP TABLE tbl_score; 

-- 엑셀데이터 성적일람표 IMPORT
-- IMPORT가 잘됐는지 확인하는 코드(데이터 숫자 나옴)
SELECT COUNT(*) FROM tbl_score;

SELECT * FROM tbl_score;

-- 이렇게 과학/수학 칼럼이 아닌 과목칼럼에 과학/수학등이 모두 포함된 테이블의 장점
-- ==> 이름칼럼으로 묶어서 통합한 후 s_score의 값을 모두 더한 총점과 나눈 평균을 계산할 수 있음
-- ### 
-- 1. 학생(s_std) 데이터가 같은 레코드를 묶기
-- 2. 묶인 그룹내에서 총점과 평균 계산
select s_std, sum(s_score) AS 총점, ROUND(avg(s_score),0) AS 평균
FROM tbl_score
GROUP BY s_std
ORDER BY s_std;

/*
학생이름    과목       점수 
위와 같은 형식으로 저장된 데이터를

학생이름    국어  영어  수학  과학
형식으로 펼쳐서 보는 방법
*/
-- 1. tbl_score에 저장된 과목명들을 확인
-- 데이터에 어떤 과목들이 저장되어 있나 확인
SELECT s_subject FROM tbl_score
GROUP BY s_subject  --여기까지 하면 s_subject에 저장된 레코드들 보여줌
ORDER BY s_subject;

/*
과학
수학
국어
국사
미술
영어
*/
--                                  [DECODE를 이용한 PIVOT DATA VIEW]

-- DECODE함수를 사용해 s_subject가 과학이면  S_SCORE를 표시하고 과학이라고 이름 붙여라
-- 세로방향 데이터를 가로방향 데이터로 펼쳐놓는 코드 ==> PIVOT
-- SUM()을 추가하면 한줄에 한 학생의 데이터가 펼쳐짐 ==> 완성하고자 하는 최종 데이터 VIEW  ==> PIVOT DATA VIEW

/*
###
    성적테이블을
    각 과목이름으로 칼럼을 만들어서 생성을 하면
    데이터를 추가하거나, 단순 조회를 할 때에는 상당히 편리하게 사용할 수 있다.
    하지만, 사용중에 과목이 추가되거나 과목병이 변경되는 경우
    테이블의 칼럼을 변경해야하는 상황이 발생할 수 있다.
        테이블의 칼럼을 변경하는 것은 DBMS 입장에서나 사용자 입장에서 
        많은 비용(==사용중지시간, 노력, 위험성 등등)을 지불해야 한다.
        테이블의 칼럼을 변경하는 일은 매우 신중해야 한다.
        
그래서 실제 데이터는 고정된 칼럼으로 생성된 테이블에 저장을 하고
view로 확인을 할 때 PIVOT 방식으로 펼쳐 보면
마치 실제 테이블에 칼럼이 존재하는 것처럼 사용을 할 수 있는 장점이 있다.

(나중에 VIEW로 생성하면 마치 실제 테이블이 존재하는 것처럼 볼 수 있음)

하지만 이름을 기준으로 묶었기 때문에 동명이인에 경우에는 문제 발생 가능
(이건 지금 안하고 나중에 제 2 정규화에서 따로 처리를 하는 방법을 배움)
*/

-- 오라클 버전 관계 없이 모두 사용할 수 있는 문법
SELECT s_std AS 학생, 
    SUM(DECODE(s_subject, '과학', s_score)) AS 과학,
    SUM(DECODE(s_subject, '국사', s_score)) AS 국사,
    SUM(DECODE(s_subject, '국어', s_score)) AS 국어,
    SUM(DECODE(s_subject, '미술', s_score)) AS 미술,
    SUM(DECODE(s_subject, '수학', s_score)) AS 수학,
    SUM(DECODE(s_subject, '영어', s_score)) AS 영어
FROM tbl_score
--WHERE s_std = '갈한수'   ==> 갈한수 학생의 데이터만 보여달라
GROUP BY s_std
ORDER BY s_std;



-- 오라클10c이후(실무에서는 10c를 거의 안쓰니까 11g라고 표현해도 됨)에 사용하는 PIVOT 전용 문법
-- SQL DEVELOPER에서 명령수행에 제한이 있다.
--  (칼럼을 문자열로 쓰고 AS 키워드를 사용해야 함 -> 아니면 문자열처럼 ''가 생겨서 칼럼에 표시됨)
--  (FROM다음에 반드시 SUB QUERY를 사용해서 테이블을 지정해줘야함)
-- 한번 SELECT를 하고 다시 QUERY를 사용해야 해서 속도가 약간 느리다는 느낌이 들 수 있음
-- 실무에서는 pivot코드보다는 위의 오라클 전용 코드를 더 많이 사용
SELECT * 
FROM
-- SUB QUERY
    ( SELECT s_std, s_subject, s_score FROM tbl_score)
PIVOT (
-- 여기는 컴마 안써도 됨
    SUM(s_score)       -- 칼럼 이름별로 분리하여 표시할 데이터
    FOR(s_subject)     -- 묶어서 펼칠 칼럼 이름
    IN(                -- 펼쳤을때 보여질 칼럼 이름 목록
                    '과학' AS 과학,
                    '수학' AS 수학,
                    '국어' AS 국어,
                    '국사' AS 국사,
                    '미술' AS 미술,
                    '영어' AS 영어
      )                            
)
ORDER BY s_std;
    
CREATE VIEW view_score
AS
(
SELECT s_std AS 학생, 
    SUM(DECODE(s_subject, '과학', s_score)) AS 과학,
    SUM(DECODE(s_subject, '국사', s_score)) AS 국사,
    SUM(DECODE(s_subject, '국어', s_score)) AS 국어,
    SUM(DECODE(s_subject, '미술', s_score)) AS 미술,
    SUM(DECODE(s_subject, '수학', s_score)) AS 수학,
    SUM(DECODE(s_subject, '영어', s_score)) AS 영어,
    SUM(s_score) AS 총점,
    ROUND(AVG(s_score),0) AS 평균,
    RANK() OVER (ORDER BY SUM(s_score) DESC) AS 석차
    
FROM tbl_score
--WHERE s_std = '갈한수'   ==> 갈한수 학생의 데이터만 보여달라
GROUP BY s_std
--ORDER BY s_std;  ==> 여기서는 orderby 못씀
);

SELECT * FROM view_score
ORDER BY 학생;






















