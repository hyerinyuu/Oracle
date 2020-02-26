-- 여기는 관리자화면
-- 1. tablespace 생성
CREATE TABLESPACE bbs_final_ts
DATAFILE 'c:/bizwork/oracle/data/bbs_final.dbf'
SIZE 10M AUTOEXTEND ON NEXT 1K;

-- 2. 사용자 등록, 테이블 스페이스 연동
CREATE USER bbsfinal IDENTIFIED BY bbsfinal
DEFAULT TABLESPACE bbs_final_ts;

-- 3. DBA 권한 부여
GRANT DBA TO bbsfinal;
