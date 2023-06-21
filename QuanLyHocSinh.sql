CREATE DATABASE test
GO 
USE test

CREATE TABLE VAITRO(
	TenVaiTro NVARCHAR(50),
	HocSinh NVARCHAR(50),
	Lop NVARCHAR(50),
	MonHoc NVARCHAR(50),
	GiaoVien NVARCHAR(50),
	ThongBao NVARCHAR(50),
	QuyDinh NVARCHAR(50),
	BaoCao NVARCHAR(50),
	ThemVaiTro NVARCHAR(50),

)

INSERT INTO dbo.VAITRO(
    TenVaiTro,
    HocSinh,
    Lop,
    MonHoc,
    GiaoVien,
    ThongBao,
    QuyDinh,
    BaoCao,
    ThemVaiTro
)
VALUES
(   N'Quản trị viên', -- TenVaiTro - nvarchar(50)
    N'Toàn Quyền', -- HocSinh - nvarchar(50)
    N'Toàn Quyền', -- Lop - nvarchar(50)
    N'Toàn Quyền', -- MonHoc - nvarchar(50)
    N'Toàn Quyền', -- GiaoVien - nvarchar(50)
    N'Toàn Quyền', -- ThongBao - nvarchar(50)
    N'Toàn Quyền', -- QuyDinh - nvarchar(50)
    N'Chỉ xem', -- BaoCao - nvarchar(50)
    N'Toàn Quyền'  -- ThemVaiTro - nvarchar(50)
    )


	--CREATE TABLE BAIDANG(
	--MaBaiDang NVARCHAR(50),
	--NgayDang SMALLDATETIME
	--)

CREATE TABLE HOCSINH (
	MaHS VARCHAR(20) PRIMARY KEY,
	HoTen NVARCHAR(50) NOT NULL,
	GioiTinh NVARCHAR(3) NOT NULL,
	NgSinh SMALLDATETIME,
	DiaChi NVARCHAR(50),
	Email VARCHAR(50)
)

ALTER TABLE dbo.HOCSINH ADD CONSTRAINT CHECK_GIOITINH CHECK (GioiTinh = 'Nam' OR GioiTinh = N'Nữ')

CREATE TABLE GIAOVIEN (
	MaGV VARCHAR(20) PRIMARY KEY,
	HoTen NVARCHAR(50) NOT NULL,
	GioiTinh NVARCHAR(3) NOT NULL,
	NgSinh SMALLDATETIME,
	DiaChi NVARCHAR(50),
	Email VARCHAR(20)
)

ALTER TABLE dbo.GIAOVIEN ADD CONSTRAINT CHECK_GIOITINH_GV CHECK (GioiTinh = 'Nam' OR GioiTinh = N'Nữ')

CREATE TABLE KHOILOP (
	MaKhoiLop VARCHAR(20) PRIMARY KEY,
	TenKhoiLop NVARCHAR(50) NOT NULL
)

CREATE TABLE NAMHOC (
	MaNam VARCHAR(20) PRIMARY KEY,
	Nam1 INT,
	Nam2 INT,
)

ALTER TABLE dbo.NAMHOC ADD CONSTRAINT CHECK_NAM CHECK (Nam1 < Nam2)

CREATE TABLE HOCKY (
	MaHocKy VARCHAR(20) PRIMARY KEY,
	HocKy INT CHECK (HocKy > 0),
	MaNam VARCHAR(20) FOREIGN KEY REFERENCES dbo.NAMHOC(MaNam),
	NgayBD SMALLDATETIME,
	NgayKT SMALLDATETIME
)

ALTER TABLE HOCKY ADD CONSTRAINT CHECK_THOIGIAN CHECK (NgayBD < NgayKT)

CREATE TABLE LOP (
	MaLop VARCHAR(20),
	MaHocKy VARCHAR(20) FOREIGN KEY REFERENCES dbo.HOCKY(MaHocKy),
	TenLop NVARCHAR(50) NOT NULL,
	MaKhoiLop VARCHAR(20) FOREIGN KEY REFERENCES dbo.KHOILOP (MaKhoiLop),
	SiSo INT CHECK (SiSo >= 0),
	PRIMARY KEY (MaLop, MaHocKy)
)

CREATE TABLE MONHOC (
	MaMH VARCHAR(20) PRIMARY KEY,
	TenMH NVARCHAR(50) NOT NULL,
	MoTa NVARCHAR(50),
	HeSo INT
)

ALTER TABLE dbo.KETQUAHOCMON CHECK CONSTRAINT ALL
ALTER TABLE dbo.LOP_MONHOC NOCHECK CONSTRAINT ALL
ALTER TABLE dbo.GIAOVIEN NOCHECK CONSTRAINT ALL
INSERT INTO dbo.LOP_MONHOC
(
    MaMH,
    MaGV,
    MaLop
)
VALUES
(   'Hoa10', -- MaMH - varchar(20)
    NULL, -- MaGV - varchar(20)
    'TN102'  -- MaLop - varchar(20)
    )



CREATE TABLE LOP_MONHOC (
	MaMH VARCHAR(20) FOREIGN KEY REFERENCES dbo.MONHOC(MaMH),
	MaGV VARCHAR(20) FOREIGN KEY REFERENCES dbo.GIAOVIEN(MaGV),
	MaLop VARCHAR(20),
	PRIMARY KEY(MaMH, MaGV, MaLop)
)


CREATE TABLE KETQUAHOCMON (
	MaQTHoc INT IDENTITY(1,1),
	MaMH VARCHAR(20) FOREIGN KEY REFERENCES dbo.MONHOC(MaMH),
	DiemTBMon FLOAT,
	MaHS VARCHAR(20) FOREIGN KEY REFERENCES dbo.HOCSINH(MaHS),
	MaHocKy VARCHAR(20) FOREIGN KEY REFERENCES dbo.HOCKY(MaHocKy),
	PRIMARY KEY(MaQTHoc)
)

ALTER TABLE dbo.HOCSINH_LOP NOCHECK CONSTRAINT ALL
ALTER TABLE dbo.HOCSINH NOCHECK CONSTRAINT ALL	
DELETE FROM dbo.HOCSINH_LOP WHERE DiemTBHK =NULL


CREATE TABLE HOCSINH_LOP (
	MaHS VARCHAR(20) FOREIGN KEY REFERENCES dbo.HOCSINH(MaHS),
	MaLop VARCHAR(20),
	DiemTBHK FLOAT,
	MaQTHoc INT,
	PRIMARY KEY(MaHS, MaLop)
)


--Thêm điểm trung bình học kì 2
ALTER TABLE dbo.HOCSINH_LOP ADD DiemTBHK2 float

ALTER TABLE dbo.HOCSINH_LOP ADD CONSTRAINT FK_HSLOP_KQHM FOREIGN KEY (MaQTHoc) REFERENCES dbo.KETQUAHOCMON(MaQTHoc)

CREATE TABLE LOAIHINHKIEMTRA (
	MaLHKT VARCHAR(20) PRIMARY KEY,
	TenLHKT NVARCHAR(50) NOT NULL,
	HeSo INT
)

CREATE TABLE CT_HOCMON (
	MaCTHocMon INT IDENTITY(1,1) PRIMARY KEY,
	Diem FLOAT,
	MaQTHoc INT,
	MaLHKT VARCHAR(20) FOREIGN KEY REFERENCES dbo.LOAIHINHKIEMTRA(MaLHKT),
	MaMH VARCHAR(20) FOREIGN KEY REFERENCES dbo.MONHOC(MaMH)
)

ALTER TABLE dbo.CT_HOCMON ADD CONSTRAINT FK_CTHM_KQHM FOREIGN KEY (MaQTHoc) REFERENCES dbo.KETQUAHOCMON(MaQTHoc)

CREATE TABLE BAOCAOMONHOC (
	MaHocKy VARCHAR(20) FOREIGN KEY REFERENCES dbo.HOCKY(MaHocKy),
	MaMH VARCHAR(20) FOREIGN KEY REFERENCES dbo.MONHOC(MaMH),
	MaLop VARCHAR(20),
	SoLuongDat INT,
	TiLe FLOAT,
	PRIMARY KEY(MaHocKy, MaMH, MaLop)
)

CREATE TABLE BAOCAOHOCKY (
	MaHocKy VARCHAR(20) FOREIGN KEY REFERENCES dbo.HOCKY(MaHocKy),
	MaLop VARCHAR(20),
	SoLuongDat INT,
	TiLe FLOAT,
	PRIMARY KEY(MaHocKy, MaLop)	
)

CREATE TABLE THAMSO (
	TenThamSo VARCHAR(20) PRIMARY KEY,
	GiaTri FLOAT NOT NULL
)

CREATE TABLE BAIDANG (
	MaBaiDang INT,
	TieuDe NVARCHAR(MAX) NOT NULL,
	NgayDang SMALLDATETIME NOT NULL,
	NoiDung NVARCHAR(MAX)
)

set dateformat dmy;
DECLARE @MaBai INT
SELECT @MaBai=COUNT(*)+1
FROM dbo.BAIDANG
INSERT into BaiDang 
        (MaBaiDang,NoiDung, NgayDang, TieuDe) 
        values (@MaBai,N'${data.NoiDung}', N'01/01/2000', N'${data.TieuDe}')

INSERT into BaiDang 
        (MaBaiDang,NoiDung, NgayDang, TieuDe) 
        values (@MaBai,N'${data.NoiDung}', N'${data.NgayDang}', N'${data.TieuDe}')

DROP TABLE dbo.BAIDANG

GO
-- 1. YÊU CẦU TIẾP NHẬN HỌC SINH
GO 
----  1.1 KIỂM TRA TUỔI TIẾP NHẬN HỌC SINH 
CREATE TRIGGER [dbo].[TRG_KiemTraTuoi] ON [dbo].[HOCSINH] FOR INSERT, UPDATE AS
BEGIN
	DECLARE @TuoiToiDa INT, @TuoiToiThieu INT, @TuoiHS INT
	SELECT @TuoiToiDa = GiaTri FROM dbo.THAMSO WHERE TenThamSo = N'TuoiToiDa'
	SELECT @TuoiToiThieu = GiaTri FROM dbo.THAMSO WHERE TenThamSo = N'TuoiToiThieu'

	SELECT @TuoiHS = FLOOR((CAST (GetDate() AS INTEGER) - CAST(NgSinh AS INTEGER)) / 365.25)
	FROM Inserted
	IF(@TuoiHS > @TuoiToiDa OR @TuoiHS < @TuoiToiThieu)
	BEGIN
	    PRINT N'Tuổi không hợp lệ'
		ROLLBACK TRANSACTION
	END
	ELSE
    BEGIN
        PRINT N'Thêm thành công!'
    END
END
GO

----  1.2 XÓA HỌC SINH
CREATE TRIGGER [dbo].[TRG_DEL_HOCSINH] ON [dbo].[HOCSINH] INSTEAD OF DELETE
AS
BEGIN
	DECLARE @MaHS VARCHAR(20), @MaQTHoc INT
	SELECT @MaHS = Deleted.MaHS FROM Deleted 
	SELECT @MaQTHoc = MaQTHoc FROM dbo.KETQUAHOCMON WHERE MaHS = @MaHS
	DELETE FROM dbo.CT_HOCMON WHERE MaQTHoc = @MaQTHoc
	DELETE FROM dbo.KETQUAHOCMON WHERE MaHS = @MaHS
	DELETE FROM dbo.HOCSINH_LOP WHERE MaHS = @MaHS
	DELETE FROM dbo.HOCSINH WHERE MaHS = @MaHS
END
GO 
-- 2. LẬP DANH SÁCH LỚP
GO
----  2.1. KIỂM TRA SỈ SỐ LỚP
CREATE TRIGGER [dbo].[TRG_SISO] ON [dbo].[HOCSINH_LOP] FOR INSERT AS 
BEGIN
	DECLARE @MaLop VARCHAR(20), @SiSo INT, @SiSoToiDa INT

	SELECT @SiSoToiDa = GiaTri  FROM dbo.THAMSO WHERE TenThamSo = N'SiSoToiDa'
	PRINT @SiSoToiDa
	DECLARE MyCursor CURSOR FOR SELECT HOCSINH_LOP.MaLop, COUNT(HOCSINH_LOP.MaHS) AS SiSo FROM dbo.LOP INNER JOIN HOCSINH_LOP ON HOCSINH_LOP.MaLop = LOP.MaLop
	GROUP BY HOCSINH_LOP.MaLop, LOP.MaHocKy

	OPEN MyCursor 
	FETCH MyCursor INTO @MaLop, @SiSo 
	WHILE (@@FETCH_STATUS = 0)
	BEGIN
	 PRINT @SiSoToiDa
	 PRINT @SiSo
	 IF (@SiSo > @SiSoToiDa)
	 BEGIN
		 PRINT N'[2] Sỉ số lớp vượt qua mức tối đa!'
		 ROLLBACK TRANSACTION
		 END
	 ELSE
		 BEGIN
		 PRINT N'[2] Thêm thành công!'
	 END
	 FETCH NEXT FROM MyCursor INTO @MaLop, @SiSo 
	END
	CLOSE MyCursor 
	DEALLOCATE MyCursor 
END 
GO 
----  2.2. CẬP NHẬT SỈ SỐ LỚP
CREATE TRIGGER [dbo].[TRG_UPDATE_SISO] ON [dbo].[HOCSINH_LOP] FOR INSERT,UPDATE,DELETE AS 
BEGIN
    DECLARE @MaLop VARCHAR(20), @SoLuong INT

    DECLARE MyCursor CURSOR FOR 
		SELECT DISTINCT LOP.MaLop, COUNT(MaHS) AS SoLuong
		FROM dbo.LOP INNER JOIN dbo.HOCSINH_LOP ON HOCSINH_LOP.MaLop = LOP.MaLop
		GROUP BY LOP.MaLop, MaHocKy

	OPEN MyCursor 
	FETCH MyCursor INTO @MaLop, @SoLuong
	WHILE (@@FETCH_STATUS = 0)
	BEGIN
	    UPDATE dbo.LOP SET SiSo = @SoLuong
		WHERE MaLop = @MaLop

		FETCH NEXT FROM MyCursor INTO @MaLop, @SoLuong
	END
	CLOSE MyCursor
	DEALLOCATE MyCursor
END
GO


----  2.3. TỰ ĐỘNG CẬP NHẬT LẠI THÔNG TIN BÁO CÁO KHI CÓ SỰ THAY ĐỔI VỀ THÔNG TIN LỚP (XÉT TRÊN ĐIỂM ĐẠT MÔN)
CREATE TRIGGER [dbo].[TRG_BAOCAOMONHOC] ON [dbo].[HOCSINH_LOP] FOR INSERT, UPDATE, DELETE AS 
BEGIN

    DECLARE @MaHocKy VARCHAR(20), @MaLop VARCHAR(20),
	@MaMH VARCHAR(20), @SoLuongDat INT, @DiemDatMon Float,
	@SiSo INT, @TiLe FLOAT
	SELECT @DiemDatMon = GiaTri FROM dbo.THAMSO WHERE TenThamSo = 'DiemDatMon'

    DECLARE MyCursorTuTinhBaoCaoMH CURSOR FOR 
		SELECT DISTINCT KETQUAHOCMON.MaHocKy, LOP_MONHOC.MaLop, LOP_MONHOC.MaMH, COUNT(IIF(DiemTBMon >= @DiemDatMon, 1, NULL)) AS SoLuongDat, SiSo
		FROM dbo.HOCSINH_LOP INNER JOIN dbo.KETQUAHOCMON
		ON KETQUAHOCMON.MaHS = HOCSINH_LOP.MaHS  FULL JOIN dbo.LOP_MONHOC 
		ON LOP_MONHOC.MaMH = KETQUAHOCMON.MaMH FULL JOIN dbo.LOP 
		ON LOP.MaLop = LOP_MONHOC.MaLop AND LOP.MaLop = HOCSINH_LOP.MaLop
		WHERE DiemTBMon IS NOT NULL AND KETQUAHOCMON.MaHocKy IS NOT NULL
		GROUP BY KETQUAHOCMON.MaHocKy, LOP_MONHOC.MaLop, LOP_MONHOC.MaMH, SiSo

	OPEN MyCursorTuTinhBaoCaoMH 
	FETCH MyCursorTuTinhBaoCaoMH INTO @MaHocKy, @MaLop, @MaMH, @SoLuongDat, @SiSo
	WHILE (@@FETCH_STATUS = 0)
	BEGIN
	    IF EXISTS (SELECT * FROM dbo.BAOCAOMONHOC WHERE MaHocKy = @MaHocKy AND MaLop = @MaLop AND MaMH = @MaMH)
		BEGIN
			IF (@SiSo = 0)
			BEGIN
			    UPDATE dbo.BAOCAOMONHOC SET SoLuongDat = @SoLuongDat, TiLe = 0
				WHERE MaHocKy = @MaHocKy AND MaLop = @MaLop AND MaMH = @MaMH
			END
			ELSE 
			BEGIN
				SET @TiLe = @SoLuongDat / @SiSo
			    UPDATE dbo.BAOCAOMONHOC SET SoLuongDat = @SoLuongDat, TiLe = @TiLe
				WHERE MaHocKy = @MaHocKy AND MaLop = @MaLop AND MaMH = @MaMH
			END
		
		END
		ELSE 
		BEGIN
			IF (@SiSo = 0)
			BEGIN
			    INSERT INTO dbo.BAOCAOMONHOC(MaHocKy,MaLop,MaMH,SoLuongDat,TiLe)
				VALUES(@MaHocKy, @MaLop, @MaMH, @SoLuongDat, 0)
			END
			ELSE
			BEGIN
				SET @TiLe = @SoLuongDat / @SiSo
			    INSERT INTO dbo.BAOCAOMONHOC(MaHocKy,MaLop,MaMH,SoLuongDat,TiLe)
				VALUES(@MaHocKy, @MaLop, @MaMH, @SoLuongDat, @TiLe)
			END
		    
		END
		FETCH NEXT FROM MyCursorTuTinhBaoCaoMH INTO @MaHocKy, @MaLop, @MaMH, @SoLuongDat, @SiSo
	END
	CLOSE MyCursorTuTinhBaoCaoMH
	DEALLOCATE MyCursorTuTinhBaoCaoMH
END
GO 
--kiemtra
select *
from baocaomonhoc
-- 3. TRA CỨU HỌC SINH
SELECT HOCSINH.MaHS, HoTen, TenLop, HocKy, DiemTBHK
FROM dbo.HOCSINH_LOP 
	INNER JOIN dbo.HOCSINH ON HOCSINH.MaHS = HOCSINH_LOP.MaHS
	INNER JOIN dbo.LOP ON LOP.MaLop = HOCSINH_LOP.MaLop
	INNER JOIN dbo.HOCKY ON HOCKY.MaHocKy = LOP.MaHocKy
GO
-- 4. NHẬN BẢNG ĐIỂM MÔN
GO
----  4.1. KIỂM TRA THÔNG TIN ĐIỂM
CREATE TRIGGER [dbo].[TRG_KiemTraDiem] ON [dbo].[CT_HOCMON] FOR INSERT, UPDATE AS
BEGIN
	DECLARE @DiemToiDa INT, @DiemToiThieu INT, @Diem FLOAT
	SELECT @DiemToiDa = GiaTri FROM dbo.THAMSO WHERE TenThamSo = N'DiemToiDa'
	SELECT @DiemToiThieu = GiaTri FROM dbo.THAMSO WHERE TenThamSo = N'DiemToiThieu'

	SELECT @Diem = Diem FROM Inserted
	IF(@Diem > @DiemToiDa OR @Diem < @DiemToiThieu)
	BEGIN
	    PRINT N'Điểm không hợp lệ'
		ROLLBACK TRANSACTION
	END
	ELSE
    BEGIN
        PRINT N'Thêm thành công!'
    END
END

GO 
----  4.2. LƯU ĐIỂM
CREATE PROCEDURE [dbo].[XULYDIEM] AS 
BEGIN
    DECLARE @MaHS VARCHAR(20), @MaMH VARCHAR(20), @MaLop VARCHAR(20), @HocKy INT, @MaLHKT VARCHAR(20), @Diem FLOAT, @MaQTHoc INT
	
	IF NOT EXISTS(
		SELECT * 
		FROM KETQUAHOCMON WHERE MaHS = @MaHS AND MaHocKy = 'HK0' + @HocKy
	) BEGIN
	      INSERT KETQUAHOCMON (MaMH, MaHS, MaHocKy) 
		  VALUES (@MaMH, @MaHS, 'HK0' + @HocKy)
	  END 

	SELECT @MaQTHoc = MaQTHoc
	FROM dbo.KETQUAHOCMON WHERE MaMH = @MaMH AND MaHS = @MaHS AND MaHocKy = 'HK0' + @HocKy

	IF NOT EXISTS(
		SELECT * FROM dbo.CT_HOCMON WHERE MaQTHoc = @MaQTHoc
	) BEGIN
		INSERT INTO  dbo.CT_HOCMON (Diem, MaQTHoc, MaLHKT, MaMH) VALUES (@Diem, @MaQTHoc, @MaLHKT, @MaMH)
	  END
	ELSE BEGIN
	         UPDATE dbo.CT_HOCMON SET Diem = @Diem WHERE MaQTHoc = @MaQTHoc AND MaLHKT = @MaLHKT
	     END
END
GO

DROP PROC dbo.XULYDIEM
----  4.3. XEM ĐIỂM THEO LỚP
SELECT DISTINCT HOCSINH.MaHS, HoTen, KQHM.MaLHKT, KQHM.DiemTBMon, LOP.MaLop, TenLop FROM (
                    SELECT MaHS, MaLHKT, Diem, DiemTBMon
                    FROM dbo.KETQUAHOCMON INNER JOIN dbo.CT_HOCMON ON CT_HOCMON.MaQTHoc = KETQUAHOCMON.MaQTHoc
                    WHERE dbo.CT_HOCMON.MaMH = 'TOAN10'  AND MaLHKT = 'KT15P'
                    ) KQHM RIGHT JOIN dbo.HOCSINH ON HOCSINH.MaHS = KQHM.MaHS INNER JOIN dbo.HOCSINH_LOP ON HOCSINH_LOP.MaHS = HOCSINH.MaHS INNER JOIN dbo.LOP ON LOP.MaLop = HOCSINH_LOP.MaLop INNER JOIN dbo.LOP_MONHOC ON LOP_MONHOC.MaLop = LOP.MaLop
                WHERE MaMH = 'TOAN10' AND LOP.MaLop = 'TN101' 
--GO
----  4.4. TÍNH ĐIỂM TRUNG BÌNH MÔN THEO MÃ QUÁ TRÌNH HỌC
CREATE FUNCTION [dbo].[TINH_DIEMTB] (@MaQTHoc INT)
RETURNS FLOAT AS
BEGIN
	DECLARE @HeSo INT, @Diem FLOAT, @DiemTB FLOAT, @TongHeSo INT
	SET @DiemTB = 0
	SET @TongHeSo = 0

    DECLARE MyCursor CURSOR FOR 
		SELECT HeSo, Diem
		FROM dbo.LOAIHINHKIEMTRA INNER JOIN dbo.CT_HOCMON ON CT_HOCMON.MaLHKT = LOAIHINHKIEMTRA.MaLHKT
		WHERE MaQTHoc = @MaQTHoc

	OPEN MyCursor 
	FETCH MyCursor INTO @HeSo, @Diem
	WHILE (@@FETCH_STATUS = 0)
	BEGIN
	    SET @DiemTB = @DiemTB + @Diem * @HeSo
		SET @TongHeSo = @TongHeSo + @HeSo
		FETCH NEXT FROM MyCursor INTO @HeSo, @Diem
	END
	IF(@TongHeSo=0) RETURN 0
	CLOSE MyCursor
	DEALLOCATE MyCursor

	RETURN @DiemTB / @TongHeSo
END
GO



SET IDENTITY_INSERT KETQUAHOCMON off

DECLARE @DUYET CURSOR, @MaQTHoc INT , @Diem FLOAT
SET @DUYET = CURSOR FOR SELECT MaQTHoc FROM CT_HOCMON
OPEN @DUYET
FETCH NEXT FROM @DUYET INTO @MaQTHoc
WHILE @@FETCH_STATUS = 0
	BEGIN
		SELECT @Diem = [dbo].[TINH_DIEMTB](@MaQTHoc)
		UPDATE KETQUAHOCMON
		SET DiemTBMon = @Diem
		WHERE @MaQTHoc =KETQUAHOCMON.MaQTHoc
		FETCH NEXT FROM @DUYET INTO @MaQTHoc
	END
CLOSE @DUYET
DEALLOCATE @DUYET

--kiem tra
select *
from ketquahocmon



SELECT MaLop, KETQUAHOCMON.MaMH, MaHS, [dbo].TINH_DIEMTB(CT_HOCMON.MaQTHoc) AS DiemTB
        FROM dbo.CT_HOCMON INNER JOIN dbo.KETQUAHOCMON ON KETQUAHOCMON.MaQTHoc = CT_HOCMON.MaQTHoc INNER JOIN dbo.LOP_MONHOC ON LOP_MONHOC.MaMH = KETQUAHOCMON.MaMH
        WHERE MaLop = 'TN101'
        GROUP BY CT_HOCMON.MaQTHoc, MaLop, KETQUAHOCMON.MaMH, MaHS, MaHocKy;

----  4.5. TÍNH ĐIỂM TRUNG BÌNH THEO TỪNG HỌC KỲ
CREATE FUNCTION [dbo].[TINH_DIEMTB_HOCKY] (@MaHS VARCHAR(20), @MaHocKy VARCHAR(20))
RETURNS FLOAT AS
BEGIN
	DECLARE @HeSo INT, @DiemTBMon FLOAT, @DiemTBHK FLOAT, @TongHeSo INT
	SET @DiemTBHK = 0
	SET @TongHeSo = 0

    DECLARE MyCursor CURSOR FOR 
		SELECT HeSo, DiemTBMon
		FROM dbo.KETQUAHOCMON INNER JOIN dbo.MONHOC ON MONHOC.MaMH = KETQUAHOCMON.MaMH
		WHERE MaHS = @MaHS AND DiemTBMon IS NOT NULL AND MaHocKy = @MaHocKy

	OPEN MyCursor 
	FETCH MyCursor INTO @HeSo, @DiemTBMon
	WHILE (@@FETCH_STATUS = 0)
	BEGIN
	    SET @DiemTBHK = @DiemTBHK + @DiemTBMon * @HeSo
		SET @TongHeSo = @TongHeSo + @HeSo
		FETCH NEXT FROM MyCursor INTO @HeSo, @DiemTBMon
	END
	CLOSE MyCursor
	DEALLOCATE MyCursor

	IF(@TongHeSo = 0)
	BEGIN
	    RETURN @DiemTBHK
	END

	RETURN @DiemTBHK / @TongHeSo
END
GO

DECLARE @DUYET CURSOR, @DUYET1 CURSOR, @MAHS VARCHAR(20), @MAHocKy VARCHAR(20) , @Diem FLOAT
SET @DUYET = CURSOR FOR
SELECT MaHS, MaHocKy
FROM KETQUAHOCMON
OPEN @DUYET
FETCH NEXT FROM @DUYET INTO @MAHS, @MAHocKy
WHILE @@FETCH_STATUS = 0
	BEGIN
		SELECT @Diem = [dbo].[TINH_DIEMTB_HOCKY](@MAHS, @MAHocKy)
		IF(@MAHocKy='HK01')
			BEGIN
			UPDATE HOCSINH_LOP
			SET DiemTBHK = @Diem
			WHERE @MAHS =HOCSINH_LOP.MaHS
			END
		ELSE
			BEGIN
			UPDATE HOCSINH_LOP
			SET DiemTBHK2 = @Diem
			WHERE @MAHS =HOCSINH_LOP.MaHS
			END
		FETCH NEXT FROM @DUYET INTO @MAHS, @MAHocKy
	END
CLOSE @DUYET
DEALLOCATE @DUYET



--4.6 --Cập nhật điểm trung bình
go
CREATE TRIGGER [dbo].[LUUDIEM] ON CT_HOCMON FOR insert,update AS 
BEGIN
    DECLARE @Diem FLOAT, @MaQTHoc INT
	SELECT @Diem = Diem,@MaQTHoc= MaQTHoc from inserted 
	BEGIN
		SELECT @Diem = [dbo].[TINH_DIEMTB](@MaQTHoc)
		UPDATE KETQUAHOCMON
		SET DiemTBMon = @Diem
		WHERE @MaQTHoc =KETQUAHOCMON.MaQTHoc
	END

	DECLARE @DUYET CURSOR, @DUYET1 CURSOR, @MAHS VARCHAR(20), @MAHocKy VARCHAR(20) , @Diem1 FLOAT
SET @DUYET = CURSOR FOR
SELECT MaHS, MaHocKy
FROM KETQUAHOCMON
OPEN @DUYET
FETCH NEXT FROM @DUYET INTO @MAHS, @MAHocKy
WHILE @@FETCH_STATUS = 0
	BEGIN
		SELECT @Diem1 = [dbo].[TINH_DIEMTB_HOCKY](@MAHS, @MAHocKy)
		IF(@MAHocKy='HK01')
			BEGIN
			UPDATE HOCSINH_LOP
			SET DiemTBHK = @Diem1
			WHERE @MAHS =HOCSINH_LOP.MaHS
			END
		ELSE
			BEGIN
			UPDATE HOCSINH_LOP
			SET DiemTBHK2 = @Diem1
			WHERE @MAHS =HOCSINH_LOP.MaHS
			END
		FETCH NEXT FROM @DUYET INTO @MAHS, @MAHocKy
	END
CLOSE @DUYET
DEALLOCATE @DUYET
END
GO

-- 5. LẬP BÁO CÁO TỔNG KẾT
GO
----  5.1 LẬP BÁO CÁO TỔNG KẾT KỲ 1

--new
CREATE TRIGGER [dbo].[TRG_BAOCAOHOCKY1_THAMSO] ON [dbo].[THAMSO] FOR UPDATE AS 
BEGIN
    DECLARE @MaHocKy VARCHAR(20), @MaLop VARCHAR(20), @SoLuongDat INT, @DiemDat INT, @SiSo INT, @TiLe FLOAT
	SELECT @DiemDat = GiaTri FROM dbo.THAMSO WHERE TenThamSo = N'DiemDatMon'

    DECLARE MyCursorTuTinhBaoCaoHK1_TS CURSOR FOR 
		
	SELECT KQ.MaHocKy ,HL.MaLop, COUNT(DISTINCT HL.MaHS) AS SoLuongHocSinh , LOP.SiSo
	FROM HOCSINH_LOP HL
	INNER JOIN LOP LP ON HL.MaLop = LP.MaLop
	INNER JOIN KETQUAHOCMON KQ ON KQ.MaHS = HL.MaHS
	INNER JOIN LOP LOP ON LOP.MaLop = HL.MaLop
	WHERE KQ.MaHocKy = 'HK01' --AND  HL.DiemTBHK > 8  
	GROUP BY HL.MaLop, LP.TenLop, KQ.MaHocKy, LOP.SiSo



	--xoa
	OPEN MyCursorTuTinhBaoCaoHK1_TS 
	FETCH MyCursorTuTinhBaoCaoHK1_TS INTO @MaHocKy, @MaLop,  @SoLuongDat, @SiSo
	WHILE (@@FETCH_STATUS = 0)
		BEGIN
			IF EXISTS (SELECT * FROM dbo.BAOCAOHOCKY WHERE MaHocKy = @MaHocKy AND MaLop = @MaLop)
			BEGIN
				
					UPDATE dbo.BAOCAOHOCKY SET SoLuongDat = 0, TiLe = 0
					WHERE MaHocKy = @MaHocKy AND MaLop = @MaLop
					
			
			END
			ELSE 
			BEGIN
			
				BEGIN
					INSERT INTO dbo.BAOCAOHOCKY(MaHocKy,MaLop,SoLuongDat,TiLe)
					VALUES(@MaHocKy, @MaLop, 0, 0)
				END
				
		    
			END
			FETCH NEXT FROM MyCursorTuTinhBaoCaoHK1_TS INTO @MaHocKy, @MaLop, @SoLuongDat, @SiSo
		END
	CLOSE MyCursorTuTinhBaoCaoHK1_TS
	DEALLOCATE MyCursorTuTinhBaoCaoHK1_TS

	--xoa
	   DECLARE MyCursorTuTinhBaoCaoHK1_TS CURSOR FOR 
		
	SELECT KQ.MaHocKy ,HL.MaLop, COUNT(DISTINCT HL.MaHS) AS SoLuongHocSinh , LOP.SiSo
	FROM HOCSINH_LOP HL
	INNER JOIN LOP LP ON HL.MaLop = LP.MaLop
	INNER JOIN KETQUAHOCMON KQ ON KQ.MaHS = HL.MaHS
	INNER JOIN LOP LOP ON LOP.MaLop = HL.MaLop
	WHERE KQ.MaHocKy = 'HK01' AND  HL.DiemTBHK > @DiemDat  
	GROUP BY HL.MaLop, LP.TenLop, KQ.MaHocKy, LOP.SiSo 

	OPEN MyCursorTuTinhBaoCaoHK1_TS 
	FETCH MyCursorTuTinhBaoCaoHK1_TS INTO @MaHocKy, @MaLop,  @SoLuongDat, @SiSo
	WHILE (@@FETCH_STATUS = 0)
		BEGIN
			IF EXISTS (SELECT * FROM dbo.BAOCAOHOCKY WHERE MaHocKy = @MaHocKy AND MaLop = @MaLop)
			BEGIN
				IF (@SiSo = 0)
				BEGIN
					UPDATE dbo.BAOCAOHOCKY SET SoLuongDat = @SoLuongDat, TiLe = 0
					WHERE MaHocKy = @MaHocKy AND MaLop = @MaLop
					
				END
				ELSE 
				BEGIN
					SET @TiLe = cast((cast(@SoLuongDat as float)/@SiSo)as float)
					UPDATE dbo.BAOCAOHOCKY SET SoLuongDat = @SoLuongDat, TiLe = @TiLe
					WHERE MaHocKy = @MaHocKy AND MaLop = @MaLop
				END
		
			END
			ELSE 
			BEGIN
				IF (@SiSo = 0)
				BEGIN
					INSERT INTO dbo.BAOCAOHOCKY(MaHocKy,MaLop,SoLuongDat,TiLe)
					VALUES(@MaHocKy, @MaLop, 0, 0)
				END
				ELSE
				BEGIN
					SET @TiLe = cast((cast(@SoLuongDat as float)/@SiSo)as float)
					INSERT INTO dbo.BAOCAOHOCKY(MaHocKy,MaLop,SoLuongDat,TiLe)
					VALUES(@MaHocKy, @MaLop, @SoLuongDat, @TiLe)
				END
		    
			END
			FETCH NEXT FROM MyCursorTuTinhBaoCaoHK1_TS INTO @MaHocKy, @MaLop, @SoLuongDat, @SiSo
		END
	CLOSE MyCursorTuTinhBaoCaoHK1_TS
	DEALLOCATE MyCursorTuTinhBaoCaoHK1_TS
END
GO

drop trigger [dbo].[TRG_BAOCAOHOCKY1_THAMSO]



--5.1.2
CREATE TRIGGER [dbo].[TRG_BAOCAOHOCKY1_KETQUAHOCMON] ON [dbo].[KETQUAHOCMON] FOR INSERT, UPDATE , DELETE  AS 
BEGIN
    DECLARE @MaHocKy VARCHAR(20), @MaLop VARCHAR(20), @SoLuongDat INT, @DiemDat INT, @SiSo INT, @TiLe FLOAT
	SELECT @DiemDat = GiaTri FROM dbo.THAMSO WHERE TenThamSo = N'DiemDatMon'

    DECLARE MyCursorTuTinhBaoCaoHK1_TS CURSOR FOR 
		
	SELECT KQ.MaHocKy ,HL.MaLop, COUNT(DISTINCT HL.MaHS) AS SoLuongHocSinh , LOP.SiSo
	FROM HOCSINH_LOP HL
	INNER JOIN LOP LP ON HL.MaLop = LP.MaLop
	INNER JOIN KETQUAHOCMON KQ ON KQ.MaHS = HL.MaHS
	INNER JOIN LOP LOP ON LOP.MaLop = HL.MaLop
	WHERE KQ.MaHocKy = 'HK01' --AND  HL.DiemTBHK > 8  
	GROUP BY HL.MaLop, LP.TenLop, KQ.MaHocKy, LOP.SiSo



	--xoa
	OPEN MyCursorTuTinhBaoCaoHK1_TS 
	FETCH MyCursorTuTinhBaoCaoHK1_TS INTO @MaHocKy, @MaLop,  @SoLuongDat, @SiSo
	WHILE (@@FETCH_STATUS = 0)
		BEGIN
			IF EXISTS (SELECT * FROM dbo.BAOCAOHOCKY WHERE MaHocKy = @MaHocKy AND MaLop = @MaLop)
			BEGIN
				
					UPDATE dbo.BAOCAOHOCKY SET SoLuongDat = 0, TiLe = 0
					WHERE MaHocKy = @MaHocKy AND MaLop = @MaLop
					
			END
			ELSE 
			BEGIN
			
				BEGIN
					INSERT INTO dbo.BAOCAOHOCKY(MaHocKy,MaLop,SoLuongDat,TiLe)
					VALUES(@MaHocKy, @MaLop, 0, 0)
				END
				
		    
			END
			FETCH NEXT FROM MyCursorTuTinhBaoCaoHK1_TS INTO @MaHocKy, @MaLop, @SoLuongDat, @SiSo
		END
	CLOSE MyCursorTuTinhBaoCaoHK1_TS
	DEALLOCATE MyCursorTuTinhBaoCaoHK1_TS

	--xoa
	   DECLARE MyCursorTuTinhBaoCaoHK1_TS CURSOR FOR 
		
	SELECT KQ.MaHocKy ,HL.MaLop, COUNT(DISTINCT HL.MaHS) AS SoLuongHocSinh , LOP.SiSo
	FROM HOCSINH_LOP HL
	INNER JOIN LOP LP ON HL.MaLop = LP.MaLop
	INNER JOIN KETQUAHOCMON KQ ON KQ.MaHS = HL.MaHS
	INNER JOIN LOP LOP ON LOP.MaLop = HL.MaLop
	WHERE KQ.MaHocKy = 'HK01' AND  HL.DiemTBHK > @DiemDat  
	GROUP BY HL.MaLop, LP.TenLop, KQ.MaHocKy, LOP.SiSo 

	OPEN MyCursorTuTinhBaoCaoHK1_TS 
	FETCH MyCursorTuTinhBaoCaoHK1_TS INTO @MaHocKy, @MaLop,  @SoLuongDat, @SiSo
	WHILE (@@FETCH_STATUS = 0)
		BEGIN
			IF EXISTS (SELECT * FROM dbo.BAOCAOHOCKY WHERE MaHocKy = @MaHocKy AND MaLop = @MaLop)
			BEGIN
				IF (@SiSo = 0)
				BEGIN
					UPDATE dbo.BAOCAOHOCKY SET SoLuongDat = @SoLuongDat, TiLe = 0
					WHERE MaHocKy = @MaHocKy AND MaLop = @MaLop
					
				END
				ELSE 
				BEGIN
					SET @TiLe = cast((cast(@SoLuongDat as float)/@SiSo)as float)
					UPDATE dbo.BAOCAOHOCKY SET SoLuongDat = @SoLuongDat, TiLe = @TiLe
					WHERE MaHocKy = @MaHocKy AND MaLop = @MaLop
				END
		
			END
			ELSE 
			BEGIN
				IF (@SiSo = 0)
				BEGIN
					INSERT INTO dbo.BAOCAOHOCKY(MaHocKy,MaLop,SoLuongDat,TiLe)
					VALUES(@MaHocKy, @MaLop, 0, 0)
				END
				ELSE
				BEGIN
					SET @TiLe = cast((cast(@SoLuongDat as float)/@SiSo)as float)
					INSERT INTO dbo.BAOCAOHOCKY(MaHocKy,MaLop,SoLuongDat,TiLe)
					VALUES(@MaHocKy, @MaLop, @SoLuongDat, @TiLe)
				END
		    
			END
			FETCH NEXT FROM MyCursorTuTinhBaoCaoHK1_TS INTO @MaHocKy, @MaLop, @SoLuongDat, @SiSo
		END
	CLOSE MyCursorTuTinhBaoCaoHK1_TS
	DEALLOCATE MyCursorTuTinhBaoCaoHK1_TS
END
GO
----  5.2 LẬP BÁO CÁO TỔNG KẾT KỲ 2



CREATE TRIGGER [dbo].[TRG_BAOCAOHOCKY2_THAMSO] ON [dbo].[THAMSO] FOR UPDATE AS 
BEGIN
    DECLARE @MaHocKy VARCHAR(20), @MaLop VARCHAR(20), @SoLuongDat INT, @DiemDat INT, @SiSo INT, @TiLe FLOAT
	SELECT @DiemDat = GiaTri FROM dbo.THAMSO WHERE TenThamSo = N'DiemDatMon'

    DECLARE MyCursorTuTinhBaoCaoHK2_TS CURSOR FOR 
		
	SELECT KQ.MaHocKy ,HL.MaLop, COUNT(DISTINCT HL.MaHS) AS SoLuongHocSinh , LOP.SiSo
	FROM HOCSINH_LOP HL
	INNER JOIN LOP LP ON HL.MaLop = LP.MaLop
	INNER JOIN KETQUAHOCMON KQ ON KQ.MaHS = HL.MaHS
	INNER JOIN LOP LOP ON LOP.MaLop = HL.MaLop
	WHERE KQ.MaHocKy = 'HK02' --AND  HL.DiemTBHK > 8  
	GROUP BY HL.MaLop, LP.TenLop, KQ.MaHocKy, LOP.SiSo



	--xoa
	OPEN MyCursorTuTinhBaoCaoHK2_TS 
	FETCH MyCursorTuTinhBaoCaoHK2_TS INTO @MaHocKy, @MaLop,  @SoLuongDat, @SiSo
	WHILE (@@FETCH_STATUS = 0)
		BEGIN
			IF EXISTS (SELECT * FROM dbo.BAOCAOHOCKY WHERE MaHocKy = @MaHocKy AND MaLop = @MaLop)
			BEGIN
				
					UPDATE dbo.BAOCAOHOCKY SET SoLuongDat = 0, TiLe = 0
					WHERE MaHocKy = @MaHocKy AND MaLop = @MaLop
					
			
			END
			ELSE 
			BEGIN
			
				BEGIN
					INSERT INTO dbo.BAOCAOHOCKY(MaHocKy,MaLop,SoLuongDat,TiLe)
					VALUES(@MaHocKy, @MaLop, 0, 0)
				END
				
		    
			END
			FETCH NEXT FROM MyCursorTuTinhBaoCaoHK2_TS INTO @MaHocKy, @MaLop, @SoLuongDat, @SiSo
		END
	CLOSE MyCursorTuTinhBaoCaoHK2_TS
	DEALLOCATE MyCursorTuTinhBaoCaoHK2_TS

	--xoa
	   DECLARE MyCursorTuTinhBaoCaoHK2_TS CURSOR FOR 
		
	SELECT KQ.MaHocKy ,HL.MaLop, COUNT(DISTINCT HL.MaHS) AS SoLuongHocSinh , LOP.SiSo
	FROM HOCSINH_LOP HL
	INNER JOIN LOP LP ON HL.MaLop = LP.MaLop
	INNER JOIN KETQUAHOCMON KQ ON KQ.MaHS = HL.MaHS
	INNER JOIN LOP LOP ON LOP.MaLop = HL.MaLop
	WHERE KQ.MaHocKy = 'HK02' AND  HL.DiemTBHK > @DiemDat  
	GROUP BY HL.MaLop, LP.TenLop, KQ.MaHocKy, LOP.SiSo 

	OPEN MyCursorTuTinhBaoCaoHK2_TS 
	FETCH MyCursorTuTinhBaoCaoHK2_TS INTO @MaHocKy, @MaLop,  @SoLuongDat, @SiSo
	WHILE (@@FETCH_STATUS = 0)
		BEGIN
			IF EXISTS (SELECT * FROM dbo.BAOCAOHOCKY WHERE MaHocKy = @MaHocKy AND MaLop = @MaLop)
			BEGIN
				IF (@SiSo = 0)
				BEGIN
					UPDATE dbo.BAOCAOHOCKY SET SoLuongDat = @SoLuongDat, TiLe = 0
					WHERE MaHocKy = @MaHocKy AND MaLop = @MaLop
					
				END
				ELSE 
				BEGIN
					SET @TiLe = cast((cast(@SoLuongDat as float)/@SiSo)as float)
					UPDATE dbo.BAOCAOHOCKY SET SoLuongDat = @SoLuongDat, TiLe = @TiLe
					WHERE MaHocKy = @MaHocKy AND MaLop = @MaLop
				END
		
			END
			ELSE 
			BEGIN
				IF (@SiSo = 0)
				BEGIN
					INSERT INTO dbo.BAOCAOHOCKY(MaHocKy,MaLop,SoLuongDat,TiLe)
					VALUES(@MaHocKy, @MaLop, 0, 0)
				END
				ELSE
				BEGIN
					SET @TiLe = cast((cast(@SoLuongDat as float)/@SiSo)as float)
					INSERT INTO dbo.BAOCAOHOCKY(MaHocKy,MaLop,SoLuongDat,TiLe)
					VALUES(@MaHocKy, @MaLop, @SoLuongDat, @TiLe)
				END
		    
			END
			FETCH NEXT FROM MyCursorTuTinhBaoCaoHK2_TS INTO @MaHocKy, @MaLop, @SoLuongDat, @SiSo
		END
	CLOSE MyCursorTuTinhBaoCaoHK2_TS
	DEALLOCATE MyCursorTuTinhBaoCaoHK2_TS
END
GO

--5.2.2
CREATE TRIGGER [dbo].[TRG_BAOCAOHOCKY2_KETQUAHOCMON] ON [dbo].[KETQUAHOCMON] FOR UPDATE AS 
BEGIN
    DECLARE @MaHocKy VARCHAR(20), @MaLop VARCHAR(20), @SoLuongDat INT, @DiemDat INT, @SiSo INT, @TiLe FLOAT
	SELECT @DiemDat = GiaTri FROM dbo.THAMSO WHERE TenThamSo = 'Diemdatmon'--diemdatmon

    DECLARE MyCursorTuTinhBaoCaoHK2_TS CURSOR FOR 
		SELECT DISTINCT KETQUAHOCMON.MaHocKy, LOP_MONHOC.MaLop, COUNT(IIF(DiemTBHK >= @DiemDat, 1, NULL)) AS SoLuongDat, SiSo
		FROM dbo.HOCSINH_LOP INNER JOIN dbo.KETQUAHOCMON ON KETQUAHOCMON.MaHS = HOCSINH_LOP.MaHS  FULL JOIN dbo.LOP_MONHOC ON LOP_MONHOC.MaMH = KETQUAHOCMON.MaMH FULL JOIN dbo.LOP ON LOP.MaLop = LOP_MONHOC.MaLop AND LOP.MaLop = HOCSINH_LOP.MaLop
		WHERE DiemTBMon IS NOT NULL AND KETQUAHOCMON.MaHocKy IS NOT NULL AND SiSo IS NOT NULL AND KETQUAHOCMON.MaHocKy = 'HK002'
		GROUP BY KETQUAHOCMON.MaHocKy, LOP_MONHOC.MaLop, SiSo

	OPEN MyCursorTuTinhBaoCaoHK2_TS 
	FETCH MyCursorTuTinhBaoCaoHK2_TS INTO @MaHocKy, @MaLop, @SoLuongDat, @SiSo
	WHILE (@@FETCH_STATUS = 0)
	BEGIN
	    IF EXISTS (SELECT * FROM dbo.BAOCAOHOCKY WHERE MaHocKy = @MaHocKy AND MaLop = @MaLop)
		BEGIN
			IF (@SiSo = 0)
			BEGIN
			    UPDATE dbo.BAOCAOMONHOC SET SoLuongDat = @SoLuongDat, TiLe = 0
				WHERE MaHocKy = @MaHocKy AND MaLop = @MaLop
			END
			ELSE 
			BEGIN
				SET @TiLe = @SoLuongDat / @SiSo
			    UPDATE dbo.BAOCAOMONHOC SET SoLuongDat = @SoLuongDat, TiLe = @TiLe
				WHERE MaHocKy = @MaHocKy AND MaLop = @MaLop
			END
		
		END
		ELSE 
		BEGIN
			IF (@SiSo = 0)
			BEGIN
			    INSERT INTO dbo.BAOCAOHOCKY(MaHocKy,MaLop,SoLuongDat,TiLe)
				VALUES(@MaHocKy, @MaLop, @SoLuongDat, 0)
			END
			ELSE
			BEGIN
				SET @TiLe =  @SoLuongDat/@SiSo
			    INSERT INTO dbo.BAOCAOHOCKY(MaHocKy,MaLop,SoLuongDat,TiLe)
				VALUES(@MaHocKy, @MaLop, @SoLuongDat, @TiLe)
			END
		    
		END
		FETCH NEXT FROM MyCursorTuTinhBaoCaoHK2_TS INTO @MaHocKy, @MaLop, @SoLuongDat, @SiSo
	END
	CLOSE MyCursorTuTinhBaoCaoHK2_TS
	DEALLOCATE MyCursorTuTinhBaoCaoHK2_TS
END
GO
----  5.3 LẬP BÁO CÁO TỔNG KẾT MÔN
drop trigger [dbo].[TRG_BAOCAOMONHOC_THAMSO]

CREATE TRIGGER [dbo].[TRG_BAOCAOMONHOC_THAMSO] ON [dbo].[THAMSO] FOR UPDATE AS 
BEGIN
    DECLARE @MaHocKy VARCHAR(20), @MaLop VARCHAR(20), @MaMH VARCHAR(20), @SoLuongDat INT, @DiemDatMon INT, @SiSo INT, @TiLe FLOAT
	SELECT @DiemDatMon = GiaTri FROM dbo.THAMSO WHERE TenThamSo = 'DiemDatMon'

    DECLARE MyCursorTuTinhBaoCaoMH_TS CURSOR FOR 
		--sua

		SELECT KQ.MaHocKy ,HL.MaLop,KQ.MaMH, COUNT(DISTINCT HL.MaHS) AS SoLuongDat , LOP.SiSo
	FROM HOCSINH_LOP HL
	INNER JOIN LOP LP ON HL.MaLop = LP.MaLop
	INNER JOIN KETQUAHOCMON KQ ON KQ.MaHS = HL.MaHS
	INNER JOIN LOP LOP ON LOP.MaLop = HL.MaLop
	--WHERE   HL.DiemTBHK > =5 
	GROUP BY HL.MaLop, LP.TenLop, KQ.MaHocKy, LOP.SiSo ,KQ.MaMH
		--SELECT  LOP.MaHocKy, HOCSINH_LOP.MaLop, KETQUAHOCMON.MaMH, COUNT( DiemTBMon) AS SoLuongDat, SiSo
		--FROM dbo.KETQUAHOCMON INNER JOIN dbo.HOCSINH_LOP 
		--ON HOCSINH_LOP.MaHS = KETQUAHOCMON.MaHS INNER JOIN dbo.LOP_MONHOC
		--ON LOP_MONHOC.MaMH = KETQUAHOCMON.MaMH AND LOP_MONHOC.MaLop = HOCSINH_LOP.MaLop INNER JOIN LOP 
		--ON LOP.MaHocKy = KETQUAHOCMON.MaHocKy AND LOP.MaLop = HOCSINH_LOP.MaLop
		--WHERE DiemTBMon IS NOT NULL AND SiSo IS NOT NULL --AND DiemTBMon >= 5--@DiemDatMon
		--GROUP BY KETQUAHOCMON.MaMH, LOP.MaHocKy, HOCSINH_LOP.MaLop, SiSo

	
	
	--xoa
	OPEN MyCursorTuTinhBaoCaoMH_TS 
	FETCH MyCursorTuTinhBaoCaoMH_TS INTO @MaHocKy, @MaLop, @MaMH, @SoLuongDat, @SiSo
	WHILE (@@FETCH_STATUS = 0)
	BEGIN
	    IF EXISTS (SELECT * FROM dbo.BAOCAOMONHOC WHERE MaHocKy = @MaHocKy AND MaLop = @MaLop AND MaMH = @MaMH)
		BEGIN
			BEGIN
			    UPDATE dbo.BAOCAOMONHOC SET SoLuongDat = 0, TiLe = 0 --SoLuongDat = @SoLuongDat, TiLe = 0
				WHERE MaHocKy = @MaHocKy AND MaLop = @MaLop AND MaMH = @MaMH
			END
			
		
		END
		ELSE 
		BEGIN
		
			BEGIN
			    INSERT INTO dbo.BAOCAOMONHOC(MaHocKy,MaLop,MaMH,SoLuongDat,TiLe)
				VALUES(@MaHocKy, @MaLop, @MaMH, 0, 0)
			END
			
		    
		END
		FETCH NEXT FROM MyCursorTuTinhBaoCaoMH_TS INTO @MaHocKy, @MaLop, @MaMH, @SoLuongDat, @SiSo
	END
	CLOSE MyCursorTuTinhBaoCaoMH_TS
	DEALLOCATE MyCursorTuTinhBaoCaoMH_TS

	--xoa
	DECLARE MyCursorTuTinhBaoCaoMH_TS CURSOR FOR 
		--sua

		SELECT KQ.MaHocKy ,HL.MaLop,KQ.MaMH, COUNT(DISTINCT HL.MaHS) AS SoLuongDat , LOP.SiSo
	FROM HOCSINH_LOP HL
	INNER JOIN LOP LP ON HL.MaLop = LP.MaLop
	INNER JOIN KETQUAHOCMON KQ ON KQ.MaHS = HL.MaHS
	INNER JOIN LOP LOP ON LOP.MaLop = HL.MaLop
	WHERE   HL.DiemTBHK >=@DiemDatMon 
	GROUP BY HL.MaLop, LP.TenLop, KQ.MaHocKy, LOP.SiSo ,KQ.MaMH

	OPEN MyCursorTuTinhBaoCaoMH_TS 
	FETCH MyCursorTuTinhBaoCaoMH_TS INTO @MaHocKy, @MaLop, @MaMH, @SoLuongDat, @SiSo
	WHILE (@@FETCH_STATUS = 0)
	BEGIN
	    IF EXISTS (SELECT * FROM dbo.BAOCAOMONHOC WHERE MaHocKy = @MaHocKy AND MaLop = @MaLop AND MaMH = @MaMH)
		BEGIN
		print (@Siso);
			IF (@SiSo = 0)
			BEGIN
			    UPDATE dbo.BAOCAOMONHOC SET SoLuongDat = 0, TiLe = 0 --SoLuongDat = @SoLuongDat, TiLe = 0
				WHERE MaHocKy = @MaHocKy AND MaLop = @MaLop AND MaMH = @MaMH
			END
			ELSE 
			BEGIN
				SET @TiLe = cast((cast(@SoLuongDat as float)/@SiSo)as float)
			    UPDATE dbo.BAOCAOMONHOC SET SoLuongDat = @SoLuongDat, TiLe = @TiLe
				WHERE MaHocKy = @MaHocKy AND MaLop = @MaLop AND MaMH = @MaMH
			END
		
		END
		ELSE 
		BEGIN
			IF (@SiSo = 0)
			BEGIN
			    INSERT INTO dbo.BAOCAOMONHOC(MaHocKy,MaLop,MaMH,SoLuongDat,TiLe)
				VALUES(@MaHocKy, @MaLop, @MaMH, 0, 0)
			END
			ELSE
			BEGIN
				SET @TiLe =  cast((cast(@SoLuongDat as float)/@SiSo)as float)
			    INSERT INTO dbo.BAOCAOMONHOC(MaHocKy,MaLop,MaMH,SoLuongDat,TiLe)
				VALUES(@MaHocKy, @MaLop, @MaMH, @SoLuongDat, @TiLe)
			END
		    
		END
		FETCH NEXT FROM MyCursorTuTinhBaoCaoMH_TS INTO @MaHocKy, @MaLop, @MaMH, @SoLuongDat, @SiSo
	END
	CLOSE MyCursorTuTinhBaoCaoMH_TS
	DEALLOCATE MyCursorTuTinhBaoCaoMH_TS
END

GO

---5.3.2
CREATE TRIGGER [dbo].[TRG_BAOCAOMONHOC_KETQUAHOCMON] ON [dbo].[KETQUAHOCMON] FOR UPDATE AS 
BEGIN
    DECLARE @MaHocKy VARCHAR(20), @MaLop VARCHAR(20), @MaMH VARCHAR(20), @SoLuongDat INT, @DiemDatMon INT, @SiSo INT, @TiLe FLOAT
	SELECT @DiemDatMon = GiaTri FROM dbo.THAMSO WHERE TenThamSo = 'DiemDatMon'

    DECLARE MyCursorTuTinhBaoCaoMH_TS CURSOR FOR 
		--sua

		SELECT KQ.MaHocKy ,HL.MaLop,KQ.MaMH, COUNT(DISTINCT HL.MaHS) AS SoLuongDat , LOP.SiSo
	FROM HOCSINH_LOP HL
	INNER JOIN LOP LP ON HL.MaLop = LP.MaLop
	INNER JOIN KETQUAHOCMON KQ ON KQ.MaHS = HL.MaHS
	INNER JOIN LOP LOP ON LOP.MaLop = HL.MaLop
	--WHERE   HL.DiemTBHK > =5 
	GROUP BY HL.MaLop, LP.TenLop, KQ.MaHocKy, LOP.SiSo ,KQ.MaMH
	--xoa
	OPEN MyCursorTuTinhBaoCaoMH_TS 
	FETCH MyCursorTuTinhBaoCaoMH_TS INTO @MaHocKy, @MaLop, @MaMH, @SoLuongDat, @SiSo
	WHILE (@@FETCH_STATUS = 0)
	BEGIN
	    IF EXISTS (SELECT * FROM dbo.BAOCAOMONHOC WHERE MaHocKy = @MaHocKy AND MaLop = @MaLop AND MaMH = @MaMH)
		BEGIN
			BEGIN
			    UPDATE dbo.BAOCAOMONHOC SET SoLuongDat = 0, TiLe = 0 --SoLuongDat = @SoLuongDat, TiLe = 0
				WHERE MaHocKy = @MaHocKy AND MaLop = @MaLop AND MaMH = @MaMH
			END
			
		
		END
		ELSE 
		BEGIN
		
			BEGIN
			    INSERT INTO dbo.BAOCAOMONHOC(MaHocKy,MaLop,MaMH,SoLuongDat,TiLe)
				VALUES(@MaHocKy, @MaLop, @MaMH, 0, 0)
			END
			
		    
		END
		FETCH NEXT FROM MyCursorTuTinhBaoCaoMH_TS INTO @MaHocKy, @MaLop, @MaMH, @SoLuongDat, @SiSo
	END
	CLOSE MyCursorTuTinhBaoCaoMH_TS
	DEALLOCATE MyCursorTuTinhBaoCaoMH_TS

	--xoa
	DECLARE MyCursorTuTinhBaoCaoMH_TS CURSOR FOR 
		--sua

		SELECT KQ.MaHocKy ,HL.MaLop,KQ.MaMH, COUNT(DISTINCT HL.MaHS) AS SoLuongDat , LOP.SiSo
	FROM HOCSINH_LOP HL
	INNER JOIN LOP LP ON HL.MaLop = LP.MaLop
	INNER JOIN KETQUAHOCMON KQ ON KQ.MaHS = HL.MaHS
	INNER JOIN LOP LOP ON LOP.MaLop = HL.MaLop
	WHERE   HL.DiemTBHK >=@DiemDatMon 
	GROUP BY HL.MaLop, LP.TenLop, KQ.MaHocKy, LOP.SiSo ,KQ.MaMH

	OPEN MyCursorTuTinhBaoCaoMH_TS 
	FETCH MyCursorTuTinhBaoCaoMH_TS INTO @MaHocKy, @MaLop, @MaMH, @SoLuongDat, @SiSo
	WHILE (@@FETCH_STATUS = 0)
	BEGIN
	    IF EXISTS (SELECT * FROM dbo.BAOCAOMONHOC WHERE MaHocKy = @MaHocKy AND MaLop = @MaLop AND MaMH = @MaMH)
		BEGIN
		print (@Siso);
			IF (@SiSo = 0)
			BEGIN
			    UPDATE dbo.BAOCAOMONHOC SET SoLuongDat = 0, TiLe = 0 --SoLuongDat = @SoLuongDat, TiLe = 0
				WHERE MaHocKy = @MaHocKy AND MaLop = @MaLop AND MaMH = @MaMH
			END
			ELSE 
			BEGIN
				SET @TiLe = cast((cast(@SoLuongDat as float)/@SiSo)as float)
			    UPDATE dbo.BAOCAOMONHOC SET SoLuongDat = @SoLuongDat, TiLe = @TiLe
				WHERE MaHocKy = @MaHocKy AND MaLop = @MaLop AND MaMH = @MaMH
			END
		
		END
		ELSE 
		BEGIN
			IF (@SiSo = 0)
			BEGIN
			    INSERT INTO dbo.BAOCAOMONHOC(MaHocKy,MaLop,MaMH,SoLuongDat,TiLe)
				VALUES(@MaHocKy, @MaLop, @MaMH, 0, 0)
			END
			ELSE
			BEGIN
				SET @TiLe =  cast((cast(@SoLuongDat as float)/@SiSo)as float)
			    INSERT INTO dbo.BAOCAOMONHOC(MaHocKy,MaLop,MaMH,SoLuongDat,TiLe)
				VALUES(@MaHocKy, @MaLop, @MaMH, @SoLuongDat, @TiLe)
			END
		    
		END
		FETCH NEXT FROM MyCursorTuTinhBaoCaoMH_TS INTO @MaHocKy, @MaLop, @MaMH, @SoLuongDat, @SiSo
	END
	CLOSE MyCursorTuTinhBaoCaoMH_TS
	DEALLOCATE MyCursorTuTinhBaoCaoMH_TS
END
go
--insert
SET DATEFORMAT DMY
--- TABLE HOCSINH (50)
INSERT INTO HOCSINH(MaHS,HoTen,GioiTinh,NgSinh,DiaChi,Email) VALUES ('HS01',N'Nguyễn Thế Hưng',N'Nam','15/12/2003',N'Thái Bình',N'21522120@gm.uit.edu.vn');
INSERT INTO HOCSINH(MaHS,HoTen,GioiTinh,NgSinh,DiaChi,Email) VALUES ('HS02',N'Nguyễn Tấn Đạt',N'Nam','23/06/2003',N'Đồng Nai',N'21520703@gm.uit.edu.vn');
INSERT INTO HOCSINH(MaHS,HoTen,GioiTinh,NgSinh,DiaChi,Email) VALUES ('HS03',N'Phạm Huy Hoàng',N'Nam','10/12/2003',N'Bình Dương',N'21522098@gm.uit.edu.vn');
INSERT INTO HOCSINH(MaHS,HoTen,GioiTinh,NgSinh,DiaChi,Email) VALUES ('HS04',N'Nguyễn Huy Hoàng',N'Nam',NULL,N'Gia Lai',N'21520255@gm.uit.edu.vn');
INSERT INTO HOCSINH(MaHS,HoTen,GioiTinh,NgSinh,DiaChi,Email) VALUES ('HS05',N'Nguyễn Lê Quỳnh Hương',N'Nữ','10/03/2003',N'Đồng Nai',N'21520255@gm.uit.edu.vn');
INSERT INTO HOCSINH(MaHS,HoTen,GioiTinh,NgSinh,DiaChi,Email) VALUES ('HS06',N'Dương Quang Bảo',N'Nam','10/02/2002',N'Bến Tre',N'20521098@gm.uit.edu.vn');
INSERT INTO HOCSINH(MaHS,HoTen,GioiTinh,NgSinh,DiaChi,Email) VALUES ('HS07',N'Đào Đại Chí',N'Nam','14/05/2003',N'Bạc Liêu',N'21520646@gm.uit.edu.vn');
INSERT INTO HOCSINH(MaHS,HoTen,GioiTinh,NgSinh,DiaChi,Email) VALUES ('HS08',N'Đào Tiến Đạt',N'Nam','01/05/2003',N'An Giang',N'21520692@gm.uit.edu.vn');
INSERT INTO HOCSINH(MaHS,HoTen,GioiTinh,NgSinh,DiaChi,Email) VALUES ('HS09',N'Đỗ Khánh Đan',N'Nữ','30/04/2003',N'Kiên Giang',N'21521916@gm.uit.edu.vn');
INSERT INTO HOCSINH(MaHS,HoTen,GioiTinh,NgSinh,DiaChi,Email) VALUES ('HS10',N'Đỗ Nguyễn Anh Khoa',N'Nam','15/07/2003',N'TPHCM',N'21522219@gm.uit.edu.vn');
INSERT INTO HOCSINH(MaHS,HoTen,GioiTinh,NgSinh,DiaChi,Email) VALUES ('HS11',N'Hồ Chí An',N'Nam','23/10/2002',N'Lâm Đồng',N'20521046@gm.uit.edu.vn');
INSERT INTO HOCSINH(MaHS,HoTen,GioiTinh,NgSinh,DiaChi,Email) VALUES ('HS12',N'Hồ Đăng Minh Trí',N'Nam','06/07/2002',N'Bình Định',N'20522047@gm.uit.edu.vn');
INSERT INTO HOCSINH(MaHS,HoTen,GioiTinh,NgSinh,DiaChi,Email) VALUES ('HS13',N'Hồ Tấn Anh',N'Nam','25/12/2003',N'Tiền Giang',N'21521818@gm.uit.edu.vn');
INSERT INTO HOCSINH(MaHS,HoTen,GioiTinh,NgSinh,DiaChi,Email) VALUES ('HS14',N'Huỳnh Hải Băng',N'Nam','27/11/2003',N'Khánh Hòa',N'21521846@gm.uit.edu.vn');
INSERT INTO HOCSINH(MaHS,HoTen,GioiTinh,NgSinh,DiaChi,Email) VALUES ('HS15',N'Huỳnh Minh Thư',N'Nữ','21/09/2001',N'Đà Nẵng',N'19522304@gm.uit.edu.vn');
INSERT INTO HOCSINH(MaHS,HoTen,GioiTinh,NgSinh,DiaChi,Email) VALUES ('HS16',N'Lê Hoàng Phúc',N'Nam','10/05/2002',N'Cà Mau',N'20521762@gm.uit.edu.vn');
INSERT INTO HOCSINH(MaHS,HoTen,GioiTinh,NgSinh,DiaChi,Email) VALUES ('HS17',N'Lê Nguyễn Nhật Anh',N'Nữ','23/10/2003',N'Gia Lai',N'21520138@gm.uit.edu.vn');
INSERT INTO HOCSINH(MaHS,HoTen,GioiTinh,NgSinh,DiaChi,Email) VALUES ('HS18',N'Lê Trung Hải',N'Nam','19/04/2003',N'Kom Tum',N'21522033@gm.uit.edu.vn');
INSERT INTO HOCSINH(MaHS,HoTen,GioiTinh,NgSinh,DiaChi,Email) VALUES ('HS19',N'Lê Trung Kiên',N'Nam','17/02/2002',N'Cần Thơ',N'20521488@gm.uit.edu.vn');
--- TABLE GIAOVIEN
ALTER TABLE GIAOVIEN NOCHECK CONSTRAINT ALL

INSERT INTO GIAOVIEN(MaGV,HoTen,NgSinh,GioiTinh,DiaChi,Email) VALUES ('GV01',N'Phạm Nhật Huy','21/09/1999',N'Nam',N'Bình Thuận',N'huypn@uit.edu.vn');
INSERT INTO GIAOVIEN(MaGV,HoTen,NgSinh,GioiTinh,DiaChi,Email) VALUES ('GV02',N'Nguyễn Gia Tuấn','10/05/1990',N'Nam',N'Phú Yên',N'tuanng@uit.edu.vn');
INSERT INTO GIAOVIEN(MaGV,HoTen,NgSinh,GioiTinh,DiaChi,Email) VALUES ('GV03',N'Trần Minh Ngọc','23/10/1978',N'Nữ',N'Quảng Ninh',N'ngoctm@uit.edu.vn');
INSERT INTO GIAOVIEN(MaGV,HoTen,NgSinh,GioiTinh,DiaChi,Email) VALUES ('GV04',N'Nguyễn Nhật Tân','19/04/1988',N'Nam',N'Hà Nội',N'tannn@uit.edu.vn');
INSERT INTO GIAOVIEN(MaGV,HoTen,NgSinh,GioiTinh,DiaChi,Email) VALUES ('GV05',N'Nguyễn Thị Trang','17/02/1993',N'Nữ',N'Vĩnh Long',N'trangnt@uit.edu.vn');
INSERT INTO GIAOVIEN(MaGV,HoTen,NgSinh,GioiTinh,DiaChi,Email) VALUES ('GV07',N'Trần Hà Đan','25/12/1991',N'Nữ',N'Long An',N'danht@uit.edu.vn');
INSERT INTO GIAOVIEN(MaGV,HoTen,NgSinh,GioiTinh,DiaChi,Email) VALUES ('GV08',N'Nguyễn Khánh Tùng','27/11/1997',N'Nam',N'Long Khánh',N'tungnk@uit.edu.vn');


ALTER TABLE GIAOVIEN CHECK CONSTRAINT ALL
--- TABLE KHOILOP (3)
INSERT INTO KHOILOP(MaKhoiLop,TenKhoiLop) VALUES (N'K10',N'Khối 10');
INSERT INTO KHOILOP(MaKhoiLop,TenKhoiLop) VALUES (N'K11',N'Khối 11');
INSERT INTO KHOILOP(MaKhoiLop,TenKhoiLop) VALUES (N'K12',N'Khối 12');

--- TABLE NAMHOC (3)
INSERT INTO NAMHOC(MaNam,Nam1,Nam2) VALUES ('NH2020',2019,2020);
INSERT INTO NAMHOC(MaNam,Nam1,Nam2) VALUES ('NH2021',2020,2021);
INSERT INTO NAMHOC(MaNam,Nam1,Nam2) VALUES ('NH2022',2021,2022);
INSERT INTO NAMHOC(MaNam,Nam1,Nam2) VALUES ('NH2023',2022,2023);


--- TABLE HOCKY (2)
SET DATEFORMAT DMY
INSERT INTO HOCKY(MaHocKy,HocKy,MaNam,NgayBD,NgayKT) VALUES ('HK01',1,'NH2022','5/9/2022','31/1/2023');
INSERT INTO HOCKY(MaHocKy,HocKy,MaNam,NgayBD,NgayKT) VALUES ('HK02',2,'NH2022','10/2/2023','1/7/2023');

--- TABLE LOP
INSERT INTO LOP(MaLop,TenLop,MaHocKy,SiSo,MaKhoiLop) VALUES ('TN101',N'Tự nhiên','HK01',NULL,'K10');
INSERT INTO LOP(MaLop,TenLop,MaHocKy,SiSo,MaKhoiLop) VALUES ('TN101',N'Tự nhiên','HK02',NULL,'K10');
INSERT INTO LOP(MaLop,TenLop,MaHocKy,SiSo,MaKhoiLop) VALUES ('TN102',N'Tự nhiên','HK01',NULL,'K10');
INSERT INTO LOP(MaLop,TenLop,MaHocKy,SiSo,MaKhoiLop) VALUES ('TN102',N'Tự nhiên','HK02',NULL,'K10');
INSERT INTO LOP(MaLop,TenLop,MaHocKy,SiSo,MaKhoiLop) VALUES ('TN103',N'Tự nhiên','HK01',NULL,'K10');
INSERT INTO LOP(MaLop,TenLop,MaHocKy,SiSo,MaKhoiLop) VALUES ('TN103',N'Tự nhiên','HK02',NULL,'K10');
INSERT INTO LOP(MaLop,TenLop,MaHocKy,SiSo,MaKhoiLop) VALUES ('TN111',N'Tự nhiên','HK01',NULL,'K11');
INSERT INTO LOP(MaLop,TenLop,MaHocKy,SiSo,MaKhoiLop) VALUES ('TN111',N'Tự nhiên','HK02',NULL,'K11');
INSERT INTO LOP(MaLop,TenLop,MaHocKy,SiSo,MaKhoiLop) VALUES ('TN112',N'Tự nhiên','HK01',NULL,'K11');
INSERT INTO LOP(MaLop,TenLop,MaHocKy,SiSo,MaKhoiLop) VALUES ('TN112',N'Tự nhiên','HK02',NULL,'K11');
INSERT INTO LOP(MaLop,TenLop,MaHocKy,SiSo,MaKhoiLop) VALUES ('TN113',N'Tự nhiên','HK01',NULL,'K11');
INSERT INTO LOP(MaLop,TenLop,MaHocKy,SiSo,MaKhoiLop) VALUES ('TN113',N'Tự nhiên','HK02',NULL,'K11');
INSERT INTO LOP(MaLop,TenLop,MaHocKy,SiSo,MaKhoiLop) VALUES ('TN121',N'Tự nhiên','HK01',NULL,'K12');
INSERT INTO LOP(MaLop,TenLop,MaHocKy,SiSo,MaKhoiLop) VALUES ('TN121',N'Tự nhiên','HK02',NULL,'K12');
INSERT INTO LOP(MaLop,TenLop,MaHocKy,SiSo,MaKhoiLop) VALUES ('TN122',N'Tự nhiên','HK01',NULL,'K12');
INSERT INTO LOP(MaLop,TenLop,MaHocKy,SiSo,MaKhoiLop) VALUES ('TN122',N'Tự nhiên','HK02',NULL,'K12');
INSERT INTO LOP(MaLop,TenLop,MaHocKy,SiSo,MaKhoiLop) VALUES ('TN123',N'Tự nhiên','HK01',NULL,'K12');
INSERT INTO LOP(MaLop,TenLop,MaHocKy,SiSo,MaKhoiLop) VALUES ('TN123',N'Tự nhiên','HK02',NULL,'K12');
INSERT INTO LOP(MaLop,TenLop,MaHocKy,SiSo,MaKhoiLop) VALUES ('XH101',N'Xã hội','HK01',NULL,'K10');
INSERT INTO LOP(MaLop,TenLop,MaHocKy,SiSo,MaKhoiLop) VALUES ('XH101',N'Xã hội','HK02',NULL,'K10');
INSERT INTO LOP(MaLop,TenLop,MaHocKy,SiSo,MaKhoiLop) VALUES ('XH111',N'Xã hội','HK01',NULL,'K11');
INSERT INTO LOP(MaLop,TenLop,MaHocKy,SiSo,MaKhoiLop) VALUES ('XH111',N'Xã hội','HK02',NULL,'K11');
INSERT INTO LOP(MaLop,TenLop,MaHocKy,SiSo,MaKhoiLop) VALUES ('XH121',N'Xã hội','HK01',NULL,'K12');
INSERT INTO LOP(MaLop,TenLop,MaHocKy,SiSo,MaKhoiLop) VALUES ('XH121',N'Xã hội','HK02',NULL,'K12');
--monhoc
INSERT INTO MONHOC(MaMH,TenMH,MoTa,HeSo) VALUES ('Toan10',N'Toán 10',N'Môn bắt buộc',2);
INSERT INTO MONHOC(MaMH,TenMH,MoTa,HeSo) VALUES ('Toan11',N'Toán 11',N'Môn bắt buộc',2);
INSERT INTO MONHOC(MaMH,TenMH,MoTa,HeSo) VALUES ('Toan12',N'Toán 12',N'Môn bắt buộc',2);
INSERT INTO MONHOC(MaMH,TenMH,MoTa,HeSo) VALUES ('Van10',N'Văn 10',N'Môn bắt buộc',2);
INSERT INTO MONHOC(MaMH,TenMH,MoTa,HeSo) VALUES ('Van11',N'Văn 11',N'Môn bắt buộc',2);
INSERT INTO MONHOC(MaMH,TenMH,MoTa,HeSo) VALUES ('Van12',N'Văn 12',N'Môn bắt buộc',2);
INSERT INTO MONHOC(MaMH,TenMH,MoTa,HeSo) VALUES ('Anh10',N'Ngoại ngữ 10',N'Môn bắt buộc',2);
INSERT INTO MONHOC(MaMH,TenMH,MoTa,HeSo) VALUES ('Anh11',N'Ngoại ngữ 11',N'Môn bắt buộc',2);
INSERT INTO MONHOC(MaMH,TenMH,MoTa,HeSo) VALUES ('Anh12',N'Ngoại ngữ 12',N'Môn bắt buộc',2);
INSERT INTO MONHOC(MaMH,TenMH,MoTa,HeSo) VALUES ('Hoa12',N'Hóa 12',N'Môn tự nhiên',1);
INSERT INTO MONHOC(MaMH,TenMH,MoTa,HeSo) VALUES ('Hoa10',N'Hóa 10',N'Môn tự nhiên',1);
INSERT INTO MONHOC(MaMH,TenMH,MoTa,HeSo) VALUES ('Ly10',N'Lý 10',N'Môn tự nhiên',1);
INSERT INTO MONHOC(MaMH,TenMH,MoTa,HeSo) VALUES ('Ly11',N'Lý 11',N'Môn tự nhiên',1);
INSERT INTO MONHOC(MaMH,TenMH,MoTa,HeSo) VALUES ('Su11',N'Sử 11',N'Môn xã hội',1);
INSERT INTO MONHOC(MaMH,TenMH,MoTa,HeSo) VALUES ('Dia10',N'Địa 10',N'Môn xã hội',1);
--lop_monhoc
INSERT INTO LOP_MONHOC(MaLop,MaMH,MaGV) VALUES ('TN101','Toan10','GV01');
INSERT INTO LOP_MONHOC(MaLop,MaMH,MaGV) VALUES ('TN101','Van10','GV02');
INSERT INTO LOP_MONHOC(MaLop,MaMH,MaGV) VALUES ('TN101','Anh10','GV07');
INSERT INTO LOP_MONHOC(MaLop,MaMH,MaGV) VALUES ('TN102','Van10','GV02');
INSERT INTO LOP_MONHOC(MaLop,MaMH,MaGV) VALUES ('TN102','Ly10','GV03');
INSERT INTO LOP_MONHOC(MaLop,MaMH,MaGV) VALUES ('TN102','Anh10','GV07');
INSERT INTO LOP_MONHOC(MaLop,MaMH,MaGV) VALUES ('TN103','Ly10','GV03');
INSERT INTO LOP_MONHOC(MaLop,MaMH,MaGV) VALUES ('TN111','Toan11','GV04');
INSERT INTO LOP_MONHOC(MaLop,MaMH,MaGV) VALUES ('TN112','Van11','GV05');
INSERT INTO LOP_MONHOC(MaLop,MaMH,MaGV) VALUES ('TN113','Anh11','GV07');
INSERT INTO LOP_MONHOC(MaLop,MaMH,MaGV) VALUES ('TN121','Toan12','GV08');
INSERT INTO LOP_MONHOC(MaLop,MaMH,MaGV) VALUES ('TN122','Anh12','GV07');
INSERT INTO LOP_MONHOC(MaLop,MaMH,MaGV) VALUES ('TN123','Van12','GV08');
INSERT INTO LOP_MONHOC(MaLop,MaMH,MaGV) VALUES ('XH101','Dia10','GV04');
INSERT INTO LOP_MONHOC(MaLop,MaMH,MaGV) VALUES ('XH111','Su11','GV05');
INSERT INTO LOP_MONHOC(MaLop,MaMH,MaGV) VALUES ('XH121','Toan12','GV02');

SET IDENTITY_INSERT dbo.KETQUAHOCMON ON
GO


INSERT INTO KETQUAHOCMON(MaQTHoc,MaMH,MAHS,MaHocKy) VALUES (1,'Toan10','HS01','HK01');
INSERT INTO KETQUAHOCMON(MaQTHoc,MaMH,MAHS,MaHocKy) VALUES (2,'Toan10','HS02','HK01');
INSERT INTO KETQUAHOCMON(MaQTHoc,MaMH,MAHS,MaHocKy) VALUES (3,'Toan10','HS03','HK01');
INSERT INTO KETQUAHOCMON(MaQTHoc,MaMH,MAHS,MaHocKy) VALUES (4,'Toan10','HS04','HK01');
INSERT INTO KETQUAHOCMON(MaQTHoc,MaMH,MAHS,MaHocKy) VALUES (5,'Toan10','HS05','HK01');
INSERT INTO KETQUAHOCMON(MaQTHoc,MaMH,MAHS,MaHocKy) VALUES (6,'Toan10','HS06','HK01');
INSERT INTO KETQUAHOCMON(MaQTHoc,MaMH,MAHS,MaHocKy) VALUES (7,'Toan10','HS07','HK01');
INSERT INTO KETQUAHOCMON(MaQTHoc,MaMH,MAHS,MaHocKy) VALUES (8,'Toan10','HS08','HK01');
INSERT INTO KETQUAHOCMON(MaQTHoc,MaMH,MAHS,MaHocKy) VALUES (9,'Toan10','HS09','HK01');
INSERT INTO KETQUAHOCMON(MaQTHoc,MaMH,MAHS,MaHocKy) VALUES (10,'Toan10','HS10','HK01');
INSERT INTO KETQUAHOCMON(MaQTHoc,MaMH,MAHS,MaHocKy) VALUES (11,'Toan10','HS11','HK01');
INSERT INTO KETQUAHOCMON(MaQTHoc,MaMH,MAHS,MaHocKy) VALUES (12,'Toan10','HS12','HK01');
INSERT INTO KETQUAHOCMON(MaQTHoc,MaMH,MAHS,MaHocKy) VALUES (13,'Toan10','HS13','HK01');
INSERT INTO KETQUAHOCMON(MaQTHoc,MaMH,MAHS,MaHocKy) VALUES (14,'Toan10','HS14','HK01');
INSERT INTO KETQUAHOCMON(MaQTHoc,MaMH,MAHS,MaHocKy) VALUES (15,'Toan10','HS15','HK01');
INSERT INTO KETQUAHOCMON(MaQTHoc,MaMH,MAHS,MaHocKy) VALUES (16,'Toan10','HS16','HK01');
INSERT INTO KETQUAHOCMON(MaQTHoc,MaMH,MAHS,MaHocKy) VALUES (17,'Toan10','HS17','HK01');
INSERT INTO KETQUAHOCMON(MaQTHoc,MaMH,MAHS,MaHocKy) VALUES (18,'Toan10','HS18','HK01');
INSERT INTO KETQUAHOCMON(MaQTHoc,MaMH,MAHS,MaHocKy) VALUES (19,'Toan10','HS19','HK01');
INSERT INTO KETQUAHOCMON(MaQTHoc,MaMH,MAHS,MaHocKy) VALUES (20,'Toan10','HS01','HK02');
INSERT INTO KETQUAHOCMON(MaQTHoc,MaMH,MAHS,MaHocKy) VALUES (21,'Toan10','HS02','HK02');
INSERT INTO KETQUAHOCMON(MaQTHoc,MaMH,MAHS,MaHocKy) VALUES (22,'Toan10','HS03','HK02');
INSERT INTO KETQUAHOCMON(MaQTHoc,MaMH,MAHS,MaHocKy) VALUES (23,'Toan10','HS04','HK02');
INSERT INTO KETQUAHOCMON(MaQTHoc,MaMH,MAHS,MaHocKy) VALUES (24,'Toan10','HS05','HK02');
INSERT INTO KETQUAHOCMON(MaQTHoc,MaMH,MAHS,MaHocKy) VALUES (25,'Toan10','HS06','HK02');
INSERT INTO KETQUAHOCMON(MaQTHoc,MaMH,MAHS,MaHocKy) VALUES (26,'Toan10','HS07','HK02');
INSERT INTO KETQUAHOCMON(MaQTHoc,MaMH,MAHS,MaHocKy) VALUES (27,'Toan10','HS08','HK02');
INSERT INTO KETQUAHOCMON(MaQTHoc,MaMH,MAHS,MaHocKy) VALUES (28,'Toan10','HS09','HK02');
INSERT INTO KETQUAHOCMON(MaQTHoc,MaMH,MAHS,MaHocKy) VALUES (29,'Toan10','HS10','HK02');
INSERT INTO KETQUAHOCMON(MaQTHoc,MaMH,MAHS,MaHocKy) VALUES (30,'Toan10','HS11','HK02');
INSERT INTO KETQUAHOCMON(MaQTHoc,MaMH,MAHS,MaHocKy) VALUES (31,'Toan10','HS12','HK02');
INSERT INTO KETQUAHOCMON(MaQTHoc,MaMH,MAHS,MaHocKy) VALUES (32,'Toan10','HS13','HK02');
INSERT INTO KETQUAHOCMON(MaQTHoc,MaMH,MAHS,MaHocKy) VALUES (33,'Toan10','HS14','HK02');
INSERT INTO KETQUAHOCMON(MaQTHoc,MaMH,MAHS,MaHocKy) VALUES (34,'Toan10','HS15','HK02');
INSERT INTO KETQUAHOCMON(MaQTHoc,MaMH,MAHS,MaHocKy) VALUES (35,'Toan10','HS16','HK02');
INSERT INTO KETQUAHOCMON(MaQTHoc,MaMH,MAHS,MaHocKy) VALUES (36,'Toan10','HS17','HK02');
INSERT INTO KETQUAHOCMON(MaQTHoc,MaMH,MAHS,MaHocKy) VALUES (37,'Toan10','HS18','HK02');
INSERT INTO KETQUAHOCMON(MaQTHoc,MaMH,MAHS,MaHocKy) VALUES (38,'Toan10','HS19','HK02');
INSERT INTO KETQUAHOCMON(MaQTHoc,MaMH,MAHS,MaHocKy) VALUES (39,'Van10','HS01','HK01');
INSERT INTO KETQUAHOCMON(MaQTHoc,MaMH,MAHS,MaHocKy) VALUES (40,'Van10','HS02','HK01');
INSERT INTO KETQUAHOCMON(MaQTHoc,MaMH,MAHS,MaHocKy) VALUES (41,'Van10','HS03','HK01');
INSERT INTO KETQUAHOCMON(MaQTHoc,MaMH,MAHS,MaHocKy) VALUES (42,'Van10','HS04','HK01');
INSERT INTO KETQUAHOCMON(MaQTHoc,MaMH,MAHS,MaHocKy) VALUES (43,'Van10','HS05','HK01');
INSERT INTO KETQUAHOCMON(MaQTHoc,MaMH,MAHS,MaHocKy) VALUES (44,'Van10','HS06','HK01');
INSERT INTO KETQUAHOCMON(MaQTHoc,MaMH,MAHS,MaHocKy) VALUES (45,'Van10','HS07','HK01');
INSERT INTO KETQUAHOCMON(MaQTHoc,MaMH,MAHS,MaHocKy) VALUES (46,'Van10','HS08','HK01');
INSERT INTO KETQUAHOCMON(MaQTHoc,MaMH,MAHS,MaHocKy) VALUES (47,'Van10','HS09','HK01');
INSERT INTO KETQUAHOCMON(MaQTHoc,MaMH,MAHS,MaHocKy) VALUES (48,'Van10','HS10','HK01');
INSERT INTO KETQUAHOCMON(MaQTHoc,MaMH,MAHS,MaHocKy) VALUES (49,'Van10','HS11','HK01');
INSERT INTO KETQUAHOCMON(MaQTHoc,MaMH,MAHS,MaHocKy) VALUES (50,'Van10','HS12','HK01');
SET IDENTITY_INSERT dbo.KETQUAHOCMON OFF

go
SELECT * FROM dbo.KETQUAHOCMON
TRUNCATE TABLE HOCSINH_LOP;
INSERT INTO HOCSINH_LOP(MaHS,MaLop) VALUES ('HS01','TN101');
INSERT INTO HOCSINH_LOP(MaHS,MaLop) VALUES ('HS02','TN101');
INSERT INTO HOCSINH_LOP(MaHS,MaLop) VALUES ('HS03','TN101');
INSERT INTO HOCSINH_LOP(MaHS,MaLop) VALUES ('HS04','TN101');
INSERT INTO HOCSINH_LOP(MaHS,MaLop) VALUES ('HS05','TN102');
INSERT INTO HOCSINH_LOP(MaHS,MaLop) VALUES ('HS06','TN102');
INSERT INTO HOCSINH_LOP(MaHS,MaLop) VALUES ('HS07','TN102');
INSERT INTO HOCSINH_LOP(MaHS,MaLop) VALUES ('HS08','TN112');
INSERT INTO HOCSINH_LOP(MaHS,MaLop) VALUES ('HS09','TN112');
INSERT INTO HOCSINH_LOP(MaHS,MaLop) VALUES ('HS10','TN112');
INSERT INTO HOCSINH_LOP(MaHS,MaLop) VALUES ('HS11','TN123');
INSERT INTO HOCSINH_LOP(MaHS,MaLop) VALUES ('HS12','TN123');
INSERT INTO HOCSINH_LOP(MaHS,MaLop) VALUES ('HS13','TN123');
INSERT INTO HOCSINH_LOP(MaHS,MaLop) VALUES ('HS14','XH101');
INSERT INTO HOCSINH_LOP(MaHS,MaLop) VALUES ('HS15','XH101');
INSERT INTO HOCSINH_LOP(MaHS,MaLop) VALUES ('HS16','XH101');
INSERT INTO HOCSINH_LOP(MaHS,MaLop) VALUES ('HS17','XH111');
INSERT INTO HOCSINH_LOP(MaHS,MaLop) VALUES ('HS18','XH111');
INSERT INTO HOCSINH_LOP(MaHS,MaLop) VALUES ('HS19','XH111');

INSERT INTO LOAIHINHKIEMTRA(MaLHKT,TenLHKT,HeSo) VALUES ('DM',N'Kiểm tra miệng',1);
INSERT INTO LOAIHINHKIEMTRA(MaLHKT,TenLHKT,HeSo) VALUES ('KT15P',N'Kiểm tra 15 phút',1);
INSERT INTO LOAIHINHKIEMTRA(MaLHKT,TenLHKT,HeSo) VALUES ('KT1T',N'Kiểm tra 1 tiết',2);
INSERT INTO LOAIHINHKIEMTRA(MaLHKT,TenLHKT,HeSo) VALUES ('KTCK',N'Kiểm tra cuối kỳ',3);
INSERT INTO LOAIHINHKIEMTRA(MaLHKT,TenLHKT,HeSo) VALUES ('KTGK',N'Kiểm tra giữa kỳ',2);

SET IDENTITY_INSERT dbo.CT_HOCMON ON
GO
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (1,1,'DM',8);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (2,1,'KT15P',9);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (3,1,'KT1T',7);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (4,1,'KTGK',9);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (5,1,'KTCK',7.5);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (6,2,'DM',8);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (7,2,'KT15P',9);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (8,2,'KT1T',7);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (9,2,'KTGK',9);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (10,2,'KTCK',7.5);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (11,3,'DM',8);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (12,3,'KT15P',9);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (13,3,'KT1T',7);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (14,3,'KTGK',9);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (15,3,'KTCK',7.5);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (16,4,'DM',8);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (17,4,'KT15P',9);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (18,4,'KT1T',7);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (19,4,'KTGK',9);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (20,4,'KTCK',7);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (21,5,'DM',8);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (22,5,'KT15P',9);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (23,5,'KT1T',7);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (24,5,'KTGK',9);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (25,5,'KTCK',7.5);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (26,6,'DM',8);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (27,6,'KT15P',9);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (28,6,'KT1T',7);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (29,6,'KTGK',9);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (30,6,'KTCK',7.5);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (31,7,'DM',8);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (32,7,'KT15P',9);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (33,7,'KT1T',7);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (34,7,'KTGK',9);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (35,7,'KTCK',7.5);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (36,8,'DM',8);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (37,8,'KT15P',9);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (38,8,'KT1T',7);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (39,8,'KTGK',9);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (40,8,'KTCK',7.5);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (41,9,'DM',8);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (42,9,'KT15P',9);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (43,9,'KT1T',7);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (44,9,'KTGK',9);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (45,9,'KTCK',7.5);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (46,10,'DM',8);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (47,10,'KT15P',9);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (48,10,'KT1T',7);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (49,10,'KTGK',9);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (50,10,'KTCK',7.5);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (51,11,'DM',9);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (52,11,'KT15P',7.5);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (53,11,'KT1T',8);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (54,11,'KTGK',9);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (55,11,'KTCK',7);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (56,12,'DM',9);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (57,12,'KT15P',7.5);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (58,12,'KT1T',8);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (59,12,'KTGK',9);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (60,12,'KTCK',7);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (61,13,'DM',9);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (62,13,'KT15P',7.5);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (63,13,'KT1T',8);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (64,13,'KTGK',9);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (65,13,'KTCK',7);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (66,14,'DM',9);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (67,14,'KT15P',7.5);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (68,14,'KT1T',8);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (69,14,'KTGK',9);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (70,14,'KTCK',7);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (71,15,'DM',9);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (72,15,'KT15P',7.5);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (73,15,'KT1T',8);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (74,15,'KTGK',9);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (75,15,'KTCK',7);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (76,16,'DM',9);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (77,16,'KT15P',7.5);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (78,16,'KT1T',8);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (79,16,'KTGK',9);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (80,16,'KTCK',7);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (81,17,'DM',9);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (82,17,'KT15P',7.5);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (83,17,'KT1T',8);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (84,17,'KTGK',9);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (85,17,'KTCK',7);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (86,18,'DM',9);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (87,18,'KT15P',7.5);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (88,18,'KT1T',8);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (89,18,'KTGK',9);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (90,18,'KTCK',7);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (91,19,'DM',9);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (92,19,'KT15P',7.5);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (93,19,'KT1T',8);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (94,19,'KTGK',9);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (95,19,'KTCK',7);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (96,20,'DM',9);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (97,20,'KT15P',7.5);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (98,20,'KT1T',8);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (99,20,'KTGK',9);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (100,20,'KTCK',7);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (101,21,'DM',7.5);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (102,21,'KT15P',8);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (103,21,'KT1T',9);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (104,21,'KTGK',7);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (105,21,'KTCK',9);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (106,22,'DM',7.5);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (107,22,'KT15P',8);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (108,22,'KT1T',9);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (109,22,'KTGK',7);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (110,22,'KTCK',9);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (111,23,'DM',7.5);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (112,23,'KT15P',8);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (113,23,'KT1T',9);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (114,23,'KTGK',7);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (115,23,'KTCK',9);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (116,24,'DM',7.5);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (117,24,'KT15P',8);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (118,24,'KT1T',9);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (119,24,'KTGK',7);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (120,24,'KTCK',9);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (121,25,'DM',7.5);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (122,25,'KT15P',8);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (123,25,'KT1T',9);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (124,25,'KTGK',7);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (125,25,'KTCK',9);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (126,26,'DM',7.5);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (127,26,'KT15P',8);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (128,26,'KT1T',9);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (129,26,'KTGK',7);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (130,26,'KTCK',9);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (131,27,'DM',7.5);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (132,27,'KT15P',8);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (133,27,'KT1T',9);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (134,27,'KTGK',7);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (135,27,'KTCK',9);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (136,28,'DM',7.5);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (137,28,'KT15P',8);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (138,28,'KT1T',9);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (139,28,'KTGK',7);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (140,28,'KTCK',9);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (141,29,'DM',7.5);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (142,29,'KT15P',8);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (143,29,'KT1T',9);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (144,29,'KTGK',7);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (145,29,'KTCK',9);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (146,30,'DM',7.5);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (147,30,'KT15P',8);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (148,30,'KT1T',9);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (149,30,'KTGK',7);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (150,30,'KTCK',9);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (151,31,'DM',7);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (152,31,'KT15P',9);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (153,31,'KT1T',7.5);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (154,31,'KTGK',8);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (155,31,'KTCK',9);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (156,32,'DM',7);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (157,32,'KT15P',9);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (158,32,'KT1T',7.5);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (159,32,'KTGK',8);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (160,32,'KTCK',9);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (161,33,'DM',7);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (162,33,'KT15P',9);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (163,33,'KT1T',7.5);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (164,33,'KTGK',8);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (165,33,'KTCK',9);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (166,34,'DM',7);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (167,34,'KT15P',9);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (168,34,'KT1T',7.5);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (169,34,'KTGK',8);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (170,34,'KTCK',9);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (171,35,'DM',7);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (172,35,'KT15P',9);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (173,35,'KT1T',7.5);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (174,35,'KTGK',8);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (175,35,'KTCK',9);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (176,36,'DM',7);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (177,36,'KT15P',9);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (178,36,'KT1T',7.5);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (179,36,'KTGK',8);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (180,36,'KTCK',9);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (181,37,'DM',7);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (182,37,'KT15P',9);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (183,37,'KT1T',7.5);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (184,37,'KTGK',8);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (185,37,'KTCK',9);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (186,38,'DM',7);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (187,38,'KT15P',9);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (188,38,'KT1T',7.5);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (189,38,'KTGK',8);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (190,38,'KTCK',9);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (191,39,'DM',9);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (192,39,'KT15P',9);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (193,39,'KT1T',7.5);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (194,39,'KTGK',8);
INSERT INTO CT_HOCMON(MaCTHocMon,MaQTHoc,MALHKT,Diem) VALUES (195,39,'KTCK',9);

SET IDENTITY_INSERT dbo.CT_HOCMON OFF
go

INSERT INTO THAMSO VALUES (N'DiemDatMon',5);
UPDATE THAMSO
SET GiaTri=5
where TenThamSo=N'DiemDatMon'

delete from BAOCAOHOCKY

select distinct *
from hocky inner  join ketquahocmon on hocky.MaHocKy=ketquahocmon.MaHocKy, lop 
where hocky.MaHocKy= lop.MaHocKy



INSERT INTO THAMSO VALUES (N'DiemToiDa',10);
INSERT INTO THAMSO VALUES (N'DiemToiThieu',1);
INSERT INTO THAMSO VALUES (N'SiSoToiDa','45');
INSERT INTO THAMSO VALUES (N'TuoiToiDa','18');
INSERT INTO THAMSO VALUES (N'TuoiToiThieu','15');