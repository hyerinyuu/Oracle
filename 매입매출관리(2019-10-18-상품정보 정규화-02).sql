-- IOLIST 사용자 화면
SELECT * FROM tbl_product;

--tbl_product의 판매가격의 1원단위 제거하고 0으로 세팅 ==> ROUND(판매가격 / 10,0) *10 
-- ※한개 이상의 데이터를 대상으로 UPDATE, DELETE를 수행할 때에는 항상 신중하게 코드를 검토해야함※
UPDATE tbl_product
SET p_oprice = ROUND(p_oprice /10,0) * 10 ;

-- 매입매출장과 상품정보를 테이블 JOIN하기 위해
-- 1. 매입매출장에 상품코드 칼럼을 추가하고
-- 2. 상품이름과 연결된 상품코드로 업데이트 하고
-- 3. 상품이름 칼럼 제거

-- 1. 매입매출장에 상품코드 칼럼 추가
ALTER TABLE tbl_ioList ADD io_pcode VARCHAR2(6);

-- 2. 매입매출장의 상품코드 칼럼을 업데이트
-- 서브쿼리를 사용해서
-- UPDATE 실행시 유의사항 : UPDATE를 수행하는 SUBQ에는 SELECT Projection에는
--                          칼럼을 한개만 사용해야 한다. 
--                          SUBQ에서 나타나는 레코드수도 반드시 한개만 나타나야한다.   

-- 매입매출테이블 리스트를 나열하고
-- 각 요소의 상품이름을 SUBQ로 전달
-- SUBQ에서는 상품테이블로부터 상품이름을 조회하여 일치하는 레코드가 1개 나타나면 
-- 해당레코드의 상품코드 칼럼의 값을 매입매출칼럼의 상품코드칼럼에 업데이트하라
UPDATE tbl_ioList IO 
SET io_pcode =
(
    SELECT p_code
    FROM tbl_product P
    WHERE IO.io_pname = P.p_name

);

-- UPDATE후에 검증
-- ioList와 product 테이블을 EQJOIN을 수행해서 누락 데이터가 없는지 확인
-- ※ 테이블 JOIN을 하면서 Table Alias를 설정하지 않고  Join 조건등을 사용함
-- join되는 Table들의 join조건에 사용되는 칼럼중 같은 이름의 칼럼이 없을 경우 가능함 ※
SELECT *
FROM tbl_ioList, tbl_product
WHERE io_pcode = p_code ;

-- 매입매출 테이블에서 상품이름 칼럼을 제거
ALTER TABLE tbl_ioList 
DROP COLUMN io_pname;

-- (ALTER를 수행했기 때문에 앞의 UPDATE문 자동 COMMIT)
/*
    오라클에서 INSERT, UPDATE, DELETE를 수행한 직후에는
    아직 데이터가 COMMIT되자 않아 실제 물리적 테이블이 저장되지 않은 상태이다
    이때는 ROLLBACK을 수행해서 CUD를 취소할 수 있다.
    
    단, DDL명령(CREATE, ALTER, DROP) 명령을 수행하면 자동 COMMIT이 된다.(취소는 가능)
    
    대량의 INSERT, UPDQTE, DELETE를 수행한 후
    데이터 검증이 완료 되면 가급적 COMMIT을 수행하고 다음으로 진행하자
       
*/

-- 오라클에서는 COMMIT과 ROLLBACK도 시점을 시정해서 어디까지 ROLLBACK을 할것인지 지정하는 기능도 있음(구글참조)

SELECT COUNT(*) 
FROM tbl_ioList, tbl_product
WHERE io_pcode = p_code;

