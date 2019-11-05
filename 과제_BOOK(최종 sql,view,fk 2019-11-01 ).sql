CREATE VIEW view_rent
AS
(
SELECT
    
    RENT_SEQ,
    U_CODE,
    U_NAME,
    B_CODE,
    B_NAME,
    RENT_DATE,
    RENT_RETURN_YN
    
FROM tbl_rent_book R

    LEFT JOIN tbl_books B
    ON R.rent_bcode = B.b_code
    LEFT JOIN tbl_users U
    ON R.rent_ucode = U.u_code
);    

DROP VIEW view_rent;

DROP TABLE tbl_rent_book;

CREATE TABLE tbl_rent_book(

   RENT_SEQ	NUMBER	PRIMARY KEY,	
    RENT_DATE	VARCHAR2(10)	NOT NULL,	
    RENT_RETURN_DATE	VARCHAR2(10)	NOT NULL,
    RENT_BCODE	VARCHAR2(6)	NOT NULL,	
    RENT_UCODE	VARCHAR2(6)	NOT NULL,	
    RENT_RETURN_YN	VARCHAR2(1),		
    RENT_POINT	NUMBER DEFAULT 0	
    
);


CREATE SEQUENCE SEQ_BOOKS
START WITH 1 INCREMENT BY 1;

ALTER TABLE tbl_rent_book
ADD CONSTRAINT FK_USER 
FOREIGN KEY(rent_ucode)
REFERENCES tbl_users(u_code);

ALTER TABLE tbl_rent_book
ADD CONSTRAINT FK_BOOK
FOREIGN KEY (rent_bcode)
REFERENCES tbl_books(b_code);