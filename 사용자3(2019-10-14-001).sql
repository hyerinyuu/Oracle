-- USER3 화면입니다.

-- DUAL 시스템 Table
-- Dummy Table이라고 한다.
-- 표준 SQL에서는 일반적인 프로그ㅜ래밍 코드에서 사용하는
-- 간단한 연산을 SELECT문을 이용해서 실행할 수 있도록 하고 있다.
-- SELECT 30+40
-- 오라클에서는 SELECT 다음에 FROM절이 없으면 문법오류를 발생하도록 설계되어있음
-- 그래서 표준 SQL에서 사용하는 간단한 코드를 실행하기가 매우 까다롭다.
-- 그래서 문법오류를 방지하고 간단한 코드를 실행하도록 하기 위해서
-- DUAL이라는 DUMMY TABLE을 준비 해두었다.
SELECT * FROM DUAL;
SELECT '1' AS num, '홍길동' AS name, '컴공과' AS dept FROM DUAL;

-- 위의 DUAL TABLE을 이용한 간단한 코드를 실제 데이터가 있는
-- TABLE을 상대로 실행하면 TABLE에 저장된 데이터 개수만큼
-- 반복 되어서 실행이 된다.
-- 그래서 1개의 레코드만 가진 DUMMY TABLE을 준비해 두고
-- 이 테이블을 활용하여 코드를 실행하도록 하는 것
SELECT '1' AS num, '홍길동' AS name, '컴공과' AS dept FROM tbl_student;

-- 가상의 데이터를 하나 만들어 보기
-- (실제로는 존재하지 않지만 마치 테이블이 존재하는 것처럼 보여줌)

--                  [UNION](KEYWORD)
-- 여러 테이블을 묶어서 마치 하나의 결과처럼 보고자 할 때 사용
SELECT '1' AS num, '홍길동' AS name, '컴공과' AS dept FROM DUAL
UNION ALL SELECT '2' AS num, '이몽룡' AS name, '컴공과' AS dept FROM DUAL
UNION ALL SELECT '3' AS num, '성춘향' AS name, '컴공과' AS dept FROM DUAL
UNION ALL SELECT '4' AS num, '장보고' AS name, '컴공과' AS dept FROM DUAL
UNION ALL SELECT '5' AS num, '임꺽정' AS name, '컴공과' AS dept FROM DUAL
UNION ALL SELECT '6' AS num, '장영실' AS name, '컴공과' AS dept FROM DUAL
UNION ALL SELECT '7' AS num, '장길산' AS name, '컴공과' AS dept FROM DUAL;

-- 실제 사용하는 DBMS에 물리적인 테이블을 생성하지 않고
-- 가상의 데이터를 만들어서 사용하고자 할 때 임시로 table구조와 데이터를 생성하여
-- 테이트 용도로 사용하는 명령 군
-- 이 명령 군을 사용할 때 UNION이라는 키워드를 사용한다.

SELECT * FROM tbl_score;


SELECT '=====' AS 학번, '====' AS 국어, '====' AS 영어, '====' AS 수학 FROM DUAL
UNION ALL SELECT '학번' AS 학번, '국어' AS 국어, '영어' AS 영어, '수학' AS 수학 FROM DUAL
UNION ALL SELECT '=====' AS 학번, '====' AS 국어, '====' AS 영어, '====' AS 수학 FROM DUAL
UNION ALL SELECT s_num AS 학번, to_char(s_kor,'999') AS 국어, 
                                to_char(s_eng, '999') AS 영어, 
                                to_char(s_math, '999') AS 수학 FROM tbl_score
UNION ALL SELECT '------' AS 학번, '-----' AS 국어, '-----' AS 영어, '-----' AS 수학 FROM DUAL
UNION ALL SELECT '총점' AS 학번, to_char(SUM(s_kor),'99,999') AS 국어,
                                to_char(SUM(s_eng), '99,999') AS 영어, 
                                to_char(SUM(s_math),'99,999') AS 수학 FROM tbl_score
UNION ALL SELECT '=====' AS 학번  , '======' AS 국어, '=====' AS 영어, '=====' AS 수학 FROM DUAL;

-- to char(값, 형식)
-- 숫자형 자료를 문자열형 자료로 변환시키는 cascading 함수
-- 형식
-- 9 :  숫자 자릿수를 나타내는 형식, 실제 출력되는 값의 자릿수만큼 개수를 지정 해야한다.
--      to_char(123, '9999') >>  123
-- 0 : 숫자 자릿수를 나타내는 형식, 실제 출력되는 값보다 자릿수가 많으면 나머지는 0으로 채움
--      to_char(123,'0000') >> 00123
-- , : 천단위 구분 기호
--      to_char(1234567, '9,999,9999')  >> 1,234,567
-- , : 천단위 구분 기호
--      to_char(1234567, '9,999,9999')  >> 1,234,567

-- 날짜형 데이터를 문자열형으로 바꿀 때
--      YYYY : 연도형식으로 표시
--      RR   : 연도형식
--      MM   : 월 형식
--      DD   : 일 형식
--      HH   : 12시간제 시간
--      HH24 : 24시간제 시간
--      MI   : 분
--      SS   : 초
-- to_char(날짜값, 'YYYY-MM-DD HH:MI:SS')

-- SYSDATE 오라클에서 현재 컴퓨터의 시간과 날짜를 가져오는 시스템 변수
SELECT to_char(SYSDATE, 'YYYY-MM-DD HH:MI:SS') FROM DUAL;

-- UNION
-- 테이블의 결과를 결합하여 하나의 VIEW 처럼 보여주는 형식
/*
======================================================
        UNION                      UNION ALL
======================================================
      중복데이터                 무조건 결합        
        배제                  중복데이터 모두 표시
        
    내부적으로
    SORT 작동
    
    중복제가
    작업으로
    쿼리가 
    늦어질 수 있다.
=======================================================
*/

-- 임시로 사용할 테이블 생성
-- WITH ~~ TEPM; : 아래 LINE115 ~ 122를 오라클 형식으로 만든 것
-- 원본 데이터를 만들어서 tbl_temp라는 이름을 붙이고 select문을 이용해 테스트를 수행한 것
-- with 로 테이블을 선언하고 테이블에 포함될 데이터들을 나열하는 패턴
WITH tbl_temp AS 
(

    SELECT '1' AS num, '홍길동' AS name FROM DUAL
    UNION ALL SELECT '2' AS num, '이몽룡' AS name FROM DUAL
    UNION ALL SELECT '3' AS num, '성춘향' AS name FROM DUAL
    UNION ALL SELECT '4' AS num, '임꺽정' AS name FROM DUAL
    UNION ALL SELECT '5' AS num, '장보고' AS name FROM DUAL 
)
SELECT * FROM tbl_temp;

-- 표준 SQL에서 사용하는 가장 간단한 SUBQUERY
-- 어떤 table의 결과를 FROM으로 받아서
-- 다시 SELECT를 수행하는 SQL
SELECT * FROM (
    SELECT '1' AS num, '홍길동' AS name FROM DUAL
    UNION ALL SELECT '2' AS num, '이몽룡' AS name FROM DUAL
    UNION ALL SELECT '3' AS num, '성춘향' AS name FROM DUAL
    UNION ALL SELECT '4' AS num, '임꺽정' AS name FROM DUAL
    UNION ALL SELECT '5' AS num, '장보고' AS name FROM DUAL 
);


-- 가상의 메모리에만 존재하는 테이블
-- 테이블을 만들고 지우는 것은 메모리에 큰 부담이 될 수 있으므로 가상의 데이터를 만들어서 이용하는 목적
WITH tbl_temp AS 
(
    SELECT '1' AS num, '홍길동' AS name FROM DUAL
    UNION ALL SELECT '2' AS num, '이몽룡' AS name FROM DUAL
    UNION ALL SELECT '3' AS num, '성춘향' AS name FROM DUAL
    UNION ALL SELECT '4' AS num, '임꺽정' AS name FROM DUAL
    UNION ALL SELECT '5' AS num, '장보고' AS name FROM DUAL 
)
SELECT * FROM tbl_temp
WHERE num IN ( '3', '1', '5')
ORDER BY name;

SELECT * FROM tbl_student;
-- 기은성, 남도예, 내세원, 갈한수, 방재호, 배재호

SELECT * FROM tbl_student
WHERE st_name IN ('기은성', '남동예', '내세원', '갈한수', '방채호', '배재호');


-- SUB QUERY
-- 1. WHERE 절에 사용하는 SUBQ
--  SUQQ 중에 가장 많이 사용하는 것
--  중첩(SUB)쿼리 라고도 한다.
WITH tbl_temp AS 
(
    SELECT '기은성' AS name FROM DUAL
    UNION ALL SELECT '남동예' AS name FROM DUAL
    UNION ALL SELECT '내세원' AS name FROM DUAL
    UNION ALL SELECT '방채호' AS name FROM DUAL
    UNION ALL SELECT '배재호' AS name FROM DUAL 
)
SELECT * 
FROM tbl_student 
WHERE st_name IN ( SELECT name FROM tbl_temp);

/*
    WHERE절에 포함된 SELECT를 실행 : SELECT name FROM tbl_temp
    '기은성', '남동예', '내세원', '방채호', '배재호' 리스트를 생성하고
    WHERE IN ('기은성', '남동예', '내세원', '방채호', '배재호') 코드를 생성한다.
    
    그리고 이 WHERE절을 사용해서
    tbl_student의 데이터를 조회한다.
*/

-- 2. FROM절에 포함되는 SUBQ
-- 인라인뷰라고 하며 다른 TABLE의 결과를 FROM절에서 사용하는 것
-- 여러가지 테이블을 결합하여 나오는 결과값들을 모아서 하나의 쿼리로 연결하여
-- VIEW로 보여주기 위한 SQUERY
-- 인라인뷰는 EQ JOIN을 대신해 사용하기도 함
-- EX) SELECT * FROM tbl_score2, tbl_student
SELECT * FROM
(SELECT * FROM tbl_student WHERE st_grade = '1');

SELECT * 
FROM tbl_score2 SC, tbl_student ST
    WHERE SC.s_num = ST.st_num;
 
-- 단순한 join을 이용해서 보여주기 어려운 복잡한 통계, 집계등을 사용할 때
-- 먼저 SUBQ에서 통계, 집계등을 계산하고
-- 그 결과와 MAIN TABLE을 JOIN 하고자 할 때
SELECT *
FROM tbl_student ST,
    (
        SELECT SC.s_num, 
        SC.s_kor + SC.s_eng + SC.s_math FROM tbl_score2 SC
    ) SC_S
WHERE ST.st_num = SC_S.s_num ;

-- 3.SELECT SUB
-- 스칼라브 쿼리
-- 1,2 쿼리와 달리 SUBQ에서는 절대 LIST를 출력하면 안된다.
-- SUBQ에서는 단 1줄의 RECORD만 결과로 나와야 한다.

SELECT st_num,
    (
        SELECT SUM(s_kor + s_eng + s_math) 
        FROM tbl_score SC
        WHERE ST.st_num = SC.s_num
    )
FROM tbl_student ST;

-- ( ) 괄호 안의 코드가 가장 마지막에 실행됨
-- 학번부분을 리스트로 학생번호 리스트로 나열한 후
-- 서브쿼리(=())는 자바의 method개념으로 이해하면 됨
-- (for문을 이용해 회전(반복) 시키면서 score에서 stNum을 찾아 칼럼을 덧셈한 후 )
-- (where문이 매개변수를 자동으로 전달)
-- sum부분이 마치 return처럼 작용
-- 학번을 서브쿼리에 매개변수로 전달 score에서 찾아서 리턴 하라
-- ###
-- 가. tbl_student 테이블을 for()반복문으로 반복하기
-- 나. tbl_student의 st_num 칼럼 값을 sub쿼리에 전달
--      subq는 마치 method처럼 작동
-- 다. subq에서는 WHERE절을 실행하여 데이터를 추출하고
-- 라. SUM(s_kor + s_eng + s_math) 를 실행하여
-- 마. 결과를 return
-- 바. main에서 st_num, 리턴받은 결과 형식으로 표시
SELECT s_num, s_kor, s_eng,
    (
        SELECT SUM(s_kor + s_eng + s_math) 
        FROM tbl_score SC
        WHERE SC_MAIN.s_num = SC.s_num
    ) AS 총점
FROM tbl_score SC_MAIN;

