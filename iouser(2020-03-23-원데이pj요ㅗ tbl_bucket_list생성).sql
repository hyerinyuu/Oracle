CREATE TABLE tbl_bucket_list(
    bk_seq	number	PRIMARY KEY,
    bk_subject	nVARCHAR2(255) NOT NULL,
    bk_text	nVARCHAR2(1000) NOT NULL,
    bk_date	nVARCHAR2(30),
    bk_time	nVARCHAR2(30),
    bk_complete	VARCHAR2(1)	DEFAULT 'N'	
);

drop table tbl_bucket_list;

CREATE SEQUENCE SEQ_BUCKET
START WITH 1 INCREMENT BY 1; 

drop sequence SEQ_BUCKET;

INSERT INTO tbl_bucket_list(bk_seq,bk_subject,bk_text,bk_date, bk_time,bk_complete)
VALUES(SEQ_BUCKET.NEXTVAL, 'subject', 'text', '2020-03-23', '13:08:00', 'Y');

commit;