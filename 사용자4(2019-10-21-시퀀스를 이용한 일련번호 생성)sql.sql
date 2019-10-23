-- user4 화면
/*
새로운 table생성
이름 : tbl_books
칼럼 : 코드 : b_code VARCHAR(4)
       이름 : b_name VARCHAR(50)
       출판사 : b_comp VARCHAR(50)
       저자 : b_writer VARCHAR(20)
       가격 : b_price INT
*/

/*

--      [TABLE  생성 조건]
-- 95년 이전 출판 도서들에는 ISBN이 없는 경우도 있어서
-- ISBN과 별도로 우리가 자체적으로 생산한 코드를  PK로 잡을 예정
-- 따라서 CODE를 VARCHAR2가 아닌 NUMBERE로 설정하고

[요구조건]
1. 입력 순서대로 번호를 부여할 예정

2. 기존에 입력된 번호와 다른 번호를 사용해 데이터를 입력할 것

3. 데이터를 입력할 때 일련번호를 기억하기 싫다.
항상 새로운 번호로 일련번호를 생성하여 데이터를 추가할 수 있도록 할 것.

4. b_price는 숫자값인데 값이 없이 추가가 되면 null 형태가 된다.
이럴 경우 프로그래밍 언어에서 데이터를 가져다 사용할 때 문제를 일으킬 수 있으므로
b_price에 값이 없이 데이터가 추가되면 자동으로 0을 채우도록 할 것
*/
CREATE TABLE tbl_books (

-- TABLE생성시 PK를 !!꼭!! 고려하기
    b_code NUMBER PRIMARY KEY,
    b_name nVARCHAR2(50) NOT NULL,
    b_comp nVARCHAR2(50),
    b_writer nVARCHAR2(50),
    b_price NUMBER DEFAULT 0 -- INSERT 수행할 때 값이 없으면 0으로 세팅해라

);

INSERT INTO tbl_books(b_code, b_name, b_comp, b_writer)
VALUES(1,'자바입문','이지퍼블','박은종');

SELECT * FROM tbl_books;

/*
테이블의 칼럼순서가 정확하다는 보장이 있고,
모든 칼럼에 데이터가 있다 라는 보장이 있을때는
INSERT 명령문에 칼럼을 나열하지 않아도(projection)하지 않아도 데이터만 정확히 나열하여
명령 수행이 가능하다.

하지만 가급적 사용을 자제하자
*/
-- 칼럼명을 나열 안함(가급적 사용하지 마시오)
INSERT INTO tbl_books
VALUES (2,'오라클','생능','서진수',35000);

/*
        [데이터를 추가할 때마다 b_code칼럼의 값을 새로 생성하고 싶다]
        
    1. Random() 사용
-- 숫자가 일련번호가 아닌 뒤죽박죽된 순서로 나타나고
-- 컴퓨터의 RANDOM값은 완전한 RANDOM이 아니기 때문에 간혹 중복값이 나타날 수 있다.
-- 일련번호를 PK로 설정할 경우
        일반적인 경우에 일련번호는 데이터가 추가된 순서가 되지만
        RANDOM을 사용한다면 숫자가 무작위로 나오기 때문에 그러한 조건을 사용할 수 없다.


    2. 일련 번호를 순서대로 자동으로 생성하도록 칼럼을 설정하기
-- mysql이나 mssql등등 에서는 AUTO INCREMENT라는 옵션을 칼럼에 부여하는 방법이 있다.(오라클은 12 이상에서만 가능)
*/

INSERT INTO tbl_books(b_code, b_name)
VALUES (ROUND(DBMS_RANDOM.VALUE(1000000000,9999999999),0),'연습도서');

SELECT * FROM tbl_books;

/*
SEQUENCE 객체(Object)를 사용하여 만드는 방법
오라클의 AUTO IMPLEMENT 기능을 대체하는 방법
*/

CREATE SEQUENCE SEQ_BOOKS
START WITH 1 INCREMENT BY 1; -- 1부터 1씩 증가하는 형태로 숫자값을 생성하는 시퀀스 객체를 생성하라

-- [SEQUENCE 사용법]
SELECT SEQ_BOOKS.NEXTVAL FROM DUAL; -- NEXTVAL칼럼의 값이 실행시마다 1씩 증가해서 표시됨

-- 오라클에서 가장 많이 사용하는 일련번호 부여방법
INSERT INTO tbl_books(b_code, b_name)
VALUES(SEQ_BOOKS.NEXTVAL,'시퀀스연습');

SELECT * FROM tbl_books;

-- 기존에 생성된 테이블에 SEQ를 적용하기
/*
매입매출에서 tbl_iolist에 데이터를 추가하면서
엑셀로 데이터를 정리하고
SEQ칼럼을 만든 다음, 일련번호를 추가해두었다.
이제 새로 만든 APP에서 데이터를 추가할 때 SEQUENCE를 사용하고자 한다.

1. 기존데이터의 SEQ칼럼의 최대값이 얼마인지 확인 : 589
2. 새로운 시퀀스를 생성할 때 START WITH : 600으로 설절
*/
CREATE SEQUENCE SEQ_IOLIST
START WITH 1 INCREMENT BY 1;
-- 만약 START WITH 1으로 잘못 입력하면 시퀀스를 600번 실행해야함
/*
만약 실수로 시퀀스 시작값을 잘 못 설정했을 경우
*/
ALTER SEQUENCE SEQ_IOLIST START WITH 600; -- 시작값 변경이 안됨

-- 이럴경우 편법을 사용해서 

-- 증가값을 최대값보다 큰값으로 일단 설정(NEXTVAL : 600)
ALTER SEQUENCE SEQ_IOLIST INCREMENT BY 600; 
-- NEXTVAL을 호출하여 현재 값을 변경해주고(NEXTVAL : 601)
SELECT SEQ_IOLIST.NEXTVAL FROM DUAL;

-- 다시 증가값을 600->1로 설정
ALTER SEQUENCE SEQ_IOLIST INCREMENT BY 1;

SELECT SEQ_IOLIST.NEXTVAL FROM DUAL;  

-- 쉬운방법 : SEQUENCE DROP
DROP SEQUENCE SEQ_IOLIST ;
CREATE SEQUENCE SEQ_IOLIST
START WITH 1000 INCREMENT BY 1;


SELECT SEQ_IOLIST.NEXTBAL FROM DUAL;


-- 현재 SEQ_IOLIST 값을 보여주는 코드
-- 간혹 현재 SEQ_IOLIST의 실제값이 아닌 값을 알려주는 경우도 있음
SELECT SEQ_IOLIST.CURRVAL FROM DUAL;

/*
TABLE에 특정할 수 있는 PK가 있는 경우는
해당하는 값을 INSERT를 수행하면서 입력하는 것이 좋고

그렇지 못한 경우는 SEQUENCE를 사용하여 일련번호 형식으로 지정하자
*/

/*
도서 코드를 B0001형식으로 일련번호를 만들고 싶다.
이 방식은 ORACLE 이외의 다른 DBMS에서는 사용이 상당히 복잡하다.
*/

DROP TABLE tbl_books;

CREATE TABLE tbl_books (

    b_code VARCHAR2(5) PRIMARY KEY,
    b_name nVARCHAR2(50) NOT NULL,
    b_comp nVARCHAR2(50),
    b_writer nVARCHAR2(50),
    b_price NUMBER DEFAULT 0 

);

SELECT 'B' || TRIM(TO_CHAR(SEQ_BOOKS.NEXTVAL,'0000')), FROM DUAL ;
-- b_code :  B0001 부터 1씩 증가하는 형태로 생성하기
INSERT INTO tbl_books(b_code, b_name)
VALUES ('B' || TRIM(TO_CHAR(SEQ_BOOKS.NEXTVAL,'0000')), 'SEQ 연습') ;
-- TO_CHAR (값, 포맷형)
-- TO_CHAR(숫자, '0000') : 자릿수를 4개로 설정하고, 공백부분을 0으로 채워라
-- TO_CHAR(숫자, '9999') : 자릿수를 4자리로 설정하고, 남는 부분은 공백으로 둬라
-- || : 문자열 연결 기호 
-- TRIM : 문자열 앞뒤 공백 제거, 중간공백은 제거 불가
-- LTRIM(). RTRIM()


-- 오라클의 고정길이 문자열 생성(오라클 전용 함수)
/*
원래값이 숫자형일 경우
TO_CHAR(값, 포멧형)

원래값이 다양한 형일 경우
LPAD(값, 총길이, 채움문자)
*/
-- LPAD
-- 총길이를 10으로 하고
-- 공백(남는부분)은 *로 표시하여 문자열 생성
SELECT LPAD(30,10,'*') FROM DUAL;

-- RPAD
SELECT RPAD(30,10,'A') FROM DUAL;
-- LPAD를 이용해서 B0001형식으로 코드 출력
SELECT 'B' || LPAD(SEQ_BOOKS.NEXTVAL,4,'0') FROM DUAL;

/*
우리                
대한민국            
미연방합중국        
중화인민공화국      
*/
SELECT RPAD('우리',20,' ') FROM DUAL
UNION ALL SELECT RPAD('대한민국',20,' ') FROM DUAL
UNION ALL SELECT RPAD('미연방합중국',20,' ') FROM DUAL
UNION ALL SELECT RPAD('중화인민공화국',20,' ') FROM DUAL;

/*
               우리
            대한민국
        미연방합중국
      중화인민공화국
*/
SELECT LPAD('우리',20,' ') FROM DUAL                                                    
UNION ALL SELECT LPAD('대한민국',20,' ') FROM DUAL
UNION ALL SELECT LPAD('미연방합중국',20,' ') FROM DUAL
UNION ALL SELECT LPAD('중화인민공화국',20,' ') FROM DUAL;

SELECT * FROM tbl_books;

INSERT INTO tbl_books(b_code, b_name)
VALUES ('B' || TRIM(TO_CHAR(SEQ_BOOKS.NEXTVAL,'0000')), 'SEQ연습') ;

INSERT INTO tbl_books(b_code, b_name)
VALUES('B' || LPAD(SEQ_BOOKS.NEXTVAL, 4, '0'), 'SEQ연습2');