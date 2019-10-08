-- 주석(remark)문은 --로 시작한다.
-- 모든 명령문이 끝나는 곳에 ;를 붙여야한다.
-- oracle의 모든 keyword는 대소문자 관계 없음
-- 하지만 수업에서는 모든 keyword는 대문자로 작성할 예정
-- keyword가 아닌 것들은 소문자로 작성할 예정(구분을 위해)

-- 문자열이나 틀별한 경우는 대소문자를 구별하는 경우도 있다.
-- 이때는 대소문자 구분을 공지한다.

SELECT 30 + 40 FROM dual;
select 30 * 40 from dual;

-- 조회할 때 (SELECT할때) 컴마(,)로 구분을 하면
-- TABLE로 보요줄 때 column으로 구분하여 보여준다.
SELECT 30+40, 30*40, 40/2, 50-10 FROM dual;

-- 문자열은 작은따옴표(SQ, ')로 묶어준다 *큰따옴표 사용하지 않음
SELECT '대한민국' FROM dual;


-- || : oracle에서 문자열을 연결할 때 씀(db마다 다를 수 있음 ex &,+)
SELECT '대한' || '민국' FROM dual;
SELECT '대한', '민국', '만세', 'KOREA' FROM dual;

-- 조회할때 SELECT * FROM ??? 명령문을 사용하면 모든것을 보여달라는 의미
SELECT * FROM dual;

SELECT * FROM v$database;

