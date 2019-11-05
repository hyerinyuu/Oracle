CREATE TABLE TBL_cbt(

    cb_code	VARCHAR2(5)		PRIMARY KEY,
    cb_quest	nVARCHAR2(125)	NOT NULL,	
    cb_one	nVARCHAR2(125) NOT NULL,		
    cb_two	nVARCHAR2(125) NOT NULL,		
    cb_three	nVARCHAR2(125) NOT NULL,		
    cb_four	nVARCHAR2(125) NOT NULL,		
    cb_ra	VARCHAR2(5)	
    
);

DROP TABLE tbl_cbt;