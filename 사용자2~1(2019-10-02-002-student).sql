-- 여기는 USER2 입니다.
-- 학생정보를 저장할 새 테이블 생성(엑셀 활용)

DROP TABLE tbl_student ;

CREATE TABLE tbl_student (
    
    st_num	VARCHAR2(5)	    NOT NULL	PRIMARY KEY,  -- PRIMARY KEY를 설정했기 때문에 NOT NULL은 의미없는 코드임
    st_name	nVARCHAR2(30)	NOT NULL,
    st_addr	nVARCHAR2(125),		
    st_grade	NUMBER(1),		
    st_height	NUMBER(3),		
    st_weight	NUMBER(3),		
    st_nick	nVARCHAR2(20),		
    st_nick_rem	nVARCHAR2(50),		
    st_dep_no	VARCHAR2(3)	NOT NULL	
                
);

INSERT INTO tbl_student(st_num, st_name, st_dep_no, st_grade)
VALUES('A0001', '홍길동', '001', 3);

INSERT INTO tbl_student(st_num, st_name, st_dep_no, st_grade)
VALUES('A0002', '이몽룡', '001', 2);

INSERT INTO tbl_student(st_num, st_name, st_dep_no, st_grade)
VALUES('A0003', '성춘향', '002', 1);

INSERT INTO tbl_student(st_num, st_name, st_dep_no, st_grade)
VALUES('A0004', '임꺽정', '003', 4);

INSERT INTO tbl_student(st_num, st_name, st_dep_no, st_grade)
VALUES('A0005', '장보고', '004', 2);

UPDATE tbl_student
SET st_dep_no = '003'
WHERE st_name = '장보고' ;


-- 이름순으로 정렬해 확인
SELECT * FROM tbl_student ORDER BY st_name;

-- 학번이 2부터 4번까지인 학생의 리스트만 보고 싶다.
SELECT * FROM tbl_student WHERE st_num >= 'A0002' AND st_num <= 'A0004' ;
SELECT * FROM tbl_student WHERE st_num BETWEEN 'A0002' AND 'A0004';

-- 학년(grade)이 2학년인 학생의 리스트만 보고싶다.
SELECT * FROM tbl_student WHERE st_grade = 2;

-- 학번이 2번부터 4번까지인 학생의 리스트를 이름순으로 보고싶다
SELECT * FROM tbl_student
WHERE st_num BETWEEN 'A0002' AND 'A0004'
ORDER BY st_name ;

-- 학번이 2번부터 4번까지인 학생의 리스트를 학년의 역순으로 보고싶다.
SELECT * FROM tbl_student
WHERE st_num BETWEEN 'A0002' AND 'A0004'
ORDER BY st_grade DESC ;

--tbl_student의 테이블에 저장된 데이터 레코드가 모두 몇개냐?
SELECT COUNT(*) FROM tbl_student ;

-- 학생테이블에서 2학년 학생들의 데이터 레코드가 모두 몇개냐?
SELECT COUNT(*) FROM tbl_student
WHERE st_grade = 2 ;

-- 학생테이블에서 학년이 가장 높은 값은 어떤 값이 있나
SELECT MAX(st_grade) FROM tbl_student ;

-- 학생테이블에서 학년이 가장 낮은 값은 어떤 값이 있나
SELECT MIN(st_grade) FROM tbl_student ;

-- 학생테이블에 저장된 데이터의 학년 칼럼의 모든 데이터를 더하면 얼마?
SELECT SUM(st_grade) FROM tbl_student;
-- 학생테이블에 저장된 데이터의 학년 칼럼의 모든 데이터의 평균은 얼마?
SELECT AVG(st_grade) FROM tbl_student;

-- 오라클 이외에 다른 DBMS에서는
-- 간단한 연산등을 수행할 때
-- SELECT 연산 형식으로 사용이 된다.(FROM 이후 없이 사용 가능)
SELECT 30 + 40 FROM dual;
SELECT * FROM dual;

-- 레코드 셋(Record Set) : SELECT 명령이 실행된 후 보여지는 리스트
SELECT 30 * 40 FROM tbl_student ;

SELECT * FROM tbl_student ;



-- 학생들의 주소 칼럼의 데이터가 생략된 상태임(NULL)
-- 성춘향 학생의 주소를 광주광역시로
-- 이몽룡 학생의 주소를 익산시로
-- 홍길동 학생의 주소를 서울특별시로 입력하고 싶음


-- 이미 존재하는 레코드의 특정 칼럼에 값을 입력하고자 할때는 UPDATE명령을 수행함
-- UPDATE SET WHERE

UPDATE tbl_student
SET st_addr = '광주광역시'
WHERE st_name = '성춘향';

UPDATE tbl_student
SET st_addr = '익산시'
WHERE st_name = '이몽룡';

UPDATE tbl_student
SET st_addr = '서울특별시'
WHERE st_name = '홍길동';

SELECT * FROM tbl_student;

INSERT INTO tbl_student(st_num, st_name, st_grade, st_dep_no)
VALUES ('A0006','성춘향',2,'001') ;

UPDATE tbl_student
SET st_addr = '광주광역시'
WHERE st_name = '성춘향' AND st_grade = 1;

SELECT * FROM tbl_student;

INSERT INTO tbl_student(st_num, st_name, st_grade, st_dep_no)
VALUES('A0007','성춘향', 1,'001');

UPDATE tbl_student
SET st_addr = '광주광역시'
WHERE st_name = '성춘향' AND st_grade = 1 AND st_dep_no = '002';

-- 데이터 추가를 마치고
-- 각 학생들의 주소를 업데이트 하려고 한다.
-- 일단 학생들의 이름으로 조회를 하여
-- 이름을 WHERE 조건에 걸고UPDATE명령을 수행하려고 한다.
-- 그런데 1. 동명이인인 학생들이 다수 보인다.
-- 그래서 이번에는 이름과 학년을 WHERE 조건에 걸고 UPDATE수행하려한다.
-- 또, 2. 이름이 같고 학년이 같은 학생들이 다수 보인다.
-- 결국 이름, 학년, 학과 까지 WHERE조건에 걸어 UPDATE를 수행하려고 하는데
-- 세 칼럼에 값이 같은 학생이 다수 있다.
-- 이제 지금까지 WHERE조건에 설정한 항목들은 무의미 해져버림

-- 결론
-- ***********WHERE조건을 걸때는 반드시 PK를 기준으로 걸어라*********************
-- UPDATE를 수행하고자 할때는 
-- 학생테이블의 PK로 설정된 학생의 학번(ST_NUM)을 조건으로 걸고 UPDATE를 수행해야만
-- 데이터의 신뢰도를 유지하고 개체무결성을 보장할 수 있다.
-- 



