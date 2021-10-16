-- HO TEN: VO MINH TRI
-- MA SO SINH VIEN: 19522396
-- TAO BANG CAN THIET 
--
--cau 1:
CREATE TABLE BTKHDL1.XE
(
    MAXE CHAR(3) PRIMARY KEY NOT NULL, 
    BIENKS CHAR(9), 
    MATUYEN CHAR(4), 
    SOGHET1 number, 
    SOGHET2 number
);

CREATE TABLE BTKHDL1.TUYEN
(
    MATUYEN CHAR(4) PRIMARY KEY NOT NULL, 
    BENDAU VARCHAR(5), 
    BENCUOI VARCHAR(5), 
    GIATUYEN DECIMAL,
    NGXB DATE,
    TGDK number
);
CREATE TABLE BTKHDL1.KHACH
(
    MAKH CHAR(4) PRIMARY KEY NOT NULL, 
    HOTEN NVARCHAR2(20), 
    GIOITINH VARCHAR(3), 
    CMND NUMBER(9)
);
CREATE TABLE BTKHDL1.VEXE
(
    MATUYEN CHAR(4), 
    MAKH CHAR(4), 
    NGMUA DATE, 
    GIAVE number,
    CONSTRAINT PK_VEXE PRIMARY KEY(MATUYEN,MAKH)
);

-- KHOA NGOAI
ALTER TABLE BTKHDL1.XE
ADD FOREIGN KEY (MATUYEN) REFERENCES BTKHDL1.TUYEN(MATUYEN);
ALTER TABLE BTKHDL1.VEXE
ADD FOREIGN KEY (MATUYEN) REFERENCES BTKHDL1.TUYEN(MATUYEN);
ALTER TABLE BTKHDL1.VEXE
ADD FOREIGN KEY (MAKH) REFERENCES BTKHDL1.KHACH(MAKH);
-- cau 2:
-- INSERT INTO
-- xe
ALTER SESSION SET NLS_DATE_FORMAT =' DD/MM/YYYY HH24:MI:SS ';
ALTER USER BTKHDL1 QUOTA UNLIMITED ON USERS;
INSERT INTO BTKHDL1.XE 
VALUES 
('X01', '52LD-4393', 'T11A', 20, 20);
INSERT INTO BTKHDL1.XE 
VALUES 
('X02', '59LD-7247', 'T32D', 36, 36);
INSERT INTO BTKHDL1.XE 
VALUES 
('X03', '55LD-6850', 'T06F', 15, 15);


-- tuyen
INSERT INTO BTKHDL1.TUYEN 
VALUES 
('T11A', 'SG', 'DL', '210000','26/12/2016', 6);
INSERT INTO BTKHDL1.TUYEN 
VALUES 
('T32D', 'PT', 'SG', '120000','30/12/2016', 4);
INSERT INTO BTKHDL1.TUYEN 
VALUES 
('T06F', 'NT', 'DNG', '225000','02/01/2017',6);


--khach
INSERT INTO BTKHDL1.KHACH 
VALUES 
('KH01', 'Lam Van Ben', 'Nam', '655615896');
INSERT INTO BTKHDL1.KHACH 
VALUES 
('KH02', 'Duong Thi Luc', 'Nu', '275648642');
INSERT INTO BTKHDL1.KHACH 
VALUES 
('KH03', 'Hoang Thanh Tung', 'Nam', '456889143');


-- ve xe
INSERT INTO BTKHDL1.VEXE 
VALUES 
('T11A', 'KH01', '20/12/2016', 210000);
INSERT INTO BTKHDL1.VEXE 
VALUES 
('T32D', 'KH02', '25/12/2016', 144000);
INSERT INTO BTKHDL1.VEXE 
VALUES 
('T06F', 'KH03', '30/12/2016', 270000);


-- cau 3:Hi?n th?c r�ng bu?c to�n v?n sau: C�c tuy?n xe c� Th?i gian d? ki?n l?n h?n 5 ti?ng lu�n c� 
gi� tuy?n l?n h?n 200.000
ALTER TABLE BTKHDL1.TUYEN 
ADD CONSTRAINT GIA_TUYEN_CHECK 
CHECK (TGDK > 5 AND GIATUYEN > 200000)
ENABLE NOVALIDATE;
-- cau 5:T�m t?t c? c�c v� xe mua trong th�ng 12, s?p x?p k?t qu? gi?m d?n theo gi� v�
SELECT *
FROM BTKHDL1.VEXE
WHERE EXTRACT(MONTH FROM(NGMUA))=12
ORDER BY GIAVE DESC;
-- 6. T�m tuy?n xe c� s? v� xe �t nh?t trong n?m 2016
SELECT MATUYEN
FROM BTKHDL1.VEXE
WHERE EXTRACT (YEAR FROM(NGMUA))=2016
GROUP BY MATUYEN
HAVING COUNT(MATUYEN)<= ALL
    (
        SELECT COUNT(MATUYEN)
        FROM BTKHDL1.VEXE
        WHERE EXTRACT(YEAR FROM(NGMUA))=2016
        GROUP BY MATUYEN
    );
-- cau 7: T�m tuy?n xe c� c? h�nh kh�ch nam v� h�nh kh�ch n? mua v�.
SELECT BTKHDL1.TUYEN.MATUYEN
FROM BTKHDL1.TUYEN, BTKHDL1.VEXE, BTKHDL1.KHACH
WHERE VEXE.MATUYEN=TUYEN.MATUYEN AND VEXE.MAKH=KHACH.MAKH
AND GIOITINH='Nam'
INTERSECT
SELECT BTKHDL1.TUYEN.MATUYEN
FROM BTKHDL1.TUYEN, BTKHDL1.VEXE, BTKHDL1.KHACH
WHERE VEXE.MATUYEN=TUYEN.MATUYEN AND VEXE.MAKH=KHACH.MAKH
AND GIOITINH='Nu';
-- cau 8:T�m h�nh kh�ch n? ?� t?ng mua v� t?t c? c�c tuy?n xe.
SELECT *
FROM BTKHDL1.KHACH KH
WHERE GIOITINH='Nu' AND NOT EXISTS
    (
        SELECT *
        FROM BTKHDL3.TUYEN TU
        WHERE NOT EXISTS 
        (
            SELECT *
            FROM BTKHDL1.VEXE VX
            WHERE VX.MATUYEN=TU.MATUYEN AND VX.MAKH=KH.MAKH
        )
    )



































