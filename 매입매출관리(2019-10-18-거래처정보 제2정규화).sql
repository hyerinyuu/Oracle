-- IOLIST 화면
-- 여기서는 거래처정보 제2정규화 수행

-- 매입매출정보의 거래처정보에는 거래처명과 대표자 두개의 칼럼이 있음
-- 거래처명이 같은데 대표가 다른 거래처가 있을수 있기 때문에

-- 매입매출에서 거래처 정보 추출하기
SELECT io_dname, io_dceo
FROM tbl_ioList
GROUP BY io_dname, io_dceo
ORDER BY io_dname;

-- 거래처 테이블 생성
-- 거래처 테이블일 경우
-- 거래처 명이 같고, 대표자 명이 다른 테이터를 UNIQUE로 설정
-- 데이터를 입력할 때 거래처명과 대표자명이 동시에 같은 데이터는 INSERT되지 않도록 설정
CREATE TABLE tbl_dept (
    d_code	VARCHAR2(5)		PRIMARY KEY,
    d_name	nVARCHAR2(50)	NOT NULL,	
    d_ceo	nVARCHAR2(50)	NOT NULL,	
    d_tel	VARCHAR2(20),		
    d_addr	nVARCHAR2(125),		
    d_man	nVARCHAR2(50),
    CONSTRAINT UQ_name_ceo UNIQUE (d_name, d_ceo)
);
-- 테이블에 생성후에 추가할 경우
ALTER TABLE tbl_dept ADD CONSTRAINT UQ_name_ceo UNIQUE (d_name, d_ceo) ;

SELECT COUNT(*) FROM tbl_dept ;

-- 거래처테이블 생성하고 테이블 데이터를 조회해보기
-- 거래처명이 같고 CEO가 다른 거래처가 있는지 확인해보기 = 같은 거래처명이 있는지 확인하겠다
SELECT d_name,COUNT(*), COUNT(d_name)  -- d_name    count   count(d_name)
FROM tbl_dept                          -- 우리냉동	 2	        2
GROUP BY d_name;

-- d name의 COUNT가 2 이상인 데이터를 보여주는 코드
SELECT d_name,COUNT(*), COUNT(d_name) 
FROM tbl_dept                        
GROUP BY d_name
HAVING COUNT(*) > 1;


-- iolist와 dept테이블을 eqjoin해서 dept데이터가 잘 만들어졌는지 검증 
SELECT COUNT(*)
FROM tbl_iolist, tbl_dept
WHERE io_dname = d_name;  -- 497개


SELECT COUNT(*)
FROM tbl_iolist, tbl_dept
WHERE io_dname = d_name AND io_dceo = d_ceo;  -- 491개(거래처명에 중복이 있어서 개수 차이남)

ALTER TABLE tbl_ioList ADD io_dcode VARCHAR2(5);

UPDATE tbl_iolist
SET io_dcode = 
(
    SELECT d_code
    FROM tbl_dept
    WHERE io_dname = d_name AND io_dceo = d_ceo
);

-- UPDATE후 검증
SELECT COUNT(*)
FROM tbl_ioList, tbl_dept
WHERE io_dcode = d_code;

SELECT * FROM tbl_ioList;  -- io_dcode칼럼에 값이 채워진 걸 확인할 수 있음

-- ioList에서 io_dname, i_dceo칼럼을 삭제
ALTER TABLE tbl_ioList 
DROP COLUMN io_dname;
ALTER TABLE tbl_ioList 
DROP COLUMN io_dceo;

SELECT * FROM tbl_ioList;

/*
ioList를 제2정규화 수행해서 상품정보와 거래처정보를 table분리 완성
ioL
ioList의 단가(io_price) 칼럼을 삭제하지 않고 유지 하고있는 이유 : 
ioList의 매입, 매출단가는 실제로 상품이 매입, 매출되는 시점에 변동이 있을 수 있다.
        기준수량, 입출할때와 권장수량 입출할 때 밀어내기 입출 할때는 단가가 달리 적용된다.
        ex) 기준단가(100개) : 1000, 권장수량(1000개) : 900, 밀어내기단가(5000개) : 700,
        ioList에는 실질적인 입출단가가 기록되어서 결산수행의 기준값으로 삼는다. == 실질적 결산내용
        
        회계상 재고, 이익금을 계산할때는 
        매입매출이 변동된 단가로 계산을 하게되면 상당히 어려운 연산들이 필요함
        그래서 회계사 계산을 할 때 사용할 표준단가를 product에 저장해 두고, 사용한다.
*/
SELECT * 
FROM tbl_ioList IO
    LEFT JOIN tbl_product P
        ON IO.io_pcode = P.p_code
    LEFT JOIN tbl_dept D
        ON IO.io_dcode = D.d_code
ORDER BY IO.io_date, IO.io_pcode ;        


CREATE VIEW VIEW_IOLIST
AS
(
    SELECT 
        IO_SEQ AS SEQ,
        IO_DATE AS IODATE, -- DATE키워드 사용금지!!(DATE앞에는 뭐 붙여서 사용하기)
        IO_INOUT AS INOUT,
        IO_DCODE AS DCODE,
        D_NAME AS DNAME,
        D_CEO AS DCEO,
        D_TEL AS DTEL,
        IO_PCODE AS PCODE,
        P_NAME AS PNAME,
        IO_QTY AS QTY,
        P_IPRICE AS IPRICE,
        P_OPRICE AS OPRICE,
        IO_PRICE AS PRICE,
        IO_AMT AS AMT
       
FROM tbl_ioList IO
    LEFT JOIN tbl_product P
        ON IO.io_pcode = P.p_code
    LEFT JOIN tbl_dept D
        ON IO.io_dcode = D.d_code
);        

-- 매입과 매출 구분해서
SELECT DECODE(INOUT, '1','매입','2','매출'),  -- inout은 NUMBER형이지만 1/2를 문자열형이나 숫자형으로 입력해도 둘다 인식 가능
    DCODE, DNAME, DCEO,
    PCODE, PNAME,
    QTY, PRICE, AMT
FROM view_iolist;


-- 거래처별 매입, 매출의 합계
-- 보고자 하는 VIEW
-- 거래처별로 흩어져있는 거래내역을 모아서
-- 매입합계, 매출합계를 보고싶다.
-- 1. DECODE를 사용해서 INOUT 칼럼값을 기주으로 매입, 매출구분을 실행
-- 2. 매입과 매출 구분된 항목을 SUM()으로 묶어주기
-- 3. SUM() 묶이지 않은  DCODE, DNAME칼럼을 GROUP BY 절에 나열
SELECT DCODE, DNAME,
    SUM(DECODE(INOUT,1,AMT,0)) AS 매입합계,
    SUM(DECODE(INOUT,2,AMT,0)) AS 매출합계
FROM view_iolist
GROUP BY DCODE, DNAME
ORDER BY DCODE;

-- 월별로 매입매출합계를 계산
-- 1. 거래일자 칼럼에서 년,월만 추출
-- 2. DECODE를 사용해서 INOUT에 따라 매입/매출 구분
-- 3. 합계니까 SUM()으로 묶기
-- 4. 월별 추출 계산식을 GROUP BY에 지정
SELECT SUBSTR(IODATE,0,7) AS 월,  -- SUBSTR(칼럼,시작,개수)
       SUM(DECODE(INOUT,1,AMT)) AS 매입합계,
       SUM(DECODE(INOUT,2,AMT)) AS 매출합계
FROM view_iolist
GROUP BY SUBSTR(IODATE,0,7)
ORDER BY SUBSTR(IODATE,0,7);

-- [PIVOT방식]
SELECT SUBSTR(IODATE,0,7) AS 월,  -- SUBSTR(칼럼,시작,개수)
-- TO_CHAR(오라클전용) : SQL에서 일반적으로 보기용으로는 사용을 하되,
-- 다른언어와 연동되는 부분에서는 가급적 사용을 자제
-- 왜냐면 숫자 -> 문자열화 해서 계산할 때 어려움이 있을 수 있음(숫자형이 아닌 문자열형이니까)
       TO_CHAR(SUM(DECODE(INOUT,1,AMT)),'999,999,999') AS 매입합계, -- '999,999~~' => 출력포맷형식, 실제 표시되는 값보다 
       TO_CHAR(SUM(DECODE(INOUT,2,AMT)),'999,999,999') AS 매출합계  --충분히 큰 자릿수를 지정해줘야 함.
--  만약 위 코드를 '999,999'만 지정해주면 자릿수가 부족해 숫자가 아닌 특정 문자를 표시해버림(EX : ########)
FROM view_iolist
GROUP BY SUBSTR(IODATE,0,7)
ORDER BY SUBSTR(IODATE,0,7);

-- 전체리스트를 모두 PIVOT방식으로 보기
-- SEQ가 PK이므로 SUM으로 묶지 않아도 매입/매출 나옴
SELECT SEQ, IODATE, DNAME, PNAME,
    DECODE(INOUT,1,AMT) AS 매입,
    DECODE(INOUT,2,AMT) AS 매출
FROM view_iolist;

-- 2018년 1년동안 총 매입합계, 총 매출합계
SELECT SUM(DECODE(INOUT,1,AMT,0)) AS 총매입합계,
       SUM(DECODE(INOUT,2,AMT,0)) AS 총매출합계
FROM view_iolist
-- 날짜칼럼의 자릿수가 일정하기때문에 BETWEEN 사용가능
-- 저장된 실제 데이터의 길이가 모두 같은 경우, BETWEEN 키워드를 사용하여 범위 검색이 가능
WHERE IODATE BETWEEN '2018-01-01' AND '2018-12-31';
        
SELECT SUM(DECODE(INOUT,1,AMT,0)) AS 총매입합계,
       SUM(DECODE(INOUT,2,AMT,0)) AS 총매출합계
FROM view_iolist
WHERE IODATE LIKE '2018%'; -- LIKE를 사용해도 같은 결과가 출력되지만 
--                            BETWEEN코드는 데이터가 잘못 입력됐을 경우 출력이 안되기 때문에 검증이 가능하므로
--                            BETWEEN코드가 더 좋은 코드라고 볼 수 있음

-- 상품정보에 저장된 매입매출단가와
-- ioList에 저장된 매입매출단가의 차이를 확인해보기
SELECT IPRICE, OPRICE, 
       DECODE(INOUT,1,PRICE,0) 매입,
       DECODE(INOUT,2,PRICE,0) 매출
FROM view_ioList;

-- 상품정보와 매입매출 테이블의 입출단가의 차액을 계산해보는 SQL
SELECT 
       PCODE, PNAME, 
       IPRICE, 
       DECODE(INOUT,1,PRICE,0) 매입,
       
       DECODE(INOUT,1,IPRICE,0)
       - DECODE(INOUT,1,PRICE,0) AS 매입차액,
       
       OPRICE, 
       DECODE(INOUT,2,PRICE,0) 매출,
       DECODE(INOUT,2,OPRICE,0) 
       - DECODE(INOUT,2,PRICE,0) AS 매출차액
       
FROM view_ioList;

-- SEQ 자동생성 코드
