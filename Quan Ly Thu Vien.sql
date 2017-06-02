USE [master]
GO
/****** Object:  Database [QUANLYTHUVIEN]    Script Date: 2017-06-02 2:52:40 PM ******/
CREATE DATABASE [QUANLYTHUVIEN]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'QUANLYTHUVIEN', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.SQLEXPRESS\MSSQL\DATA\QUANLYTHUVIEN.mdf' , SIZE = 3136KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'QUANLYTHUVIEN_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.SQLEXPRESS\MSSQL\DATA\QUANLYTHUVIEN_log.ldf' , SIZE = 832KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [QUANLYTHUVIEN] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [QUANLYTHUVIEN].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [QUANLYTHUVIEN] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [QUANLYTHUVIEN] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [QUANLYTHUVIEN] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [QUANLYTHUVIEN] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [QUANLYTHUVIEN] SET ARITHABORT OFF 
GO
ALTER DATABASE [QUANLYTHUVIEN] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [QUANLYTHUVIEN] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [QUANLYTHUVIEN] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [QUANLYTHUVIEN] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [QUANLYTHUVIEN] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [QUANLYTHUVIEN] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [QUANLYTHUVIEN] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [QUANLYTHUVIEN] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [QUANLYTHUVIEN] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [QUANLYTHUVIEN] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [QUANLYTHUVIEN] SET  ENABLE_BROKER 
GO
ALTER DATABASE [QUANLYTHUVIEN] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [QUANLYTHUVIEN] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [QUANLYTHUVIEN] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [QUANLYTHUVIEN] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [QUANLYTHUVIEN] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [QUANLYTHUVIEN] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [QUANLYTHUVIEN] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [QUANLYTHUVIEN] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [QUANLYTHUVIEN] SET  MULTI_USER 
GO
ALTER DATABASE [QUANLYTHUVIEN] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [QUANLYTHUVIEN] SET DB_CHAINING OFF 
GO
ALTER DATABASE [QUANLYTHUVIEN] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [QUANLYTHUVIEN] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
USE [QUANLYTHUVIEN]
GO
/****** Object:  StoredProcedure [dbo].[show_sach]    Script Date: 2017-06-02 2:52:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create proc [dbo].[show_sach]
as
begin
select MaSach,TenSach,NoiDungTT,SoTrang,GiaTien,SoLuong,NgayNhap,TinhTrang,N.TenNXB,t.HoTenTG,tl.TenTL
from Sach S,NhaXuatBan N,TacGia T,TheLoai TL
where S.MaNXB = N.MaNXB and s.MaTG = T.MaTG and s.MaTL = TL.MaTL
end
GO
/****** Object:  StoredProcedure [dbo].[SP_addphieumuon]    Script Date: 2017-06-02 2:52:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[SP_addphieumuon](@Maphieu int, @Masach varchar(10),@Madocgia varchar(10),@Manhanvien varchar(10),@Ngaymuon datetime,@Ngaytra datetime)
as
begin
if exists (select * from PhieuMuon p where p.MaPhieu=@Maphieu and p.MaDG!=@Madocgia)
begin
raiserror (N'Một phiếu mượn chỉ có 1 độc giả tương ứng',16,1)
end
if exists (select * from CT_PhieuMuon c where c.MaPhieu= @Maphieu and c.MaSach = @Masach)
begin
raiserror (N'Chỉ được mượn 1 quyển sách mỗi loại',16,1)
end
else
begin
if exists (select * from PhieuMuon where PhieuMuon.MaPhieu=@Maphieu)
begin
insert into CT_PhieuMuon(MaPhieu,MaSach,HanTra) values(@Maphieu,@Masach,@Ngaytra)
raiserror(N'Thêm thành công!',16,1)
end
else
begin
insert into PhieuMuon(MaPhieu,Ngaymuon,MaDG,MaNV) values(@Maphieu, @Ngaymuon,@Madocgia,@Manhanvien)
insert into CT_PhieuMuon(MaPhieu,MaSach,HanTra) values(@Maphieu,@Masach,@Ngaytra)
raiserror(N'Thêm thành công!',16,1)
end

end
end

GO
/****** Object:  StoredProcedure [dbo].[SP_showthongtindocgia]    Script Date: 2017-06-02 2:52:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[SP_showthongtindocgia]

as
begin 
select d.MaDG 'Mã độc giả',d.HoTenDG 'Tên độc giả',d.NgaySinhDG 'Ngày sinh',d.DiaChiDG 'Địa chỉ',d.GioiTinhDG 'Giới tính',d.EmailDG 'Email' ,d.DienThoaiDG 'Sđt',d.NgayLamThe 'Ngày làm thẻ',d.NgayHetHan 'Ngày hết hạn'
from DocGia d
end
GO
/****** Object:  StoredProcedure [dbo].[SP_showthongtinmuon]    Script Date: 2017-06-02 2:52:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[SP_showthongtinmuon]
as
begin
select  p.MaPhieu 'Phiếu mượn',p.MaDG 'Mã độc giả',d.HoTenDG 'Họ tên',d.NgaySinhDG 'Ngày sinh',ct.MaSach 'Mã sách',s.TenSach'Tên Sách',ct.HanTra 'Hạn trả',p.Ngaymuon  'Ngày mượn',n.HoTenNV 'Người cho mượn',p.MaNV 'Mã NV' 
from PhieuMuon p join CT_PhieuMuon ct on p.MaPhieu = ct.MaPhieu
join Sach s on ct.MaSach = s.MaSach
join DocGia d on p.MaDG= d.MaDG
join NhanVien n on p.MaNV = n.MaNV
end




GO
/****** Object:  StoredProcedure [dbo].[SP_showthongtinsach]    Script Date: 2017-06-02 2:52:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[SP_showthongtinsach]
as
begin
select s.MaSach as 'Mã sách', s.TenSach 'Tên sách',s.NoiDungTT as 'Nội dung tóm tắt',s.SoTrang as 'Số trang',s.GiaTien as 'Giá tiền',s.SoLuong as 'Số lượng',s.NgayNhap as 'Ngày nhập',s.TinhTrang as 'Tình trạng' ,n.TenNXB as 'Nhà xuất bản',t.HoTenTG 'Tác giả',tl.TenTL 'Thể loại'
from Sach s 
join NhaXuatBan n on s.MaNXB = n.MaNXB
join TacGia t on s.MaTG = t.MaTG
join TheLoai tl on s.MaTL = tl.MaTL
end
GO
/****** Object:  StoredProcedure [dbo].[SP_timkiemdocgia]    Script Date: 2017-06-02 2:52:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[SP_timkiemdocgia](@ten nvarchar(100))

as
begin
select * from DocGia where HoTenDG like N'%'+@ten+N'%'
end
GO
/****** Object:  StoredProcedure [dbo].[SP_timkiemnguoimuon]    Script Date: 2017-06-02 2:52:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[SP_timkiemnguoimuon] 
@ten nvarchar(100)
as
begin
select p.MaPhieu 'Phiếu mượn',p.MaDG 'Mã độc giả',d.HoTenDG 'Họ tên',d.NgaySinhDG 'Ngày sinh',n.HoTenNV 'Người cho mượn',p.MaNV 'Mã NV',s.TenSach'Tên Sách',ct.MaSach 'Mã sách' ,ct.HanTra 'Hạn trả',p.Ngaymuon  'Ngày mượn'
from PhieuMuon p join CT_PhieuMuon ct on p.MaPhieu = ct.MaPhieu
join Sach s on ct.MaSach = s.MaSach
join DocGia d on p.MaDG= d.MaDG
join NhanVien n on p.MaNV = n.MaNV where d.HoTenDG like '%'+@ten+'%'
end
GO
/****** Object:  StoredProcedure [dbo].[SP_timkiemsach]    Script Date: 2017-06-02 2:52:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[SP_timkiemsach](@ten nvarchar(100))

as
begin
select * from Sach where TenSach like N'%'+@ten+N'%'
end
GO
/****** Object:  StoredProcedure [dbo].[timkiem]    Script Date: 2017-06-02 2:52:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[timkiem](@key nvarchar(50))
as
begin
select *from DocGia where MaDG like N'%'+@key+'%' or HoTenDG like N'%'+@key+'%' or GioiTinhDG like N'%'+@key+'%' or NgaySinhDG like N'%'+@key+'%' or
DiaChiDG like N'%'+@key+'%' or DienThoaiDG like N'%'+@key+'%' or EmailDG like N'%'+@key+'%' or NgayLamThe like N'%'+@key+'%' or NgayHetHan like N'%'+@key+'%'
end

GO
/****** Object:  Table [dbo].[CT_PhieuMuon]    Script Date: 2017-06-02 2:52:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CT_PhieuMuon](
	[MaPhieu] [int] NOT NULL,
	[MaSach] [varchar](10) NOT NULL,
	[HanTra] [datetime] NULL,
 CONSTRAINT [PK_CT_PhieuMuon] PRIMARY KEY CLUSTERED 
(
	[MaPhieu] ASC,
	[MaSach] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DocGia]    Script Date: 2017-06-02 2:52:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DocGia](
	[MaDG] [varchar](10) NOT NULL,
	[HoTenDG] [nvarchar](100) NULL,
	[GioiTinhDG] [nvarchar](5) NULL,
	[NgaySinhDG] [datetime] NULL,
	[DiaChiDG] [nvarchar](100) NULL,
	[DienThoaiDG] [varchar](15) NULL,
	[EmailDG] [varchar](100) NULL,
	[NgayLamThe] [datetime] NULL,
	[NgayHetHan] [datetime] NULL,
 CONSTRAINT [PK_DocGia] PRIMARY KEY CLUSTERED 
(
	[MaDG] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[NhanVien]    Script Date: 2017-06-02 2:52:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[NhanVien](
	[MaNV] [varchar](10) NOT NULL,
	[HoTenNV] [nvarchar](100) NULL,
	[GioiTinhNV] [nvarchar](5) NULL,
	[NgaySinhNV] [datetime] NULL,
	[DienThoaiNV] [nvarchar](15) NULL,
	[DiaChiNV] [nvarchar](100) NULL,
	[EmailNV] [varchar](100) NULL,
	[NgayVaoLam] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[MaNV] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[NhaXuatBan]    Script Date: 2017-06-02 2:52:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[NhaXuatBan](
	[MaNXB] [varchar](10) NOT NULL,
	[TenNXB] [nvarchar](100) NULL,
	[DiaChiNXB] [nvarchar](100) NULL,
	[DienThoaiNXB] [varchar](15) NULL,
	[Website] [varchar](50) NULL,
 CONSTRAINT [PK_NhaXuatBan] PRIMARY KEY CLUSTERED 
(
	[MaNXB] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PhieuMuon]    Script Date: 2017-06-02 2:52:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PhieuMuon](
	[MaPhieu] [int] NOT NULL,
	[Ngaymuon] [datetime] NULL,
	[MaDG] [varchar](10) NULL,
	[MaNV] [varchar](10) NULL,
 CONSTRAINT [PK_PhieuMuon] PRIMARY KEY CLUSTERED 
(
	[MaPhieu] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Sach]    Script Date: 2017-06-02 2:52:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Sach](
	[MaSach] [varchar](10) NOT NULL,
	[TenSach] [nvarchar](100) NULL,
	[NoiDungTT] [nvarchar](300) NULL,
	[SoTrang] [int] NULL,
	[GiaTien] [bigint] NULL,
	[SoLuong] [int] NULL,
	[NgayNhap] [datetime] NULL,
	[TinhTrang] [nvarchar](100) NULL,
	[MaNXB] [varchar](10) NULL,
	[MaTG] [varchar](10) NULL,
	[MaTL] [varchar](10) NULL,
 CONSTRAINT [PK_Sach] PRIMARY KEY CLUSTERED 
(
	[MaSach] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TacGia]    Script Date: 2017-06-02 2:52:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TacGia](
	[MaTG] [varchar](10) NOT NULL,
	[HoTenTG] [nvarchar](100) NULL,
	[DiaChiTG] [nvarchar](100) NULL,
	[DienThoaiTG] [varchar](15) NULL,
 CONSTRAINT [PK_TacGia] PRIMARY KEY CLUSTERED 
(
	[MaTG] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TheLoai]    Script Date: 2017-06-02 2:52:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TheLoai](
	[MaTL] [varchar](10) NOT NULL,
	[TenTL] [nvarchar](100) NULL,
	[GhiChu] [nvarchar](500) NULL,
 CONSTRAINT [PK_TheLoai] PRIMARY KEY CLUSTERED 
(
	[MaTL] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TraSach]    Script Date: 2017-06-02 2:52:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TraSach](
	[MaPhieu] [int] NOT NULL,
	[MaSach] [varchar](10) NOT NULL,
	[Phat] [nvarchar](100) NULL,
	[NgayTra] [datetime] NULL,
	[MaNV] [varchar](10) NULL,
 CONSTRAINT [PK_TraSach] PRIMARY KEY CLUSTERED 
(
	[MaPhieu] ASC,
	[MaSach] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
INSERT [dbo].[CT_PhieuMuon] ([MaPhieu], [MaSach], [HanTra]) VALUES (4, N'S0002', CAST(0x0000A84700000000 AS DateTime))
INSERT [dbo].[CT_PhieuMuon] ([MaPhieu], [MaSach], [HanTra]) VALUES (7, N'S0001', CAST(0x0000A84700000000 AS DateTime))
INSERT [dbo].[CT_PhieuMuon] ([MaPhieu], [MaSach], [HanTra]) VALUES (8, N'S0001', CAST(0x0000A77100000000 AS DateTime))
INSERT [dbo].[CT_PhieuMuon] ([MaPhieu], [MaSach], [HanTra]) VALUES (8, N'S0002', CAST(0x0000A77100000000 AS DateTime))
INSERT [dbo].[CT_PhieuMuon] ([MaPhieu], [MaSach], [HanTra]) VALUES (10, N'S0001', CAST(0x0000A77200000000 AS DateTime))
INSERT [dbo].[CT_PhieuMuon] ([MaPhieu], [MaSach], [HanTra]) VALUES (10, N'S0004', CAST(0x0000A77200000000 AS DateTime))
INSERT [dbo].[DocGia] ([MaDG], [HoTenDG], [GioiTinhDG], [NgaySinhDG], [DiaChiDG], [DienThoaiDG], [EmailDG], [NgayLamThe], [NgayHetHan]) VALUES (N'âd', N'', N'Nam', CAST(0x0000A74E0178F914 AS DateTime), N'', N'', N'', CAST(0x0000A74E0178F914 AS DateTime), CAST(0x0000A74E0178F914 AS DateTime))
INSERT [dbo].[DocGia] ([MaDG], [HoTenDG], [GioiTinhDG], [NgaySinhDG], [DiaChiDG], [DienThoaiDG], [EmailDG], [NgayLamThe], [NgayHetHan]) VALUES (N'DG001', N'Trần Huy Tuấn', N'Nữ', CAST(0x000088F700000000 AS DateTime), N'Hà Nội 1', N'01689192299', N'huytuannn@gmail.com', CAST(0x0000A02A00000000 AS DateTime), CAST(0x0000A5DF00000000 AS DateTime))
INSERT [dbo].[DocGia] ([MaDG], [HoTenDG], [GioiTinhDG], [NgaySinhDG], [DiaChiDG], [DienThoaiDG], [EmailDG], [NgayLamThe], [NgayHetHan]) VALUES (N'DG002', N'namtv', N'Nam', CAST(0x00008A5D0153B154 AS DateTime), N'Nguyễn Khánh Toàn', N'01293218', N'namtv@gmail.com', CAST(0x0000A74E0153B154 AS DateTime), CAST(0x0000A74E0153B154 AS DateTime))
INSERT [dbo].[DocGia] ([MaDG], [HoTenDG], [GioiTinhDG], [NgaySinhDG], [DiaChiDG], [DienThoaiDG], [EmailDG], [NgayLamThe], [NgayHetHan]) VALUES (N'DG003', N'Tạ Văn Việt', N'Nam', CAST(0x00008F510156F864 AS DateTime), N'Bồng Mạc - Liên Mạc - Mê Linh - Hà Nội', N'01292938', N'viet@gmail.com', CAST(0x0000A03C0156F864 AS DateTime), CAST(0x0000A3060156F864 AS DateTime))
INSERT [dbo].[DocGia] ([MaDG], [HoTenDG], [GioiTinhDG], [NgaySinhDG], [DiaChiDG], [DienThoaiDG], [EmailDG], [NgayLamThe], [NgayHetHan]) VALUES (N'DG004', N'nam', N'Nữ', CAST(0x0000A74E0158F9AC AS DateTime), N'', N'', N'', CAST(0x0000A74E0158F9AC AS DateTime), CAST(0x0000A74E0158F9AC AS DateTime))
INSERT [dbo].[DocGia] ([MaDG], [HoTenDG], [GioiTinhDG], [NgaySinhDG], [DiaChiDG], [DienThoaiDG], [EmailDG], [NgayLamThe], [NgayHetHan]) VALUES (N'g1', N'', N'Nữ', CAST(0x0000A74E0160A10C AS DateTime), N'', N'', N'', CAST(0x0000A74E0160A10C AS DateTime), CAST(0x0000A74E0160A10C AS DateTime))
INSERT [dbo].[DocGia] ([MaDG], [HoTenDG], [GioiTinhDG], [NgaySinhDG], [DiaChiDG], [DienThoaiDG], [EmailDG], [NgayLamThe], [NgayHetHan]) VALUES (N'nam', N'', N'Nam', CAST(0x0000A74E015C0750 AS DateTime), N'', N'', N'', CAST(0x0000A74E015C0750 AS DateTime), CAST(0x0000A74E015C0750 AS DateTime))
INSERT [dbo].[DocGia] ([MaDG], [HoTenDG], [GioiTinhDG], [NgaySinhDG], [DiaChiDG], [DienThoaiDG], [EmailDG], [NgayLamThe], [NgayHetHan]) VALUES (N'nam1', N'', N'Nữ', CAST(0x0000A74E015C0750 AS DateTime), N'', N'', N'', CAST(0x0000A74E015C0750 AS DateTime), CAST(0x0000A74E015C0750 AS DateTime))
INSERT [dbo].[DocGia] ([MaDG], [HoTenDG], [GioiTinhDG], [NgaySinhDG], [DiaChiDG], [DienThoaiDG], [EmailDG], [NgayLamThe], [NgayHetHan]) VALUES (N'S0004', N'', N'Nữ', CAST(0x0000A74F010B696C AS DateTime), N'', N'', N'', CAST(0x0000A74F010B696C AS DateTime), CAST(0x0000A74F010B696C AS DateTime))
INSERT [dbo].[DocGia] ([MaDG], [HoTenDG], [GioiTinhDG], [NgaySinhDG], [DiaChiDG], [DienThoaiDG], [EmailDG], [NgayLamThe], [NgayHetHan]) VALUES (N'ss', N'', N'Nam', CAST(0x0000A78600B0B008 AS DateTime), N'', N'', N'', CAST(0x0000A78600B0B008 AS DateTime), CAST(0x0000A78600B0B008 AS DateTime))
INSERT [dbo].[NhanVien] ([MaNV], [HoTenNV], [GioiTinhNV], [NgaySinhNV], [DienThoaiNV], [DiaChiNV], [EmailNV], [NgayVaoLam]) VALUES (N'nv001', N'Tạ Văn Nam', N'Nam', CAST(0x00008A5D00000000 AS DateTime), N'01668327660', N'Hà Nội', N'namtv1996@gamil.com', CAST(0x0000A12500000000 AS DateTime))
INSERT [dbo].[NhanVien] ([MaNV], [HoTenNV], [GioiTinhNV], [NgaySinhNV], [DienThoaiNV], [DiaChiNV], [EmailNV], [NgayVaoLam]) VALUES (N'nv002', N'Đỗ Quang Hưng', N'Nam', CAST(0x0000893600000000 AS DateTime), N'09123123123', N'Hải Phòng', N'hungngu96@gamail.com', CAST(0x0000A1F500000000 AS DateTime))
INSERT [dbo].[NhanVien] ([MaNV], [HoTenNV], [GioiTinhNV], [NgaySinhNV], [DienThoaiNV], [DiaChiNV], [EmailNV], [NgayVaoLam]) VALUES (N'nv003', N'Đỗ Văn Quảng', N'Nam', CAST(0x00008A2C00000000 AS DateTime), N'09123137183', N'Thái Bình', N'quangcave96@gmail.com', CAST(0x0000A1F500000000 AS DateTime))
INSERT [dbo].[NhanVien] ([MaNV], [HoTenNV], [GioiTinhNV], [NgaySinhNV], [DienThoaiNV], [DiaChiNV], [EmailNV], [NgayVaoLam]) VALUES (N'nv004', N'Quang', N'Nam', CAST(0x000089E200000000 AS DateTime), N'016832342989', N'Hà Nội', N'quangtt@gmail.com', CAST(0x0000A23300000000 AS DateTime))
INSERT [dbo].[NhaXuatBan] ([MaNXB], [TenNXB], [DiaChiNXB], [DienThoaiNXB], [Website]) VALUES (N'nxb01', N'Giáo Dục', N'Hà Nội', N'01234429', N'giaoduc.com')
INSERT [dbo].[NhaXuatBan] ([MaNXB], [TenNXB], [DiaChiNXB], [DienThoaiNXB], [Website]) VALUES (N'nxb02', N'TP Hồ Chí Minh', N'Hồ Chí Minh', N'0923178187', N'xb.com.vn')
INSERT [dbo].[NhaXuatBan] ([MaNXB], [TenNXB], [DiaChiNXB], [DienThoaiNXB], [Website]) VALUES (N'nxb03', N'Đại Học Quốc Gia', N'Hà Nội', N'0912384819', NULL)
INSERT [dbo].[PhieuMuon] ([MaPhieu], [Ngaymuon], [MaDG], [MaNV]) VALUES (4, NULL, N'DG001', N'nv002')
INSERT [dbo].[PhieuMuon] ([MaPhieu], [Ngaymuon], [MaDG], [MaNV]) VALUES (6, CAST(0x0000A76D013D3141 AS DateTime), N'DG001', N'nv001')
INSERT [dbo].[PhieuMuon] ([MaPhieu], [Ngaymuon], [MaDG], [MaNV]) VALUES (7, CAST(0x0000A76A00000000 AS DateTime), N'DG003', N'nv001')
INSERT [dbo].[PhieuMuon] ([MaPhieu], [Ngaymuon], [MaDG], [MaNV]) VALUES (8, CAST(0x0000A77100000000 AS DateTime), N'DG003', N'nv001')
INSERT [dbo].[PhieuMuon] ([MaPhieu], [Ngaymuon], [MaDG], [MaNV]) VALUES (9, CAST(0x0000A77100000000 AS DateTime), N'DG003', N'nv001')
INSERT [dbo].[PhieuMuon] ([MaPhieu], [Ngaymuon], [MaDG], [MaNV]) VALUES (10, CAST(0x0000A77200000000 AS DateTime), N'DG002', N'nv001')
INSERT [dbo].[PhieuMuon] ([MaPhieu], [Ngaymuon], [MaDG], [MaNV]) VALUES (11, CAST(0x0000A77200000000 AS DateTime), N'DG001', N'nv001')
INSERT [dbo].[PhieuMuon] ([MaPhieu], [Ngaymuon], [MaDG], [MaNV]) VALUES (12, CAST(0x0000A77200000000 AS DateTime), N'DG001', N'nv001')
INSERT [dbo].[Sach] ([MaSach], [TenSach], [NoiDungTT], [SoTrang], [GiaTien], [SoLuong], [NgayNhap], [TinhTrang], [MaNXB], [MaTG], [MaTL]) VALUES (N'2', N'', N'', 0, 0, 0, CAST(0x0000A74F015D428C AS DateTime), N'', N'nxb01', N'TG001', N'TL001')
INSERT [dbo].[Sach] ([MaSach], [TenSach], [NoiDungTT], [SoTrang], [GiaTien], [SoLuong], [NgayNhap], [TinhTrang], [MaNXB], [MaTG], [MaTL]) VALUES (N'3', N'', N'', 0, 0, 0, CAST(0x0000A75A0174678C AS DateTime), N'', N'nxb01', N'TG001', N'TL001')
INSERT [dbo].[Sach] ([MaSach], [TenSach], [NoiDungTT], [SoTrang], [GiaTien], [SoLuong], [NgayNhap], [TinhTrang], [MaNXB], [MaTG], [MaTL]) VALUES (N'd', N'', N'', 12, 0, 0, CAST(0x0000A74F015CFE94 AS DateTime), N'', N'nxb01', N'TG001', N'TL001')
INSERT [dbo].[Sach] ([MaSach], [TenSach], [NoiDungTT], [SoTrang], [GiaTien], [SoLuong], [NgayNhap], [TinhTrang], [MaNXB], [MaTG], [MaTL]) VALUES (N'S0001', N'Lý Thuyết Xác Suất  Thống Kê', N'Tái bản lần thứ nhất', 200, 20500, 1000, CAST(0x00009E4A00000000 AS DateTime), N'Mới', N'nxb01', N'TG001', N'TL005')
INSERT [dbo].[Sach] ([MaSach], [TenSach], [NoiDungTT], [SoTrang], [GiaTien], [SoLuong], [NgayNhap], [TinhTrang], [MaNXB], [MaTG], [MaTL]) VALUES (N'S0002', N'Sinh Học', N'Tái bản lần thứ 4', 198, 30000, 320, CAST(0x0000A00900000000 AS DateTime), N'Mới', N'nxb01', N'TG001', N'TL001')
INSERT [dbo].[Sach] ([MaSach], [TenSach], [NoiDungTT], [SoTrang], [GiaTien], [SoLuong], [NgayNhap], [TinhTrang], [MaNXB], [MaTG], [MaTL]) VALUES (N'S0003', N'Cấu Trúc Thiết Kế Và Giải Thuật', N'Tái bản lần thứ nhất', 350, 40000, 100, CAST(0x00009E4A00000000 AS DateTime), N'Mới', N'nxb01', N'TG001', N'TL001')
INSERT [dbo].[Sach] ([MaSach], [TenSach], [NoiDungTT], [SoTrang], [GiaTien], [SoLuong], [NgayNhap], [TinhTrang], [MaNXB], [MaTG], [MaTL]) VALUES (N'S0004', N'Đại số tuyến tính', N'Tái bản lần 2', 200, 20000, 0, CAST(0x0000A74F015AAFF4 AS DateTime), N'Cũ', N'nxb01', N'TG007', N'TL005')
INSERT [dbo].[Sach] ([MaSach], [TenSach], [NoiDungTT], [SoTrang], [GiaTien], [SoLuong], [NgayNhap], [TinhTrang], [MaNXB], [MaTG], [MaTL]) VALUES (N'S0005', N'', N'', 0, 0, 0, CAST(0x0000A74F015C69C0 AS DateTime), N'', N'nxb01', N'TG001', N'TL001')
INSERT [dbo].[Sach] ([MaSach], [TenSach], [NoiDungTT], [SoTrang], [GiaTien], [SoLuong], [NgayNhap], [TinhTrang], [MaNXB], [MaTG], [MaTL]) VALUES (N'S0006', N'Nhung nguyen ly co ban', N'tai ban lan hai', 120, 10000, 12, NULL, N'Moi', N'nxb01', N'TG008', N'TL010')
INSERT [dbo].[Sach] ([MaSach], [TenSach], [NoiDungTT], [SoTrang], [GiaTien], [SoLuong], [NgayNhap], [TinhTrang], [MaNXB], [MaTG], [MaTL]) VALUES (N'S007', N'na', NULL, 120, 9, 9, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[TacGia] ([MaTG], [HoTenTG], [DiaChiTG], [DienThoaiTG]) VALUES (N'TG001', N'Tạ Văn Nam', N'Hà Nội', N'01668327660')
INSERT [dbo].[TacGia] ([MaTG], [HoTenTG], [DiaChiTG], [DienThoaiTG]) VALUES (N'TG002', N'Tố Hữu', N'Hà Nội', N'10293182312')
INSERT [dbo].[TacGia] ([MaTG], [HoTenTG], [DiaChiTG], [DienThoaiTG]) VALUES (N'TG003', N'Nam Cao', NULL, N'0921313123')
INSERT [dbo].[TacGia] ([MaTG], [HoTenTG], [DiaChiTG], [DienThoaiTG]) VALUES (N'TG004', N'Huy Cận', NULL, N'0989271833')
INSERT [dbo].[TacGia] ([MaTG], [HoTenTG], [DiaChiTG], [DienThoaiTG]) VALUES (N'TG005', N'Đỗ Phủ', NULL, N'0917482733')
INSERT [dbo].[TacGia] ([MaTG], [HoTenTG], [DiaChiTG], [DienThoaiTG]) VALUES (N'TG006', N'Trần Sinh', N'Đà Nẵng', NULL)
INSERT [dbo].[TacGia] ([MaTG], [HoTenTG], [DiaChiTG], [DienThoaiTG]) VALUES (N'TG007', N'Huy Anh', N'Huế', NULL)
INSERT [dbo].[TacGia] ([MaTG], [HoTenTG], [DiaChiTG], [DienThoaiTG]) VALUES (N'TG008', N'Đỗ Quảng', N'Thái Bình', N'0912123123')
INSERT [dbo].[TheLoai] ([MaTL], [TenTL], [GhiChu]) VALUES (N'TL001', N'Truyện Tranh', N'dành cho lứa tuổi thiếu nhi')
INSERT [dbo].[TheLoai] ([MaTL], [TenTL], [GhiChu]) VALUES (N'TL002', N'Truyện Tranh', N'anime,Nhật Bản')
INSERT [dbo].[TheLoai] ([MaTL], [TenTL], [GhiChu]) VALUES (N'TL003', N'Văn Học', NULL)
INSERT [dbo].[TheLoai] ([MaTL], [TenTL], [GhiChu]) VALUES (N'TL004', N'Lịch Sử', NULL)
INSERT [dbo].[TheLoai] ([MaTL], [TenTL], [GhiChu]) VALUES (N'TL005', N'Toán Học ', NULL)
INSERT [dbo].[TheLoai] ([MaTL], [TenTL], [GhiChu]) VALUES (N'TL006', N'Lịch Sử', N'Việt Nam')
INSERT [dbo].[TheLoai] ([MaTL], [TenTL], [GhiChu]) VALUES (N'TL007', N'Truyện Cười ', N'Việt Nam')
INSERT [dbo].[TheLoai] ([MaTL], [TenTL], [GhiChu]) VALUES (N'TL008', N'Tin Học', NULL)
INSERT [dbo].[TheLoai] ([MaTL], [TenTL], [GhiChu]) VALUES (N'TL009', N'Sinh Học', NULL)
INSERT [dbo].[TheLoai] ([MaTL], [TenTL], [GhiChu]) VALUES (N'TL010', N'Xã Hội', N'Việt Nam')
ALTER TABLE [dbo].[PhieuMuon] ADD  CONSTRAINT [DF_PhieuMuon_Ngaymuon]  DEFAULT (getdate()) FOR [Ngaymuon]
GO
ALTER TABLE [dbo].[CT_PhieuMuon]  WITH CHECK ADD  CONSTRAINT [FK_CT_PhieuMuon_PhieuMuon] FOREIGN KEY([MaPhieu])
REFERENCES [dbo].[PhieuMuon] ([MaPhieu])
GO
ALTER TABLE [dbo].[CT_PhieuMuon] CHECK CONSTRAINT [FK_CT_PhieuMuon_PhieuMuon]
GO
ALTER TABLE [dbo].[CT_PhieuMuon]  WITH CHECK ADD  CONSTRAINT [FK_CT_PhieuMuon_Sach] FOREIGN KEY([MaSach])
REFERENCES [dbo].[Sach] ([MaSach])
GO
ALTER TABLE [dbo].[CT_PhieuMuon] CHECK CONSTRAINT [FK_CT_PhieuMuon_Sach]
GO
ALTER TABLE [dbo].[PhieuMuon]  WITH CHECK ADD  CONSTRAINT [FK_NhanVien_PhieuMuon] FOREIGN KEY([MaNV])
REFERENCES [dbo].[NhanVien] ([MaNV])
GO
ALTER TABLE [dbo].[PhieuMuon] CHECK CONSTRAINT [FK_NhanVien_PhieuMuon]
GO
ALTER TABLE [dbo].[PhieuMuon]  WITH CHECK ADD  CONSTRAINT [FK_PhieuMuon_Docgia] FOREIGN KEY([MaDG])
REFERENCES [dbo].[DocGia] ([MaDG])
GO
ALTER TABLE [dbo].[PhieuMuon] CHECK CONSTRAINT [FK_PhieuMuon_Docgia]
GO
ALTER TABLE [dbo].[Sach]  WITH CHECK ADD  CONSTRAINT [FK_Sach_NXB] FOREIGN KEY([MaNXB])
REFERENCES [dbo].[NhaXuatBan] ([MaNXB])
GO
ALTER TABLE [dbo].[Sach] CHECK CONSTRAINT [FK_Sach_NXB]
GO
ALTER TABLE [dbo].[Sach]  WITH CHECK ADD  CONSTRAINT [FK_Sach_TacGia] FOREIGN KEY([MaTG])
REFERENCES [dbo].[TacGia] ([MaTG])
GO
ALTER TABLE [dbo].[Sach] CHECK CONSTRAINT [FK_Sach_TacGia]
GO
ALTER TABLE [dbo].[Sach]  WITH CHECK ADD  CONSTRAINT [FK_Sach_TheLoai] FOREIGN KEY([MaTL])
REFERENCES [dbo].[TheLoai] ([MaTL])
GO
ALTER TABLE [dbo].[Sach] CHECK CONSTRAINT [FK_Sach_TheLoai]
GO
ALTER TABLE [dbo].[TraSach]  WITH CHECK ADD  CONSTRAINT [FK_NhanVien_TraSach] FOREIGN KEY([MaNV])
REFERENCES [dbo].[NhanVien] ([MaNV])
GO
ALTER TABLE [dbo].[TraSach] CHECK CONSTRAINT [FK_NhanVien_TraSach]
GO
ALTER TABLE [dbo].[TraSach]  WITH CHECK ADD  CONSTRAINT [FK_TraSach_PhieuMuon] FOREIGN KEY([MaPhieu])
REFERENCES [dbo].[PhieuMuon] ([MaPhieu])
GO
ALTER TABLE [dbo].[TraSach] CHECK CONSTRAINT [FK_TraSach_PhieuMuon]
GO
ALTER TABLE [dbo].[TraSach]  WITH CHECK ADD  CONSTRAINT [FK_TraSach_Sach] FOREIGN KEY([MaSach])
REFERENCES [dbo].[Sach] ([MaSach])
GO
ALTER TABLE [dbo].[TraSach] CHECK CONSTRAINT [FK_TraSach_Sach]
GO
USE [master]
GO
ALTER DATABASE [QUANLYTHUVIEN] SET  READ_WRITE 
GO
