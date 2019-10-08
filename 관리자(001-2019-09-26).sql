-- SQL명령어를 사용해 DBMS 학습 진행
-- oracle 11g의 명령세트 학습
-- 현재 최신 oracle 버전은 19c(거의 보급x), 18c인데
-- 현업에서 사용하는 oracle DBMS SW들이 아직 하위버전을 많이 사용해
-- 11위주의 명령세트(체계) 학습 예정

-- [마이그레이션 Migration ] : 버전업 또는 업그레이드
-- 하위버전에서 사용하던 데이터베이스(물리적 storage에 저장된 data들을)를
-- 상위버전 또는 다른 DBMS에서 사용할 수 있도록 변환, 변경, 이전하는 것.

-- oracle DBMS SW(== oracle DB 또는 oracle)를 이용해서 DB관리 명령어를 연습하기 위해
-- 연습용 data저장공간을 생성
-- oracle에서는 storage에 생성한 물리적 저장공간을 table space라고 함.
-- 기타 MySQL, MSSQL등등의 DBMS SW들은 물리적저장공간을 DATABASE라고 함.

-- DDL 명령을 사용해 TABLESPACE를 사용함
-- DDL 명령을 사용하는 사용자는? DBA(DataBase Administor, 데이터베이스 관리자)



-- DDL 명령에서 "생성한다" : CREATE
--      == 물리 SCHEMA를 생성한다는 의미
CREATE TABLESPACE; -- TABLESPACE 생성하기
CREATE USER; -- 새로운 접속사용자를 생성하기
CREATE TABLE; -- 구체적인 데이터를 저장할 공간을 생성하기

--              "삭제/제거" : DROP
--              "변경(수정이라고 표현하지x)" : ALTER

-- C:\bizwork\oracle\data
-- C:/bizwork/oracle/data


-- C:/bizwork/oracle/data/user1.dbf 파일 이름으로 물리적 저장소를 생성한다.
-- 그 저장소 이름은 앞으로 user1_DB라고 사용하겠다.
-- 초기 사이즈를 100M(Byte) 로 설정하라
CREATE TABLESPACE user1_DB
DATAFILE 'C:/bizwork/oracle/data/user1.dbf'
SIZE 100M ;
-- user1_DB라는 tablespace를 100M의 크기(초기사이즈)로 c:~~~에 dbf파일로 생성하라

-- user1_DB를 지우라는 명령(DROP)
-- DROP(삭제) 명령은 굉장히 위험한 명령이므로 문법이 까다롭다.
-- line45,46,47은 drop문법이므로 외우기(아직은 안외워도됨)
DROP TABLESPACE user1_DB
INCLUDING CONTENTS AND DATAFILES
CASCADE CONSTRAINTS;

-- TABLESPACE생성시의 기본 문법
-- user1_DB라는 이름으로 TABLESPACE를 생성하라
-- 물리적 저장공간은 C:/bizwork/oracle/data/user1.dbf 이다.
-- 초기에 100M(Byte)만큼의 공간을 확보해라
-- 만약 사용하는 중에 용량이 부족하면100K(Byte)씩 공간을 자동으로 추가해라.
CREATE TABLESPACE user1_DB
DATAFILE 'C:/bizwork/oracle/data/user1.dbf'
SIZE 100M AUTOEXTEND ON NEXT 100K;

-- 현재 이 화면에서 명령을 수행하는 사용자는 SYSDBA 권한을 가진 사람이다.
-- SYSDBA 권한은 system DB등을 삭제하거나 변경할 수 있기 때문에
-- 실습환경에는 가급적 꼭 필요한 명령외에는 사용하지 않는것이 좋다.


-- [실습을 위해서 새로운 사용자를 생성하기]
-- 관리자가 USER1 새로운 사용자를 등록하고
-- 임시로 비밀번호를 1234로 설정한다.
CREATE USER user1 IDENTIFIED BY 1234 

-- 그리고 앞으로 user1으로 접속하여 데이터를 추가하면
-- 그 데이터는 user1_DB TABLESPACE에 저장하라
DEFAULT TABLESPACE user1_DB ;

-- 현재 설치된 오라클DB에 생성되어있는 사용자를 보여달라
-- (사용자가 정상적으로 등록됐는지 확인하는 절차)
SELECT * FROM ALL_USERS ;

-- DML의 SELECT 명령은 데이터를 생성, 수정, 삭제 한 후에
-- 정상적으로 수행됐는지 확인하는 용도로도 사용된다.

-- oracle에서는 관리자가 새로운 사용자를 생성하면
-- 아무런 권한도 부여되지 않은 상태로 둔다.
-- 새로 생성된 사용자는 id, password를 입력해도 접속 불가능함.
-- 관리자는 새로 생성된 사용자에게 DBMS에 접속할 수 있는 권한을 부여한다.
-- 권한과 관련된 명령어 set을 DCL(Data Control Language)라고 한다.

-- [권한과 관련된 keyword]
-- 1. 권한 부여 : GRANT
-- 2. 권한 뺏기 : REVOKE
-- 새로 생성한 user1에게 권한 부여하는 연습
-- CREATE SESSION(접속설정, 접속생성) 권한을 user1에게 부여하라
GRANT CREATE SESSION TO user1 ;

-- user1에게는 CREATE SESSION 권한만을 부여했기 때문에
-- 여러 명령들을 사용하는 것이 거의 불가능하다
-- 오라클은 보안정책으로 새로 생성된 사용자가 어떤 명령을 수행하려면 
-- 사용할 수 있는 명령들을 일일이 부여해 주어야 한다.
-- 이러한 정책때문에 초기에 오라클 DBMS를 학습하는데 어려움이 있어
-- 일단 자세한 권한 정책을 학습하기에 앞서 표준 SQL 등을 학습하기가 용이하도록
-- 일반 사용자에게 DBA 권한을 부여하여 사용하자!

-- 오라클의 DBA권한
-- SYSDBA에 비해 상당히 제한적으로 부여된 권한으로
-- 일부 DDL명령, DML명령, 일부 DCL명령을 사용할 수 있는 권한을 갖는다.
GRANT DBA TO user1;

-- 권한을 회수하는 명령
REVOKE DBA FROM user1;

GRANT DBA TO user1 ;


