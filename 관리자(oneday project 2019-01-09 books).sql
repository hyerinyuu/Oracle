CREATE TABLESPACE bookspace
DATAFILE '/bizwork/oracle/data/bookspace.dbf'
SIZE 10M AUTOEXTEND ON NEXT 10K;


CREATE USER books IDENTIFIED BY books
DEFAULT TABLESPACE bookspace;

GRANT DBA to books;
