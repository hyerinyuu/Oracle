-- 관리자화면
-- 매입매출 관리를 수행할 TABLESPACE, USER 생성
/*
이름 : iolist_DB
파일 : /bizwork/oracle/data/iolist.dbf
초기크기 : 50M
자동확장 : 10K
*/
CREATE TABLESPACE iolist_DB
DATAFILE '/bizwork/oracle/data/iolist.dbf'
SIZE 50M AUTOEXTEND ON NEXT 10K;

/*
사용자 생성
ID : iolist
PASSWORD :  iolist
권한 : DBA
DEFAULT TABLESPACE : iolist_DB
*/
CREATE USER iolist IDENTIFIED BY iolist
DEFAULT TABLESPACE iolist_DB;

GRANT DBA TO iolist;

