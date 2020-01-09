--------------------------------------------------------
--  파일이 생성됨 - 목요일-1월-09-2020   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Table TBL_MEMBER
--------------------------------------------------------

  CREATE TABLE "TBL_MEMBER" 
   (	"M_ID" VARCHAR2(20 BYTE), 
	"M_PASSWORD" NVARCHAR2(125), 
	"M_LOGIN_DATE" NVARCHAR2(10), 
	"M_REM" NVARCHAR2(125)
   ) ;
REM INSERTING into TBL_MEMBER
SET DEFINE OFF;
--------------------------------------------------------
--  DDL for Index SYS_C007068
--------------------------------------------------------

  CREATE UNIQUE INDEX "SYS_C007068" ON "TBL_MEMBER" ("M_ID") 
  ;
--------------------------------------------------------
--  Constraints for Table TBL_MEMBER
--------------------------------------------------------

  ALTER TABLE "TBL_MEMBER" ADD PRIMARY KEY ("M_ID") ENABLE;
  ALTER TABLE "TBL_MEMBER" MODIFY ("M_PASSWORD" NOT NULL ENABLE);
