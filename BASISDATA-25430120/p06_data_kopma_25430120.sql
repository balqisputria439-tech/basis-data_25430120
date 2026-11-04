-- ============================================================
-- p06_data_kopma_25430120.sql
-- Pertemuan 6: data sampel Kopma
-- Nama   : ADILLA BALQIS PUTRI ANTONI    NIM : 25430120
-- Basis data : kopma_120 (dijalankan oleh akun mhs_120)
--
-- Urutan membangun ulang dari basis data kosong:
--   mysql -u mhs_120 -p < p05_ddl_kopma_25430120.sql
--   mysql -u mhs_120 -p < p06_data_kopma_25430120.sql
-- Hasilnya selalu sama karena DDL memuat DROP TABLE IF EXISTS dan
-- seluruh kunci tamu diisi lewat kode alami (INSERT ... SELECT),
-- bukan dengan menebak nilai AUTO_INCREMENT.
-- Nota PJ-2609-0142 dan PJ-2609-0143 berasal dari spreadsheet lama
-- (Gambar 4.1 buku). Harga satuan pada detail disalin dari tabel
-- barang saat nota dicatat (AB-04).
-- ============================================================

USE kopma_120;

-- 1. Data induk (INSERT banyak baris)
INSERT INTO petugas (kode_petugas, nama_petugas, peran_petugas) VALUES
  ('K01', 'Dimas', 'kasir'),
  ('K02', 'Sari', 'kasir'),
  ('K03', 'Rina', 'kasir'),
  ('G01', 'Joko', 'gudang'),
  ('P01', 'Ketua Kopma', 'ketua');

INSERT INTO barang (kode_barang, nama_barang, kategori_barang, harga_jual_barang, stok_barang, stok_min_barang) VALUES
  ('ATK-001', 'Pulpen Gel 0.5', 'ATK', 4000, 120, 20),
  ('ATK-002', 'Buku Tulis 58', 'ATK', 6500, 80, 20),
  ('MNM-001', 'Air Mineral 600', 'minuman', 4000, 48, 24),
  ('MKN-001', 'Roti Cokelat', 'makanan', 5000, 6, 10),
  ('ATK-003', 'Penghapus Putih', 'ATK', 2500, 60, 15),
  ('MNM-002', 'Teh Kotak 300', 'minuman', 5500, 36, 12),
  ('MKN-002', 'Wafer Cokelat', 'makanan', 3000, 40, 12);

INSERT INTO anggota (no_anggota, nim_anggota, nama_anggota, prodi_anggota, no_hp_anggota, status_anggota, tgl_daftar_anggota) VALUES
  ('A-0457', '2501010457', 'Budi Santoso', 'Ilmu Komputer', '081110030457', 'aktif', '2025-08-18'),
  ('A-0458', '2501010458', 'Siti Aminah', 'Sistem Informasi', '081110030458', 'aktif', '2025-08-18'),
  ('A-0471', '2501010471', 'Dani Firmansyah', 'Manajemen', NULL, 'aktif', '2025-09-09'),
  ('A-0490', '2601010490', 'Mira Lestari', 'Akuntansi', '081110030490', 'nonaktif', '2026-01-12'),
  ('A-0120', '2401010120', 'Rudi Hartono', 'Teknik Informatika', '081110030120', 'nonaktif', '2024-02-12'),
  ('A-0133', '2401010133', 'Wulan Sari', 'Sistem Informasi', NULL, 'nonaktif', '2024-05-20');

INSERT INTO pemasok (kode_pemasok, nama_pemasok, telepon_pemasok, alamat_pemasok) VALUES
  ('PMS-01', 'CV Sumber ATK', '0274555101', 'Jl. Kaliurang Km 5, Yogyakarta'),
  ('PMS-02', 'UD Segar', '0274555202', 'Jl. Magelang Km 3, Yogyakarta'),
  ('PMS-03', 'PT Mitra Boga Nusantara', '0274555303', 'Jl. Solo Km 7, Yogyakarta');

-- 2. Nota penjualan: kepala nota, lalu detail (INSERT ... SELECT), lalu kurangi stok
-- PJ-2609-0021: 2 barang, anggota A-0133
INSERT INTO penjualan (no_nota_penjualan, tgl_penjualan, id_petugas, id_anggota, bayar_penjualan) VALUES
  ('PJ-2609-0021', '2026-09-03 09:20:00', (SELECT id_petugas FROM petugas WHERE kode_petugas = 'K01'), (SELECT id_anggota FROM anggota WHERE no_anggota = 'A-0133'), 10000);
INSERT INTO detail_penjualan (id_penjualan, id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan)
  SELECT p.id_penjualan, b.id_barang, 1, b.harga_jual_barang FROM penjualan p, barang b
  WHERE p.no_nota_penjualan = 'PJ-2609-0021' AND b.kode_barang = 'ATK-001';
UPDATE barang SET stok_barang = stok_barang - 1 WHERE kode_barang = 'ATK-001';
INSERT INTO detail_penjualan (id_penjualan, id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan)
  SELECT p.id_penjualan, b.id_barang, 1, b.harga_jual_barang FROM penjualan p, barang b
  WHERE p.no_nota_penjualan = 'PJ-2609-0021' AND b.kode_barang = 'ATK-002';
UPDATE barang SET stok_barang = stok_barang - 1 WHERE kode_barang = 'ATK-002';

-- PJ-2609-0142: 3 barang, anggota A-0457
INSERT INTO penjualan (no_nota_penjualan, tgl_penjualan, id_petugas, id_anggota, bayar_penjualan) VALUES
  ('PJ-2609-0142', '2026-09-24 10:15:00', (SELECT id_petugas FROM petugas WHERE kode_petugas = 'K03'), (SELECT id_anggota FROM anggota WHERE no_anggota = 'A-0457'), 30000);
INSERT INTO detail_penjualan (id_penjualan, id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan)
  SELECT p.id_penjualan, b.id_barang, 3, b.harga_jual_barang FROM penjualan p, barang b
  WHERE p.no_nota_penjualan = 'PJ-2609-0142' AND b.kode_barang = 'ATK-001';
UPDATE barang SET stok_barang = stok_barang - 3 WHERE kode_barang = 'ATK-001';
INSERT INTO detail_penjualan (id_penjualan, id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan)
  SELECT p.id_penjualan, b.id_barang, 2, b.harga_jual_barang FROM penjualan p, barang b
  WHERE p.no_nota_penjualan = 'PJ-2609-0142' AND b.kode_barang = 'ATK-002';
UPDATE barang SET stok_barang = stok_barang - 2 WHERE kode_barang = 'ATK-002';
INSERT INTO detail_penjualan (id_penjualan, id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan)
  SELECT p.id_penjualan, b.id_barang, 1, b.harga_jual_barang FROM penjualan p, barang b
  WHERE p.no_nota_penjualan = 'PJ-2609-0142' AND b.kode_barang = 'MNM-001';
UPDATE barang SET stok_barang = stok_barang - 1 WHERE kode_barang = 'MNM-001';

-- PJ-2609-0143: 1 barang, pembeli umum
INSERT INTO penjualan (no_nota_penjualan, tgl_penjualan, id_petugas, id_anggota, bayar_penjualan) VALUES
  ('PJ-2609-0143', '2026-09-24 11:40:00', (SELECT id_petugas FROM petugas WHERE kode_petugas = 'K03'), NULL, 10000);
INSERT INTO detail_penjualan (id_penjualan, id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan)
  SELECT p.id_penjualan, b.id_barang, 2, b.harga_jual_barang FROM penjualan p, barang b
  WHERE p.no_nota_penjualan = 'PJ-2609-0143' AND b.kode_barang = 'MKN-001';
UPDATE barang SET stok_barang = stok_barang - 2 WHERE kode_barang = 'MKN-001';

-- PJ-2609-0144: 2 barang, anggota A-0458
INSERT INTO penjualan (no_nota_penjualan, tgl_penjualan, id_petugas, id_anggota, bayar_penjualan) VALUES
  ('PJ-2609-0144', '2026-09-24 13:05:00', (SELECT id_petugas FROM petugas WHERE kode_petugas = 'K01'), (SELECT id_anggota FROM anggota WHERE no_anggota = 'A-0458'), 15000);
INSERT INTO detail_penjualan (id_penjualan, id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan)
  SELECT p.id_penjualan, b.id_barang, 2, b.harga_jual_barang FROM penjualan p, barang b
  WHERE p.no_nota_penjualan = 'PJ-2609-0144' AND b.kode_barang = 'MNM-001';
UPDATE barang SET stok_barang = stok_barang - 2 WHERE kode_barang = 'MNM-001';
INSERT INTO detail_penjualan (id_penjualan, id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan)
  SELECT p.id_penjualan, b.id_barang, 1, b.harga_jual_barang FROM penjualan p, barang b
  WHERE p.no_nota_penjualan = 'PJ-2609-0144' AND b.kode_barang = 'MKN-002';
UPDATE barang SET stok_barang = stok_barang - 1 WHERE kode_barang = 'MKN-002';

-- PJ-2609-0145: 2 barang, pembeli umum
INSERT INTO penjualan (no_nota_penjualan, tgl_penjualan, id_petugas, id_anggota, bayar_penjualan) VALUES
  ('PJ-2609-0145', '2026-09-24 15:20:00', (SELECT id_petugas FROM petugas WHERE kode_petugas = 'K02'), NULL, 10000);
INSERT INTO detail_penjualan (id_penjualan, id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan)
  SELECT p.id_penjualan, b.id_barang, 1, b.harga_jual_barang FROM penjualan p, barang b
  WHERE p.no_nota_penjualan = 'PJ-2609-0145' AND b.kode_barang = 'ATK-001';
UPDATE barang SET stok_barang = stok_barang - 1 WHERE kode_barang = 'ATK-001';
INSERT INTO detail_penjualan (id_penjualan, id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan)
  SELECT p.id_penjualan, b.id_barang, 1, b.harga_jual_barang FROM penjualan p, barang b
  WHERE p.no_nota_penjualan = 'PJ-2609-0145' AND b.kode_barang = 'ATK-003';
UPDATE barang SET stok_barang = stok_barang - 1 WHERE kode_barang = 'ATK-003';

-- PJ-2609-0146: 2 barang, anggota A-0471
INSERT INTO penjualan (no_nota_penjualan, tgl_penjualan, id_petugas, id_anggota, bayar_penjualan) VALUES
  ('PJ-2609-0146', '2026-09-25 08:50:00', (SELECT id_petugas FROM petugas WHERE kode_petugas = 'K01'), (SELECT id_anggota FROM anggota WHERE no_anggota = 'A-0471'), 30000);
INSERT INTO detail_penjualan (id_penjualan, id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan)
  SELECT p.id_penjualan, b.id_barang, 3, b.harga_jual_barang FROM penjualan p, barang b
  WHERE p.no_nota_penjualan = 'PJ-2609-0146' AND b.kode_barang = 'ATK-002';
UPDATE barang SET stok_barang = stok_barang - 3 WHERE kode_barang = 'ATK-002';
INSERT INTO detail_penjualan (id_penjualan, id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan)
  SELECT p.id_penjualan, b.id_barang, 2, b.harga_jual_barang FROM penjualan p, barang b
  WHERE p.no_nota_penjualan = 'PJ-2609-0146' AND b.kode_barang = 'ATK-001';
UPDATE barang SET stok_barang = stok_barang - 2 WHERE kode_barang = 'ATK-001';

-- PJ-2609-0148: 2 barang, pembeli umum
INSERT INTO penjualan (no_nota_penjualan, tgl_penjualan, id_petugas, id_anggota, bayar_penjualan) VALUES
  ('PJ-2609-0148', '2026-09-25 11:45:00', (SELECT id_petugas FROM petugas WHERE kode_petugas = 'K02'), NULL, 20000);
INSERT INTO detail_penjualan (id_penjualan, id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan)
  SELECT p.id_penjualan, b.id_barang, 3, b.harga_jual_barang FROM penjualan p, barang b
  WHERE p.no_nota_penjualan = 'PJ-2609-0148' AND b.kode_barang = 'MNM-001';
UPDATE barang SET stok_barang = stok_barang - 3 WHERE kode_barang = 'MNM-001';
INSERT INTO detail_penjualan (id_penjualan, id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan)
  SELECT p.id_penjualan, b.id_barang, 1, b.harga_jual_barang FROM penjualan p, barang b
  WHERE p.no_nota_penjualan = 'PJ-2609-0148' AND b.kode_barang = 'MKN-001';
UPDATE barang SET stok_barang = stok_barang - 1 WHERE kode_barang = 'MKN-001';

-- PJ-2609-0149: 2 barang, anggota A-0457
INSERT INTO penjualan (no_nota_penjualan, tgl_penjualan, id_petugas, id_anggota, bayar_penjualan) VALUES
  ('PJ-2609-0149', '2026-09-25 14:10:00', (SELECT id_petugas FROM petugas WHERE kode_petugas = 'K03'), (SELECT id_anggota FROM anggota WHERE no_anggota = 'A-0457'), 20000);
INSERT INTO detail_penjualan (id_penjualan, id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan)
  SELECT p.id_penjualan, b.id_barang, 2, b.harga_jual_barang FROM penjualan p, barang b
  WHERE p.no_nota_penjualan = 'PJ-2609-0149' AND b.kode_barang = 'MNM-002';
UPDATE barang SET stok_barang = stok_barang - 2 WHERE kode_barang = 'MNM-002';
INSERT INTO detail_penjualan (id_penjualan, id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan)
  SELECT p.id_penjualan, b.id_barang, 2, b.harga_jual_barang FROM penjualan p, barang b
  WHERE p.no_nota_penjualan = 'PJ-2609-0149' AND b.kode_barang = 'MKN-002';
UPDATE barang SET stok_barang = stok_barang - 2 WHERE kode_barang = 'MKN-002';

-- PJ-2609-0150: 1 barang, pembeli umum
INSERT INTO penjualan (no_nota_penjualan, tgl_penjualan, id_petugas, id_anggota, bayar_penjualan) VALUES
  ('PJ-2609-0150', '2026-09-25 16:00:00', (SELECT id_petugas FROM petugas WHERE kode_petugas = 'K01'), NULL, 5000);
INSERT INTO detail_penjualan (id_penjualan, id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan)
  SELECT p.id_penjualan, b.id_barang, 1, b.harga_jual_barang FROM penjualan p, barang b
  WHERE p.no_nota_penjualan = 'PJ-2609-0150' AND b.kode_barang = 'ATK-001';
UPDATE barang SET stok_barang = stok_barang - 1 WHERE kode_barang = 'ATK-001';

-- PJ-2609-0151: 2 barang, anggota A-0458
INSERT INTO penjualan (no_nota_penjualan, tgl_penjualan, id_petugas, id_anggota, bayar_penjualan) VALUES
  ('PJ-2609-0151', '2026-09-26 09:05:00', (SELECT id_petugas FROM petugas WHERE kode_petugas = 'K02'), (SELECT id_anggota FROM anggota WHERE no_anggota = 'A-0458'), 20000);
INSERT INTO detail_penjualan (id_penjualan, id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan)
  SELECT p.id_penjualan, b.id_barang, 2, b.harga_jual_barang FROM penjualan p, barang b
  WHERE p.no_nota_penjualan = 'PJ-2609-0151' AND b.kode_barang = 'ATK-002';
UPDATE barang SET stok_barang = stok_barang - 2 WHERE kode_barang = 'ATK-002';
INSERT INTO detail_penjualan (id_penjualan, id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan)
  SELECT p.id_penjualan, b.id_barang, 2, b.harga_jual_barang FROM penjualan p, barang b
  WHERE p.no_nota_penjualan = 'PJ-2609-0151' AND b.kode_barang = 'ATK-003';
UPDATE barang SET stok_barang = stok_barang - 2 WHERE kode_barang = 'ATK-003';

-- PJ-2609-0152: 2 barang, pembeli umum
INSERT INTO penjualan (no_nota_penjualan, tgl_penjualan, id_petugas, id_anggota, bayar_penjualan) VALUES
  ('PJ-2609-0152', '2026-09-26 12:30:00', (SELECT id_petugas FROM petugas WHERE kode_petugas = 'K03'), NULL, 15000);
INSERT INTO detail_penjualan (id_penjualan, id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan)
  SELECT p.id_penjualan, b.id_barang, 2, b.harga_jual_barang FROM penjualan p, barang b
  WHERE p.no_nota_penjualan = 'PJ-2609-0152' AND b.kode_barang = 'MNM-001';
UPDATE barang SET stok_barang = stok_barang - 2 WHERE kode_barang = 'MNM-001';
INSERT INTO detail_penjualan (id_penjualan, id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan)
  SELECT p.id_penjualan, b.id_barang, 1, b.harga_jual_barang FROM penjualan p, barang b
  WHERE p.no_nota_penjualan = 'PJ-2609-0152' AND b.kode_barang = 'MNM-002';
UPDATE barang SET stok_barang = stok_barang - 1 WHERE kode_barang = 'MNM-002';

-- PJ-2609-0153: 2 barang, anggota A-0471
INSERT INTO penjualan (no_nota_penjualan, tgl_penjualan, id_petugas, id_anggota, bayar_penjualan) VALUES
  ('PJ-2609-0153', '2026-09-26 15:45:00', (SELECT id_petugas FROM petugas WHERE kode_petugas = 'K01'), (SELECT id_anggota FROM anggota WHERE no_anggota = 'A-0471'), 15000);
INSERT INTO detail_penjualan (id_penjualan, id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan)
  SELECT p.id_penjualan, b.id_barang, 2, b.harga_jual_barang FROM penjualan p, barang b
  WHERE p.no_nota_penjualan = 'PJ-2609-0153' AND b.kode_barang = 'MKN-001';
UPDATE barang SET stok_barang = stok_barang - 2 WHERE kode_barang = 'MKN-001';
INSERT INTO detail_penjualan (id_penjualan, id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan)
  SELECT p.id_penjualan, b.id_barang, 1, b.harga_jual_barang FROM penjualan p, barang b
  WHERE p.no_nota_penjualan = 'PJ-2609-0153' AND b.kode_barang = 'MNM-001';
UPDATE barang SET stok_barang = stok_barang - 1 WHERE kode_barang = 'MNM-001';

-- 3. Pembelian dari pemasok. Faktur berstatus dipesan belum punya petugas penerima (AB-10)
INSERT INTO pembelian (no_faktur_pembelian, tgl_pembelian, id_pemasok, id_petugas, status_pembelian) VALUES
  ('FK-2609-0003', '2026-09-10', (SELECT id_pemasok FROM pemasok WHERE kode_pemasok = 'PMS-01'), (SELECT id_petugas FROM petugas WHERE kode_petugas = 'G01'), 'diterima');
INSERT INTO detail_pembelian (id_pembelian, id_barang, qty_detail_pembelian, harga_beli_detail_pembelian)
  SELECT p.id_pembelian, b.id_barang, 100, 3000 FROM pembelian p, barang b
  WHERE p.no_faktur_pembelian = 'FK-2609-0003' AND b.kode_barang = 'ATK-001';
INSERT INTO detail_pembelian (id_pembelian, id_barang, qty_detail_pembelian, harga_beli_detail_pembelian)
  SELECT p.id_pembelian, b.id_barang, 60, 4800 FROM pembelian p, barang b
  WHERE p.no_faktur_pembelian = 'FK-2609-0003' AND b.kode_barang = 'ATK-002';

INSERT INTO pembelian (no_faktur_pembelian, tgl_pembelian, id_pemasok, id_petugas, status_pembelian) VALUES
  ('FK-2609-0007', '2026-09-12', (SELECT id_pemasok FROM pemasok WHERE kode_pemasok = 'PMS-02'), (SELECT id_petugas FROM petugas WHERE kode_petugas = 'G01'), 'diterima');
INSERT INTO detail_pembelian (id_pembelian, id_barang, qty_detail_pembelian, harga_beli_detail_pembelian)
  SELECT p.id_pembelian, b.id_barang, 40, 3500 FROM pembelian p, barang b
  WHERE p.no_faktur_pembelian = 'FK-2609-0007' AND b.kode_barang = 'MKN-001';
INSERT INTO detail_pembelian (id_pembelian, id_barang, qty_detail_pembelian, harga_beli_detail_pembelian)
  SELECT p.id_pembelian, b.id_barang, 48, 2800 FROM pembelian p, barang b
  WHERE p.no_faktur_pembelian = 'FK-2609-0007' AND b.kode_barang = 'MNM-001';

INSERT INTO pembelian (no_faktur_pembelian, tgl_pembelian, id_pemasok, id_petugas, status_pembelian) VALUES
  ('FK-2609-0011', '2026-09-20', (SELECT id_pemasok FROM pemasok WHERE kode_pemasok = 'PMS-03'), (SELECT id_petugas FROM petugas WHERE kode_petugas = 'G01'), 'diterima');
INSERT INTO detail_pembelian (id_pembelian, id_barang, qty_detail_pembelian, harga_beli_detail_pembelian)
  SELECT p.id_pembelian, b.id_barang, 48, 2200 FROM pembelian p, barang b
  WHERE p.no_faktur_pembelian = 'FK-2609-0011' AND b.kode_barang = 'MKN-002';
INSERT INTO detail_pembelian (id_pembelian, id_barang, qty_detail_pembelian, harga_beli_detail_pembelian)
  SELECT p.id_pembelian, b.id_barang, 36, 4000 FROM pembelian p, barang b
  WHERE p.no_faktur_pembelian = 'FK-2609-0011' AND b.kode_barang = 'MNM-002';

INSERT INTO pembelian (no_faktur_pembelian, tgl_pembelian, id_pemasok, id_petugas, status_pembelian) VALUES
  ('FK-2609-0014', '2026-09-27', (SELECT id_pemasok FROM pemasok WHERE kode_pemasok = 'PMS-02'), NULL, 'dipesan');
INSERT INTO detail_pembelian (id_pembelian, id_barang, qty_detail_pembelian, harga_beli_detail_pembelian)
  SELECT p.id_pembelian, b.id_barang, 30, 3500 FROM pembelian p, barang b
  WHERE p.no_faktur_pembelian = 'FK-2609-0014' AND b.kode_barang = 'MKN-001';

-- 4. Pemeriksaan: jumlah baris per tabel (bahan screenshot)
SELECT 'petugas' AS tabel, COUNT(*) AS jumlah_baris FROM petugas
UNION ALL SELECT 'anggota', COUNT(*) FROM anggota
UNION ALL SELECT 'barang', COUNT(*) FROM barang
UNION ALL SELECT 'pemasok', COUNT(*) FROM pemasok
UNION ALL SELECT 'penjualan', COUNT(*) FROM penjualan
UNION ALL SELECT 'detail_penjualan', COUNT(*) FROM detail_penjualan
UNION ALL SELECT 'pembelian', COUNT(*) FROM pembelian
UNION ALL SELECT 'detail_pembelian', COUNT(*) FROM detail_pembelian;

SELECT kode_barang, nama_barang, stok_barang, stok_min_barang FROM barang ORDER BY kode_barang;
