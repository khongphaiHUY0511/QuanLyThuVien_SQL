-- =============================
-- TẠO CƠ SỞ DỮ LIỆU
-- =============================
DROP DATABASE IF EXISTS QL_THUVIEN;
GO
CREATE DATABASE QL_THUVIEN;
GO
USE QL_THUVIEN;
GO


-- =============================
-- 1. BẢNG NGƯỜI DÙNG
-- =============================
CREATE TABLE NguoiDung (
    MaND INT IDENTITY(1,1) PRIMARY KEY,
    HoTen NVARCHAR(100),
    TenDangNhap NVARCHAR(50) UNIQUE,
    MatKhau NVARCHAR(100),
    VaiTro NVARCHAR(20), -- DocGia, ThuThu, QuanLy
    Email NVARCHAR(100),
    DienThoai NVARCHAR(15),
	CCCD VARCHAR(12)
);
GO


-- =============================
-- 2. BẢNG THỂ LOẠI
-- =============================
CREATE TABLE TheLoai (
    MaTL INT IDENTITY(1,1) PRIMARY KEY,
    TenTheLoai NVARCHAR(100)
);
GO


-- =============================
-- 3. BẢNG KỆ
-- =============================
CREATE TABLE Ke (
    MaKe INT IDENTITY(1,1) PRIMARY KEY,
    TenKe NVARCHAR(50),
    MoTa NVARCHAR(200)
);
GO


-- =============================
-- 4. BẢNG ĐẦU SÁCH
-- =============================
CREATE TABLE DauSach (
    MaDauSach INT IDENTITY(1,1) PRIMARY KEY,
    TenDauSach NVARCHAR(200),
    TacGia NVARCHAR(100),
    NhaXuatBan NVARCHAR(100),
    ISBN NVARCHAR(13) UNIQUE,
    NamXuatBan INT,
    LanXuatBan INT,
    GiaBia DECIMAL(10,2),
    NgonNgu NVARCHAR(50),
    MaTL INT FOREIGN KEY REFERENCES TheLoai(MaTL),
    MaKe INT FOREIGN KEY REFERENCES Ke(MaKe),
    SoLuong INT DEFAULT 0,
    Hinh NVARCHAR(255)
);
GO


-- =============================
-- 5. BẢNG SÁCH
-- =============================
CREATE TABLE Sach (
    MaSach INT IDENTITY(1,1) PRIMARY KEY,
    MaDauSach INT FOREIGN KEY REFERENCES DauSach(MaDauSach),
    TrangThai NVARCHAR(20) -- Con, DangMuon, Mat, HuHong
);
GO


-- =============================
-- 6. PHIẾU NHẬP
-- =============================
CREATE TABLE PhieuNhap (
    MaPN INT IDENTITY(1,1) PRIMARY KEY,
    MaND INT FOREIGN KEY REFERENCES NguoiDung(MaND),
    NgayNhap DATE,
    TongTien DECIMAL(12,2),
    GhiChu NVARCHAR(200)
);
GO


-- =============================
-- 7. CHI TIẾT PHIẾU NHẬP
-- =============================
CREATE TABLE ChiTietPhieuNhap (
    MaCTPN INT IDENTITY(1,1) PRIMARY KEY,
    MaPN INT FOREIGN KEY REFERENCES PhieuNhap(MaPN),
    MaDauSach INT FOREIGN KEY REFERENCES DauSach(MaDauSach),
    SoLuong INT,
    DonGia DECIMAL(10,2)
);
GO


-- =============================
-- 8. PHIẾU MƯỢN
-- =============================
CREATE TABLE PhieuMuon (
    MaPM INT IDENTITY(1,1) PRIMARY KEY,
    MaND INT FOREIGN KEY REFERENCES NguoiDung(MaND),
    MaSach INT FOREIGN KEY REFERENCES Sach(MaSach),
    NgayMuon DATE,
    NgayHenTra DATE,
    TrangThai NVARCHAR(20) -- DangMuon, DaTra, QuaHan
);
GO
-- =============================
-- 9. PHIẾU TRẢ
-- =============================
CREATE TABLE PhieuTra (
    MaPT INT IDENTITY(1,1) PRIMARY KEY,
    MaPM INT NOT NULL,                      -- Khóa tới phiếu mượn (mỗi phiếu mượn gắn 1 phiếu trả)
    NgayTra DATE NOT NULL,
    TongTienPhat DECIMAL(12,2) DEFAULT 0,   -- Tổng tiền phạt tính cho phiếu trả này
    GhiChu NVARCHAR(255),
    CONSTRAINT FK_PhieuTra_PhieuMuon FOREIGN KEY (MaPM) REFERENCES PhieuMuon(MaPM)
);
GO
-- =============================
-- 10. PHIẾU ĐẶT CHỖ
-- =============================
CREATE TABLE PhieuDatCho (
    MaPDC INT IDENTITY(1,1) PRIMARY KEY,
    MaND INT FOREIGN KEY REFERENCES NguoiDung(MaND),
    MaDauSach INT FOREIGN KEY REFERENCES DauSach(MaDauSach),
    NgayDat DATE,
    TrangThai NVARCHAR(20) -- ChoMuon, DaHuy, DaMuon
);
GO


-- =============================
-- 11. PHIẾU PHẠT
-- =============================
CREATE TABLE PhieuPhat (
    MaPhieuPhat INT IDENTITY(1,1) PRIMARY KEY,
    MaPT INT FOREIGN KEY REFERENCES PhieuTra(MaPT),
    SoTien DECIMAL(10,2),
    LoaiPhat INT, -- 1 (hu duoi 50% hoac tre han) ,2(hu tren 50%) , 3(khong the su dung sach)
    NgayLap DATE,
    TrangThai NVARCHAR(20) -- ChuaDong, DaDong
);
GO



-- 1. NGƯỜI DÙNG
INSERT INTO NguoiDung (HoTen, TenDangNhap, MatKhau, VaiTro, Email, DienThoai, CCCD) VALUES
(N'Nguyễn Văn A', 'docgia1', '123456', 'DocGia', 'a@gmail.com', '0909123456', '012345678901'),
(N'Trần Thị B', 'thuthu1', '123456', 'ThuThu', 'b@gmail.com', '0909234567', '012345678902'),
(N'Lê Văn C', 'quanly1', '123456', 'QuanLy', 'c@gmail.com', '0909345678', '012345678903');
GO

-- 2. THỂ LOẠI
INSERT INTO TheLoai (TenTheLoai) VALUES
(N'Tiểu thuyết'), (N'Khoa học'), (N'Lịch sử'), (N'Thiếu nhi'), (N'Công nghệ thông tin');
GO

-- 3. KỆ
INSERT INTO Ke (TenKe, MoTa) VALUES
(N'Kệ A1', N'Sách văn học và tiểu thuyết'),
(N'Kệ B2', N'Sách khoa học và lịch sử'),
(N'Kệ C3', N'Sách công nghệ và lập trình');
GO

-- 4. ĐẦU SÁCH
INSERT INTO DauSach (TenDauSach, TacGia, NhaXuatBan, ISBN, NamXuatBan, LanXuatBan, GiaBia, NgonNgu, MaTL, MaKe, SoLuong, Hinh) VALUES
(N'Đắc Nhân Tâm', N'Dale Carnegie', N'Trẻ', '9786041137643', 2020, 5, 85000, N'Tiếng Việt', 1, 1, 5, N'hinh_dacnhantam.jpg'),
(N'Lập trình Python cơ bản', N'Nguyễn Văn Dũng', N'NXB Bách Khoa', '9786047723452', 2023, 1, 120000, N'Tiếng Việt', 5, 3, 3, N'python_cb.jpg'),
(N'Lịch sử Việt Nam', N'Phan Huy Lê', N'Giáo Dục', '9786049967892', 2021, 2, 95000, N'Tiếng Việt', 3, 2, 2, N'lichsu_vn.jpg');
GO

-- 5. SÁCH (từng bản sao)
INSERT INTO Sach (MaDauSach, TrangThai) VALUES
(1, N'Con'), (1, N'Con'), (1, N'DangMuon'),
(2, N'Con'), (2, N'Con'), (2, N'Con'),
(3, N'Con'), (3, N'DangMuon');
GO

-- 6. PHIẾU NHẬP
INSERT INTO PhieuNhap (MaND, NgayNhap, TongTien, GhiChu) VALUES
(2, '2024-01-10', 500000, N'Nhập sách đầu năm'),
(3, '2024-06-15', 300000, N'Bổ sung sách CNTT');
GO

-- 7. CHI TIẾT PHIẾU NHẬP
INSERT INTO ChiTietPhieuNhap (MaPN, MaDauSach, SoLuong, DonGia) VALUES
(1, 1, 3, 80000),
(1, 3, 2, 90000),
(2, 2, 3, 110000);
GO

-- 8. PHIẾU MƯỢN
INSERT INTO PhieuMuon (MaND, MaSach, NgayMuon, NgayHenTra, TrangThai) VALUES
(1, 3, '2024-07-01', '2024-07-15', N'DaTra'),
(1, 8, '2024-08-01', '2024-08-20', N'QuaHan');
GO

-- 9. PHIẾU TRẢ
INSERT INTO PhieuTra (MaPM, NgayTra, TongTienPhat, GhiChu) VALUES
(1, '2024-07-10', 0, N'Trả đúng hạn'),
(2, '2024-08-25', 15000, N'Trả trễ 5 ngày');
GO

-- 10. PHIẾU ĐẶT CHỖ
INSERT INTO PhieuDatCho (MaND, MaDauSach, NgayDat, TrangThai) VALUES
(1, 2, '2024-09-01', N'ChoMuon'),
(1, 1, '2024-09-10', N'DaHuy');
GO

-- 11. PHIẾU PHẠT
INSERT INTO PhieuPhat (MaPT, SoTien, LoaiPhat, NgayLap, TrangThai) VALUES
(2, 15000, 1, '2024-08-25', N'DaDong');
GO
