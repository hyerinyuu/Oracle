-- 관리자 화면
/*
    TABLESPACE 생성
    이름 : grade_DB
    데이터파일 : C:/bizwork/oracle/data/grade.dbf
    초기사이즈 : 10MB
    자동증가옵션 : 10K
*/

CREATE TABLESPACE grade_db
-- C:은 빠져도 됨
DATAFILE 'C:/bizwork/oracle/data/grade.dpf'
-- MB KB 같이 뒤에 M을 붙이면 오류가 나니까 그냥 M/K만 쓰기
SIZE 10M AUTOEXTEND ON NEXT 10K; 

/*
    사용자 생성 : (=오라클에서는 스키마생성이라고도 함) DB들을 관리하는 주체
    ID : grade
    PW : grade
    권한 : DBA
    DEFAULT TABLESPACE : grade_DB
*/
CREATE USER grade IDENTIFIED BY grade
DEFAULT TABLESPACE grade_db;

GRANT DBA TO grade;

-- 만든 사용자의 정보 확인해보기(ID와 생성날짜만 확인가능(비밀번호는 암호화))
SELECT * FROM ALL_USERS WHERE username = 'GRADE';


-- 사용자의 비밀번호 변경하고 싶을 때
ALTER USER grade IDENTIFIED BY grade;