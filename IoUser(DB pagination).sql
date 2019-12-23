-- iouser
-- pagination을 위한 오라클 SQL

/*
[pagination]
전체 레코드를 모두 읽어서 화면에 보여주는 것은 실제상황에서는 매우 비 효율적이다.
메모리도 문제가 될 수 있고, 성능면에서도 상당히 여러 문제를 일으킨다.

적당한 크기(1page 분량의 리스트)를 읽어들이고 
처리를 한 후, 더 많은 내용을 보고 싶으면 
더보기, 다른 페이지를 선택해서 읽어들이도록 SQL을 수행한다.

MySql: limit라는 속성으로 매우 편리하게 pagination을 구현할 수 있다.
mssql: offset과 limit라는 속성
기타 DBMS: limit, offset과 같은 개념들이 있어서 편하게 구현이 가능하다.

Oracle: limit, offset 등을 실제적으로 지원하지 않는다.
        오라클은 개발자, DBA가 limit등을 수행하지 않아도
        엔진 자체에서 optimizer기능이 있어서 어느 정도는 자체 커버가 된다.
        
        실제 SELECT * FROM tablename을 수행하더라도
        보통 200개 단위로 구분하여 fetch(읽어들이기)를 수행하는 기능이 담겨있다.
        
        SELECT * FROM tablename ORDER BY를 사용할 경우
        자체 엔진이 상당히 무리하게 작동을 함.
        하지만 오라클에서는 ORDER BY와 WHERE절을 같이 사용하지만 않으면
        자체 optimizer엔진이 나름대로 방법으로 정렬을 수행한다.
        
        오라클 pagination에서는 정렬 따로, WHERE 따로 만들어서 사용을 한다.
        sub query를 사용하여 sql을 만든다.

*/

SELECT * FROM tbl_product;

/*
현재 p_code 칼럼은 PK로 선언이 되어있다.
PK로 선언된 항목은 내부에 index라는게 자동으로 생성된 상태이다.
그나마 PK를 상대로 ORDER BY를 수행하면 다른 칼럼에 비해 성능이 나은 편이다.
*/
SELECT * FROM tbl_product ORDER BY p_code;

-- 아래 두 코드는 같은 결과를 보임
-- 표준 SQL을 사용한 내림차순 정렬 SQL
SELECT * FROM tbl_product ORDER BY p_code DESC;
-- 오라클의 Hint라는 기능을 사용하여 PK를 기준으로 내림차순 정렬한 SQL
-- 여러줄 주석에 +기호를 사용하면 hint기능을 사용할 수 있음(오류가 발생하면 그냥 무시)
-- tbl_product의 primary key로 optimize기능을 작동해 desc로 보여라
SELECT /*+ INDEX_DESC(P) */ * FROM tbl_product P;

/*
INDEX_DESC([table] [index이름])
[index이름]으로 설정된 인덱스를 사용하여 내림차순 정렬할 후 보여달라

FIRST_ROWS
우선적으로 앞쪽에 있는 레코드들을 먼저 보여달라
=> 데이터가 많을때 순서가 앞에 있는 레코드를 먼저 찾는 OPTIMIZER 알고리즘을 작동시켜라
*/
SELECT /*+ INDEX_DESC(P) FIRST_ROWS */ * FROM tbl_product P;


/*
from에 테이블 대신 다른 select query를 사용한 sql작성
from 절에 사용한 select를 inline view라고 한다.
*/
SELECT * FROM
(
    SELECT /*+ INDEX_DESC(P) */ * FROM tbl_product P -- inline view
);

/*
cursor 보고자 하는 데이터
*/
SELECT /*+ FIRST_ROWS */ROWNUM, IP.*FROM
(
    SELECT /*+ INDEX_DESC(P) */ * FROM tbl_product P -- inline view
) IP
WHERE ROWNUM <= 100;

/*
where절에서 ROWNUM의 가상 칼럼 값을 n이하로 설정하면
처음부터 N까지 데이터를 가져오는데 최소비용을 투입하는 알고리즘을 작동해라는 의미
*/
-- 사용자에게 입력받아서 테스트하는 코드
-- &변수를 사용하면 쿼리 실행에서 입력창이 나타나서 값을 입력할 수 있다.
/*
FIRST_ROWS
9i 이하에서는 cost base로 옵티마이져 실행
10 이상에서는 index base로 옵티마이져 실행을 해서
table에 index가 없거나 레코드의 개수가 현저히 적으면
오히려 옵티마이져를 하지 않은 것보다 늦게 나오는 경우가 있다.

FIRST_ROWS(정수) 옵티마이져를 제한
11 이상에서는
FIRST_ROWS_10, FIRST_ROWS_100, FIRST_ROWS_10000 형식으로 작성해야
좀 더 효율적으로 작동이 된다.
*/
SELECT * FROM
(
    SELECT /*+ FIRST_ROWS_100 */ROWNUM AS NUM, IP.*FROM
    (
        SELECT /*+ INDEX_DESC(P) */ * FROM tbl_product P -- inline view
    ) IP
    WHERE ROWNUM <= &LAST_NO
) TBL
WHERE NUM >= &FIRST_NO;



/*
FIRST_ROWS hint는 무조건 table의 첫번째 레코드부터 
최적화 알고리즘을 작동시키도록 구조가 만들어져있어서
시작 값을 where between으로 제한하면 first_rows hint는 작동하지 않는다.
*/
SELECT /*+ FIRST_ROWS */ROWNUM, IP.*FROM
(
    SELECT /*+ INDEX_DESC(P) */ * FROM tbl_product P -- inline view
) IP
WHERE ROWNUM BETWEEN 91 AND 100 ; -- 작동x
