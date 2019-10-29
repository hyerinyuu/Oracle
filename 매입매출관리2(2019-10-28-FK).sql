SELECT D_CODE, D_NAME, D_CEO, D_TEL, D_ADDR
FROM tbl_dept;

SELECT IO_SEQ, IO_DATE, IO_INOUT, IO_QTY, IO_PRICE, IO_TOTAL, IO_PCODE, IO_DCODE
FROM tbl_iolist;

SELECT P_CODE, P_NAME, P_IPRICE, P_OPRICE, P_VAT
FROM tbl_product;

/*
tbl_iolist - tbl_product
io_pcode      p_code

tbl_iolist - tbl_dept
io_dcode     d_code

제 2정규화과 완료된 후
테이블들의 참조무결성을 보장하기 위해
FK설정을 수행해야함
*/
ALTER TABLE tbl_iolist -- 연동되는 TABLE
ADD CONSTRAINT FK_PRODUCT
FOREIGN KEY(io_pcode) -- 연동되는 칼럼
REFERENCES tbl_product(p_code); --PK로 설정된 부분

ALTER TABLE tbl_iolist -- 연동되는 TABLE
ADD CONSTRAINT FK_DEPT
FOREIGN KEY(io_dcode) -- 연동되는 칼럼
REFERENCES tbl_dept(d_code); --PK로 설정된 부분

/*
오라클의 LEVEL 기능(오라클 전용)
 
[&변수]
- 오라클의 대치연산자
- 1 <= 변수까지 연속된 값을 레코드로 추출해주는 오라클 SQL

- (SQL을 실행하는)사용자로부터 어떤 값을 입력받아서
SQL을 수행하기 위한 방법


*/
SELECT LEVEL FROM DUAL CONNECT BY LEVEL <= 10;
SELECT LEVEL FROM DUAL CONNECT BY LEVEL <= &변수;
SELECT LEVEL FROM DUAL CONNECT BY LEVEL <= &LAST;

-- 10부터 100까지
SELECT LEVEL * 10 FROM DUAL CONNECT BY LEVEL <= 10;

SELECT LEVEL * &시작 FROM DUAL CONNECT BY LEVEL <= &종료; 

-- 역순표시
SELECT (LEVEL -10) * -1 FROM DUAL CONNECT BY LEVEL <= 10;

SELECT IO_SEQ, IO_DATE, IO_INOUT, IO_QTY, IO_PRICE, IO_TOTAL, IO_PCODE, IO_DCODE
FROM tbl_iolist
WHERE io_date BETWEEN '&시작일자' AND '&종료일자'; -- 문자열로 검색할때는 ''넣어주기


-- 문자열을 날짜 TYPE으로 변환시키기
-- 날짜값을 문자열형태로 저장을 하는데
-- 날짜값으로 어떤 연산을 수행하고자 할때는
-- 문자열을 날짜 TYPE으로 변환을 시킬 필요가 있음

/*
2019-01-01부터 2019-01-31까지의 날짜 값을 추출하는 연산
 TO_DATE('2019-01-31', 'YYYY-MM-DD')
                   -(TO_DATE('2019-01-01', 'YYYY-MM-DD') +1);
*/
SELECT TO_DATE('2019-01-01', 'YYYY-MM-DD') -1 + LEVEL FROM DUAL
CONNECT BY LEVEL <= TO_DATE('2019-01-31', 'YYYY-MM-DD')
                   -(TO_DATE('2019-01-01', 'YYYY-MM-DD') + 1);

-- 2019-01-01부터 2019-09-30까지 년, 월만 추출해서 문자열로 생성하는 연산
SELECT  TO_CHAR(ADD_MONTHS(TO_DATE('2019-01-01', 'YYYY-MM-DD'),LEVEL -1), 'YYYY-MM') FROM DUAL
CONNECT BY LEVEL <= TO_DATE('2019-09-30', 'YYYY-MM-DD')
                   -(TO_DATE('2019-01-01', 'YYYY-MM-DD') + 1);

-- 기간을 지정하여 년 -월 형태의 문자열을 생성하는 코드
-- ADD_MONTHS : 날짜값에 월을 +해서 숫자형 날짜값으로 변환   
-- 문자열형태로는 날짜관련 연산이 불가능하기 때문에 
-- 문자열 형태로 저장된 날짜는 TO_DATE로 문자열 -> 날짜형으로 변환시켜서 연산 수행해야함
SELECT ADD_MONTHS(TO_DATE('2019-01-01', 'YYYY-MM-DD'), LEVEL -1 ) 
FROM DUAL
CONNECT BY LEVEL <= 5;

-- 컴퓨터의 현재 날짜
SELECT SYSDATE FROM DUAL;

-- 현재 날짜가 포함된 달의 마지막 날짜
SELECT LAST_DAY(SYSDATE) FROM DUAL;

SELECT LEVEL 
FROM DUAL
CONNECT BY LEVEL <= (LAST_DAY(SYSDATE) - TRUNC(SYSDATE, 'MONTH')) +1 ;

SELECT TO_CHAR(TRUNC(SYSDATE, 'month') + (LEVEL - 1), 'YYYY-MM-DD') 
FROM DUAL
CONNECT BY LEVEL <= (LAST_DAY(SYSDATE) - TRUNC(SYSDATE, 'MONTH') +1);

-- 2018년 1월 1일부터 12달의 달수만 가져오기
SELECT * FROM
tbl_iolist IO,
(
SELECT TO_CHAR(ADD_MONTHS(TO_DATE('2018-01-01', 'YYYY-MM-DD'), LEVEL-1), 'YYYY-MM') AS 월
FROM DUAL
CONNECT BY LEVEL <= 12
);

SELECT TO_CHAR(ADD_MONTHS(TO_DATE(io_date, 'YYYY-MM-DD'),0), 'YYYY-MM') FROM tbl_iolist;

-- 일반적인 SQL을 이용해서
-- 월별로 합계 계산
SELECT SUBSTR(io_date,0,7) AS IO_월, SUM(io_total) 
FROM tbl_iolist IO
GROUP BY SUBSTR(io_date,0,7);


-- 월 리스트를 가지고 서브쿼리로 생성한 다음
-- 월 리스트를 가지고 EQ JOIN을 수행해서 월별합계
SELECT 월, SUM(io_total) 
FROM tbl_iolist IO,

(
    SELECT TO_CHAR(ADD_MONTHS(TO_DATE('2018-01-01', 'YYYY-MM-DD'), LEVEL-1), 'YYYY-MM') AS 월
    FROM DUAL
    CONNECT BY LEVEL <= 12
)
WHERE 월 = SUBSTR(io_date,0,7)
GROUP BY 월;

-- max값 : 1500000
SELECT MAX(io_total) FROM tbl_iolist;
-- MIN값 : 12250
SELECT MIN(io_total) FROM tbl_iolist;
SELECT MIN(io_total), MAX(io_total) FROM tbl_iolist;


SELECT LEVEL * 10000 FROM DUAL CONNECT BY LEVEL <= 150;


-- subq로 10000 ~ 1500000 까지 10000씩 증가하는 값으로 리스트 생성
-- 각각의 값 범위 
-- ex) 10000 ~ < 20000까지의 합계와 개수를 연산
-- level 값과 iolist를 join
SELECT SUB.TOTAL, SUM(io_total), COUNT(io_total)
FROM tbl_iolist,
(
    SELECT LEVEL * 10000 AS TOTAL FROM DUAL CONNECT BY LEVEL <= 150
) SUB
WHERE io_total >= SUB.TOTAL AND io_total < SUB.TOTAL + 10000
AND io_inout = '매출'
GROUP BY TOTAL
ORDER BY TOTAL;

SELECT * FROM tbl_score
ORDER BY sc_seq;


-- SUBQ와 EQ JOIN으로 학생수가 있는 점수대만 보여주기
SELECT 점수, COUNT(SC.sc_score)
FROM tbl_score SC,
(
    SELECT LEVEL * 10 AS 점수 FROM DUAL CONNECT BY LEVEL <= 10
) SUB
WHERE SC.sc_score >= 점수 AND SC.sc_score <= 점수 +10
GROUP BY 점수
ORDER BY 점수;


-- subq와 left join을 같이 묶어서
-- 학생수가 없는 점수대의 점수제목도 같이 보여주기
SELECT 점수, COUNT(SC.sc_score)
FROM( SELECT LEVEL * 10 AS 점수 FROM DUAL CONNECT BY LEVEL <= 10) SUB
    LEFT JOIN tbl_score SC
           ON SC.sc_score >= 점수 AND SC.sc_score <= 점수 +10
GROUP BY 점수
ORDER BY 점수;

-- 오라클에서 숫자를 연속된 값의 리스트로 만들 때
SELECT LEVEL * 0.1 FROM DUAL CONNECT BY LEVEL <= 10;

-- sc_subject 칼럼에 들어있는 과목명의 리스트 확인
SELECT sc_subject FROM tbl_score
GROUP BY sc_subject
ORDER BY sc_subject;

-- [제 1 정규화가 되어있는 데이터를 보고서 형태로 보여주는 SQL]
-- 1. PIVOT을 이용한 방법
SELECT *
FROM (SELECT sc_name, sc_subject, sc_score FROM tbl_score)
PIVOT (

    SUM(sc_score)
    FOR sc_subject 
    IN(
    '국어' AS 국어,
    '과학' AS 과학,
    '영어' AS 영어,
    '수학' AS 수학,
    '국사' AS 국사,
    '미술' AS 미술
    )
);
-- 2. DECODE를 이용한 방법
SELECT sc_name,
    SUM(DECODE(sc_subject, '과학', sc_score)) AS 과학,
    SUM(DECODE(sc_subject, '국어', sc_score)) AS 국어,
    SUM(DECODE(sc_subject, '영어', sc_score)) AS 영어,
    SUM(DECODE(sc_subject, '수학', sc_score)) AS 수학,
    SUM(DECODE(sc_subject, '국사', sc_score)) AS 국사,
    SUM(DECODE(sc_subject, '미술', sc_score)) AS 미술
FROM tbl_score
GROUP BY sc_name;
-- sum을 사용하는 이유 : 이름을 그룹으로 묶어서 과목별 점수를 표시하는 형태의 리스트를 출력하고 싶은데
--                      sum으로 묶어주지 않으면 이름

-- 학생 한사람을 기준으로 과목을 나열하여 보여주기 위해서
-- 학생 이름으로 GROUP BY 를 수행해야하고
-- 나머지 항목에서도 GROUP BY를 수행하여야 SQL문이 정상으로 작동되는데
-- 학생이름을 제외한 나머지 항목을 SUM()묶어주면
-- GROUP BY절에 나열하지 않아도 된다.
SELECT sc_name,
    DECODE(sc_subject, '과학', sc_score,0) AS 과학,
    DECODE(sc_subject, '국어', sc_score,0) AS 국어,
    DECODE(sc_subject, '영어', sc_score,0) AS 영어,
    DECODE(sc_subject, '수학', sc_score,0) AS 수학,
    DECODE(sc_subject, '국사', sc_score,0) AS 국사,
    DECODE(sc_subject, '미술', sc_score,0) AS 미술
FROM tbl_score
GROUP BY sc_name;

-- MySQL에서는 이런식으로 이용하면 됨(표준 SQL) case when -> if
-- ELSE 0을 표시하지 않으면 오류가 나는 DBMS도 있음
SELECT sc_name,
    SUM(CASE WHEN sc_subject = '과학' THEN sc_score ELSE 0 END) AS 과학,
    SUM(CASE WHEN sc_subject = '국어' THEN sc_score ELSE 0 END) AS 국어,
    SUM(CASE WHEN sc_subject = '영어' THEN sc_score ELSE 0 END) AS 영어,
    SUM(CASE WHEN sc_subject = '수학' THEN sc_score ELSE 0 END) AS 수학,
    SUM(CASE WHEN sc_subject = '국사' THEN sc_score ELSE 0 END) AS 국사,
    SUM(CASE WHEN sc_subject = '미술' THEN sc_score ELSE 0 END) AS 미술
FROM tbl_score
GROUP BY sc_name;

-- ,0 : null대신 0이 표시됨
SELECT io_inout,
    SUM(DECODE(io_inout, '매입', io_total,0)) AS 매입,
    SUM(DECODE(io_inout, '매출', io_total,0)) AS 매출
FROM tbl_iolist
GROUP BY io_inout;


-- 매입과 매출을 한줄에 보여줌
SELECT
    SUM(DECODE(io_inout, '매입', io_total,0)) AS 매입,
    SUM(DECODE(io_inout, '매출', io_total,0)) AS 매출
FROM tbl_iolist;

-- 매입, 매출, 마진(매입 - 매출)을 한줄에 표시함
SELECT
    SUM(DECODE(io_inout, '매입', io_total,0)) AS 매입,
    SUM(DECODE(io_inout, '매출', io_total,0)) AS 매출,
    
    SUM(DECODE(io_inout, '매입', io_total,0)) -
    SUM(DECODE(io_inout, '매출', io_total,0)) AS 마진

FROM tbl_iolist;

-- 매입, 매출, 마진을 한줄에 보여주는데 100단위로 ,찍어서 보여줌
SELECT
    TO_CHAR(SUM(DECODE(io_inout, '매입', io_total,0)), '999,999,999,999') AS 매입,
    TO_CHAR(SUM(DECODE(io_inout, '매출', io_total,0)),'999,999,999,999') AS 매출,
    
    TO_CHAR(SUM(DECODE(io_inout, '매입', io_total,0)) -
    SUM(DECODE(io_inout, '매출', io_total,0)), '999,999,999,999') AS 마진

FROM tbl_iolist;


-- 월별 매입/매출 집계
SELECT
    SUBSTR(io_date,0,7),
    SUM(DECODE(io_inout, '매입', io_total,0)) AS 매입,
    SUM(DECODE(io_inout, '매출', io_total,0)) AS 매출
FROM tbl_iolist
GROUP BY SUBSTR(io_date,0,7)
ORDER BY SUBSTR(io_date,0,7);

-- 거래처코드별 매입/매출 집계
SELECT
    io_dcode,
    SUM(DECODE(io_inout, '매입', io_total,0)) AS 매입,
    SUM(DECODE(io_inout, '매출', io_total,0)) AS 매출
FROM tbl_iolist
GROUP BY io_dcode
ORDER BY io_dcode;
    

-- (sum으로 묶인 모든 칼럼은 group by에 나타나야함)
-- 거래처별로 매입, 매출 집계
-- 거래처테이블과 JOIN
SELECT
    io_dcode, d_name, d_ceo, d_tel,
    SUM(DECODE(io_inout, '매입', io_total,0)) AS 매입,
    SUM(DECODE(io_inout, '매출', io_total,0)) AS 매출
FROM tbl_iolist IO
    LEFT JOIN tbl_dept D
           ON IO.io_dcode = D.d_code
GROUP BY io_dcode, d_name, d_ceo, d_tel
ORDER BY io_dcode;


-- 실행순서 1. FROM 2.(있으면)WHERE, 3. LEFT JOIN, 4. GROUP BY, 5. SELECT
-- SELECT의 Projection부분에서 계산식을 사용할 경우,
-- GROUP BY에는 계산식을 모두 기술해 주어야함.
-- Alias 부분은 GROUP BY에서 인식하지 않는다.
-- HAVING도 계산식을 모두 기술해주어야한다.
SELECT
    io_dcode, 
    d_name || ', ' || d_ceo || ', ' || d_tel AS 거래처,
    SUM(DECODE(io_inout, '매입', io_total,0)) AS 매입,
    SUM(DECODE(io_inout, '매출', io_total,0)) AS 매출
FROM tbl_iolist IO
    LEFT JOIN tbl_dept D
           ON IO.io_dcode = D.d_code
GROUP BY io_dcode, d_name || ', ' || d_ceo || ', ' || d_tel
HAVING SUM(DECODE(io_inout, '매입', io_total,0)) > 100000 -- 매입합계 > 100000 이상만 보이라는 조건
-- HAVING 매입 > 100000 -- => 오류(SELECT문이 가장 마지막에 실행되기 때문에 이딴 코드는 안됨)
ORDER BY io_dcode;

SELECT io_date, io_pcode, p_name,
    DECODE(io_inout, '매입', io_price) AS 매입단가,
    DECODE(io_inout, '매입', io_total) AS 매입합계,
    DECODE(io_inout, '매출', io_price) AS 매출단가,
    DECODE(io_inout, '매출', io_total) AS 매출합계   
FROM tbl_iolist, tbl_product
WHERE io_pcode = p_code
ORDER BY io_date;


SELECT io_date, io_pcode, d_name, io_pcode, p_name,
    DECODE(io_inout, '매입', io_price) AS 매입단가,
    DECODE(io_inout, '매입', io_total) AS 매입합계,
    DECODE(io_inout, '매출', io_price) AS 매출단가,
    DECODE(io_inout, '매출', io_total) AS 매출합계   
FROM tbl_iolist
    LEFT JOIN tbl_product
           ON io_pcode = p_code
    LEFT JOIN tbl_dept
           ON io_dcode = d_code           
ORDER BY io_date;
    
