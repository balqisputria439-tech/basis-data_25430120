-- p06_data_kopma_25430120.sql
-- Pertemuan 6 - Data sampel Kopma. Pemilik: Adilla Balqis Putri Antoni (25430120)
-- Jalankan SETELAH p05_ddl_kopma_25430120.sql pada basis data yang baru dibangun ulang:
--   mysql -u mhs_120 -p < p05_ddl_kopma_25430120.sql
--   mysql -u mhs_120 -p < p06_data_kopma_25430120.sql
-- Urutan: induk dahulu, anak kemudian. Kunci tamu diambil lewat kode alami (INSERT ... SELECT)
-- agar tidak menebak nilai AUTO_INCREMENT.

USE kopma_120;

-- ---------- D.1 data induk ----------
INSERT INTO petugas (kode_petugas, nama_petugas, peran_petugas) VALUES
  ('K01','Dimas','kasir'), ('K02','Sari','kasir'), ('K03','Rina','kasir'),
  ('G01','Joko','gudang'), ('P01','Ketua Kopma','ketua');

INSERT INTO barang (kode_barang, nama_barang, kategori_barang, harga_jual_barang, stok_barang, stok_min_barang) VALUES
  ('ATK-001','Pulpen Gel 0.5','ATK',4000,120,20),
  ('ATK-002','Buku Tulis 58','ATK',6500,80,20),
  ('MNM-001','Air Mineral 600','minuman',4000,48,24),
  ('MKN-001','Roti Cokelat','makanan',5000,6,10);

-- Minimal tiga anggota, satu nonaktif. DATA FIKTIF - ganti nama/NIM/HP dengan karanganmu sendiri
-- (nama fiktif tidak boleh sama persis dengan mahasiswa lain).
INSERT INTO anggota (no_anggota, nim_anggota, nama_anggota, prodi_anggota, no_hp_anggota, status_anggota, tgl_daftar_anggota) VALUES
  ('A-0001','2301010101','ISI NAMA FIKTIF 1','Ilmu Komputer','081200000001','aktif','2024-08-12'),
  ('A-0002','2301010102','ISI NAMA FIKTIF 2','Ilmu Komputer',NULL,'aktif','2024-09-03'),
  ('A-0003','2301010103','ISI NAMA FIKTIF 3','Manajemen','081200000003','nonaktif','2023-02-20');

-- Minimal dua pemasok
INSERT INTO pemasok (nama_pemasok, telepon_pemasok, alamat_pemasok) VALUES
  ('ISI NAMA PEMASOK 1','0721000001','ISI ALAMAT'),
  ('ISI NAMA PEMASOK 2','0721000002','ISI ALAMAT');

-- ---------- D.2 nota contoh PJ-2609-0142 (anggota id 1 aktif, kasir K03 = Rina) ----------
-- PENTING: samakan isi barang/qty nota ini dengan Gambar 2.5 pada modul. Nilai di bawah adalah contoh.
INSERT INTO penjualan (no_nota_penjualan, tgl_penjualan, id_petugas, id_anggota, bayar_penjualan)
SELECT 'PJ-2609-0142', '2026-09-24 10:15:00', p.id_petugas, a.id_anggota, 30000
FROM petugas p, anggota a WHERE p.kode_petugas = 'K03' AND a.no_anggota = 'A-0001';

-- harga satuan disalin dari harga jual saat itu (AB-04)
INSERT INTO detail_penjualan (id_penjualan, id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan)
SELECT j.id_penjualan, b.id_barang, 3, b.harga_jual_barang
FROM penjualan j, barang b WHERE j.no_nota_penjualan = 'PJ-2609-0142' AND b.kode_barang = 'ATK-001';
INSERT INTO detail_penjualan (id_penjualan, id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan)
SELECT j.id_penjualan, b.id_barang, 2, b.harga_jual_barang
FROM penjualan j, barang b WHERE j.no_nota_penjualan = 'PJ-2609-0142' AND b.kode_barang = 'ATK-002';
INSERT INTO detail_penjualan (id_penjualan, id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan)
SELECT j.id_penjualan, b.id_barang, 1, b.harga_jual_barang
FROM penjualan j, barang b WHERE j.no_nota_penjualan = 'PJ-2609-0142' AND b.kode_barang = 'MNM-001';

-- kurangi stok sesuai qty (WHERE memakai kolom UNIQUE agar lolos sql_safe_updates)
UPDATE barang SET stok_barang = stok_barang - 3 WHERE kode_barang = 'ATK-001';
UPDATE barang SET stok_barang = stok_barang - 2 WHERE kode_barang = 'ATK-002';
UPDATE barang SET stok_barang = stok_barang - 1 WHERE kode_barang = 'MNM-001';

-- ---------- Bukti jumlah baris (untuk screenshot laporan) ----------
SELECT 'petugas' t, COUNT(*) n FROM petugas UNION ALL SELECT 'anggota', COUNT(*) FROM anggota
UNION ALL SELECT 'barang', COUNT(*) FROM barang UNION ALL SELECT 'pemasok', COUNT(*) FROM pemasok
UNION ALL SELECT 'penjualan', COUNT(*) FROM penjualan UNION ALL SELECT 'detail_penjualan', COUNT(*) FROM detail_penjualan;
