-- GRADE 화면

-- DB 이론상 정규화 과정

/*
1. 실무에서 사용하던 엑셀 데이터
======================================
학생이름 학년  학과    취미
--------------------------------------
홍길동    3   컴공과  낚시, 등산, 독서
==> 데이터를 이와 같은 형식으로 해서 테이블을 생성하면 
잘못된 테이블임(취미 칼럼에 ,를 이용해 3개의 데이터 저장)



2. 엑셀 데이터를 단순히 DBMS의 테이블로 구현
        - 만약 취미가 4개인 학생은 4개중에 3개만 선택해야 하는 상황
        - 취미가 3개 미만인 학생은 사용하지 않는 칼럼이 있어 낭비되는 상황
===========================================
학생이름 학년  학과    취미1  취미2  취미3
-------------------------------------------
홍길동    3   컴공과    낚시   등산   독서




3. 제 1 정규화가 수행된 TABLE 스키마
==> 한 칼럼에 다수의 데이터가 있는 경우에
데이터의 추가가 더이상 이루어 지지 않는게 확실한 경우에는 2번 방식을 사용해도 되지만
데이터의 추가가 이루어 질 가능성이 있다면 3번방법을 사용해야함
===========================================
학생이름 학년  학과     취미
-------------------------------------------
홍길동    3   컴공과    낚시
홍길동    3   컴공과    등산
홍길동    3   컴공과    독서
홍길동    3   컴공과    영화




4. 제 2 정규화
-- 테이블의 고정값을 다른 테이블로 분리하고
테이블간의 JOIN을 통해서 VIEW 생성하도록
구조적 변경을 하는 작업
 제 2 정규화까지는 되어야 제대로 생성된 테이블이라고 볼 수 있음

tbl_student
===========================================
학생이름 학년  학과     취미
-------------------------------------------
홍길동    3     001      001
홍길동    3     001      002
홍길동    3     001      003
성춘향    2     002      004


tbl_hobby
========================
CODE        취미
------------------------
001         낚시
002         등산
003         독서
004         영화


tbl_dept
============================
CODE    학과명     담당교수     
----------------------------
001      컴공       임꺽정
002      법학       이순신
003      경영       장보고  
004      경제       전봉준

*/

-- tbl_score의 구조
DESC tbl_score;
/*
[성적일람표 table의 구조]
이름        널?       유형            
--------- -------- ------------- 
S_ID      NOT NULL NUMBER        
S_STD     NOT NULL NVARCHAR2(50) 
S_SUBJECT NOT NULL NVARCHAR2(50) 
S_SCORE   NOT NULL NUMBER(3)     
S_REM              NVARCHAR2(50) 

성적일람표 table의 데이터중에서 과목항목을
제2정규화 작업을 수행

*/

-- 1. tbl_score에서 과목명만 추출하기
SELECT s_subject FROM tbl_score
GROUP BY s_subject ;
-- 추출된 과목명 데이터로 엑셀 파일 작업....

-- tbl_score에서 추출된 과목명을 저장할 table을 생성

CREATE TABLE tbl_subject(

    sb_code	VARCHAR2(4)		PRIMARY KEY,
    sb_name	nVARCHAR2(20)	NOT NULL,	
    sb_pro	nVARCHAR2(20)		
);

-- 엑셀데이터 import
SELECT * FROM tbl_subject ;

-- tbl_score에서 tbl_subject 테이블 데이터를 생성 완료
-- 생성된 tbl_subject 하고 tbl_score하고 잘 연결되는지 테스트(EQ QUERY 이용)
SELECT *
FROM tbl_score SC, tbl_subject SB
WHERE SC.s_subject = SB.sb_name;

-- 위의 코드가 귀찮으면 아래 두 sql문의 결과 값을 확인하고 같으면 정상적으로 수행 완료된 것임
SELECT COUNT(*) FROM tbl_score;
SELECT COUNT(*)
FROM tbl_score SC, tbl_subject SB
WHERE SC.s_subject = SB.sb_name;




-- tbl_score의 s_subject 칼럼에 있는 과목명을 코드로 변경하는 작업 수행
-- 1. 임시로 칼럼을 하나 tbl_score 추가
--      tbl_subject의 sb_code 칼럼과 구조(형식)이 같은 칼럼을 추가
ALTER TABLE tbl_score ADD s_sbcode VARCHAR2(4);

SELECT * FROM tbl_score;

-- tbl_subject 테이블에서 과목명을 조회하여 해당하는 과목 코드를 
-- tbl_score 테이블의 s_sbcode칼럼에 update 수행하라
UPDATE tbl_score SC
SET s_sbcode = 
    (SELECT sb_code 
     FROM tbl_subject SB 
     WHERE SC.s_subject = SB.sb_name 
    ); 
/*
자바로 한다면
for( s : tbl_score){
    where(s.s_subject == tbl_subject.s_name) {
        sb.s_sbcode = tbl_subject.s_code
    }  
 }   
*/

-- UPDATE 수행 후 검증
SELECT SC.s_sbcode, SB.sb_code, SC.s_subject, SB.sb_name
FROM tbl_score SC, tbl_subject SB
    WHERE SC.s_sbcode = SB.sb_code ;
    
-- tbl_score의 s_subject칼럼을 삭제
ALTER TABLE tbl_score DROP COLUMN s_subject;

-- tbl_score s_sbcode 칼럼을 s_subject로 이름 변경
ALTER TABLE tbl_score RENAME COLUMN s_sbcode TO s_subject ;

-- 제 2 정규화가 일부 완료된 테이블 구조
DESC tbl_score;
/*
이름        널?       유형            
--------- -------- ------------- 
S_ID      NOT NULL NUMBER        
S_STD     NOT NULL NVARCHAR2(50) 
S_SCORE   NOT NULL NUMBER(3)     
S_REM              NVARCHAR2(50) 
S_SUBJECT          VARCHAR2(4)   
*/
-- 제2정규화 완료된 테이블
SELECT * FROM tbl_score; 

--JOIN을 통해서 데이터 확인(현재상태에서는 완전JOIN 가능)
SELECT s_std, s_subject, SB.sb_name, SB.sb_pro, s_score
FROM tbl_score SC, tbl_subject SB
WHERE SC.s_subject = SB.sb_code;
-- 테이블을 join 할 때 join할 테이블 간에 같은 칼럼이름이 존재한다면
-- 반드시 칼럼이 어떤 table에 있는 칼럼인지를 명시 해주어야 문법적 오류가 발생하지 않는다.
-- 그래서 table을 설계할 때 가급적 접두사를 붙여서 만드는 것이 좋고(ex : s_std)
-- 그렇더라도 join을 할 때 테이블 Alias를 설정하여 Alias.column 형식으로 작성하는 것이 좋다.
/*
Table1 : num, name, addr, dept
Table2 : num, subject, pro

SELECT * 
FROM Table1, Table2
    WHERE dept = num;
이런 형식으로 SQL을 작성하면 num이 누구의 Table인지 알 수 없어서 문법 오류 발생


==> 밑의 SQL형식같이 Alias를 설정해서 구별해줘야함
SELECT T1.num AS 학번, T1.name, T1.addr, T1.dept,
       T2.num AS 과목코드, T2.subject, T2.pro 
FORM Table1 T1, Table2 T2
    WHERE T1.dept = T2.num; 
*/

SELECT * FROM tbl_score ;

-- 실제 코딩에서 *을 통해 SELECT를 사용하는 것은 좋지 않다
-- DBA와 JAVA개발자 간 오류를 줄이기 위해 SELECT ALL을 하더라도 
-- 칼럼명을 명시적으로 나열해 주는 것이 좋은 방법이다.
SELECT s_id, s_std, s_subject, s_score, s_rem FROM tbl_score;

-- java에서 insert한 데이터
SELECT *
FROM tbl_score
WHERE s_id > 600;

DELETE 
FROM tbl_score
WHERE s_id > 600;

COMMIT ;







