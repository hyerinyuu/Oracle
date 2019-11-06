CREATE TABLE tbl_question(

    q_seq NUMBER PRIMARY KEY,
    q_ques nVARCHAR2(1000) NOT NULL
);

CREATE TABLE tbl_answer(

    a_seq NUMBER PRIMARY KEY,
    a_q_seq NUMBER NOT NULL,
    a_ques nVARCHAR2(1000) NOT NULL,
    a_ra VARCHAR2(1) DEFAULT 'N'
    
);

