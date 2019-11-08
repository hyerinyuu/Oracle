/*
[PK설정]

PK는 테이블의 데이터가 완벽하도록 보장하기 위한 중요한 개념
==무결성, 객체무결성보장==
가장 좋은 방법은 1개의 유일한 값을 갖는 칼럼을 선정하여 PK로 설정
하지만 그렇지 못한 경우 2개 이상의 칼럼을 묶어서 pk로 설정하기도 한다.

2개의 칼럼으로 pk를 설정하면 수정, 삭제 과정에서 where절에 2개 이상의 조건을 설정해야 하는데,
자칫 잘못하여 누락시키는 경우 데이터 무결성을 해치는 결과를 낳을 수 있다.

이런 경우 실제 데이터와는 관련 없지만
pk를 위해서 별도의 칼럼을 생성하고, 일련번호 등으로 설정하는 것이 좋다.


*/



CREATE TABLE tbl_memo(
    
    m_seq NUMBER PRIMARY KEY,
    m_date VARCHAR2(10) NOT NULL, -- 2019-11-08, 한글제외
    m_time VARCHAR2(8) NOT NULL, -- 09:22:00
    m_auth nVARCHAR2(20) NOT NULL,
    m_subject nVARCHAR2(125) NOT NULL,
    m_text nVARCHAR2(1000),
    m_flag nVARCHAR2(1),
    m_field nVARCHAR2(20),
    m_ok VARCHAR2(1)

);

DESC tbl_memo;

-- m_seq 칼럼의 값 = 1 인 데이터가 추가된 상태에서
-- 다시 m_seq 칼러므이 값 = 1 인 데이터를 또 추가하려고 시도하면 ==> 오류
-- pk 규칙에 어긋나서 데이터가 추가되지 않는다.
-- 이런 상황에서 새로운 데이터를 추가할때마다
-- m_seq 값을 기존값과 중복되지 않은 값을 찾아야하는데
-- 이 방법이 업무진해엥서 매우 번거로운 작업이 된다.

-- 만약 m_seq 칼럼의 값을 항상 새로운 값으로 만들 수 있는 방법이 있다면 매우 편리할 것이다.
-- 오라클에서는 sequence라는 OBJECT를 사용하여
-- 해당 OBJECT의 특정한 METHOD를 호출하면 일련번호를 생성 할 수 있다.
-- SEQUENCE 생성하기
CREATE SEQUENCE SEQ_MEMO
START WITH 1 INCREMENT BY 1;
-- SEQ_MENO = 시퀀스를 생성하고, 시작값을 1로 설정, 자동으로 1씩 증가되는 값으로 새로운 값을 생성하라

-- tbl_memo(projection(칼럼을 나열한 것))
INSERT INTO tbl_memo(m_seq, m_date, m_time, m_auth, m_subject)
VALUES (1, '2019-11-08', '09:42:00','홍길동','메모작성');

-- [INSERT를 수행할 때 projection 생략 하는 경우]
-- projection을 생략하고 INSERT INTO tbl_memo VALUES(....)  
--    ==> 전체칼럼에 모든 데이터를 다 입력해 데이터 추가해야함.


-- [projection을 꼭 적고 table의 칼럼 순서대로 데이터를 나열해야하는 이유]
-- 만약 업무(프로젝트)가 진행되는 과정에서 table의 칼럼 순서 구조가 변경되는 경우에
-- 칼럼을 추가하면 보통 table구조에서 끝부분에 칼럼이 추가되는데
-- 이때는 데이터가 순서대로 원하는 칼럼에 저장될 것이다 라는 보장을 할 수 없게 된다.
-- 데이터가 잘못된 칼럼에 insert될 가능성 있음



--        [SEQUENCE]
-- SEQ.NEXTVAL : method와 같은 형식
-- SELECT INSERT UPDATE 명령문 내에서 사용이 되면 
-- 설정한 옵션에 따라 자동으로 값을 생성해낸다.
SELECT SEQ_MEMO.NEXTVAL FROM DUAL;


--          [INSERT]
INSERT INTO tbl_memo(m_seq, m_date, m_time, m_auth, m_subject)
VALUES (SEQ_MEMO.NEXTVAL, '2019-11-08', '09:42:00','홍길동','메모작성');


SELECT * FROM tbl_memo;

--          [WHERE]
-- 현재 추가된 데이터에서 M_SEQ가 10인 데이터만 확인하고싶을 때
SELECT * FROM tbl_memo
WHERE m_seq = 10;


--          [UPDATE]
-- m_seq가 10인 레코드의 작성자 이름을 홍길동 -> 성춘향 으로 바꾸고 싶을 때
UPDATE tbl_memo       -- 1. UPDATE 수행할 테이블 이름
SET m_auth = '성춘향' -- 2. SET 바꾸고 싶은 칼럼 = 바꾸고 싶은 데이터 
WHERE m_seq = 17 ;    -- 3. WHERE pk 조건


--          [DELETE]
-- 데이터를 입력해 놓고 확인을 해 봤더니
-- m_seq가 15인 데이터는 잘못 입력한 것이 발견 m_seq가 15인 데이터는 필요 없는 데이터임
-- 이럴때 필요없는 데이터 삭제하는 법
DELETE FROM tbl_memo  -- 1. DELETE FROM 삭제를 수행할 table
WHERE m_seq = 15;     -- 2. pk 삭제 조건

--       [ CRUD ] : DML MANAGEMENT LANGUAGE
-- INSERT INTO VALUE : IIV
-- SELECT FROM : SF
-- UPDATE SET WHERE : USW
-- DELETE FROM WHERE : DFW

-- DDL DATA DEFINITION LANGUAGE
-- CRETE : 생성
-- ALTER : 변경
-- DROP  : 삭제


CREATE TABLE tbl_iolist(

    io_seq	NUMBER		PRIMARY KEY,
    io_date	VARCHAR2(10)	NOT NULL,	
    io_pname	nVARCHAR2(25)	NOT NULL,	
    io_dname	nVARCHAR2(25)	NOT NULL,	
    io_dceo	nVARCHAR2(25)	NOT NULL,	
    io_inout	nVARCHAR2(2)	NOT NULL,	
    io_qty	NUMBER	NOT NULL,	
    io_price	NUMBER,		
    io_total	NUMBER		
    
);

CREATE TABLE tbl_product(

    p_code	VARCHAR2(5)		PRIMARY KEY,
    p_name	nVARCHAR2(50)	NOT NULL,	
    p_iprice	NUMBER,	
    p_oprice	NUMBER,		
    p_vat	VARCHAR2(1)		

);

CREATE TABLE tbl_dept(

    d_code	VARCHAR2(5)		PRIMARY KEY,
    d_name	nVARCHAR2(50)	NOT NULL,	
    d_ceo	nVARCHAR2(50)	NOT NULL,	
    d_tel	VARCHAR2(20),		
    d_addr	nVARCHAR2(125)		

);

SELECT COUNT(*) FROM tbl_iolist;
SELECT COUNT(*) FROM tbl_dept;
SELECT COUNT(*) FROM tbl_product;

-- 매입, 매출을 구분하여 레코드 개수 알아보기
SELECT io_inout, count(*) FROM tbl_iolist
GROUP BY io_inout;

-- 매입, 매출 각각의 총 합계 구하기
SELECT io_inout,sum(io_total) FROM tbl_iolist
GROUP BY io_inout;

-- 매입, 매출을 PIVOT 방식으로 알아보기
SELECT DECODE(io_inout,'매입',io_total,0) AS 매입,  
-- io_inout이 매입이면 io_total을 표시하고 아니면 0을 표시, 칼럼을 매입으로 명명
DECODE(io_inout,'매출',io_total,0)  AS 매출
-- io_inout이 매출이면 io_total을 표시하고 아니면 0을 표시, 칼럼을 매출으로 명명
FROM tbl_iolist;

SELECT 
    SUM( DECODE(io_inout,'매입',io_total,0)) AS 매입,  
    SUM( DECODE(io_inout,'매출',io_total,0)) AS 매출
FROM tbl_iolist;


-- 매입, 매출의 합계를 월별로 부분합을 구하여 PIVOT방식으로 알아보기
SELECT 
    SUBSTR(io_date,0,7) 월별,
    SUM( DECODE(io_inout,'매입',io_total,0)) AS 매입,  
    SUM( DECODE(io_inout,'매출',io_total,0)) AS 매출
FROM tbl_iolist
GROUP BY SUBSTR(io_date,0,7);

-- 매입과 매출의 합계를 거래처별로 부분합을 구하여 pivot방식으로 알아보기
-- io_dname의 거래처명이 중복이 없다는 가정
SELECT 
    io_dname,
    SUM( DECODE(io_inout,'매입',io_total,0)) AS 매입,  
    SUM( DECODE(io_inout,'매출',io_total,0)) AS 매출
FROM tbl_iolist
GROUP BY io_dname;


-- 거래처명과 대표가 동시에 같은 거래처는 없다는 가정
SELECT 
    io_dname, io_dceo,
    SUM( DECODE(io_inout,'매입',io_total,0)) AS 매입,  
    SUM( DECODE(io_inout,'매출',io_total,0)) AS 매출
FROM tbl_iolist
GROUP BY io_dname, io_dceo;


-- 거래명세와 거래처정보 table을 join하여 확인하기(정규화가 안되어있어서 코드로 join 수행x )
-- EQ(INNER) JOIN : JOIN하는 테이블이 서로 참조무결성이 보장되는 경우 가능
-- 참조무결성이 위배되는 테이블을 EQ JOIN을 실행하면 보여지는 데이터가 누락될 수 있다.
SELECT * 
FROM tbl_iolist, tbl_dept
WHERE io_dname = d_name AND io_dceo = d_ceo;

-- 참조무결성이 설정되지 않은 테이블간의 JOIN
-- 참조무결성에 위배되는 데이터는 NULL로 표현된다.
SELECT *
FROM tbl_iolist IO
     LEFT JOIN tbl_dept D
     ON IO.io_dname = D.d_name AND io_dceo = D.d_ceo;
     
-- 시험 JOIN은 제2정규화 코드로 외우기     
SELECT *
FROM tbl_iolist IO
    LEFT JOIN tbl_dept D
    ON IO.io_dcode = D.d_code;
