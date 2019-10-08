-- [git hub에 프로젝트를 업로드하는 법]

-- 불필요한 파일이나 비밀번호가 입력된 파일 등
-- 업로드 하지 않아야 될 파일들은
-- git 폴더에 .gitignore 파일을 만들고
-- 파일의 이름, 폴더, 이름들을 기록해 주면 된다.
-- test.java 라고 기록하면 test.java 파일은 git hub에 업로드가 되지 않는다.
-- data/ 라고 기록하면 git 폴더 아래에 data 폴더의 모든 파일은 업로드 되지 않는다.
-- 단, 최초에 프로젝트를 올릴때 .gitinnore를 먼저 설정해 두어야 한다.
-- 이미 업로드가 된 파일이나 폴더는 삭제하기가 매우 까다로움

-- bizwork/oracle 폴더를 업로드 하기 전에 .gitignore 파일을 만들고(vi .gitignore)
-- data/라고 기록 추가




-- [tbl_student 테이블에 데이터를 추가하고, 조회하기]

SELECT * FROM tbl_student ;

-- [기존데이터를 삭제하고 추가하기]
DELETE FROM tbl_student ; 

INSERT INTO tbl_student(st_num, st_name, st_addr, st_tel)
VALUES ('A0001','홍길동','서울특별시','010-111-1234') ;

INSERT INTO tbl_student(st_num, st_name, st_addr, st_tel)
VALUES ('A0002','이몽룡','익산시','010-222-1234') ;

INSERT INTO tbl_student(st_num, st_name, st_addr, st_tel)
VALUES ('A0003','성춘향','남원시','010-333-1234') ;

INSERT INTO tbl_student(st_num, st_name, st_addr, st_tel)
VALUES ('A0004','장길산','충청남도','010-444-1234') ;

INSERT INTO tbl_student(st_num, st_name, st_addr, st_tel)
VALUES ('A0005','장보고','해남군','010-555-1234') ;

--[데이터를 추가할 때 주의해야 할 점]
-- [TABLE](칼럼리스트) 와 VALUES(값리스트) 는
-- 반드시 개수와 순서가 서로 일치해야 한다.
-- 개수가 일치하지 않으면 오류가 발생하고,
-- 순서가 일치하지 않으면 엉뚱한 순서로 데이터가 추가된다.

-- 아래 코드는 데이터가 데이터가 모두 String형이기 때문에 입력은 되지만 엉뚱한 순서로 입력됨
INSERT INTO tbl_student(st_num, st_name, st_addr, st_tel)
VALUES ('A0006','임꺽정','010-666-1234','함경도') ;


-- 1.~4. ==> 칼럼과 관련된 내용
-- 1. 모든 데이터를 조건 없이 보여라
--      보이기만 하는 명령이기 때문에 특별히 다른 명령어를 추가하지 않는 이상
--      추가된 모든 데이터만 보이고 데이터의 변경은 이루어지지 않음
SELECT * FROM tbl_student ;

-- 2. tbl_student에서 학번/이름/주소/전화번호를 제외한 다른 칼럼은 리스트에 안보이게 하는법
SELECT st_num, st_name, st_addr, st_tel
FROM tbl_student ;

-- 3. tbl-student에서 이름/학번,전화번호,주소 순서로 칼럼을 리스트에 보이게 하는 법(내가 보고싶은 칼럼 순서대로)
SELECT st_name, st_num, st_tel, st_addr
FROM tbl_student;

-- 4-1. 칼럼에 리스트를 볼 때 원래의 칼럼 이름 대신 별명을 사용하는 방법(표준 SQL)
-- 표준 SQL은 [AS 별명] 형식으로 사용해야 함.
SELECT st_num AS 학번, st_name AS 이름, st_tel AS 전화번호, st_addr AS 주소
FROM tbl_student ;

-- 4-2. 칼럼에 리스트를 볼 때 원래의 칼럼 이름 대신 별명을 사용하는 방법(ORACLE SQL)
-- ORACLE SQL은 AS를 생략하고 별명만 뒤에 추가하면 됨
-- AS를 빼야하는 경우에 사용 가능하지만 필요한 경우가 아니면 표준 SQL 사용하기
SELECT st_num  학번, st_name 이름, st_tel 전화번호, st_addr 주소
FROM tbl_student ;




-- [데이터 리스트(row, recored) 중에서 필요한 부분만 보고 싶을 때]

-- 1. tbl_student에 보관중인 데이터 중에서 이름이 '홍길동'인 리스트만 보이는 방법
-- WHERE 조건 절
-- == java if(tbl_student.st_name == "홍길동") viewList()
SELECT * FROM tbl_student
WHERE st_name = '홍길동'; -- ==>tbl_student의 전체 데이터 중 이름이 홍길동인 데이터들을 모두 보여줌


-- 동명이인인 홍길동 데이터를 추가
INSERT INTO tbl_student(st_num, st_name, st_addr, st_tel)
VALUES ('A0007','홍길동','부산광역시','010-777-1234') ;

SELECT * FROM tbl_student
WHERE st_name = '홍길동'; 

-- tbl_student 테이블에서 이름(st_name)이 홍길동인 데이터를 찾아서
-- 학번, 이름, 전화번호 칼럼만 보여달라
SELECT st_num, st_name, st_tel
FROM tbl_student
WHERE st_name = '홍길동' ;


SELECT * FROM tbl_student;
-- SELECT 명령문을 사용할 때
-- 칼럼 리스트를 *로 사용하지 않고 필요한 칼럼만 나열해 주는 것이
-- 많은 양의 데이터를 조회할때 속도면에서 다서 유리함.(*쓰는걸 지양해라)
-- 조회를 한 후 특정 칼럼의 값을 응용프로그램에서 사용하려고 하는 경우
-- 위치(index)로 칼럼 값을 추출했을때
-- 정확히 원하는 위치값을 보장하여 오류를 줄일 수 있다.

-- 모든 칼럼을 조회하고 싶어도 *를 쓰지 말고 코드가 다소 길어지더라도 칼럼이름을 나열해서 조회하기
-- projection : 칼럼리스트를 나열하는 것
SELECT st_num, st_name, st_tel, st_addr, st_grade, st_dept, st_age
FROM tbl_student;

-- 학생 테이블에서 이름이 홍길동이고 주소가 서울특별시인 데이터만 보기

-- [다중 조건 조회] 

--  1. AND 조건 : 두 조건이 모두 TRUE인 리스트만 보여줌
SELECT * FROM tbl_student
WHERE st_name = '홍길동' AND st_addr = '서울특별시' ;

-- 2-1. OR 조건 :  여러 조건 중 한가지라도 TRUE인 리스트를 보여줌(포함된 값을 보고 싶을 때)
SELECT * FROM tbl_student
WHERE st_name = '홍길동' OR st_name = '이몽룡' ;


-- tbl_table 에서 이름이 홍길동 이거나 주소가 서울특별시 인 데이터를 조회
SELECT * FROM tbl_student
WHERE st_name = '홍길동' OR st_addr = '서울특별시' ;

-- tbl_table 에서 이름이 이몽룡 이거나 주소가 남원시 인 데이터를 조회
SELECT * FROM tbl_student
WHERE st_name = '이몽룡' OR st_addr = '남원시' ;

-- 칼럼값들을 서로 연결해서 한개의 문자열처럼 리스트를 보는 방법
-- 연결 ==> oracle : ||  /  타DB : &(가장 많이 사용)  / java : +
SELECT st_num || ' + ' || st_name || ' + ' || st_tel AS 칼럼
FROM tbl_student ; --  ==> 0001 + 홍길동 + 010-111-1234

SELECT st_num || ':' || st_name || ':' || st_tel AS 칼럼
FROM tbl_student ; -- ==> 0001:홍길동:010-111-1234



--  [부분 문자열 조건 조회] keyword(연산자) : LIKE 
-- ==> SELECT 조회문 중에서 속도가 가장 느림(데이터가 많으면 속도가 매우 느려짐) 
--     INDEX라던가 기법들을 사용하여 SELECT의 속도를 높이려고 만든 것들을 무력화시킴


-- 문자열칼럼에 저장된 값의 일부분만 조건으로 설정하는 방법
-- 데이터를 추가하면서
-- 주소는 어떤 데이터는 '서울특별시'라고 하고
--        어떤 데이턴는 '서울시' 라고 했다.
-- 이럴경우, 서울특별시라고 조회를 하면 서울시인 데이터는 보이지 않고
-- 서울시 라고 조회를 하면 서울특별시 데이터는 보이지 않게 된다.
-- 이럴 때 '서울'이라는 문자열이 포함된 모든 데이터를 보고 싶을때
-- [부분 문자열 조건 조회] 를 사용한다.
-- %(표준SQL)

SELECT * FROM tbl_student
WHERE st_addr = '서울시' ;

-- tbl_student의 주소칼럼에 저장된 문자열이 '서울'이라는 문자열로 ##시작## 되는 데이터를 보여라
SELECT * FROM tbl_student
WHERE st_addr LIKE '서울%' ; -- 홍길동

-- tbl_student의 주소칼럼에 저장된 문자열이 '시'이라는 문자열로 ##끝나는## 데이터를 보여라
SELECT * FROM tbl_student
WHERE st_addr LIKE '%시' ; -- 서울특별시, 익산시, 남원시, 부산광역시

-- 중간문자열 검색 [%검색하고싶은 문자열%]
-- tbl_student의 주소칼럼에 저장된 이름문자열 중간에 '길'이라는 문자열이  ##포함된## 모든 데이터를 보여라
SELECT * FROM tbl_student
WHERE st_name LIKE '%길%' ; -- 홍길동(서울), 장길산, 홍길동(부산)


-- SQL에서는 입력되는 데이터의 길이가 일정할때
-- 데이터 type이 문자열형이어도 비교연산자(<>)를 사용해서 데이터를 추출할 수 있음
SELECT * FROM tbl_student
WHERE st_tel >= '010-111-1234' AND st_tel <= '010-333-9999' ;



-- 학생데이터를 조회하고 싶은데
-- 이름은 모르고 학번이 3번부터 6번 사이에 있었던 것 같을 때
-- 학번 데이터는 문자열형 이지만 저장된 데이터의 형식이 5자리로 모두 일정하므로
-- 학번데이터에 비교연산자를 사용해 3~6번 사이 학생을 조회 가능함
-- (데이터 형식이 일정하지 않아도 조회는 가능하지만 일정한게 훨씬 좋음 )
SELECT * FROM tbl_student
WHERE st_num >= 'A0003' AND st_num <= 'A0006' ;  -- A0003 성춘향 ~~ A0006 임꺽정 까지 표시


-- 어떤 범위 내에 있는 데이터 리스트를 보고자 할 때
-- 학번이 A0003 부터 A0006 까지 범위의 데이터를 보고자 할 때
SELECT * FROM tbl_student
WHERE st_num BETWEEN 'A0003' AND 'A0006' ;  -- == WHERE st_num >= 'A0003' AND st_num <= 'A0006' ;


SELECT * FROM tbl_student;

-- 주소가 익산시, 남원시, 해남군 인 모든 데이터를 보고자 할 떄
SELECT * FROM tbl_student
WHERE st_addr = '익산시' OR st_addr = '남원시' OR st_addr = '해남군' ;

-- KEYWORD [IN] : 표준SQL 칼럼에 포함된 모든 데이터를 보고 싶은데 조건이 여러가지 일 때 사용
SELECT * FROM tbl_student
WHERE st_addr IN('익산시' , '남원시', '해남군') ;   -- LINE203-204 코드와 동일한 코드


--              [개체 무결성]
-- 만약 찾고자하는 데이터의 학번을 알고 있다면
-- 학번으로 조회를 하면(PRIMARY로 설정해놔서) 필요한 데이터 1개(개체)만을 보여주어 업무처리 난이도가 훨씬 낮아짐 
-- (데이터가 없으면 조회 불가)
-- == 개체 무결성 == 중복값이나 NULL값은 저장 안됨

-- [PK]로 설정된 칼럼을 조건으로하여 데이터를 조회하면
-- table에 데이터가 얼마가 저장되어 있던 상관 없이
-- 출력되는 리스트는 1개 이거나 없음.
-- pk는 절대 2개이상 출력되지 않는다.(중복데이터X)
-- pk는 절대 비어있으면 안된다.(== null값이면 안됨)
SELECT * FROM tbl_student
WHERE st_num = 'A0007' ;  

INSERT INTO tbl_student(st_name, st_tel)
VALUES('김정은', '010-999-9999') ;  -- st_num이 pk로 지정되었는데 값을 생략한 채로 데이터를 추가하려고 해서 오류발생함

-- DBMS의 임시저장소에 임시로 저장된 데이터를 STORAGE에 저장하는 명령
-- ## DCL 명령## (또는 TCL(Transaction Control Language)명령 이라고도 함)
COMMIT ;

SELECT * FROM tbl_student ;
