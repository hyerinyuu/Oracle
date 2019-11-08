-- Master Detail Table 관계설정
-- 더 많은 칼럼을 집어넣을 수도 있음
CREATE TABLE tbl_master(

    m_seq NUMBER PRIMARY KEY,
    m_subject nVARCHAR2(1000) NOT NULL
    
);


-- DEFAULT : INSERT를 수행할 때 칼럼의 값을 지정하지 않으면 무조건 N으로 저장(기본값 설정)
CREATE TABLE tbl_detail(
    
    d_seq NUMBER PRIMARY KEY,
    d_m_seq NUMBER NOT NULL,
    d_subject nVARCHAR2(1000) NOT NULL,
    d_ok VARCHAR2(1) DEFAULT 'N'
    
);
DROP TABLE tbl_detail;
DROP TABLE tbl_master;

DROP SEQUENCE SEQ_MASTER;
DROP SEQUENCE SEQ_DETAIL;


CREATE SEQUENCE SEQ_MASTER
START WITH 1 INCREMENT BY 1;

CREATE SEQUENCE SEQ_DETAIL
START WITH 1 INCREMENT BY 1;

ALTER TABLE tbl_detail
ADD CONSTRAINT FK_MD
FOREIGN KEY (d_m_seq)
REFERENCES tbl_master(m_seq);



INSERT INTO tbl_master(m_seq, m_subject)
VALUES(SEQ_MASTER.NEXTVAL, '다음 OSI 7계층 중 가장 하위 계층으로 맞는 것은?');

INSERT INTO tbl_detail(d_seq, d_m_seq, d_subject)
VALUES(SEQ_DETAIL.NEXTVAL,1,'전송계층');

INSERT INTO tbl_detail(d_seq, d_m_seq, d_subject)
VALUES(SEQ_DETAIL.NEXTVAL,1,'세션계층');

INSERT INTO tbl_detail(d_seq, d_m_seq, d_subject, d_ok)
VALUES(SEQ_DETAIL.NEXTVAL,1,'물리계층','Y');

INSERT INTO tbl_detail(d_seq, d_m_seq, d_subject)
VALUES(SEQ_DETAIL.NEXTVAL,1,'네트워크계층');



INSERT INTO tbl_master(m_seq, m_subject)
VALUES(SEQ_MASTER.NEXTVAL, '다음중 사용자의 데이터가 저장되는 메모리는?');

INSERT INTO tbl_detail(d_seq, d_m_seq, d_subject)
VALUES(SEQ_DETAIL.NEXTVAL, SEQ_MASTER.CURRVAL, 'cache');

INSERT INTO tbl_detail(d_seq, d_m_seq, d_subject)
VALUES(SEQ_DETAIL.NEXTVAL, SEQ_MASTER.CURRVAL,'ROM');

INSERT INTO tbl_detail(d_seq, d_m_seq, d_subject, d_ok)
VALUES(SEQ_DETAIL.NEXTVAL, SEQ_MASTER.CURRVAL,'RAM','Y');

INSERT INTO tbl_detail(d_seq, d_m_seq, d_subject)
VALUES(SEQ_DETAIL.NEXTVAL, SEQ_MASTER.CURRVAL,'Register');

DROP SEQUENCE SEQ_DETAIL;

SELECT * FROM tbl_detail;

-- 제 1 정규화 형식으로 보기
SELECT * 
FROM tbl_master, tbl_detail
WHERE m_seq = d_m_seq;

COMMIT;

/*

[TBL_MASTER]

M_SEQ : PARENT ID
M_SUBJECT

TBL_





