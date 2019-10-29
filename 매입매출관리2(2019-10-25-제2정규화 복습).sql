-- iolist 화면(매입매출관리// 정규화 복습)
 -- 데이터 임포트 수행 후 정확히 데이터가 있는지 확인
 SELECT * FROM  tbl_iolist;
 SELECT COUNT(*) FROM tbl_iolist;  -- 데이터 232

-- 구분 칼럼을 그룹으로 묶어서 
-- 그룹내의 개수가 몇개씩인지 확인
SELECT io_inout, count(*) FROM tbl_iolist
GROUP BY io_inout; 

-- 현재 데이터는 제 1 정규화가 완료된 데이터이고
-- 이 데이터를 제 2 정규화 작업 수행하기

--       [제 2 정규화]
-- 1개의 테이블에 정리된 데이터를
-- 다른 테이블로 데이터를 분리하여 UPDATE등을 수행할 때
-- 데이터의 무결성을 보장하기 위한 조치

-- 현재 데이터에서 상품의 이름을 변경하고자 할 때
UPDATE tbl_iolist
SET io_pname = ''
WHERE io_pname = '';
-- 위 UPDATE 명령문은 다수의(1개를 초과하는) 레코드를 변경하는 코드임
-- 이 코드가 실행되면서 실제로 변경하지 말아야 할 데이터들이 변경될수도 있고
-- 변경해야할 데이터들이 변경되지 않는ㄴ 경우도 발생할 수 있다.
-- 상품정보를 별도의 테이블로 분리하고, 
-- 현재 테이블에는 상품정보테이블과 연결하는 칼럼만 두어서
-- 상품정보를 최소한으로 변경을 해도 
-- 보이는 데이터가 원하는 방향으로 변경될 수 있도록 수행하는 것.


-- 상품정보와 상품단가의 평균에 대한 리스트 확보
SELECT io_pname, AVG(io_price)
FROM tbl_iolist
WHERE io_inout = '매입'
GROUP BY io_pname 
ORDER BY io_pname;

/*
SELECT io_pname, 
    AVG(DECODE(io_inout, '매입', io_price)) AS '매입단가',
    AVG(DECODE(io_inout, '매출', io_price)) AS '매출단가'    
FROM tbl_iolist
GROUP BY io_pname
ORDER BY io_pname;
*/
-- 상품정보에 대한 리스트 확보
SELECT io_pname
FROM tbl_iolist
GROUP BY io_pname;

CREATE TABLE tbl_product(

    p_code	VARCHAR2(5)		PRIMARY KEY,
    p_name	nVARCHAR2(50)	NOT NULL,	
    p_iprice	NUMBER,		
    p_oprice	NUMBER,		
    p_vat	VARCHAR2(1)		

);
SELECT COUNT(*) FROM tbl_product;

-- 작성한 상품정보 테이블과 매입매출 테이블을 EQ JOIN 을 실행하여
-- 데이터가 정확히 작성되었는지 확인
-- 이 두 코드의 데이터 개수가 다르면 데이터가 잘 못 입력된것
SELECT COUNT(*)
FROM tbl_iolist, tbl_product
WHERE io_pname = p_name;

SELECT COUNT(*) FROM tbl_iolist;

-- 매입매출데이터에서 상품코드 칼럼을 추가
ALTER TABLE tbl_iolist
ADD io_pcode VARCHAR2(5);

-- 상품테이블에서 상품코드를 가져와서 
-- 매입매출데이터의 상품코드 칼럼에 UPDATE를 실행

-- == 매입매출 테이블(tbl_iolist) 전체를 펼쳐두고
-- 각 레코드에서 상품이름 io_pname을 추출하여
-- 상품테이블의 SELECT문으로 주입하고
-- 상품테이블에서 해당 상품이름으로 WHERE조건을 실행하여 나타나는 상품코드를
-- 매입매출 테이블의 상품코드 칼럼에 UPDATE를 실행하라
UPDATE tbl_iolist
SET io_pcode = 
(
    SELECT p_code FROM tbl_product
    WHERE io_pname = p_name
);

-- 상품코드가 정확히 업데이트 되었는지 확인
SELECT COUNT(*)
FROM tbl_iolist, tbl_product
WHERE io_pcode = p_code;

-- 매입매출테이블에서 상품이름 칼럼을 제거
ALTER TABLE tbl_iolist DROP COLUMN io_pname;

SELECT *
FROM tbl_iolist, tbl_product
WHERE io_pcode = p_code;

-- 회사가 중복으로 있는지 확인하기 위한 코드
SELECT io_dname, COUNT(*)
FROM tbl_iolist
GROUP BY io_dname;

-- 거래처정보는 같은 이름의 거래처가 있을 수 있기 때문에
-- 거래처정보 테이블을 생성할때는
-- 거래처명과 대표이름을 함께 묶어서 정보를 추출해야한다.
SELECT io_dname, io_dceo,  COUNT(*)
FROM tbl_iolist
GROUP BY io_dname, io_dceo;

DROP TABLE tbl_iolist;

COMMIT;

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

SELECT * FROM tbl_iolist;

-- 엑셀에서 전화번호 생성 = "010" & "-" & TEXT(RNADBETWEEN("1000","9999") & "-" & 

-- 거래처정보 테이블 생성
CREATE TABLE tbl_dept(

    d_code	VARCHAR2(5)		PRIMARY KEY,
    d_name	nVARCHAR2(50)	NOT NULL,	
    d_ceo	nVARCHAR2(50)	NOT NULL,	
    d_tel	VARCHAR2(20),		
    d_addr	nVARCHAR2(125)		
);

SELECT COUNT(*) FROM tbl_dept;

ALTER TABLE tbl_iolist
ADD io_dcode VARCHAR2(5);

DESC tbl_iolist;

-- 거래처정보 테이블과 매입매출정보 테이블 EQ JOIN을 실행해서
-- 거래처정보가 정확히 생성됐는지 확인
SELECT COUNT (*) 
FROM tbl_iolist, tbl_dept
WHERE io_dname = d_name And io_dceo = d_ceo ;

SELECT COUNT(*) FROM tbl_iolist;

-- 매입매출테이블에 거래처 코드를 UPDATE 하는 작업
UPDATE tbl_iolist
SET io_dcode =
    (
    -- subQ에서는 반드시 1개의 레코드만 추출 되도록 WHERE조건이 성립되어야 한다.
    -- 하지만 거래처정보(io_dname, d_name)에 중복이 있으므로
    -- 중복을 제거하기 위해 ceo까지 조건으로 걸어줌
        SELECT d_code
        FROM tbl_dept
        WHERE io_dname = d_name AND io_dceo = d_ceo
);        

SELECT COUNT(*)
FROM tbl_iolist, tbl_dept
WHERE io_dcode = d_code;

SELECT *
FROM tbl_iolist, tbl_dept
WHERE io_dcode = d_code;

-- 칼럼이름에 중복이 있으면 JOIN이 불가능하므로 이럴때는 테이블에 Alias를 지정해주면
-- 오류를 해결할 수 있다.

ALTER TABLE tbl_iolist DROP COLUMN io_dname;
ALTER TABLE tbl_iolist DROP COLUMN io_dceo;

SELECT * FROM tbl_iolist;

DROP VIEW view_iolist;

CREATE VIEW view_iolist
AS
(
SELECT
    IO.IO_SEQ,
    IO.IO_DATE,
    IO.IO_INOUT,
    IO.IO_DCODE,
  
    D.D_NAME AS IO_NAME,
    D.D_CEO AS IO_DCEO,
    D.D_TEL AS IO_DTEL,
    D.D_ADDR AS IO_DADDR,
    
    IO.IO_PCODE,
         
    P.P_NAME AS IO_PNAME,
    P.P_IPRICE AS IO_IPRICE,
    P.P_OPRICE AS IO_OPRICE,
    P.P_VAT AS IO_PVAT,
    

    IO.IO_QTY,
    IO.IO_PRICE,
    IO.IO_TOTAL
    
FROM tbl_iolist IO
   LEFT JOIN tbl_product P
        ON IO.io_pcode = P.p_code
    LEFT JOIN tbl_dept D
        ON IO.io_dcode = D.d_code
 
)   ; 

SELECT * FROM view_iolist;

SELECT *
FROM view_iolist
ORDER BY io_date;
















