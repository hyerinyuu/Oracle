--------------------------------------------------------
--  파일이 생성됨 - 목요일-1월-09-2020   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Table TBL_BOOKS
--------------------------------------------------------

  CREATE TABLE "TBL_BOOKS" 
   (	"B_CODE" VARCHAR2(20 BYTE), 
	"B_NAME" NVARCHAR2(125), 
	"B_AUTHER" NVARCHAR2(125), 
	"B_COMP" NVARCHAR2(125), 
	"B_YEAR" VARCHAR2(10 BYTE), 
	"B_IPRICE" NUMBER
   ) ;
REM INSERTING into TBL_BOOKS
SET DEFINE OFF;
Insert into TBL_BOOKS (B_CODE,B_NAME,B_AUTHER,B_COMP,B_YEAR,B_IPRICE) values ('979-11-625407-7-0','데스 바이 아마존','시로타 마코토','비즈니스북스','04/15/2019',15000);
Insert into TBL_BOOKS (B_CODE,B_NAME,B_AUTHER,B_COMP,B_YEAR,B_IPRICE) values ('979-11-888505-4-9','4주 만에 완성하는 레깅스핏 스트레칭','모리 다쿠로','북라이프','04/11/2019',13000);
Insert into TBL_BOOKS (B_CODE,B_NAME,B_AUTHER,B_COMP,B_YEAR,B_IPRICE) values ('979-11-888505-1-8','왕이 된 남자 2','김선덕','북라이프','04/10/2019',14000);
Insert into TBL_BOOKS (B_CODE,B_NAME,B_AUTHER,B_COMP,B_YEAR,B_IPRICE) values ('979-11-888505-0-1','왕이 된 남자 1','김선덕','북라이프','04/10/2019',14000);
Insert into TBL_BOOKS (B_CODE,B_NAME,B_AUTHER,B_COMP,B_YEAR,B_IPRICE) values ('979-11-625407-5-6','새벽에 읽는 유대인 인생 특강','장대은','비즈니스북스','04/10/2019',15000);
Insert into TBL_BOOKS (B_CODE,B_NAME,B_AUTHER,B_COMP,B_YEAR,B_IPRICE) values ('979-11-888504-7-1','왕이 된 남자 포토에세이','스튜디오 드래곤','북라이프','04/10/2019',25000);
Insert into TBL_BOOKS (B_CODE,B_NAME,B_AUTHER,B_COMP,B_YEAR,B_IPRICE) values ('979-11-625407-3-2','오토노미 제2의 이동 혁명','로렌스 번스 -  크리스토퍼 슐건','비즈니스북스','03/31/2019',22000);
Insert into TBL_BOOKS (B_CODE,B_NAME,B_AUTHER,B_COMP,B_YEAR,B_IPRICE) values ('979-11-625407-1-8','쓴다 쓴다 쓰는 대로 된다','후루카와 다케시','비즈니스북스','03/30/2019',13000);
Insert into TBL_BOOKS (B_CODE,B_NAME,B_AUTHER,B_COMP,B_YEAR,B_IPRICE) values ('979-11-625406-9-5','머니패턴','이요셉 -  김채송화','비즈니스북스','03/25/2019',15000);
Insert into TBL_BOOKS (B_CODE,B_NAME,B_AUTHER,B_COMP,B_YEAR,B_IPRICE) values ('979-11-625406-7-1','1日 1行의 기적','유근용','비즈니스북스','03/20/2019',13800);
Insert into TBL_BOOKS (B_CODE,B_NAME,B_AUTHER,B_COMP,B_YEAR,B_IPRICE) values ('979-11-888504-4-0','오늘도 울컥하고 말았습니다','정민지','북라이프','03/15/2019',13800);
Insert into TBL_BOOKS (B_CODE,B_NAME,B_AUTHER,B_COMP,B_YEAR,B_IPRICE) values ('979-11-888504-2-6','엘리트 제국의 몰락','미하엘 하르트만','북라이프','02/27/2019',16800);
Insert into TBL_BOOKS (B_CODE,B_NAME,B_AUTHER,B_COMP,B_YEAR,B_IPRICE) values ('979-11-625406-4-0','아주 작은 습관의 힘','제임스 클리어','비즈니스북스','02/26/2019',16000);
Insert into TBL_BOOKS (B_CODE,B_NAME,B_AUTHER,B_COMP,B_YEAR,B_IPRICE) values ('979-11-868053-9-8','그릿 GRIT(100쇄 기념 리커버 에디션)','앤절라 더크워스','비즈니스북스','02/20/2019',16000);
Insert into TBL_BOOKS (B_CODE,B_NAME,B_AUTHER,B_COMP,B_YEAR,B_IPRICE) values ('979-11-625406-1-9','일단 오늘 한 줄 써봅시다','김민태','비즈니스북스','02/15/2019',14000);
Insert into TBL_BOOKS (B_CODE,B_NAME,B_AUTHER,B_COMP,B_YEAR,B_IPRICE) values ('979-11-625405-9-6','뉴파워 - 새로운 권력의 탄생','제러미 하이먼즈 -  헨리 팀스','비즈니스북스','01/30/2019',18000);
Insert into TBL_BOOKS (B_CODE,B_NAME,B_AUTHER,B_COMP,B_YEAR,B_IPRICE) values ('979-11-888504-0-2','잊지 않고 남겨두길 잘했어','이유미','북라이프','01/29/2019',13500);
Insert into TBL_BOOKS (B_CODE,B_NAME,B_AUTHER,B_COMP,B_YEAR,B_IPRICE) values ('979-11-888503-8-9','아이의 뇌에 상처 입히는 부모들','도모다 아케미','북라이프','01/28/2019',13800);
Insert into TBL_BOOKS (B_CODE,B_NAME,B_AUTHER,B_COMP,B_YEAR,B_IPRICE) values ('979-11-625405-7-2','어떻게 팔지 답답할 때 읽는 마케팅 책','리처드 쇼튼','비즈니스북스','01/18/2019',15000);
Insert into TBL_BOOKS (B_CODE,B_NAME,B_AUTHER,B_COMP,B_YEAR,B_IPRICE) values ('979-11-625405-5-8','서른과 마흔 사이 나를 되돌아볼 시간','미리암 프리스','비즈니스북스','01/10/2019',15800);
Insert into TBL_BOOKS (B_CODE,B_NAME,B_AUTHER,B_COMP,B_YEAR,B_IPRICE) values ('979-11-888503-6-5','먹고사는 게 전부가 아닌 날도 있어서','노지양','북라이프','12/25/2018',13500);
Insert into TBL_BOOKS (B_CODE,B_NAME,B_AUTHER,B_COMP,B_YEAR,B_IPRICE) values ('979-11-888503-4-1','선생님 -  저 우울증인가요?','오카다 다카시','북라이프','12/20/2018',14800);
Insert into TBL_BOOKS (B_CODE,B_NAME,B_AUTHER,B_COMP,B_YEAR,B_IPRICE) values ('979-11-625405-2-7','관계의 품격','오노코로 신페이','비즈니스북스','12/15/2018',13500);
Insert into TBL_BOOKS (B_CODE,B_NAME,B_AUTHER,B_COMP,B_YEAR,B_IPRICE) values ('979-11-888503-2-7','백년 두뇌','하세가와 요시야','북라이프','11/29/2018',14000);
Insert into TBL_BOOKS (B_CODE,B_NAME,B_AUTHER,B_COMP,B_YEAR,B_IPRICE) values ('979-11-625405-0-3','세계미래보고서 2019','박영숙 -  제롬 글렌','비즈니스북스','11/24/2018',16500);
Insert into TBL_BOOKS (B_CODE,B_NAME,B_AUTHER,B_COMP,B_YEAR,B_IPRICE) values ('979-11-888503-0-3','진정한 나로 살아갈 용기','브레네 브라운','북라이프','11/23/2018',13500);
Insert into TBL_BOOKS (B_CODE,B_NAME,B_AUTHER,B_COMP,B_YEAR,B_IPRICE) values ('979-11-888502-8-0','반려견 증상 상식 사전','김보윤','북라이프','11/15/2018',14800);
Insert into TBL_BOOKS (B_CODE,B_NAME,B_AUTHER,B_COMP,B_YEAR,B_IPRICE) values ('979-11-888502-6-6','나를 사랑하는 일에 서툰 당신에게','안정현(마음달)','북라이프','10/31/2018',14000);
Insert into TBL_BOOKS (B_CODE,B_NAME,B_AUTHER,B_COMP,B_YEAR,B_IPRICE) values ('979-11-625404-8-0','대한민국 주식투자자를 위한 완벽한 재무제표 읽기','이강연','비즈니스북스','10/30/2018',20000);
--------------------------------------------------------
--  DDL for Index SYS_C007064
--------------------------------------------------------

  CREATE UNIQUE INDEX "SYS_C007064" ON "TBL_BOOKS" ("B_CODE") 
  ;
--------------------------------------------------------
--  Constraints for Table TBL_BOOKS
--------------------------------------------------------

  ALTER TABLE "TBL_BOOKS" ADD PRIMARY KEY ("B_CODE") ENABLE;
  ALTER TABLE "TBL_BOOKS" MODIFY ("B_AUTHER" NOT NULL ENABLE);
  ALTER TABLE "TBL_BOOKS" MODIFY ("B_NAME" NOT NULL ENABLE);
