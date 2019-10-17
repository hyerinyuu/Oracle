-- 매입매출관리 [ 상품정보 제 2 정규화]

--  매입매출정보에 상품정보가 어떻게 저장되어 있는지 확인
SELECT io_pname
FROM tbl_iolist
GROUP BY io_pname
ORDER BY io_pname;


-- 상품테이블 생성
CREATE TABLE tbl_product (

    p_code	VARCHAR2(6)	NOT NULL	PRIMARY KEY,
    p_name	nVARCHAR2(50)	NOT NULL,	
    p_iprice	NUMBER,		
    p_oprice	NUMBER		

);

SELECT * FROM tbl_product ;

-- 상품정보테이블이 잘 만들어졌는지 확인하기 위해
-- tbl_iolist와 tbl_product를 EQ JOIN해서 조회
SELECT io_inout, COUNT(*)
FROM tbl_iolist IO, tbl_product P
WHERE IO.io_pname = P.p_name
GROUP BY io_inout ;

-- 상품정보테이블의 단가를 어떻게 세팅을 할 것인가 고민(상품이 같아도 거래처 별로 단가가 달라서)

-- 상품들의 매입단가를 확인
SELECT io_inout, IO.io_pname, IO.io_price
FROM tbl_iolist IO, tbl_product P
WHERE IO.io_pname = P.p_name
    AND IO.io_inout = 1;


-- 상품 이름이 같은데 단가가 다른게 있느냐
SELECT io_inout, IO.io_pname, IO.io_price, COUNT(*)
FROM tbl_iolist IO, tbl_product P
WHERE IO.io_pname = P.p_name
    AND IO.io_inout = 1
GROUP BY io_inout, IO.io_pname, IO.io_price;

-- 매입미출테이블에서 매입단가를 조회해봤더니
-- 상품이름이 같은데 단가가 다른 상품이 있다.(오라떼)
-- 그래서 매입매출테이블에서 매입단가를 상품정보테이블의 매입단가칼럼에 세팅하려고함.



-- 이코드는 오류가 남
--(왜냐하면 상품명이 중복으로 존재하기 때문에 SUBQ의 값이 한개를 초과해서 
--   single-row subquery returns more than one row)
UPDATE tbl_product P
SET P.p_iprice 
= ( SELECT IO.io_price FROM tbl_iolist IO
    -- 매입(=1) 만 우선 가져오기 위해서
    WHERE io_inout = 1 AND 
    P.p_name = IO.io_pname 
    );
    

UPDATE tbl_product P
SET P.p_iprice 
= ( SELECT MAX(IO.io_price) FROM tbl_iolist IO
    WHERE IO.io_inout = 1 AND
    P.p_name = IO.io_pname 
    );

UPDATE tbl_product P
SET P.p_oprice 
= ( SELECT MAX(IO.io_price) FROM tbl_iolist IO
    WHERE IO.io_inout = 2 AND
    P.p_name = IO.io_pname 
    );

SELECT * FROM tbl_product ;

-- 상품거래정보에서 상품매입, 매출단가를 생성을 했더니
-- null인 값이 있다.
-- 어떤 상품은 매입만 되고, 어떤 상품은 매출만 된 경우(동시에 이루어지지 않음)

/*
    1. 매입단가에서 매출단가 생성하기
    (공산품의 경우) 매입단가의 약 18%를 더해서 매출단가를 계산 = + vat10% = 매출단가 
        매출단가 = ( 매입단가 + (매입단가 * 0.18)) * 1.1
        
    매출단가에서 매입단가 생성하기
    매출단가에서 부가세를 제외하고, 그 검액에서 18%를 빼서 매입단가를 계산
    매입단가 = (매출단가 / 1.1) - ((매출단가 / 1.1) * 0.18) == (매출단가 / 1.1) * 0.82
*/

UPDATE tbl_product
SET p_iprice = 
    (p_oprice / 1.1) * 0.82
WHERE p_iprice IS NULL ;


UPDATE tbl_product
SET p_oprice = 
    (p_iprice + (p_iprice * 0.18)) * 1.1
WHERE p_oprice IS NULL ;

ROLLBACK;


SELECT * FROM tbl_product ;


UPDATE tbl_product
SET p_iprice = ROUND(p_iprice,0),
    p_oprice = ROUND(p_oprice,0) ;

COMMIT;



