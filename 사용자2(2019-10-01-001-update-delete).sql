-- 여기는 user2 화면입니다.
-- 오늘은 CRUD 명령 중 UPDATE, DELETE명령을 배울것임


-- 새로운 사용자가 사용할 Table 생성
-- 주소록테이블을 생성
-- 주소록 기본 항목들/=변수 : 이름, 전화번호, 주소, 관계, 기타, 생년월일, 나이
-- name(한글문자열), tel(숫자문자열), address(한글문자열), chain(한글문자열), rem(한글문자열), birth(숫자문자열), age(숫자)
CREATE TABLE tbl_address (
    
    name NVARCHAR2(20) NOT NULL,        -- 이름은 반드시 있어야함
    tel VARCHAR2(20) NOT NULL,          -- 전화번호는 반드시 있어야함
    address NVARCHAR2(125),
    chain NVARCHAR2(10),
    rem NVARCHAR2(10),
    birth VARCHAR2(10), --1999-01-01
    age NUMBER(3)

);

INSERT INTO tbl_address(name, tel)
VALUES('홍길동','서울특별시') ;

SELECT * FROM tbl_address;

INSERT into tbl_address(name, tel)
VALUES ('이몽룡', '익산시') ;

INSERT into tbl_address(name, tel)
VALUES ('성춘향', '남원시') ;

INSERT into tbl_address(name, tel)
VALUES ('장길산', '부산광역시') ;

INSERT into tbl_address(name, tel)
VALUES ('임꺽정', '함경남도') ;

-- 현재 Transaction()이 완료되었다라는 것을 DBMS에게 알리는 명령(DCL 또는 TCL 명령)
COMMIT ;

SELECT * FROM tbl_address;

--                   [UPDATE]
-- 이미 INSERT 를 수행해서 Table에 보관중인 데이터의
-- 일부 또는 전체 칼럼의 값을 변경하는 것.
-- UPDATE 테이블명 SET
UPDATE tbl_address 
SET address = '서울특별시';

SELECT * FROM tbl_address;

--                  [ROLLBACK]
-- 데이터의 추가, 수정, 삭제를 **취소**하는 명령
-- DCL명령 또는 TCL(TRANSACTION CONTOL LANGUAGE)명령으로도 볼 수 있음

-- COMMIT을 수행한 이후
-- 데이터의 추가, 수정, 삭제를 수행한 것들을
-- 명령을 취소하는 명령
-- COMMIT를 수행하지 않고 ROLLBACK를 수행하면 전체 데이터가 삭제되기 때문에 매우 위험한 명령임.
-- 데이터를 입력(INSERT)을 수행하면 DBMS 임시저장소(buffer)에 임시로 저장된다
-- COMMIT를 수행하면 실제 내가 만들어놓은 DBF파일에 데이터를 기록한다.
-- 따라서 COMMIT 수행 후 ROLLBACK를 수행하면 COMMIT 수행 이후의 데이터 만 삭제되고 COMMIT 한 데이터들은 그대로 남는다.
ROLLBACK;

SELECT * FROM tbl_address;

-- UPDATE 명령을 기본형으로 수행을 하게 되면
-- 모든 Record 데이터가 변경이 되어버리는 사태가 발생한다.
-- ***********절대 UPDATE 명령은 기본형(UPDATE 테이블명 SET 칼럼명)으로만 수행하지 않기(조건을 꼭 붙이기)*******
UPDATE tbl_address
SET address = '서울특별시'
WHERE name = '홍길동' ;   -- tbl_address에 저장된 데이터들 중에서 name칼럼의 값이 '홍길동'인 데이터들을 찾아서
--                           adress칼럼의 값을 '서울특별시'로 변경하라 
--                           일종의 변 수 변경 방법과 유사함 ==> 원래 데이터가 뭐든 관계없이 변경된값이 저장
--                           최종 저장될 데이터 값만 고려하면 됨

SELECT * FROM tbl_address;

COMMIT ;

UPDATE tbl_address
SET address = '익산시'
WHERE name = '성춘향';

UPDATE tbl_address
SET address = '남원시'
WHERE name = '이몽룡';

COMMIT;

SELECT * FROM tbl_address;

-- 주소를 변경하고 봤더니
-- 이몽룡과 성춘향의 주소를 잘못 변경함( 이몽룡(남원) -> 익산 // 성춘향(익산) -> 남원 )
-- 이몽룡의 주소를 '남원시'에서 '익산시'로 변경하고
-- 성춘향의 주소를 '익산시'에서 '남원시'로 변경하고 싶음
UPDATE tbl_address
SET address = '익산시'
WHERE name = '이몽룡';

UPDATE tbl_address
SET address = '남원시'
WHERE name = '성춘향';

SELECT * FROM tbl_address;

INSERT INTO tbl_address(name, tel)
VALUES('홍길동','서울특별시') ;

SELECT * FROM tbl_address;

-- 이름이 홍길동이고 주소가 서울특별시인 데이터를 찾아서 주소를 광주광역시로 setting하라
UPDATE tbl_address
SET address = '광주광역시'
WHERE name = '홍길동' AND address = '서울특별시';

SELECT * FROM tbl_address ;

-- tbl_address table을 생성해서 테스트를 해보니
-- name칼럼이 홍길동이고 tel칼럼이 서울특별시인 중복데이터가 3개 존재해서
-- 중복된 데이터 중 어떤 1개의 데이터만 변경하려고 하는 것은 거의 불가능에 가까움
-- 현재 추가된 데이터에서
-- name칼럼과 tel칼럼에 데이터만 가지고 있는데
-- 실수로 홍길동, 서울특별시 데이터가 2개가 추가가 되었다.
-- 이 상황에서 홍길동 데이터 2개 중 1개는 부산광역시로, 나머지 한개는 광주광역시로 addr칼럼을 변경하고 싶을때
-- 실행할 수 있는 방법이 없다.
--          이렇게 설계된 table은 설계상 miss로 인한 '개체무결성이 훼손된 상태'라고 할 수 있다.
-- '개체무결성'을 보장하기 위해서는 pk(primary key)를 생성해야하는데
-- 또한 현재 상황에서는 어려움이 있다.
--      ==>      '개체무결성'을 보장하는 table을 재설계해야함



-- 지금 구상한 주소록테이블에 저장된 값들은 중복되지 않는 칼럼을 찾을수가 없음
-- 이럴때는 별도로 pk로 사용할 칼럼을 추가해서 개체무결성을 보장하는 방법이 있다.

DROP TABLE tbl_address;     --테이블 삭제

-- 테이블 재 설계 생성
CREATE TABLE tbl_address (

    id NUMBER PRIMARY KEY,          --실제 칼럼에서는 필요하지 않지만 개체 무결성을 보장하기 위해 더해주고 PK로 선언
    name NVARCHAR2(20) NOT NULL,
    tel VARCHAR2(20) NOT NULL,
    address NVARCHAR2(125),
    chain NVARCHAR2(10),
    rem NVARCHAR2(10),
    birth VARCHAR2(10),
    age NUMBER(3)

);

INSERT INTO tbl_address(id,name,tel)
VALUES (1,'홍길동','서울특별시') ;

INSERT INTO tbl_address(id,name,tel)
VALUES (2,'홍길동','서울특별시') ;

INSERT INTO tbl_address(id,name,tel)
VALUES (3,'홍길동','서울특별시') ;

INSERT INTO tbl_address(id,name,tel)
VALUES (4,'이몽룡','남원시') ;

INSERT INTO tbl_address(id,name,tel)
VALUES (5,'성춘향','익산시') ;

SELECT * FROM tbl_address ;

-- 주소를 추가하고 보니 전화번호 칼럼에 주소를 입력하고
-- 더불어 서울특별시에 사는 홍길동의 데이터가 3개 중복 추가된 것을 확인했다.
-- 원본 데이터를 봤더니
-- 동명이인의 홍길동 3명이 각각 서울특별시, 광주광역시, 부산광역시에 거주하는 것으로 확인
-- 홍길동의 addr칼럼을 각각 서울특별시, 광주광역시, 부산광역시로 바꾸려면
-- id가 1번인 데이터는 addr 칼럼을 서울특별시로,
-- id가 2번인 데이터의 addr 칼럼은 광주광역시로,
-- id가 3번인 데이터의 addr 칼럼은 부산광역시로     변경하는 코드
UPDATE tbl_address SET address = '서울특별시' WHERE id = 1;
UPDATE tbl_address SET address = '광주특별시' WHERE id = 2;
UPDATE tbl_address SET address = '부산광역시' WHERE id = 3;

SELECT * FROM tbl_address;
COMMIT;

-- ########################DELETE 명령도 UPDATE와 마찬가지로 기본형으로는 절대 실행하지 말기########################
DELETE FROM tbl_address ; 

SELECT * FROM tbl_address ;

-- 연습이기때문에 ROLLBACK 실행하자(실무에서는 함부로 쓰지 마라)
ROLLBACK;

SELECT * FROM tbl_address ;

-- DELETE를 실행할때도 table에 PK가 있으면 반드시 PK단위로 데이터를 삭제하가
-- 1. 삭제하고자 하는 데이터가 있는지 여러 방법으로 조회를 해본다.
SELECT * FROM tbl_address WHERE name = '성춘향';
DELETE FROM tbl_address WHERE name ='성춘향'; -- name칼럼이 성춘향 데이터는 1개이므로 이렇게 삭제해도 무방하지만

SELECT * FROM tbl_address WHERE name = '홍길동'; -- name칼럼이 홍길동 데이터는 3개이므로 
DELETE FROM tbl_address WHERE name = '홍길동'; -- 이라고 실행하면 절대 안됨(3개 몽땅 삭제)


SELECT * FROM tbl_address WHERE name = '홍길동' AND address = '서울특별시';

DELETE FROM tbl_address 
WHERE name 
= '홍길동' AND address = '서울특별시'; -- 이라고 해도 되지만 address는 pk가 아니므로 개채무결성을 보장한다고 보기 힘듦


-- 2. 결국 이름이 홍길동이고 주소가 서울특별시인 데이터를 삭제하려면 pk인 id값이 무엇인지 확인하고
SELECT * FROM tbl_address WHERE name = '홍길동' AND address = '서울특별시';

-- 3. PK인 ID를 조건으로 삭제 명령 수행하기
DELETE FROM tbl_address WHERE id = 1;

--                  *******************중요*******************
-- UPDATE나 DELETE 명령은 특별한 경우가 아니라면
-- 2개 이상의 레코드에 대하여 동시에 적용되도록 명령을 수행하지 말고
-- 번거롭고 불편하지만 PK칼럼을 WHERE 조건으로 하여 명령을 수행하자



--                                              [데이터 복구 방법]

-- DBMS를 운영하는 과정에서 만에 하나 재난(실수로 수행명령으로 데이터 변경, 삭제, 천재지변등으로 인한)이 발생하면
-- 데이터를 복구할 수 있게끔 준비를 해야한다.

-- 1. 백업 : 업무가 종료된 후 데이터를 다른 저장소, 저장매체에 복사하여 보관하는 것
--  1-1. 복구 : 백업해둔 데이터를 사용중인 시스템에 다시 설치하여 사용할 수 있도록 하는 것
--          복구는 원상태로 만드는데 상당한 시간이 소요되고 
--          백업된 시점에 따라 완전 복구가 되지 않는 경우도 있다.

-- 2. 로그 기록 복구 : INSERT UPDATE DELETE 명령이 수행될 때
--          수행되는 모든 명령들을 별도의 파일로 기록해 두고
--          문제가 발생했을 때 로그를 다시 역으로 추적하여 복구하는 방법 ==> 저널링 복구

-- 3. 이중화, 삼중화 : 실제 운영중인 운영체제, DBMS, storage 등을 똑같은 구조로
--          설치 위치를 달리하여 동시에 운영하는 것
--          재난이 발생하면 발생지역의 시스템을 단절하고
--          정상시스템으로 절환하여 운영을 계속하도록 하는 시스템
-- (ex)대한민국 국민 모두의 정보를 가지고 있는 전자정부 시스템은 DB를 대전을 메인으로 광주에 이중 DB를 두고
-- 재난상황같은 돌발상황이 발생하면 MAIN을 끊고 광주DB를 연결하는 형식으로 운영함)

-- 데이터센터(데이터웨어하우스)
--          대량의 데이터베이스를 운영하는 서버시스템들을 모아서 통합 관리하는 곳


