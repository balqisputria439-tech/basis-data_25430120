-- ============================================================
-- p06_data_25430120.sql
-- Pertemuan 6: data sampel proyek Perpustakaan Cendekia ABPA
-- Nama   : ADILLA BALQIS PUTRI ANTONI    NIM : 25430120
-- Basis data : perpus_120 (dijalankan oleh akun dev_120)
--
-- Urutan membangun ulang dari basis data kosong:
--   mysql -u dev_120 -p < p05_ddl_25430120.sql
--   mysql -u dev_120 -p < p06_data_25430120.sql
-- Hasilnya selalu sama karena DDL memuat DROP TABLE IF EXISTS
-- dan seluruh kunci tamu diisi lewat kode alami (bukan menebak id).
--
-- Dasar jumlah baris (P = 3, dari 20 mod 9 + 1):
--   peminjaman >= 10 x P = 30 baris, tersebar pada banyak tanggal.
-- Data dibuat konsisten dengan aturan bisnis yang belum dijaga server:
--   AB-02 (maks 5 eksemplar per peminjaman), AB-03 (peminjam aktif),
--   AB-04 (eksemplar tidak dipinjam ganda), AB-08 (denda hanya bila
--   terlambat), AB-11 (peminjam tidak punya denda belum lunas),
--   AB-12 (tanggal kembali tidak lebih awal dari tanggal pinjam).
-- Tanggal acuan "hari ini" pada data: 2026-10-31.
-- ============================================================

USE perpus_120;

-- ------------------------------------------------------------
-- 1. Tabel induk
-- ------------------------------------------------------------
INSERT INTO petugas (kode_petugas, nama_petugas, peran_petugas) VALUES
  ('PTG-01', 'Rina Marlina', 'pustakawan'),
  ('PTG-02', 'Hendra Saputra', 'pustakawan'),
  ('PTG-03', 'Lestari Wulandari', 'pustakawan'),
  ('PTG-04', 'Yoga Pratama', 'pustakawan'),
  ('PTG-05', 'Dr. Sri Wahyuni', 'kepala');

INSERT INTO anggota (no_anggota, no_identitas_anggota, nama_anggota, no_hp_anggota, status_anggota, tanggal_daftar_anggota) VALUES
  ('AG-0001', '25430101', 'Salsabila Putri Ramadhani', '081110020001', 'aktif', '2025-08-18'),
  ('AG-0002', '25430102', 'Raka Aditya Pratama', '081110020002', 'aktif', '2025-08-18'),
  ('AG-0003', '25430115', 'Nabila Khairunnisa', '081110020003', 'aktif', '2025-08-19'),
  ('AG-0004', '25430118', 'Fikri Maulana Yusuf', '081110020004', 'aktif', '2025-08-20'),
  ('AG-0005', '25430133', 'Anindya Larasati', '081110020005', 'aktif', '2025-09-02'),
  ('AG-0006', '25430147', 'Dimas Prasetyo Utomo', '081110020006', 'aktif', '2025-09-02'),
  ('AG-0007', '25430152', 'Citra Wulandari', '081110020007', 'aktif', '2025-09-09'),
  ('AG-0008', '25430168', 'Galih Permana Sakti', '081110020008', 'aktif', '2026-02-16'),
  ('AG-0009', '198503122010011002', 'Dr. Hartono Wirawan', '081110020009', 'aktif', '2025-08-25'),
  ('AG-0010', '197911052005012004', 'Ratna Kusumawardhani, M.Kom.', NULL, 'aktif', '2025-08-25'),
  ('AG-0011', '24430077', 'Yoga Aditama Nugraha', '081110020011', 'nonaktif', '2024-09-10'),
  ('AG-0012', '24430091', 'Meilani Suryaningsih', NULL, 'nonaktif', '2024-09-12');

INSERT INTO buku (kode_buku, judul_buku, pengarang_buku, penerbit_buku, tahun_terbit_buku, isbn_buku, kategori_buku) VALUES
  ('BK-0101', 'Basis Data Dasar', 'Dedi Irawan', 'Penerbit Kampus Mandiri', 2024, '978-623-7101-01-4', 'Komputer'),
  ('BK-0102', 'Pemrograman Web dengan PHP', 'Siska Anggraini', 'Cahaya Ilmu', 2023, '978-623-7101-02-1', 'Komputer'),
  ('BK-0103', 'Jaringan Komputer Terapan', 'Bagus Wicaksono', 'Cahaya Ilmu', 2022, '978-623-7101-03-8', 'Komputer'),
  ('BK-0104', 'Algoritma dan Struktur Data', 'Maya Kusuma', 'Penerbit Kampus Mandiri', 2021, '978-623-7101-04-5', 'Komputer'),
  ('BK-0105', 'Statistika untuk Ilmu Komputer', 'Rahmat Hidayat', 'Nusantara Pustaka', 2020, NULL, 'Matematika'),
  ('BK-0106', 'Manajemen Proyek Perangkat Lunak', 'Intan Permata', 'Nusantara Pustaka', 2023, '978-623-7101-06-9', 'Komputer'),
  ('BK-0107', 'Kewirausahaan Digital', 'Fajar Nugroho', 'Cahaya Ilmu', 2025, '978-623-7101-07-6', 'Ekonomi'),
  ('BK-0108', 'Sejarah Pemikiran Indonesia', 'Tuti Handayani', NULL, 2019, NULL, 'Sosial'),
  ('BK-0109', 'Sistem Operasi Modern', 'Arif Budiman', 'Penerbit Kampus Mandiri', 2022, '978-623-7101-09-0', 'Komputer'),
  ('BK-0110', 'Desain Antarmuka Pengguna', 'Nadia Safitri', 'Cahaya Ilmu', 2026, '978-623-7101-10-6', 'Komputer');

-- Eksemplar: status awal dipinjam/rusak/hilang diselaraskan dengan riwayat peminjaman di bawah
INSERT INTO eksemplar (kode_eksemplar, id_buku, status_eksemplar, lokasi_rak_eksemplar, tanggal_masuk_eksemplar) VALUES
  ('EKS-0101-01', (SELECT id_buku FROM buku WHERE kode_buku = 'BK-0101'), 'tersedia', 'Rak A-1', '2025-08-04'),
  ('EKS-0101-02', (SELECT id_buku FROM buku WHERE kode_buku = 'BK-0101'), 'dipinjam', 'Rak A-1', '2025-08-15'),
  ('EKS-0101-03', (SELECT id_buku FROM buku WHERE kode_buku = 'BK-0101'), 'tersedia', 'Rak A-1', '2025-08-26'),
  ('EKS-0101-04', (SELECT id_buku FROM buku WHERE kode_buku = 'BK-0101'), 'tersedia', 'Rak A-1', '2025-09-06'),
  ('EKS-0102-01', (SELECT id_buku FROM buku WHERE kode_buku = 'BK-0102'), 'hilang', 'Rak B-1', '2025-09-17'),
  ('EKS-0102-02', (SELECT id_buku FROM buku WHERE kode_buku = 'BK-0102'), 'rusak', 'Rak B-1', '2025-09-28'),
  ('EKS-0102-03', (SELECT id_buku FROM buku WHERE kode_buku = 'BK-0102'), 'dipinjam', 'Rak B-1', '2025-10-09'),
  ('EKS-0103-01', (SELECT id_buku FROM buku WHERE kode_buku = 'BK-0103'), 'tersedia', 'Rak C-4', '2025-10-20'),
  ('EKS-0103-02', (SELECT id_buku FROM buku WHERE kode_buku = 'BK-0103'), 'dipinjam', 'Rak C-4', '2025-10-31'),
  ('EKS-0104-01', (SELECT id_buku FROM buku WHERE kode_buku = 'BK-0104'), 'dipinjam', 'Rak B-3', '2025-11-11'),
  ('EKS-0104-02', (SELECT id_buku FROM buku WHERE kode_buku = 'BK-0104'), 'tersedia', 'Rak B-3', '2025-11-22'),
  ('EKS-0104-03', (SELECT id_buku FROM buku WHERE kode_buku = 'BK-0104'), 'dipinjam', 'Rak B-3', '2025-12-03'),
  ('EKS-0105-01', (SELECT id_buku FROM buku WHERE kode_buku = 'BK-0105'), 'dipinjam', 'Rak A-1', '2025-12-14'),
  ('EKS-0105-02', (SELECT id_buku FROM buku WHERE kode_buku = 'BK-0105'), 'dipinjam', 'Rak A-1', '2025-12-25'),
  ('EKS-0106-01', (SELECT id_buku FROM buku WHERE kode_buku = 'BK-0106'), 'tersedia', 'Rak C-2', '2025-08-08'),
  ('EKS-0106-02', (SELECT id_buku FROM buku WHERE kode_buku = 'BK-0106'), 'tersedia', 'Rak C-2', '2025-08-19'),
  ('EKS-0107-01', (SELECT id_buku FROM buku WHERE kode_buku = 'BK-0107'), 'tersedia', 'Rak B-1', '2025-08-30'),
  ('EKS-0107-02', (SELECT id_buku FROM buku WHERE kode_buku = 'BK-0107'), 'dipinjam', 'Rak B-1', '2025-09-10'),
  ('EKS-0108-01', (SELECT id_buku FROM buku WHERE kode_buku = 'BK-0108'), 'dipinjam', 'Rak A-1', '2025-09-21'),
  ('EKS-0108-02', (SELECT id_buku FROM buku WHERE kode_buku = 'BK-0108'), 'rusak', 'Rak A-1', '2025-10-02'),
  ('EKS-0109-01', (SELECT id_buku FROM buku WHERE kode_buku = 'BK-0109'), 'dipinjam', 'Rak C-2', '2025-10-13'),
  ('EKS-0109-02', (SELECT id_buku FROM buku WHERE kode_buku = 'BK-0109'), 'tersedia', 'Rak C-2', '2025-10-24');

-- ------------------------------------------------------------
-- 2. Tabel transaksi: peminjaman (30 baris)
-- ------------------------------------------------------------
INSERT INTO peminjaman (no_peminjaman, tanggal_pinjam_peminjaman, lama_pinjam_hari_peminjaman, id_anggota, id_petugas) VALUES
  ('PM-2610-0001', '2026-10-05', 7, (SELECT id_anggota FROM anggota WHERE no_anggota = 'AG-0002'), (SELECT id_petugas FROM petugas WHERE kode_petugas = 'PTG-04')),
  ('PM-2610-0002', '2026-10-05', 7, (SELECT id_anggota FROM anggota WHERE no_anggota = 'AG-0006'), (SELECT id_petugas FROM petugas WHERE kode_petugas = 'PTG-03')),
  ('PM-2610-0003', '2026-10-06', 7, (SELECT id_anggota FROM anggota WHERE no_anggota = 'AG-0005'), (SELECT id_petugas FROM petugas WHERE kode_petugas = 'PTG-04')),
  ('PM-2610-0004', '2026-10-07', 7, (SELECT id_anggota FROM anggota WHERE no_anggota = 'AG-0003'), (SELECT id_petugas FROM petugas WHERE kode_petugas = 'PTG-04')),
  ('PM-2610-0005', '2026-10-07', 7, (SELECT id_anggota FROM anggota WHERE no_anggota = 'AG-0006'), (SELECT id_petugas FROM petugas WHERE kode_petugas = 'PTG-02')),
  ('PM-2610-0006', '2026-10-07', 7, (SELECT id_anggota FROM anggota WHERE no_anggota = 'AG-0006'), (SELECT id_petugas FROM petugas WHERE kode_petugas = 'PTG-04')),
  ('PM-2610-0007', '2026-10-07', 7, (SELECT id_anggota FROM anggota WHERE no_anggota = 'AG-0001'), (SELECT id_petugas FROM petugas WHERE kode_petugas = 'PTG-04')),
  ('PM-2610-0008', '2026-10-08', 7, (SELECT id_anggota FROM anggota WHERE no_anggota = 'AG-0006'), (SELECT id_petugas FROM petugas WHERE kode_petugas = 'PTG-03')),
  ('PM-2610-0009', '2026-10-08', 7, (SELECT id_anggota FROM anggota WHERE no_anggota = 'AG-0002'), (SELECT id_petugas FROM petugas WHERE kode_petugas = 'PTG-03')),
  ('PM-2610-0010', '2026-10-08', 7, (SELECT id_anggota FROM anggota WHERE no_anggota = 'AG-0010'), (SELECT id_petugas FROM petugas WHERE kode_petugas = 'PTG-03')),
  ('PM-2610-0011', '2026-10-09', 7, (SELECT id_anggota FROM anggota WHERE no_anggota = 'AG-0005'), (SELECT id_petugas FROM petugas WHERE kode_petugas = 'PTG-02')),
  ('PM-2610-0012', '2026-10-12', 7, (SELECT id_anggota FROM anggota WHERE no_anggota = 'AG-0005'), (SELECT id_petugas FROM petugas WHERE kode_petugas = 'PTG-01')),
  ('PM-2610-0013', '2026-10-14', 7, (SELECT id_anggota FROM anggota WHERE no_anggota = 'AG-0001'), (SELECT id_petugas FROM petugas WHERE kode_petugas = 'PTG-03')),
  ('PM-2610-0014', '2026-10-14', 7, (SELECT id_anggota FROM anggota WHERE no_anggota = 'AG-0008'), (SELECT id_petugas FROM petugas WHERE kode_petugas = 'PTG-02')),
  ('PM-2610-0015', '2026-10-15', 7, (SELECT id_anggota FROM anggota WHERE no_anggota = 'AG-0006'), (SELECT id_petugas FROM petugas WHERE kode_petugas = 'PTG-01')),
  ('PM-2610-0016', '2026-10-16', 7, (SELECT id_anggota FROM anggota WHERE no_anggota = 'AG-0008'), (SELECT id_petugas FROM petugas WHERE kode_petugas = 'PTG-04')),
  ('PM-2610-0017', '2026-10-19', 7, (SELECT id_anggota FROM anggota WHERE no_anggota = 'AG-0009'), (SELECT id_petugas FROM petugas WHERE kode_petugas = 'PTG-03')),
  ('PM-2610-0018', '2026-10-19', 7, (SELECT id_anggota FROM anggota WHERE no_anggota = 'AG-0007'), (SELECT id_petugas FROM petugas WHERE kode_petugas = 'PTG-03')),
  ('PM-2610-0019', '2026-10-19', 7, (SELECT id_anggota FROM anggota WHERE no_anggota = 'AG-0007'), (SELECT id_petugas FROM petugas WHERE kode_petugas = 'PTG-02')),
  ('PM-2610-0020', '2026-10-20', 7, (SELECT id_anggota FROM anggota WHERE no_anggota = 'AG-0009'), (SELECT id_petugas FROM petugas WHERE kode_petugas = 'PTG-03')),
  ('PM-2610-0021', '2026-10-22', 7, (SELECT id_anggota FROM anggota WHERE no_anggota = 'AG-0007'), (SELECT id_petugas FROM petugas WHERE kode_petugas = 'PTG-03')),
  ('PM-2610-0022', '2026-10-22', 7, (SELECT id_anggota FROM anggota WHERE no_anggota = 'AG-0008'), (SELECT id_petugas FROM petugas WHERE kode_petugas = 'PTG-04')),
  ('PM-2610-0023', '2026-10-22', 7, (SELECT id_anggota FROM anggota WHERE no_anggota = 'AG-0007'), (SELECT id_petugas FROM petugas WHERE kode_petugas = 'PTG-04')),
  ('PM-2610-0024', '2026-10-22', 7, (SELECT id_anggota FROM anggota WHERE no_anggota = 'AG-0009'), (SELECT id_petugas FROM petugas WHERE kode_petugas = 'PTG-02')),
  ('PM-2610-0025', '2026-10-23', 7, (SELECT id_anggota FROM anggota WHERE no_anggota = 'AG-0007'), (SELECT id_petugas FROM petugas WHERE kode_petugas = 'PTG-01')),
  ('PM-2610-0026', '2026-10-26', 7, (SELECT id_anggota FROM anggota WHERE no_anggota = 'AG-0010'), (SELECT id_petugas FROM petugas WHERE kode_petugas = 'PTG-02')),
  ('PM-2610-0027', '2026-10-27', 7, (SELECT id_anggota FROM anggota WHERE no_anggota = 'AG-0003'), (SELECT id_petugas FROM petugas WHERE kode_petugas = 'PTG-03')),
  ('PM-2610-0028', '2026-10-27', 7, (SELECT id_anggota FROM anggota WHERE no_anggota = 'AG-0009'), (SELECT id_petugas FROM petugas WHERE kode_petugas = 'PTG-04')),
  ('PM-2610-0029', '2026-10-28', 7, (SELECT id_anggota FROM anggota WHERE no_anggota = 'AG-0004'), (SELECT id_petugas FROM petugas WHERE kode_petugas = 'PTG-02')),
  ('PM-2610-0030', '2026-10-30', 7, (SELECT id_anggota FROM anggota WHERE no_anggota = 'AG-0010'), (SELECT id_petugas FROM petugas WHERE kode_petugas = 'PTG-04'));

-- detail_peminjaman: tanggal dan kondisi kembali NULL berarti belum dikembalikan
INSERT INTO detail_peminjaman (id_peminjaman, id_eksemplar, tanggal_kembali_detail_peminjaman, kondisi_kembali_detail_peminjaman) VALUES
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2610-0001'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EKS-0104-01'), '2026-10-16', 'baik'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2610-0001'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EKS-0103-02'), '2026-10-09', 'baik'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2610-0002'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EKS-0102-02'), '2026-10-12', 'rusak'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2610-0002'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EKS-0106-02'), '2026-10-12', 'baik'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2610-0003'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EKS-0101-03'), '2026-10-13', 'baik'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2610-0003'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EKS-0108-01'), NULL, NULL),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2610-0003'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EKS-0106-01'), '2026-10-16', 'baik'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2610-0003'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EKS-0102-03'), '2026-10-19', 'baik'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2610-0004'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EKS-0107-01'), '2026-10-15', 'baik'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2610-0005'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EKS-0102-01'), '2026-10-12', 'hilang'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2610-0005'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EKS-0105-01'), '2026-10-12', 'baik'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2610-0006'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EKS-0101-01'), '2026-10-09', 'baik'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2610-0007'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EKS-0101-02'), '2026-10-19', 'baik'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2610-0007'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EKS-0109-02'), '2026-10-09', 'baik'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2610-0007'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EKS-0104-02'), '2026-10-09', 'baik'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2610-0007'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EKS-0107-02'), '2026-10-14', 'baik'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2610-0008'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EKS-0104-03'), '2026-10-19', 'baik'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2610-0009'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EKS-0101-04'), '2026-10-13', 'baik'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2610-0010'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EKS-0109-01'), '2026-10-14', 'baik'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2610-0011'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EKS-0103-02'), '2026-10-12', 'baik'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2610-0011'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EKS-0104-02'), '2026-10-19', 'baik'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2610-0011'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EKS-0101-01'), '2026-10-12', 'baik'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2610-0012'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EKS-0101-01'), '2026-10-13', 'baik'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2610-0012'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EKS-0105-02'), '2026-10-19', 'baik'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2610-0013'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EKS-0101-03'), '2026-10-22', 'baik'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2610-0014'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EKS-0101-04'), '2026-10-27', 'baik'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2610-0014'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EKS-0103-01'), '2026-10-21', 'baik'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2610-0014'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EKS-0109-02'), '2026-10-15', 'baik'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2610-0015'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EKS-0106-02'), '2026-10-16', 'baik'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2610-0015'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EKS-0101-01'), '2026-10-19', 'baik'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2610-0016'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EKS-0103-02'), NULL, NULL),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2610-0017'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EKS-0104-01'), '2026-10-26', 'baik'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2610-0017'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EKS-0107-02'), '2026-10-23', 'baik'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2610-0017'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EKS-0101-01'), '2026-10-26', 'baik'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2610-0018'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EKS-0101-02'), '2026-10-23', 'baik'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2610-0019'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EKS-0109-01'), '2026-10-22', 'baik'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2610-0019'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EKS-0104-02'), '2026-10-27', 'baik'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2610-0019'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EKS-0106-01'), '2026-10-27', 'baik'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2610-0019'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EKS-0107-01'), '2026-10-21', 'baik'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2610-0020'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EKS-0104-03'), '2026-10-26', 'baik'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2610-0021'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EKS-0101-03'), '2026-10-26', 'baik'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2610-0021'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EKS-0107-01'), '2026-10-28', 'baik'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2610-0021'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EKS-0106-02'), '2026-10-26', 'baik'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2610-0022'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EKS-0102-03'), '2026-10-26', 'baik'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2610-0022'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EKS-0109-01'), NULL, NULL),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2610-0023'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EKS-0105-02'), '2026-10-26', 'baik'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2610-0023'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EKS-0109-02'), '2026-10-29', 'baik'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2610-0023'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EKS-0103-01'), '2026-10-23', 'baik'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2610-0024'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EKS-0105-01'), '2026-10-23', 'baik'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2610-0025'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EKS-0101-02'), '2026-10-27', 'baik'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2610-0025'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EKS-0107-02'), '2026-10-26', 'baik'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2610-0026'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EKS-0107-02'), NULL, NULL),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2610-0027'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EKS-0104-01'), NULL, NULL),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2610-0027'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EKS-0105-01'), NULL, NULL),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2610-0027'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EKS-0101-02'), NULL, NULL),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2610-0028'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EKS-0105-02'), NULL, NULL),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2610-0029'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EKS-0104-03'), NULL, NULL),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2610-0030'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EKS-0102-03'), NULL, NULL);

-- denda: satu baris untuk setiap eksemplar yang dikembalikan lewat jatuh tempo (AB-08), tarif Rp3.000 per hari (P = 3)
INSERT INTO denda (no_denda, id_peminjaman, id_eksemplar, tarif_per_hari_denda, status_bayar_denda, tanggal_bayar_denda) VALUES
  ('DN-2610-0001', (SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2610-0004'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EKS-0107-01'), 3000.00, 'lunas', '2026-10-19'),
  ('DN-2610-0002', (SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2610-0001'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EKS-0104-01'), 3000.00, 'lunas', '2026-10-19'),
  ('DN-2610-0003', (SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2610-0003'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EKS-0106-01'), 3000.00, 'belum lunas', NULL),
  ('DN-2610-0004', (SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2610-0003'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EKS-0102-03'), 3000.00, 'belum lunas', NULL),
  ('DN-2610-0005', (SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2610-0007'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EKS-0101-02'), 3000.00, 'lunas', '2026-10-19'),
  ('DN-2610-0006', (SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2610-0008'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EKS-0104-03'), 3000.00, 'lunas', '2026-10-20'),
  ('DN-2610-0007', (SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2610-0011'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EKS-0104-02'), 3000.00, 'belum lunas', NULL),
  ('DN-2610-0008', (SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2610-0013'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EKS-0101-03'), 3000.00, 'lunas', '2026-10-22'),
  ('DN-2610-0009', (SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2610-0014'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EKS-0101-04'), 3000.00, 'belum lunas', NULL),
  ('DN-2610-0010', (SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2610-0019'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EKS-0104-02'), 3000.00, 'belum lunas', NULL),
  ('DN-2610-0011', (SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2610-0019'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EKS-0106-01'), 3000.00, 'lunas', '2026-10-28');

-- ------------------------------------------------------------
-- 3. Pemeriksaan: jumlah baris per tabel (bahan screenshot)
-- ------------------------------------------------------------
SELECT 'anggota' AS tabel, COUNT(*) AS jumlah_baris FROM anggota
UNION ALL SELECT 'petugas', COUNT(*) FROM petugas
UNION ALL SELECT 'buku', COUNT(*) FROM buku
UNION ALL SELECT 'eksemplar', COUNT(*) FROM eksemplar
UNION ALL SELECT 'peminjaman', COUNT(*) FROM peminjaman
UNION ALL SELECT 'detail_peminjaman', COUNT(*) FROM detail_peminjaman
UNION ALL SELECT 'denda', COUNT(*) FROM denda;

SELECT COUNT(DISTINCT tanggal_pinjam_peminjaman) AS tanggal_berbeda,
       MIN(tanggal_pinjam_peminjaman) AS paling_awal,
       MAX(tanggal_pinjam_peminjaman) AS paling_akhir
FROM peminjaman;
