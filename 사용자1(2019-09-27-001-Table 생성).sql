-- 여기는 user1 사용자화면입니다.
-- DBA 역할중에서
-- 데이터 저장소의 기초인 Table을 만드는 것에 대한 

-- 학생정보를 저장할 tbl_student Table 생성

-- 자바 StudentVO와 같은 역할을 함(CREATE TABLE something(); ==> table생성을 위한 표준 sql 명령어)
-- tbl_student라는 이름으로 table(물리적 저장소)을 생성한다.
-- tbl_student : 생성할 table 이름

-- [table 이름 명명 규칙] : Java에서 변수, 클래스 method등의 이름을 명명하는 것과 같다.(단, 오라클에서는 대소문자 구별x)
-- [테이블 명명 패턴] :일반적으로 테이블을 만들 때 테이블 이름 앞에 접두사로 tbl_사용한다.




--                                            *** [데이터타입] ***

CREATE TABLE tbl_student(
    -- 칼럼 : 필드(멤버)변수와 같은 개념
    -- 칼럼들은 컴마로 구분하여 나열한다.(마찬가지로 대소문자구분x)
    -- 칼럼들의 data type지정 : data type은 변수 명 뒤에 위치(Java는 앞에 위치하는 것과 구분됨)
    -- data type에는 ()를 사용하여 최대 저장할 크기를 byte단위로 지정한다.
    
    -- CHAR() : "고정길이" 문자열 저장 칼럼, 최대 2000글자까지 저장 가능
    --          ==> 저장할 데이터가 항상 일정한 길이를 갖고 있음이 보장될 경우에 사용
    -- 오라클에서 CHAR 칼럼에 순수 숫자로만 되어있는 데이터를 저장할 경우, 약간의 문제를 일으킴.
    --      EX >> A0001 형식으로 저장하면 당연히 문자열로 인식하는데, 만약 0001형식으로 저장하면
    --      오라클DB에는 문자열로 저장이 되는데 JAVA(또는 타프로그래밍언어)를 통해서 DB에 접속을 할 경우
    --      숫자로 인식해버리는 오류가 있음.
    --      그래서 오라클에서는 아주 특별한경우가 아니면 그냥 VARCHAR2()로 사용함.
    st_num CHAR(5),
    
    
    -- VARCHAR2() : "가변길이" 문자열 저장 칼럼, 최대 4000글자까지 저장 가능
    --          ==> 최대 글자까지 저장하는 것은 CHAR과 유사하지만
    --              만약 저장하는 데이터의 길이가 일정하지 않을 경우는
    --              데이터 길이만큼 칼럼이 변환되어 파일에 저장이 된다.
    
    -- nVARCHAR2() : 유니코드, 다국어 지원 칼럼
    --          ==> 만약 한글 데이터가 입력될 가능성이 있는 칼럼은 반드시 nVARCHAR()를 사용해야함
    --              한글이 입력될 가능성이 전혀 없는 칼럼에 nVARCHAR2()를 사용해도 큰 문제 없음.
    --              
    st_name nVARCHAR2(20),
    st_addr nVARCHAR2(125),
    
    st_tel VARCHAR2(20),
    
    -- [숫자를 저장할 칼럼]
    -- 표준 SQL에서는 INT FLOAT LONG DOUBLE 등등의 키워드가 있음
    -- 오라클에서도 표준 SQL의 숫자 type을 사용할 수 있지만
    -- 오라클 코드에서는 NUMBER라는 칼럼을 사용한다.
    -- st_grade INT >>  INT라는 keyword를 사용하면 NUMBER(38)으로 변환되어 생성된다. 
    --              ==> 낭비 따라서 오라클에서 모든 숫자는 NUMBER
    st_grade NUMBER(1),
    st_dept VARCHAR2(10),
    st_age VARCHAR2(3)  -- 제일 마지막 칼럼은 뒤에 컴마X
    
);

-- 데이터 추가
INSERT INTO tbl_student(st_num, st_name, st_addr)
VALUES('00001', '성춘향', '익산시');

INSERT INTO tbl_student(st_num, st_name, st_addr)
VALUES('00001', '성춘향', '남원시');


-- 데이터 조회
SELECT * FROM tbl_student;

DROP TABLE tbl_student ;

--                                             *** [제약조건] ***


-- [UNIQUE]
-- 시나리오
-- tbl-student에 많은 학생의 데이터를 추가하다 보니
-- 학번이 0100인 학생의 데이터가 2번 추가가 되었다.
-- 이후에 tbl-student 테이블에서 0100번 학생의 데이터를 조회했더니
-- 데이터가 2개 조회되었다.
-- 이런 상황이 되면 0100 학생의 데이터 2개중에 어떤 데이터가 이 학생의 데이터인지 알기가 매우 어려워진다.
-- 여러가지 데이터를 다시 검증해야만 어떤 데이터가 정상적인(사용가능한) 데이터인지 확인할 수 있다.

-- 이러한 문제가 발생하지 않도록 미리 무언가 조치를 취해줘야 하는데
-- database에서는 이런 문제가 발생하지 않도록 설정을 할 수 있다.
-- 이러한 설정을 "제약조건 설정"이라고 한다.

-- 결론
-- tbl_student Table에는 절대 학번이 동일한 데이터가 2개 이상 없어야한다.
-- 라는 "제약조건"을 설정해두어야한다.
-- 이러한 설정을      [UNIQUE제약조건]    이라고 한다.

CREATE TABLE tbl_student (

    st_num CHAR(5) UNIQUE,
    st_name nVARCHAR2(20),
    st_addr NVARCHAR2(125),
    st_tel  VARCHAR2(20),
    st_dept nVARCHAR2(20),
    st_grade NUMBER(1),
    st_age  NUMBER(3)

);

INSERT INTO tbl_student(st_num, st_name, st_addr)
VALUES('00001', '성춘향', '남원시') ;

-- 많은 양의 데이터를 입력하는 과정에서
-- 실수로 학번 10001 학생을 추가해야 하는데
-- 학번을 00001로 하여 추가하는 코드를 작성하고 명령을 실행했다. 
INSERT INTO tbl_student(st_num, st_name, st_addr)
VALUES('00001', '이몽룡', '서울시');
-- ==> ORA-00001: unique constraint (USER1.SYS_C006997) violated 오류 발생 
-- UNIQUE CONSTRAINT : UNIQUE로 설정된 칼럼에 이미 존재하는값을 추가할 수 없다는 소리임(중복 배재/금지) 

INSERT INTO tbl_student(st_num, st_tel)
VALUES('20112', '010-1111-1234') ;
SELECT * FROM tbl_student;

DROP TABLE tbl_student ;





-- [NOT NULL] (두글자처럼 보이지만 한 명령임)
-- 학생데이터를 추가하는 과정에서
-- 학번은 위에서 중복금지 제약조건을 설정하여
-- 중복된 값이 추가되지 못하도록 설정을 했다.

-- 많은 양의 데이터를 추가하다보니
-- 실수로 학생이름, 전화번호 등을 입력하지 않고 추가한 데이터들이 존재한다.
-- 나중에 tbl_student 테이블의 데이터를 사용하여 업무를 수행하려고 햇더니
-- 이름, 전화번호가 없어서 상당히 문제를 일으킨다.

-- 이러한 일들ㅇ르 방지하기 위해서
-- 값이 없는 칼럼이 존재하면 안되는 데이터들이 추가되는 것을 방지하기 위해서
-- 꼭 값이 있어야하는 칼럼에  NOT NULL 제약 조건을 설정한다. 

-- NOT NULL 제약조건이 설정된 칼럼은 데이터를 추가할 때 반드시 값이 있어야 한다.
CREATE TABLE tbl_student (

    st_num CHAR(5) UNIQUE NOT NULL,  -- UNIQUE 절대 값을 변경할 수 없다  / NOT NULL 값이 없이는 추가되지않는다. 
    st_name nVARCHAR2(20) NOT NULL,
    st_addr NVARCHAR2(125),
    st_tel  VARCHAR2(20) NOT NULL,
    st_dept nVARCHAR2(20),
    st_grade NUMBER(1),
    st_age  NUMBER(3)

);



-- 데이터를 추가하는 과정에서
-- 학번, 전화번호만 데이터를 입력하고
-- 이름은 없는 상태로 데이터를 추가하려고 명령 실행
INSERT INTO tbl_student(st_num, st_tel)
VALUES('20112', '010-1111-1234') ;
-- 오류발생 ==> ORA-01400: cannot insert NULL into ("USER1"."TBL_STUDENT"."ST_NAME")
-- USER1 사용자가 만든 tbl_student table의 st_name 칼럼은 
-- 값이 없는 상태로는 INSERT 명령을 수행할 수 없다.


-- 다음과 같이 NOT NULL이 붙은 st_num, st_name, st_tel 칼럼은 값이 있는 상태로 INSERT를 수행해야 명령이 정상실행됨
INSERT INTO tbl_student(st_num, st_name, st_tel)
VALUES('20111', '이몽룡', '010-1111-1234');




-- [PRIMARY KEY]
-- tbl_student 테이블은 학생정보를 보관하는 매우 중요한 table이다
-- tbl_student에서 어떤 학생의 데이터를 조회하고자 할때는
-- 학생이름, 전화번호 등으로 조회를 할 수 있다.
-- 하지만 학생이름이나 전화번호로 조회를 하면 조회(추출)되는 데이터가 2개 이상 보일 수도 있다.(동명이인 등등)
-- 두개 이상의 데이터가 조회되면 어떤 데이터가 내가 필요한 데이터인지
-- 다른 항목을 통해서 추측해야하는 불편함이 있다.(정확도 떨어짐)

-- 이때 어떤 칼럼에 값을 조회했을때 
-- 유일하게 한개의 데이터만 추출되도록 설정을 할 수 있다
-- == 기본키 = Primary Key 라고 함.

-- [Primary key] : 중복되는 값(UNIQUE)과 NULL값을 가질 수 없음(개채의 무결성)
--                 UNIQUE와 NOT NULL 설정을 생략함(안써도 자동실행) 


-- tbl_student 테이블에 저장된 수많은 데이터 중에서
-- st-num 값으로 조회를 실행하면
-- 추출되는 데이터는 1개만 나타날것이다.
-- 이유는 현제 st_num 칼럼이 UNIQUE로 설정되어있기때문이다.
-- 또한
-- st_num 값을 조회했을때 추출되는 데이터는 없거나 유일하게 1개만 나타난다.(UNIQUE때문에)

-- 이러한 조건을 만족하기 위해서
-- st_num 칼럼은 UNIQUE와 NOT NULL 제약조건을 설정해둔다.

-- 더불어 st_num칼럼은 PK(Primary Key)라는 조건을 설정한다.
-- PRIMARY KEY 로 설정한 칼럼은 UNIQUE와 NOT NULL 조건을 만족하며
-- 또한 KEY로서 조회를 할 때 매우 빨리 값을 조회할 수 있도록 DBMS가 별도 관리를 한다.
-- PRIMARY KEY 로 설정한 칼럼은 UNIQUE와 NOT NULL 설정을 생략한다.

DROP TABLE tbl_student ;

CREATE TABLE tbl_student (

    st_num CHAR(5) PRIMARY KEY,   -- UNIQUE / NOT NULL
    st_name nVARCHAR2(20) NOT NULL,
    st_addr NVARCHAR2(125),
    st_tel  VARCHAR2(20) NOT NULL,
    st_dept nVARCHAR2(20),
    st_grade NUMBER(1),
    st_age  NUMBER(3)

);

-- st_num는 pk로 설정이 되어있기때문에
-- st_num의 값으로 조회를 하면 없거나 1개의 데이터만 보여준다.



-- 데이블의 구조를 확인하는 명령문(표준 sql)
DESCRIBE tbl_student ;
DESC tbl_student; -- (DESCRIBE == DESC)


-- user1 사용자가 생성한 테이블이 어떤 것들이 있는지 보여달라
SELECT * FROM dba_tables 
WHERE OWNER = 'USER1';

-- tbl_student에 데이터 추가하기
-- [기본 패턴]
-- INSERT INTO 테이블이름(칼럼,칼럼,칼럼, ...) 
-- VALUES(값, 값, 값, ...)
INSERT INTO tbl_student(st_num, st_name, st_tel, st_addr, st_age, st_dept )
VALUES('00001','홍길동','010-1111-1234','서울시',33,'컴공과') ;


INSERT INTO tbl_student(st_num, st_name, st_tel, st_addr, st_age, st_dept )
VALUES('00002','성춘향','010-2222-1234','남원시',33,'컴공과') ;


INSERT INTO tbl_student(st_num, st_name, st_tel, st_addr, st_age, st_dept )
VALUES('00003','이몽룡','010-3333-1234','익산시',33,'컴공과') ;


INSERT INTO tbl_student(st_num, st_name, st_tel, st_addr, st_age, st_dept )
VALUES('00004','장보고','010-4444-1234','해남군',33,'컴공과') ;

INSERT INTO tbl_student(st_num, st_name, st_tel, st_addr, st_age, st_dept )
VALUES('00005','임꺽정','010-5555-1234', '함경도', 33,'컴공과') ;


SELECT * FROM tbl_student ;
