-- iolist 화면

-- 매입매출장 TABLE 생성

CREATE TABLE tbl_iolist(

    io_seq	NUMBER	NOT NULL	PRIMARY KEY,
    io_date	VARCHAR2(10)	NOT NULL,	
    io_pname	nVARCHAR2(50)	NOT NULL,	
    io_dname	nVARCHAR2(50)	NOT NULL,	
    io_dceo	nVARCHAR2(50),		
    io_inout	NUMBER(1)	NOT NULL,	
    io_qty	NUMBER	NOT NULL,	
    io_price	NUMBER,		
    io_amt	NUMBER		
);

SELECT io_inout, COUNT(*) FROM tbl_iolist
GROUP BY io_inout ;

SELECT DECODE(io_inout, 1, '매입','매출') AS 구분,
    COUNT(*)
FROM tbl_iolist
GROUP BY  DECODE(io_inout, 1, '매입','매출') ;



SELECT DECODE(io_inout, 1, '매입', 2,'매출') AS 구분,
    COUNT(*)
FROM tbl_iolist
GROUP BY  DECODE(io_inout, 1, '매입', 2,'매출') ;



/*

IF(칼럼 == 값) {
    T표시
}else if( 칼럼 == 값2 ){
    T표시2
}

// 한 칼럼에 값이 여러개 일 경우 다중 조건으로 처리하고자 할 때
// 다른 SW에서는 이렇게 코드를 짜야하지만
DECODE(칼럼, 값1,T결과, DECODE(칼럼, 값2, T결과2, DECODE(칼럼, 값3, T결과3)))


// 오라클에서는 이렇게만 짜도 됨
DECODE(칼럼,값1,T결과1, 칼럼,값2,T결과2, 칼럼,값3,T결과3)

*/

-- ex)
-- 이 두코드의 결과는 동일함
SELECT DECODE(io_inout, 1, '매입',
        DECODE(io_inout, 2, '매출'))
FROM tbl_iolist;

SELECT DECODE(io_inout, 1, '매입', 2, '매출')
FROM tbl_iolist;


SELECT DECODE(io_inout, 1, '매입', 2, '매출'),
        SUM(DECODE(io_inout,1,io_amt,0)) AS 매입합계,
        SUM(DECODE(io_inout,2,io_amt,0)) AS 매출합계
FROM tbl_iolist
GROUP BY DECODE (io_inout, 1, '매입', 2, '매출') ;


-- PIVOT방식으로 표현
SELECT  SUM(DECODE(io_inout,1,io_amt,0)) AS 매입합계,
        SUM(DECODE(io_inout,2,io_amt,0)) AS 매출합계
FROM tbl_iolist ;

-- 날짜별 매입 매출 합계
SELECT io_date, SUM(DECODE(io_inout,1,io_amt,0)) AS 매입합계,
                SUM(DECODE(io_inout,2,io_amt,0)) AS 매출합계
FROM tbl_iolist 
GROUP BY io_date;

-- LEFT(io_date,7) AS 월 : 표준 SQL // 왼쪽부터 문자열 자르기
-- RIGHT : 오른쪽부터 문자열 자르기
-- MID(문자열, 시작, 개수) : 중간 문자열 자르기
SELECT SUBSTR(io_date,0,7) AS 월,
        SUM(DECODE(io_inout,1,io_amt,0)) AS 매입합계,
        SUM(DECODE(io_inout,2,io_amt,0)) AS 매출합계
FROM tbl_iolist 
GROUP BY SUBSTR(io_date,0,7);

SELECT SUBSTR(io_date,0,7) AS 월,
        SUM(DECODE(io_inout,1,io_amt,0)) AS 매입합계,
        SUM(DECODE(io_inout,2,io_amt,0)) AS 매출합계
FROM tbl_iolist 
GROUP BY SUBSTR(io_date,0,7)
ORDER BY SUBSTR(io_date,0,7) ;

-- 회계상으로 생각하지 않고 단순계산(월별로 매출 - 매입)만 해서 마진을 보여줌
SELECT SUBSTR(io_date,0,7) AS 월,
        SUM(DECODE(io_inout,1,io_amt,0)) AS 매입합계,
        SUM(DECODE(io_inout,2,io_amt,0)) AS 매출합계,
        
    SUM(DECODE(io_inout,2,io_amt,0)) -
    SUM(DECODE(io_inout,1,io_amt,0)) AS 마진
FROM tbl_iolist 
GROUP BY SUBSTR(io_date,0,7)
ORDER BY SUBSTR(io_date,0,7) ;


-- 매입매출데이터.exel 파일을 확인하면 상품명 칼럼과 거래처 칼럼에 중복값이 존재하기 때문에
-- 상품명과 거래처 칼럼을 제 2 정규화 할 예정







