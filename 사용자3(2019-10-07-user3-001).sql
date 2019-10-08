-- 여기는 user3 화면입니다.

-- 도서정보를 저장하기 위한 TABLE 생성
CREATE TABLE tbl_books (

	b_isbn	VARCHAR(13)		PRIMARY KEY,
  	b_title	nVARCHAR2(50)	NOT NULL,	
    b_comp	nVARCHAR2(50)	NOT NULL,	
	b_writer	nVARCHAR2(50)	NOT NULL,	
	b_price	NUMBER(5),		
	b_year	VARCHAR2(10),	
	b_genre	VARCHAR2(3)

) ;

-- 도서정보 추가
INSERT INTO tbl_books( b_isbn, b_title, b_comp, b_writer, b_price)
VALUES('979-001', '오라클 프로그래밍', '생능출판사', '서진수', 30000) ;
		
INSERT INTO tbl_books( b_isbn, b_title, b_comp, b_writer, b_price)
VALUES('979-002', 'DO IT 자바', '이지퍼블리싱', '박은종', 25000) ;

INSERT INTO tbl_books( b_isbn, b_title, b_comp, b_writer, b_price)
VALUES('979-003', 'SQL 활용', '교육부', '교육부', 10000) ;

INSERT INTO tbl_books( b_isbn, b_title, b_comp, b_writer, b_price)
VALUES('979-004', '무궁화 꽃이 피었습니다', '새움', '김진명', 15000) ;

INSERT INTO tbl_books( b_isbn, b_title, b_comp, b_writer, b_price)
VALUES('979-005', '직지', '쌤앤파커스', '김진명', 12600) ;


-- 추가된 도서 전체목록 확인
SELECT * FROM tbl_books ;

-- ISBN 순서로 목록 확인
SELECT * FROM tbl_books ORDER BY b_isbn ;

DROP TABLE tbl_books ;

					
-- tbl_books 테이블을 생성을 하고 데이터를 추가하다가 보니
-- 가격 칼럼의 자릿수가 부족하여 10만원 이상의 데이터를 추가할 수 없다.
-- 데이터를 추가하기 전이라면 table을 삭제하고 생성하면 되겠지만
-- 이미 데이터가 추가되어 있는 상황에서 table을 삭제하면
-- 데이터가 모두 소실되기 때문에             
--                                          [table을 유지하면서 칼럼의 자릿수를 늘려보자]



--                          [DDL의 3대 키워드]
-- 생성 : CREATE
-- 삭제 : DROP
-- 변경(수정) : ALTER
-- 상황이 이미 생성된 table의 한 칼럼(b_price)의 자릿수를 늘리려고 한다.
ALTER TABLE tbl_books  -- tbl_books 테이블을 변경하겠다.
MODIFY(b_price NUMBER(7)); -- 칼럼의 타입 또는 자릿수를

-- 변경후 테스트
INSERT INTO tbl_books(b_isbn, b_title, b_comp, b_writer, b_price)
VALUES ('978-801', 'Effective JAVA', 'Addison', 'Joshua Bloch', 159000) ;

SELECT * FROM tbl_books;

-- 테이블을 처음 생성할 당시에 미처 생각지 못한 칼럼이 필요한 경우가 있다.
-- 이미 생성된 테이블에 새로운 칼럼을 추가하기
ALTER TABLE tbl_books
ADD(b_remark nVARCHAR2(125)); 

DESC tbl_books;

-- 기존의 칼럼을 삭제하는 명령(주의해서 사용해야함 / 실제 실무에서는 거의 사용 x)
ALTER TABLE tbl_books
DROP COLUMN b_remark ;

-- 칼럼의 이름을 변경하기
ALTER TABLE tbl_books
RENAME COLUMN b_remark TO b_rem ;



--                                 [ALTER TABLE 명령을 수행할 때 매우 주의해야할 사항]

-- 1. DRLP COLUMN
--      기존에 사용하던 TABLE 에서 칼럼을 삭제하면 저장된 데이터가 변형되어 문제가 발생할 수 있다.
--      오라클은 명령 수행전에 절대 경고하지 않는다

-- 2. MODIFIY COLUMN
--      칼럼의 타입을 변경하는 것으로 저장된 데이터가 변형될 수 있다.
--      가. 자릿수를 줄이면 : (보통)실행오류가 발생함
--                              => 그렇지 않은 경우 : 저장된 데이터의 일부가 잘릴 가능성 있음
--      나. 타입을 변경하면 : 기존 데이터 형식이 변경되면서 데이터가 손실, 소실 될 수 있다.
--                            특히 CHAR, VARCHAR2 사이에서 타입을 변경하면
--                            기존의 SQL(SELECT) 명령 결과가 전혀 엉뚱하게 나타나거나 데이터를 못 찾을 수 있음.

-- 3. RENAME COLUMN
--      칼럼의 이름을 변경하는 것은 데이터 변형이 잘 되지는 않지만
--      다른 SQL 명령문이나, 내장 프로시져, Java  프로그래밍에서 table에 접근하여
--      데이터를 CRUD(create, read ~~)를 실행할 때 문제가 발생할 수 있다.

-- 결론 : 보통 테이블을 생성하거나 칼럼을 추가한 후로는 필요 없더라도 다른 문제가 없으면
--        DROP MODIFY 등을 수행하지 말자 / 신중히 생각후에 수행하자




--                                             [사용자 비밀번호 변경하기]

-- 사용자 비밀번호는 보통 자신의 비밀번호를 변경하고,
-- (SYS)DBA 역할에서는 다른 USER의 비밀번호를 변경하기도 한다.
-- (사용하는 과정에서 비밀번호 변경이 필요한 경우가 있으니까 기억하기)
-- (이외에도 ALTER을 이용한 여러가지 TABLE 변경법이 있으나 내가 사용할 일이 얼마 없음)
ALTER USER user3 IDENTIFIED BY 1234;


CREATE TABLE tbl_genre (

    g_code	VARCHAR2(3)		PRIMARY KEY,
    g_name	nVARCHAR2(15)	NOT NULL,	
    g_remark	nVARCHAR2(125)		

) ;

INSERT INTO tbl_genre(g_code, g_name)
VALUES('001', '프로그래밍');

INSERT INTO tbl_genre(g_code, g_name)
VALUES('002', '데이터베이스');

INSERT INTO tbl_genre(g_code, g_name)
VALUES('003', '장편소설');

ALTER TABLE tbl_genre MODIFY(g_name nVARCHAR2(50));

SELECT * FROM tbl_genre ;

DESC tbl_books ;
ALTER TABLE tbl_books MODIFY (b_genre nVARCHAR2(10)) ;

-- 현재 tbl_books 테이블에 추가된 데이터들에 b_genre가 비어있는 상태이다.
-- 장르칼럼의 데이터를 채워넣기
SELECT * FROM tbl_books;

-- *************UPDATE를 실행할 때 2개이상의 레코드에 영향을 미치도록 명령을 수행하는 것은
-- 특별한 경우가 아니라면 지양해야함********************
-- UPDATE수행은 먼저 PK를 확인한 후 ****WHERE절에 PK조건을 설정해서 하자***
UPDATE tbl_books
SET b_genre = '데이터베이스'
WHERE b_isbn = '979-001';

UPDATE tbl_books
SET b_genre = '데이터베이스'
WHERE b_isbn = '979-003';

UPDATE tbl_books
SET b_genre = '장편소설'
WHERE b_isbn = '979-004';

SELECT * FROM tbl_books ;

UPDATE tbl_books
SET b_genre = '프로그래밍'
WHERE b_isbn = '979-002';

UPDATE tbl_books
SET b_genre = '장편소설'
WHERE b_isbn = '979-005';

UPDATE tbl_books
SET b_genre = '프로그래밍'
WHERE b_isbn = '978-801';

SELECT * FROM tbl_books ;

-- 장르별로 데이터를 조회
SELECT * FROM tbl_books
WHERE b_genre = '데이터베이스' ;

SELECT * FROM tbl_books
WHERE b_genre = '장편소설' ;

SELECT * FROM tbl_books ;

-- tbl_books의 데이터중에 장르가 장편소설인 데이터를 장르소설로 바꾸고 싶다.
-- 1. 썩 좋은 방법이 아님
UPDATE tbl_books
SET b_genre = '장르소설'
WHERE b_genre = '장편소설' ;

SELECT * FROM tbl_books;

INSERT INTO tbl_books(b_isbn, b_title, b_comp, b_writer, b_price, b_genre)
VALUES ('979-006', '황태자비 납치사건', '새움', '김진명', 25000, '장르소설');

SELECT * FROM tbl_books;

-- 장르소설만 리스트를 보고싶다
SELECT * FROM tbl_books
WHERE b_genre = '장르소설';


-- 도서정보 데이터를 저장하기 위해서 table을 만들고 많은 양의 도서정보를 여러사람이 입력하다 보니
-- 일부 데이터 입력과정에서 문제가 발생해 데이터를 조회할 때 문제가 발생하게 됨.
-- 특히 장르별로 데이터를 조회했더니 장르 이름은 같은데 일부 데이터가 조회되지 않는 현상을 발견함
-- 이러한 논리적 문제를 해결하기 위해서 '장르 테이블'을 하나 별도로 생성하고
--                      [books table의 '정규화' 과정을 통해 조회오류가 발생하지 않도록 해보기]

SELECT * FROM tbl_genre ;

-- 1. tbl_gooks 테이블의 장르 칼럼에 저장된 문자열을  ==>  tbl_genre 테이블에 있는 코드값으로 변경하기
SELECT * FROM tbl_books 
WHERE b_genre = '데이터베이스' ;

-- 가. 데이터베이스 장르 코드로 변경하기
UPDATE tbl_books
SET b_genre = '002' 
WHERE b_genre = '데이터베이스';

-- 나. 프로그래밍 장르 코드로 변경하기
UPDATE tbl_books
SET b_genre = '001'
WHERE b_genre = '프로그래밍';

-- 다. 장르소설을 장편소설 코드로 변경하기
UPDATE tbl_books
SET b_genre = '003'
WHERE b_genre = '장르소설' ;

SELECT * FROM tbl_books;
SELECT * FROM tbl_genre;

--                                              [테이블 JOIN]
-- (도서정보를 확인하면서 장르칼럼의 코드값 대신에 장르 이름으로 보는법)
-- 테이블 JOIN : 두개 이상의 테이블을 서로 연계해서 == Relation ship 하나의 리스트로 보여주는것 
SELECT * FROM tbl_books, tbl_genre
WHERE tbl_books.b_genre = tbl_genre.g_code ;

SELECT tbl_books.b_isbn, tbl_books.b_title, tbl_books.b_comp, tbl_books.b_writer, tbl_books.b_genre,
         -- tbl_genre.g_code, 
         tbl_genre.g_name
FROM tbl_books, tbl_genre
WHERE tbl_books.b_genre = tbl_genre.g_code ;

-- from 다음에 내가 필요한 칼럼들을 순서대로 나열하고 / where 다음에 조건을 붙임 / SELECT 다음에 내가 보고자 하는 칼럼 리스트 나열


--                                       [TABLE명에 Alias를 설정하는 방법]


SELECT B.b_isbn, B.b_title, B.b_comp, B.b_writer, B.b_genre,
         -- tbl_genre.g_code, 
         G.g_name
         
FROM tbl_books B, tbl_genre G  -- ANSI tbl_books AS B, tbl_genre AS G (원래 AS를 붙여야 하지만 오라클에서 AS붙이면 오류남)
-- ==> ************SELECT 명령문을 실행하면 FROM문이 가장 먼저 실행됨*********************
--     FROM문 다음에 테이블의 별명을 지어주고 
WHERE B.b_genre = G.g_code ;


INSERT INTO tbl_books(b_isbn, b_title, b_comp, b_writer, b_genre)
VALUES ('979-007', '자바의 정석', '도울출판', '남궁성', '004');
-- ==> tbl_genre table에는 004가 없음
-- 따라서 두 테이블의 JOIM을 실행한 line 250~257을 실행하면 b_isbn 979-007데이터가 누락되어 표시됨
-- 두 테이블의 JOIN은 두 테이블을 곱셈한 것과 같음(== tbl_books * tbl_genre)
-- 두 테이블에 연관된 데이터가 모두 있을때만 보여짐 EQ JOIN 또는 완전 JOIN이라고 함

SELECT * FROM tbl_books;

--                                  [테이블 JOIN시 주의사항]
SELECT *
FROM [table1], [table2]
WHERE table1.COLUMN = table2.COLUMN;
-- 이러한 JOIN을 완전 JOIN 또는 EQ JOIN이라고 하며
-- 결과를 카티션곱 이라고 표현한다.
-- TABLE1과 TABLE2를 RELATION할 때
-- 서로 연결하는 칼럼의 값이 두 테이블에 *모두* 존재할 때 정상적인 결과를 낼 수 있다.





