-- 여기는 user3 화면입니다.

-- 오라클 전용 System 쿼리
-- 현재 사용중인 DBMS 엔진의 전체적인 명칭 명칭, 정보 확인
SELECT * FROM v$database ;

-- 현재 사용자가 접근 (CRUD) 할 수 있는 TABLE 목록
SELECT * FROM TAB;

-- ***DBA급 이상의 사용자가 전체 TABLE 리스트를 확인할 수 있는 명령
SELECT * FROM ALL_TABLES; -- 모든 DATABASE를 다 보여줌

-- tbl_books의 테이블 구조(CREATE TABLE을 생성했을때의 모양)
-- DESC == DESCRIBE 다른 DB에서는 DESCRIBE라고 사용하는 경우도 있음
DESC tbl_books ;
DESCRIBE tbl_books;

-- SELECT * FROM TAB 과 거의 유사한 형태
-- 사용자 권한에 따라서 FROM TAB과 USER TABLES가 리스트가 다르게 나오는 경우 있음
SELECT * FROM user_tables;
