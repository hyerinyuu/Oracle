-- 성적일람표 테이블을 생성하고
-- 데이터 임포트를 실행한 후
-- 과목정보만 제 2 정규화 해보기

CREATE TABLE tbl_score(

    sc_seq	NUMBER		PRIMARY KEY,
    sc_name	nVARCHAR2(50)	NOT NULL,	
    sc_subject	nVARCHAR2(5)	NOT NULL,	
    sc_score	NUMBER	NOT NULL,	
    sc_sbcode	VARCHAR2(5),		
    sc_stcode	VARCHAR2(5)		
    
);

DROP TABLE tbl_subject ;

CREATE TABLE tbl_subject (

    sb_code	VARCHAR2(5)		PRIMARY KEY,
    sb_name	nVARCHAR2(50)	NOT NULL,	
    sb_pro	VARCHAR2(50)	

);

SELECT sc_subject FROM tbl_score
GROUP BY sc_subject;

SELECT * FROM tbl_subject;

SELECT COUNT(*)
FROM tbl_score, tbl_subject
WHERE sc_subject = sb_name;

UPDATE tbl_score
SET sc_sbcode = 
(
    SELECT sb_code 
    FROM tbl_subject
    WHERE sc_subject = sb_name    
);

SELECT * FROM tbl_score;

SELECT COUNT(*)
FROM tbl_score, tbl_subject
WHERE sc_sbcode = sb_code;

SELECT sc_sbcode, sc_name, sc_subject, sc_score
FROM tbl_score
    LEFT JOIN tbl_subject
        ON sc_subject = sb_code;


SELECT * FROM tbl_subject;
   
CREATE VIEW view_score 
AS
(
    
    


);

CREATE TABLE tbl_student (

    st_code	nVARCHAR2(5)		PRIMARY KEY,
    st_name	nVARCHAR2(50)	NOT NULL,	
    st_tel	VARCHAR2(20),		
    st_addr	nVARCHAR2(125),		
    st_grade	NUMBER,		
    st_dcode	VARCHAR2(5)		

);
