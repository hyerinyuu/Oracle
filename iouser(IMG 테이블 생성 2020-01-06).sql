CREATE TABLE tbl_images(
    IMG_FILE_SEQ number primary key,
    IMG_FILE_P_CODE number,
    IMG_FILE_ORIGIN_NAME nVARCHAR2(255),
    IMG_FILE_UPLOAD_NAME nVARCHAR2(255)
);
CREATE SEQUENCE SEQ_IMAGES
START WITH 1 INCREMENT BY 1;

DELETE FROM tbl_images;

DELETE FROM tbl_gallery;

commit;

ALTER TABLE tbl_images
DROP CONSTRAINT FK_IMAGE;

-- TBL_GALLERY table의 레코드가 삭제되면 같이 tbl_images의 연관된 레코드를 모두 삭제하기
ALTER TABLE tbl_images
ADD CONSTRAINT FK_image FOREIGN KEY (img_file_p_code)
REFERENCES tbl_gallery(img_seq) ON DELETE CASCADE;


