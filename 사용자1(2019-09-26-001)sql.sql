-- 여기는 user1 화면 입니다.
-- TABLE 생성 연습

CREATE TABLE tbl_addr (
    
    -- 이름, 주소, 전화번호, 나이, 관계
    name    VARCHAR2(10),    -- String name
    addr    VARCHAR2(125),   -- String
    tel     VARCHAR2(20),    -- Stirng
    age     int,             -- int
    chain   VARCHAR2(20)     -- String

);

SELECT * FROM tbl_addr ; -- table을 만들었지만 값을 주지 않아서 schema만 보임

-- [CREATE]


-- INSERT INTO => 값을 주입하는 명령어
-- 한개의 데이터를 tbl_addr에 table에 추가하라
INSERT INTO tbl_addr (name, addr, tel, age, chain)
VALUES('홍길동', '서울시', '010-111-1111', 34,'친구') ;




-- [READ]


-- 현재 tbl_addr table에 저장된 데이터를 모두 보여달라.
SELECT * FROM tbl_addr ;


-- [UPDATE]


-- tbl_addr table의 addr칼럼에 저장된 값을 
-- 광주광역시로 update(수정)하라
UPDATE tbl_addr
SET addr = '광주광역시' ;

SELECT * FROM tbl_addr ;

DELETE FROM tbl_addr ;

SELECT * FROM tbl_addr ;
