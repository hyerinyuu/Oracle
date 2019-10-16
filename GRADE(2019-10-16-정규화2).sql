-- GRADE 화면
DESC tbl_score;
/*
S_ID      NOT NULL NUMBER        
S_STD     NOT NULL NVARCHAR2(50) 
S_SCORE   NOT NULL NUMBER(3)     
S_REM              NVARCHAR2(50) 
S_SUBJECT          VARCHAR2(4)   

    [학생정보 칼럼을 제 2 정규화]
tbl_score테이블에는 학생이름이 일반적인 문자열로 저장이 되었다.
일반적인 문자열로 저장된 경우
학생이름을 변경해야할 경우가 발생하면

UPDATE tbl_score
    SET s_ste = '이몽룡'
    WHERE s_std = '이멍룡'
와 같은 방식으로 칼럼 update를 수행할 것이다.
하지만 DBMS의 UPDATE 권장 패턴에서는
여러개의 레코드를 수정, 변경하는 것을 지양하도록 한다.

또한, 만약 학생정보에 다른 정보를 포함하고 싶을 때는
tbl_score 테이블에 칼럼을 추가하는 등의 방식으로
처리를 해야하는데 
이 방식 또한 좋은 방식이 아니다.

그래서 학생정보 테이블을 생성하고
학생 코드를 만들어 준 다음,
tbl_score 테이블의 s_std칼럼의 값을 학생코드로 변경하여
제 2 정규화를 수행하고자 한다.

    단, tbl_score에 저장된 학생이름에 동명이인이 없다 라고 가정한다.(존재한다면 심각한 오류)
*/

-- 1. tbl_score 테이블로부터 학생이름을 추출하여 table로 생성
SELECT s_std
FROM tbl_score
GROUP BY s_std;


-- 2. 질의결과를 모두 선택하여 excel파일로 복사
-- excel 성적일람표, GRADE 테이블 명세 양식  참고
-- 3.학생정보 입력
-- 4. 학생정보 table 생성

CREATE TABLE tbl_student(
    st_num	VARCHAR2(5)		PRIMARY KEY,
    st_name	nVARCHAR2(50)	NOT NULL,
    st_tel	VARCHAR2(20),		    
    st_addr	nVARCHAR2(125),		
    st_grade	NUMBER(1)	NOT NULL,
    st_dept	VARCHAR(5)	NOT NULL	

);
-- 5. 엑셀로부터 데이터 import 후 확인까지 성공
SELECT COUNT(*) FROM tbl_student;

-- 6. tbl_score 테이블의 s_std칼럼의 값을
-- 학생이름 -> 학번으로 변경
-- 가. 임시 칼럼을 생성
ALTER TABLE tbl_score ADD s_stcode VARCHAR2(5);

-- 나. tbl_student와 tbl_score를 연결해서
--     tbl_student의 학번 정보를 tbl_score에 등록(sub query 이용)
SELECT COUNT(*) 
FROM tbl_score SC, tbl_student ST
    WHERE SC.s_std = ST.st_name;
    
-- tbl_score테이블의 List를 나열하고
-- 각 레코드의 s_std 칼럼의 값을
-- SUBQ로 전달하고
-- tbl_student 테이블에 해당하는 이름이 있으면
-- st_num 칼럼의 값을 추출하여 tbl_score테이블의 s_stcode 칼럼에 저장하라
UPDATE tbl_score SC
SET SC.s_stcode = 
   ( SELECT ST.st_num FROM tbl_student ST WHERE ST.st_name = SC.s_std);
   
   
   
SELECT SC.s_stcode, ST.st_num,
       SC.s_std, ST.st_name 
FROM tbl_score SC, tbl_student ST
     WHERE SC.s_stcode = ST.st_num;
     
     
     
     
-- tbl_score의 s_std칼럼을 삭제하고,
--      s_stcode칼럼을 s_std칼럼으로 이름 변경 ==> 기존의 다른 코드에서 s_std칼럼을 사용했기 때문에 오류방지를 위해 변경
ALTER TABLE tbl_score DROP COLUMN s_std;

ALTER TABLE tbl_score RENAME COLUMN s_stcode TO s_std;

SELECT * FROM tbl_score;
SELECT SC.s_id, SC.s_std, ST.st_name, ST.st_grade, ST.st_dept, SC.s_score 
FROM tbl_score SC, tbl_student ST
WHERE SC.s_std = ST.st_num;

SELECT SC.s_id, SC.s_std, ST.st_name, ST.st_grade, ST.st_dept, 
       SC.s_subject, SB.sb_name,
       SC.s_score 
FROM tbl_score SC
    LEFT JOIN tbl_student ST
        ON SC.s_std = ST.st_num
    LEFT JOIN tbl_subject SB
        ON SC.s_subject = SB.sb_code
ORDER BY ST.st_name, SB.sb_name;

CREATE TABLE tbl_dept(

    d_num	VARCHAR(5)		PRIMARY KEY,
    d_name	nVARCHAR2(30)	NOT NULL,	
    d_pro	nVARCHAR2(20),		
    d_tel	VARCHAR(20)		
);

SELECT * FROM tbl_dept;


SELECT SC.s_id, 
       SC.s_std, ST.st_name, ST.st_grade,
       ST.st_dept, DP.d_name, DP.d_tel,
       SC.s_subject, SB.sb_name,
       SC.s_score     
FROM tbl_score SC
    LEFT JOIN tbl_student ST
    ON SC.s_std = ST.st_num
    LEFT JOIN tbl_subject SB
    ON SC.s_subject = SB.sb_code
    LEFT JOIN tbl_dept DP
    ON ST.st_dept = DP.d_num
ORDER BY ST.st_name, SB.sb_name;


DROP VIEW view_score;
CREATE VIEW view_score
AS
(
SELECT SC.s_id, 
       SC.s_std, ST.st_name, ST.st_grade,
       ST.st_dept, DP.d_name, DP.d_tel,
       SC.s_subject, SB.sb_name,
       SC.s_score     
FROM tbl_score SC
    LEFT JOIN tbl_student ST
    ON SC.s_std = ST.st_num
    LEFT JOIN tbl_subject SB
    ON SC.s_subject = SB.sb_code
    LEFT JOIN tbl_dept DP
    ON ST.st_dept = DP.d_num
);

SELECT * FROM view_score;

SELECT * FROM tbl_subject;


/*
[DECODE]

DECODE( 칼럼, 값, T결과, F결과)
if(칼럼 == 값){
  println(T결과)
  }else{
  println(F결과)
  
  DECODE( 칼럼, 값, T결과, F결과)
if(칼럼 == 값){
  println(T결과)
  }else{
  println((null))  ==> null값은 안보이니까 false면 값이 안나타남
  
  sum으로 묶은 이유 : 학번과 학생이름을 한개씩 보여주기 위해 group by로 묶어야 하는데
  group by로 묶으려면 sum을 해야함
  
와 같은 의미
*/
SELECT s_std, st_name,d_name,st_grade,
     SUM(DECODE(s_subject, 'S001', s_score)) AS 과학,
     SUM(DECODE(s_subject, 'S002', s_score)) AS  수학,
     SUM(DECODE(s_subject, 'S003', s_score)) AS  국어,
     SUM(DECODE(s_subject, 'S004', s_score)) AS  국사,
     SUM(DECODE(s_subject, 'S005', s_score)) AS  미술,
     SUM(DECODE(s_subject, 'S006', s_score)) AS  영어,
     SUM(s_score) AS 총점,
     ROUND(AVG(s_score),1) AS 평균,
     RANK() OVER (ORDER BY SUM(s_score) DESC ) AS 석차    -- DESC를 빼면 낮은 점수가 1등이 됨
FROM view_score
GROUP BY s_std, st_name, d_name,st_grade
ORDER BY s_std ;

SELECT * FROM tbl_subject;    

SELECT *
FROM    
(
    SELECT s_std, st_name, d_name, st_grade, s_subject, s_score FROM view_score -- 원본데이터
)
PIVOT 
(
    SUM(s_score)
    FOR s_subject
    IN (
        'S001' AS 과학,
        'S002' AS 수학,
        'S003' AS 국어,
        'S004' AS 국사,
        'S005' AS 미술,
        'S006' AS 영어
        )
);

CREATE VIEW view_score_pv
AS
(
SELECT s_std, st_name,d_name,st_grade,
     SUM(DECODE(s_subject, 'S001', s_score)) AS 과학,
     SUM(DECODE(s_subject, 'S002', s_score)) AS  수학,
     SUM(DECODE(s_subject, 'S003', s_score)) AS  국어,
     SUM(DECODE(s_subject, 'S004', s_score)) AS  국사,
     SUM(DECODE(s_subject, 'S005', s_score)) AS  미술,
     SUM(DECODE(s_subject, 'S006', s_score)) AS  영어,
     SUM(s_score) AS 총점,
     ROUND(AVG(s_score),1) AS 평균,
     RANK() OVER (ORDER BY SUM(s_score) DESC ) AS 석차    -- DESC를 빼면 낮은 점수가 1등이 됨
FROM view_score
GROUP BY s_std, st_name, d_name,st_grade
);

SELECT * FROM view_score_pv;

-- 제 2 정규화과 완료된 4개의 TABLE을 서로 Relation 설정(= 참조무결성 제약조건 설정)
ALTER TABLE tbl_score
ADD CONSTRAINT FK_SCORE_SUBJECT
FOREIGN KEY(s_subject)
REFERENCES tbl_subject(sb_code);

ALTER TABLE tbl_score
ADD CONSTRAINT FK_SCORE_STUDENT
FOREIGN KEY(s_std)
REFERENCES tbl_student(st_num);

ALTER TABLE tbl_student
ADD CONSTRAINT FK_SCORE_DEPT
FOREIGN KEY(st_dept)
REFERENCES tbl_dept(d_num);




