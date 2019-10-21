COMMIT;

-- 도서금액(B_PRICE) 를 10000~50000 범위의 임의 값으로 업데이트하기
-- 이건 임의로 만든 데이터니까 2개 이상의 레코드를 UPDATE 했지만
-- 실무에서 업데이트는 가급적 2개이상의 레코드에 영향을 미치지 않도록 하자
UPDATE tbl_books
SET b_price = ROUND(DBMS_RANDOM.VALUE(10000,50000));

SELECT * FROM tbl_books;
COMMIT;