-- 관리자 화면
/*
TABLESPACE 생성
이름 : USER4_DB
DATAFILE : '/bizwork/oracle/data.user4.dbf'
초기용량 : 10MB
자동확장 : 10KB
*/
CREATE TABLESPACE USER4_DB
DATAFILE '/bizwork/oracle/data.user4.dbf'
SIZE 10M AUTOEXTEND ON NEXT 10K;


/*
사용자생성
ID : user4
PASSWORD : user4
DEFAULT TABLESPACE user4_db
권한 : DBA
*/
CREATE USER user4 IDENTIFIED BY user4
DEFAULT TABLESPACE user4_db;

GRANT DBA TO user4;



-- 사용자를 생성하면서 DEFAULT TABLESPACE를 생성하지 않으면 SYSTEM(관리자, 오라클 DBMS가 사용하는 영역)의
-- TABLESPACE를 사용하게 된다.
-- 작은 규모에서는 큰 문제가 없지만 
-- SYSTEM영역을 사용하는 것은 여러가지(특히 보안, 관리)측면에서 좋은 방법이 아님.


--          [혹시 DEFUALT TABLESPACE를 빼먹었을 경우 나중에 추가하는 방법]


--  ==> 사용과 관련하여 정보나 값들을 수정
-- 이미 생성된 사용자ID의 TABLESPACE를 변경
ALTER USER  user5 DEFAULT TABLESPACE user4_db;

-- 사용자를 생성하고, TABLE등을 생성한 후에
-- DAFUALT TABLESPACE를 변경하면 ??
-- 보통 DBMS에서 TABLE등을 TABLESPACE로 옮겨준다.
-- 하지만 DATA가많거나 하는 경우에는 문제를 일으키는 경우도 있으므로
-- 사용중(TABLE등이 있는) 경우에는 가급적 변경하지 않는 것이 좋다.

--      [기존의 TABLESPACE에 있는 TABLE들을 수동으로 다른 TABLESPACE로 옮기기]
-- 현재 사용자의 DEFAULT TABLESPACE에 있는 table을 다른 TABLESPCE에 옮기기
ALTER TABLE tbl_student MOVE TABLESPACE user4_db;
-- 만약 DEFAULT TABLESPACE를 생성하지 않고 데이터를 저장했을 경우,
-- 새로운 TABLESPACE를 생성하고 사용중이던 TABLE을 새로운 TABLESPACE로 옮기고
-- DEFAULT TABLESPACE를 병경하는 것이 좋겠다.

-- TABLESPACE를 통째로 backup하고 다른곳에 옮겨서 사용할 수 있도록 하는 방법 존재(ORACLE 10 이상에서만 가능)


--               [사용자의 PW를 변경하는 방법]
ALTER USER user4 IDENTIFIED BY user4 ;












