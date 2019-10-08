-- 여기는 user2 화면입니다.
SELECT * FROM tbl_address ;

UPDATE tbl_address SET age = 33
WHERE id = 5;

UPDATE tbl_address SET age = 0
WHERE id = 4;

SELECT * FROM tbl_address;

-- tbl_address Table의 age 칼럽에 값이 입력되지 않은 레코드들만 보여달라 
SELECT * FROM tbl_address
WHERE age IS NULL;  

-- tbl_address Table의 age 칼럽에 어떤 값이라도 입력 되어있으면 그 리스트를 보여달라
SELECT * FROM tbl_address
WHERE age IS NOT NULL;

-- [IS NULL, IS NOT NULL] --조회 명령문
-- 데이터를 많이 추가한후 혹시 중요한 칼럼의 데이터를 누락시키지 않았나 판별용으로 사용

UPDATE tbl_address SET chain = ''  -- ''과 같이 아무것도 입력하지 않은 형태의 ''는 오라클이 NULL로 인식함
WHERE id = 3;
SELECT * FROM tbl_address;

UPDATE tbl_address SET chain = ' '  -- ''중간에 SPACE가 있는 문자열을 칼럼에 저장하면 빈칸이 저장됨(WHITESPACE =/= NULL)
WHERE id = 3;                       -- 실제로는 한개 이상의 SPACE문자열이 저장되어 있음
SELECT * FROM tbl_address;

SELECT * FROM tbl_address WHERE address IS NULL ;  -- address 칼럼이 비어있는 레코드들을 보여라
SELECT * FROM tbl_address WHERE address IS NOT NULL ; -- address 칼럼에 값이 있는 레코드들을 보여라
SELECT * FROM tbl_address; -- 아무런 조건에 관계 없이 모든 레코드들을 보여라

UPDATE tbl_address SET chain = '001' WHERE id = 1;
UPDATE tbl_address SET chain = '001' WHERE id = 2;
UPDATE tbl_address SET chain = '002' WHERE id = 3;
UPDATE tbl_address SET chain = '003' WHERE id = 4;
UPDATE tbl_address SET chain = '004' WHERE id = 5;

SELECT * FROM tbl_address;

-- 렡코드 리스트를 확인했더니 CHAIN 칼럼의 값들이 알수없는 기호(숫자값)로 저장되어있다.
-- 현재는 001, 002, 003의 기호값들이 무엇을 의미하는지 알 수가 없다.
-- INSERT를 수행한 사람에게 물어보니 001은 가족, 002는 친구, 003이면 이웃이라고 함.
-- SELECT를 실행할 때 CHAIN이 001이면 가족, 002면 친구, 003이면 이웃이라는 문자열로 나타났으면 좋겠음

INSERT INTO tbl_student(id,name,tel,address,chain)
VALUES (1,'홍길동','서울특별시','001') ;

SELECT id,name,address,chain,
        DECODE(chain, '001', '가족')
FROM tbl_address ;

DROP TABLE tbl_address;

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
VALUES (2,'홍길동','광주광역시') ;

INSERT INTO tbl_address(id,name,tel)
VALUES (3,'홍길동','부산광역시') ;

INSERT INTO tbl_address(id,name,tel)
VALUES (4,'이몽룡','남원시') ;

INSERT INTO tbl_address(id,name,tel)
VALUES (5,'성춘향','익산시') ;

SELECT * FROM tbl_address ;

UPDATE tbl_address SET age = 33
WHERE id = 5;

UPDATE tbl_address SET age = 0
WHERE id = 4;

UPDATE tbl_address SET chain = ''  
WHERE id = 3;
SELECT * FROM tbl_address;

UPDATE tbl_address SET chain = ' '  
WHERE id = 3;                       
SELECT * FROM tbl_address;

UPDATE tbl_address SET address = '서울특별시' WHERE id = 1;
UPDATE tbl_address SET address = '광주특별시' WHERE id = 2;
UPDATE tbl_address SET address = '부산광역시' WHERE id = 3;

UPDATE tbl_address SET chain = '001' WHERE id = 1;
UPDATE tbl_address SET chain = '001' WHERE id = 2;
UPDATE tbl_address SET chain = '002' WHERE id = 3;
UPDATE tbl_address SET chain = '003' WHERE id = 4;
UPDATE tbl_address SET chain = '003' WHERE id = 5;


SELECT id,name,address,chain,
        DECODE(chain, '001', '가족')
FROM tbl_address ;

-- 레코드 리스트를 확인했더니 CHAIN 칼럼의 값들이 알수없는 기호(숫자값)로 저장되어있다.
-- 현재는 001, 002, 003의 기호값들이 무엇을 의미하는지 알 수가 없다.
-- INSERT를 수행한 사람에게 물어보니 001은 가족, 002는 친구, 003이면 이웃이라고 함.
-- SELECT를 실행할 때 CHAIN이 001이면 가족, 002면 친구, 003이면 이웃이라는 문자열로 나타났으면 좋겠음
SELECT id, name, address, chain,
-- chain 칼럼 값이 001 이면 가족이라고 보이고, 아닐경우
-- 002 인지 검사하고 002 이면 '친구' 라고 보이고, 아닐 경우
-- 003 인지 검사하고 003 이면 '이웃' 이라고 보여라

-- DECODE(칼럼, 조건값, ture일때, 아닐때) (자바 if와 비슷한 연산 수행)
-- 다른 DB에서는 IF(), IIF() 라고도 사용한다.
    DECODE(chain, '001', '가족', 
    DECODE(chain, '002', '친구', 
    DECODE(chain, '003', '이웃'))) AS 관계
FROM tbl_address ;    



-- 이 SQL에서 만일 '관계' 항목에 (NULL) 값이 존재한다는  것은
-- chain칼럼에 값이 잘 못 입력되었거나,
-- 조건식이 잘못되었거나 한 경우가 된다.
SELECT id, name, address, chain,
    DECODE(chain, '001', '가족', 
      DECODE(chain, '002', '친구', 
        DECODE(chain, '003', '이웃'))) AS 관계
FROM tbl_address 
WHERE DECODE(chain, '001', '가족', 
        DECODE(chain, '002', '친구', 
         DECODE(chain, '003', '이웃'))) IS NULL; 
         
-- 테스트를 위해서 아래 SQL문을 수행하면서
-- chain칼럼에 값을 101로 저장했다.
-- 그리고 위의 SELECT SQL을 수행했더니
-- 1개의 레코드가 보였다.
-- 결국 chain 칼럼에 데이터는 모두 null값이 아닌 상태이어서
-- 값이 저장은 되어있지만 원하지 않은 값이 저장되어 있음을 알 수 있다.
-- 이 코드는 보기위한 sql으로, 주로 데이터를 검증하는 도구로 활용하기도 한다.
INSERT INTO tbl_address (id, name, tel, chain)
VALUES(6, '장보고', '010-777-7777', '101');




--                               [SELECT문을 이용한 칼럼들의 순서 보이기]


-- tbl_address Table에 저장된 모든 데이터를 아무런 조건 없이 보여라
-- SELECT * : projection을 *로 표현하면 모든 칼럼을 다 보여주는 형식인데,
-- 우리가 원하는 칼럼의 순서대로 보여진다는 보장이 없음
SELECT * FROM tbl_address ;

-- 리스트를 보이는데 보여지는 칼럼을 꼭 
-- id, name, tel, address, chain, birth, age의 순으로 보고 싶을때
-- = projection(칼럼들의 나열)을 원하는 순서대로 보고자 할 때는
-- SELECT (원하는 칼럼 순서) FROM (Table이름)을 기본형으로 select키워드에 칼럼 리스트를 나열해 주면 됨
SELECT id, name, tel, address, chain, birth, age
FROM tbl_address ;

-- 리스트를 보는데 모든 칼럼을 다 보이지 않고
-- 필요한 몇몇 칼럼만 보고자 할 때는
-- 보고자 하는 칼럼들만 나열 해주면 됨
SELECT id, name, tel, chain
FROM tbl_address; 

-- 데이터들 리스트에서 원하는 **조건을 부여**해 필요한 리스트만 확인하는 방법
-- 기본 SELECT FROM 명령어에 WHERE 조건절을 추가하여 사용한다.
-- name칼럼에 저장된 값이 홍길동인 리스트들만 보여라
-- == name칼럼에 저장된 값이 홍길동인 모든 데이터들을 보여라
SELECT * FROM tbl_address
WHERE name = '홍길동';

SELECT * FROM tbl_address
WHERE name = '이몽룡';

-- 리스트(프로그램과 연결) = 레코드(컴퓨터 공학적) = row(DB)

-- 데이터의 순서는 보장이 없음(저장된 순으로 보이지만 이 순으로 나올거라는 보장x)
SELECT * FROM tbl_address;

INSERT INTO tbl_address(id, name, tel)
VALUES(10,'조덕배','010-333-22222');

INSERT INTO tbl_address(id, name, tel)
VALUES(9,'조용필','010-333-22222');

SELECT * FROM tbl_address;

COMMIT ;

INSERT INTO tbl_address(id, name, tel)
VALUES(8,'양희은','010-123-1234');

SELECT * FROM tbl_address;

COMMIT ;



--                   [데이터를 조회할 때 특정 칼럼을 기준으로 ******정렬*******을 수행하여 리스트를 보이기]
-- 정렬 : 기본 SELECT에 ORDER BY 절을 추가하여 사용

--                                  [오름차순 정렬 : ORDER BY ASC]
SELECT * FROM tbl_address
ORDER BY name ;         -- name칼럼을 기준으로 **오름차순** 정렬을 하여 보여라


SELECT * FROM tbl_address
ORDER BY id ; -- id칼럼을 기준으로 **오름차순** 정렬을 하여 보여라

SELECT * FROM tbl_address
ORDER BY name, address ; -- 1. 먼저 name 칼럼으로 가나다순 정렬을 해서 보이고, 
                         -- 2. 만약 name칼럼의 값이 같은 리스트가 두개 이상 있으면 , address칼럼으로 오름차순 정렬해라



--                                  [내림차순 정렬 : DESC]
SELECT * FROM tbl_address
ORDER BY name DESC, address ASC;  -- name칼럼을 기준으로 내림차순 정렬을 수행하고,
                                  -- 이어서 address 칼럼으로 오름차순 정렬하라
                                  -- 칼럼이름 뒤에 DESC(Descending)이 있으면 내림차순(큰 -> 작은) 정렬
                                  -- 아무런 키워드가 없으면 ASC(Ascending)가 생략된 것임(오름차순)
                                  
                                  
-- id 칼럼은 PK로 선언되어 있어서 절대 중복값이 있을 수 없다.
-- 그럼에도 불구하고 칼럼들을 나열한 것은 의미 없는 코드를 작성한 것이다.(낭비)
SELECT * FROM tbl_address
ORDER BY id, name, address, chain, rem, birth, age ;


-- 데이터를 추가하고 수정한 사항을 storage에 저장(물리적 저장) 하기
COMMIT ;




