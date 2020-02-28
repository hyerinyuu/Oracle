-- BBS_Final
CREATE SEQUENCE SEQ_BBS
START WITH 1 INCREMENT BY 1;
COMMIT;


/*
    오라클에는 *LOB 형태의 칼럼 타입이 있다.
    - CLOB : 대용량 문자열을 저장하는 칼럼, 최대 4GB
    - BLOB : 대용량 바이너리 타입을 저장하는 칼럼, 최대 4GB
    - BFILE : 대용량의 바이너리 파일데이터를 인코딩하여 저장, 최대 4GB
    
    하지만 이와같은 type은 
    select나 insert를 수행할 때 속도가 상당히 저하되므로 오라클에서 권장하는 방식은 아님
    
    
    [VARCHAR2를 CLOB로 변경할 때]
    
    1. 새로운 임시 칼럼을 만들고
    ALTER TABLE tbl_bbs ADD(b_content_b CLOB);
    2. 기존 칼럼 데이터를 새로만든 다음
    UPDATE tbl_bbs SET b_content_b = b_content;
    3. 기존 칼럼을 삭제하고
    ALTER TABLE tbl_bbs DROP COLUMN b_content;
    4. 새로만든 임시 칼럼을 기존 칼럼이름으로 변경
    ALTER TABLE tbl_bbs_final RENAME COLUMN b_content_b = b_content;
    
    하면 데이터를 날리지 않고 VARCHAR2를 CLOB로 변경할 수 있다.
    (그냥 ALTER는 오류가 발생해서 직접 변경이 안됨
    ex) ALTER TABLE tbl_bbs_final MODIFY(b_content CLOB)
    )
    
*/
ALTER TABLE tbl_bbs_final DROP COLUMN b_content;
ALTER TABLE tbl_bbs_final ADD(b_content CLOB);

COMMIT;

CREATE TABLE tbl_comment(
    
    C_ID NUMBER PRIMARY KEY,
    C_B_ID NUMBER NOT NULL,  -- 게시글과 연동 칼럼
    C_P_ID NUMBER,           -- 댓글에 댓글을 달기 위한 칼럼
    C_DATE_TIME VARCHAR2(30) NOT NULL,
    C_WRITER nVARCHAR2(30) NOT NULL,
    C_SUBJECT nVARCHAR2(125) NOT NULL
);

CREATE SEQUENCE SEQ_COMMENT
START WITH 1 INCREMENT BY 1;

drop sequence seq_comment;
drop table tbl_comment;

SELECT * FROM tbl_comment;


