/*
주소록 테이블

임의의 ID값으로 PK를 설정 NUMBER
이름 nVARCHAR2(50)
전화번호 VARCHAR2(20)
주소 nVARCHAR2(125)
관계 nVARCHAR2(10)
*/
CREATE TABLE tbl_addr (
    
    id NUMBER PRIMARY KEY,
    name nVARCHAR2(50) NOT NULL,
    tel VARCHAR2(20),
    addr nVARCHAR2(125),
    chain nVARCHAR2(10)
);

CREATE SEQUENCE SEQ_ADDR
START WITH 1 INCREMENT BY 1;

COMMIT;

INSERT INTO tbl_addr(id, name, tel, addr, chain)
VALUES (002, '이몽룡', '010-1111-3333', '서울시', '친구');

INSERT INTO tbl_addr(id, name, tel, addr, chain)
VALUES (002, '이몽룡', '010-1111-3333', '서울시', '친구');



SELECT * FROM tbl_addr;

COMMIT;

SELECT 'P' || TRIM(TO_CHAR(SEQ_ADDR.NEXTVAL,'0000')), FROM DUAL;

INSERT INTO tbl_addr(id, name)
VALUES(SEQ_ADDR.NEXTVAL,'000'), '홍길동');

INSERT INTO tbl_addr(id, name)
VALUES(SEQ_ADDR.NEXTVAL,'홍길동');

INSERT INTO tbl_addr(id, name)
VALUES(SEQ_ADDR.NEXTVAL,'이몽룡');

INSERT INTO tbl_addr(id, name)
VALUES(SEQ_ADDR.NEXTVAL,'성춘향');

DROP TABLE tbl_addr;
DROP SEQUENCE SEQ_ADDR;

COMMIT;


INSERT INTO tbl_addr(id, name, tel, addr, chain)
VALUES(SEQ_ADDR.NEXTVAL,'홍길동', '010-111-1111', '서울시', '가족');

INSERT INTO tbl_addr(id, name, tel, addr, chain)
VALUES(SEQ_ADDR.NEXTVAL,'이몽룡', '010-111-2222', '서울시', '친구');

INSERT INTO tbl_addr(id, name, tel, addr, chain)
VALUES(SEQ_ADDR.NEXTVAL,'임꺽정', '010-111-3333', '광주시', '가족');

INSERT INTO tbl_addr(id, name, tel, addr, chain)
VALUES(SEQ_ADDR.NEXTVAL,'김원봉', '010-111-4444', '구리시', '동기');

