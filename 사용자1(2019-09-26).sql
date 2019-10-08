-- 여기는 user1 사용자 화면입니다.(최소한의 명령만 쓸 수 있도록 연결된 상태임)
SELECT 30 + 40 FROM dual ;

-- 현재 부여된 권한이 무엇인지 알려달라는 명령
-- == DBA가 나에게 무슨 역할을 부여했냐?
SELECT * FROM DBA_ROLE_PRIVS;  -- 오류
SELECT * FROM DBA_TAB_PRIVS;   -- 오류

SELECT * FROM USER_TAB_PRIVS;
SELECT * FROM USER_ROLE_PRIVS;





