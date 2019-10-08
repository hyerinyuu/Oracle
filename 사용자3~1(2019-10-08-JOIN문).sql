-- 여기는 user3 화면입니다.

-- JOIN : 보통 2개 이상의 테이블에 나뉘어서 보관중인 데이터를
--        서로 연계해서 하나의 리스트처럼 출력하는 SQL 명령형태

-- EQ / 완전 / 내부 JOIN 
-- 연계된 칼럼이 두 테이블간에 모두 존재할 경우
-- 두 테이블간에 완전 참조무결성이 보장되는 경우
-- 이 JOIN이 표시하는 리스트 ==> 카티션곱
SELECT * 
FROM tbl_books B, tbl_genre G
WHERE b.b_genre = g.g_code ;

-- EQ JOIN의 경우 
-- 두 테이블이 완전 참조무결성 조건에 위배되는 경우 결과가 신뢰성을 잃는다.                                    



--                                      [참조무결성 조건]
-- SELECT * 
-- FROM tableA, tableB
-- WHERE tableA_column = tableB_column ;
-- 두 테이블간에 join되는 칼럼은 양쪽 모두가 같아야함

--     (원본)[table A]            --       (참조)[table B]
------------------------------------------------------------
--     (칼럼값이)있다         >>            반드시 있다
-- 있을수있다(없어도 무관)    <<               있다
--         절대없다           <<               없다  

-- 이러한 조건이 이루어졌을때 완전한 참조무결성이 있다고 표현

-- 참조무결성 조건 = 테이블간에 EQ JOIN을 실행했을때 결과에 신뢰성을 보장하는 조건



-- 두 테이블간에 참조무결성을 무시하고 JOIN 실행하기
-- ex) 기존에 없던 장르번호의 새로운 도서가 입고되어 (참조테이블에 없는)새로운 장르코드를 생성해 등록해야하는 경우
INSERT INTO tbl_books(b_isbn, b_title, b_comp, b_writer, b_genre)
VALUES ('979-009','아침형인간', '하늘소식', '이몽룡', '010') ;
-- 만약 tbl_books 과 tbl_genre 간에 참조무결성 조건을 설정해 두었다면 tbl_books에 새 장르코드를 INSERT 수행 못함
-- 아직 참조무결성 조건을 설정하지 않아서 INSERT 가능
SELECT * 
FROM tbl_books B, tbl_genre G
WHERE b.b_genre = g.g_code ;
-- 결과 => 참조무결성이 무너져 새로 등록한 '아침형인간'책이 도서리스트에서 누락되어 출력됨 == 결과신뢰성을 잃게됨
-- 이런 상황이 발생했을 경우
-- 참조무결성을 무시하고 (일부)신뢰성이 있는 리스트를 보기 위해서 다른 JOIN을 수행한다.  ==> LEFT JOIN

/*
          [LEFT JOIN 기본형]
SELECT *
FROM 원본테이블
LEFT JOIN 참조 테이블
ON 조건
            ==> LEFT에 있는 table의 리스트는 모두 보여주고
                ON 조건에 일치하는 값이 오른쪽의 table에 있으면 값을 보이고,
                그렇지 않으면 null로 표현하라
*/

SELECT *
FROM tbl_books B        -- 리스트를 확인하고자 하는 table
LEFT JOIN tbl_genre G   -- 참조할 table
ON B.b_genre = g.g_code -- 참조할 칼럼 연계
ORDER BY B.b_isbn ;     -- 도서코드 순서로 정렬해서 보여라


-- 아주 많이 사용됨
-- tbl_book에 b_title이 '아침형인간'인 리스트를 보여주되
-- 만약 b_genre 칼럼값과 일치하는 값이 tbl_genre의 g_code 칼럼에 있으면 그 값을 찾아서 보여라(없으면 NULL)
SELECT *
FROM tbl_books B
    LEFT JOIN tbl_genre G
        ON B.b_genre = g.g_code
WHERE b.b_title = '아침형인간' ;

SELECT B.b_isbn, B.b_title, B.b_comp, B.b_writer, G.g_code, G.g_name
FROM tbl_books B
LEFT JOIN tbl_genre G
ON B.b_genre = G.g_code 
WHERE B.b_title LIKE 'SQL%'  -- 제목이 SQL로 시작되는 리스트
ORDER BY B.b_title ;

SELECT B.b_isbn, B.b_title, B.b_comp, B.b_writer, G.g_code, G.g_name
FROM tbl_books B
LEFT JOIN tbl_genre G
ON B.b_genre = G.g_code 
WHERE G.g_name = '장편소설' ;


--                  [SELECT로 TBL_BOOKS 리스트만 보면 되는데 굳이 JOIN써서 복잡하게 보는 이유]


-- ex) 장르가 '장편소설'인 도서정보를 '장르소설'로 장르 명칭을 변경하고 싶을 경우,
--     테이블이 각각 books와 genre로 나뉘어 있고
--     두 테이블을 JOIN 해서 사용하는 중이기 때문에
--     tbl_genre 테이블의 g_name 칼럼 값을 변경한다.

SELECT * FROM tbl_genre;

SELECT B.b_isbn, B.b_title, B.b_comp, B.b_writer, G.g_code, G.g_name
FROM tbl_books B
LEFT JOIN tbl_genre G
ON B.b_genre = G.g_code ;

-- tbl_books 리스트를 조회했더니 '장편소설'인 장르 데이터가 3개가 있는데 장편소설을 모두 '장르소설로' 변경하고 싶을 경우
-- UPDATE tbl_books
-- SET b_genre = '장편소설'
-- WHERE b_genre = '장편소설'   ==> 이와같은 코드를 쓰면 최소 2개 이상의 코드가 변경(UPDATE)된다.
--                                  하지만 DB에서 1개 테이블에 2개 이상의 레코드가 변경되는 UPDATE는
--                                  무결성을 해칠 수 있으므로 지양해야 하는 방법임(데이터 무결성 유지를 위해서)

UPDATE tbl_genre
SET g_name = '장르소설'
WHERE g_code = '003';

-- ==> 즉 UPDATE 나 DELETE 등의 명령을 수행할 때는 1개의 레코드만 변경해 여러 값을 변경할 수 있도록
--     설계당시에 설정해놔야 좋은 코드라고 할 수 있다.
-- 이러한 이유로 테이블을 분리하고, 두 테이블을 JOIN해서 리스트를 출력하는 복잡한 과정을 수행하는 것임(무결성 유지하려고)

-- 보통 1개의 테이블에 존재하는 데이터를 다수(2개)의 테이블로 분리하고
-- JOIN 을 수행할 수 있도록 구조를 변경하는 작업을 DB ***[제2 정규화(2ND NF)]***라고 한다.





















