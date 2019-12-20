SELECT * FROM tbl_dept
ORDER BY d_code DESC;

DELETE FROM tbl_dept
WHERE d_code > 'D0236';

commit;