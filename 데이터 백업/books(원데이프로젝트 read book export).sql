--------------------------------------------------------
--  파일이 생성됨 - 목요일-1월-09-2020   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Table TBL_READ_BOOK
--------------------------------------------------------

  CREATE TABLE "TBL_READ_BOOK" 
   (	"RB_SEQ" NUMBER, 
	"RB_BCODE" VARCHAR2(20 BYTE), 
	"RB_DATE" VARCHAR2(10 BYTE), 
	"RB_STIME" VARCHAR2(10 BYTE), 
	"RB_RTIME" NUMBER(10,3), 
	"RB_SUBJECT" NVARCHAR2(20), 
	"RB_TEXT" NVARCHAR2(400), 
	"RB_STAR" NUMBER
   ) ;
REM INSERTING into TBL_READ_BOOK
SET DEFINE OFF;
--------------------------------------------------------
--  DDL for Index SYS_C007071
--------------------------------------------------------

  CREATE UNIQUE INDEX "SYS_C007071" ON "TBL_READ_BOOK" ("RB_SEQ") 
  ;
--------------------------------------------------------
--  Constraints for Table TBL_READ_BOOK
--------------------------------------------------------

  ALTER TABLE "TBL_READ_BOOK" ADD PRIMARY KEY ("RB_SEQ") ENABLE;
  ALTER TABLE "TBL_READ_BOOK" MODIFY ("RB_DATE" NOT NULL ENABLE);
  ALTER TABLE "TBL_READ_BOOK" MODIFY ("RB_BCODE" NOT NULL ENABLE);
--------------------------------------------------------
--  Ref Constraints for Table TBL_READ_BOOK
--------------------------------------------------------

  ALTER TABLE "TBL_READ_BOOK" ADD CONSTRAINT "FK_READ_BOOKS" FOREIGN KEY ("RB_BCODE")
	  REFERENCES "TBL_BOOKS" ("B_CODE") ENABLE;
