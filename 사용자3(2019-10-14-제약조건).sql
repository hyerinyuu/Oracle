-- USER3 화면입니다.
-- 테이블 구조를 조회
DESC tbl_student ;

-- tbl_student를 테스트 하는데 
-- 원본 테이블을 손상하지 않고 테스트를 수행하기 위해서
-- 테이블을 복제해보기
CREATE TABLE tbl_test_std
AS 
SELECT * FROM tbl_student ;
SELECT * FROM tbl_test_std;

DESC tbl_student;
/*

이름       널?       유형             
-------- -------- -------------- 
ST_NUM   NOT NULL VARCHAR2(3)    // PRIMARY KEY : NOT NULL + UNIQUE 가 포함된 기본키
ST_NAME  NOT NULL NVARCHAR2(50)  
ST_TEL            VARCHAR2(20)   
ST_ADDR           NVARCHAR2(125) 
ST_GRADE          NUMBER(1)      
ST_DEPT           VARCHAR2(3)   

*/
DESC tbl_test_std;
/*

이름       널?       유형             
-------- -------- -------------- 
ST_NUM            VARCHAR2(3)    
ST_NAME  NOT NULL NVARCHAR2(50)  
ST_TEL            VARCHAR2(20)   
ST_ADDR           NVARCHAR2(125) 
ST_GRADE          NUMBER(1)      
ST_DEPT           VARCHAR2(3)  

*/
-- 테이블을 복제하게되면 NOT NULL을 제외한 나머지 제약조건은 삭제됨(참조무결성, PRIMARY KEY 등)
-- ==> 일부 오류를 캐치하지 못하고 그냥 넘어갈 가능성 있음
-- 이미 만들어진 테이블에 제약조건을 추가하는 방법

-- ###
-- 1. 테스트를 위해서 tbl_table을 tbl_test_std 테이블로 통으로 복제를 했는데
--   테이블을 복제하면 데이터 형식, 데이터들, 제약조건 중 NOT NULL등 일부는 그대로 복제가 되는데
--   PRIMARY KEY등 중요한 제약조건들이 무시되고 복제가 되지 않는다.

-- 또는
-- 2. 테이블을 생성할 당시에는 제약조건들이 필요하지 않아서 설정해놓지 않았지만
--   사용하다 보니 제약조건들이 필요한 경우가 있다.

--   1, 2와 같은 경우에 테이블을 삭제, 재생성 하지 않아도 이미 작성된 테이블에 제약조건들만 추가해 주면 된다.

-- 1. NOT NULL 제약조건
-- : 칼럼에 값이 없으면 INSERT가 되지 않도록 하는 제약조건

-- NAME에 NOT NULL 추가해보기
ALTER TABLE tbl_test_std MODIFY (st_name nVARCHAR2(50) NOT NULL);
-- 만약 st_name의 칼럼에 값이 없는 레코드가 있으면 이 명령은 오류를 낸다.(==not null로 설정된 값이 있으면)
-- 값이 없는 레코드에 일단 값들을 채워넣고 = UPDATE를 실행한 후 명령을 수행해야 한다.

-- 2. UNIQUE 제약조건
-- : 칼럼에 중복값이 추가되지 않도록 하는 제약조건
ALTER TABLE tbl_test_std ADD UNIQUE(st_num) ;
-- 만약 ST_NUM의 칼럼에 중복된 값이 있으면 이명령은 오류를 낸다.

-- 3. PRIMARY KEY 제약조건
-- : 데이터가 없거나, 중복된 값을 추가하지 못하며, 해당 칼럼은 PK로 설정된다.
-- PK로 설정된 칼럼은 내부적으로 자동으로 INDEX라는 OBJECT가 생성된다.
-- TABLE CREATE 할때는 단순히 PRIMARY KEY 만 지정해주면 PK칼럼을 설정할 수 있었는데
-- ALTER TABLE을 사용해서 PK를 추갛ㄹ때는 가급적 이름을 지정해 주는 것이 좋다.
-- 간혹 DBMS에 따라서 이름을 지정하지 않으면 실행이 안되는 경우도 있다.

-- tbl_test_std테이블에 KEY_ST_NUM라는 이름으로 ST_NUM칼럼을 PK로 설정하라 는 의미
ALTER TABLE tbl_test_std ADD CONSTRAINT key_st_num PRIMARY KEY(st_num);

-- 경우에 따라서 PK를 다중칼럼으로 설정하는 경우도 있다.
-- 학생이름과 전화번호 조건을 추가해서 이름과 전화번호가 둘 다 같은 데이터가 중복되어 입력되는 경우
-- INSERT가 되지 않도록 설정하는 방법(동명이인을 위해서)
-- ALTER TABLE tbl_test_std ADD CONSTRAINT KEY_ST_NAME_TEL PRIMARY KEY(st_name, ST_TEL);

-- 4. CHECK 제약조건
-- 데이터를 추가할 때 어떤 칼럼에 저장되는 데이터를 제한하고자 할 때
-- st_grade 칼럼에 값을 1부터 4까지 범위의 숫자만 저장하라
-- 그리고 그 제약조건 이름으로 st_grade_check라고 등록하라
ALTER TABLE tbl_test_std ADD CONSTRAINT st_grade_check CHECK(st_grade BETWEEN 1 AND 4);

-- ST_GENDER 칼럼에는 문자열 '남', '여' 만 입력할 수 있다
-- ex) ALTER TABLE tbl_test_std ADD CONSTRAINT st_gender_check CHECK(st_genger IN ('남', '여');


-- ※ CONSTRAINT 이름을 지정하는 이유 :
-- 이름이 지정되지 않으면 나중에 조건이 필요 없어서 삭제를 하고자 할 때
-- 삭제가 어려워질 수도 있다.


-- 5. UNIQUE제약조건을 삭제
ALTER TABLE tbl_test_std DROP UNIQUE(st_num);

-- 6. CHECK 제약조건 삭제
-- ST_GRADE_CHECK 이름으로 등록된 제약조건 삭제
-- CASCADE : 연관된 모든 조건을 ㅈ같이 삭제하라
--          시스템상에 설정된 제약조건과 관련된 설정값을 모두 삭제해라
ALTER TABLE tbl_test_std DROP CONSTRAINT st_grade_check CASCADE;


-- 7. 참조무결성 설정
-- fk_std_score2의 st_num 칼럼에 어떤 값 a가 들어있으면 score2에는 a값이 있을수도 있다.
-- score2에 어떤 값 a가 없으면 fk_std_score2에는 a값이 절대 없다.   ==> 참조무결성
-- tbl_score2에 에 데이터를 추가하거나 학번을 변경할 때
-- tbl_test_std 테이블을 참조하여
-- 학번(s_num, st_num)과의 관계를 명확히 하여
-- EQ JOIN을 수행했을 때
-- 결과가 신뢰성을 보장하는 제약조건 설정

/*
        tbl_score               tbl_test_std
---------------------------------------------------    
          s_num                    st_num
          있다          >>      반드시 있다
      있을수도 있다     <<          있다
        절대없다        <<          없다

*/

ALTER TABLE tbl_score2
ADD CONSTRAINT fk_std_score2
FOREIGN KEY (s_num)  -- 테이블을 만들때 쓰기보다는 추후에 필요에 따라서 추가하는 것이 보편적인 방법임
REFERENCES tbl_test_std(st_num);


