-- p05_uji_constraint_kopma_25430120.sql
-- Bukti constraint bekerja (langkah D.3, D.4 dan latihan E.1).
-- Jalankan SETELAH p05_ddl_kopma_25430120.sql, SATU PERINTAH PADA SATU WAKTU di klien interaktif
-- (bukan sekaligus via `<`), karena perintah yang ditolak menghentikan skrip.
-- Ambil screenshot (nama akun + jam sistem terlihat) untuk tiap galat.

USE kopma_120;

-- Data induk secukupnya (harus DITERIMA)
INSERT INTO petugas (kode_petugas, nama_petugas, peran_petugas) VALUES
  ('K01','Dimas','kasir'), ('G01','Joko','gudang');
INSERT INTO barang (kode_barang, nama_barang, kategori_barang, harga_jual_barang, stok_barang, stok_min_barang) VALUES
  ('ATK-001','Pulpen Gel 0.5','ATK',4000,120,20),
  ('MNM-001','Air Mineral 600','minuman',4000,48,24);

-- UJI 1: kunci tamu tak dikenal -> harapan ERROR 1452
INSERT INTO penjualan (no_nota_penjualan, tgl_penjualan, id_petugas, id_anggota, bayar_penjualan)
VALUES ('PJ-2609-0199', NOW(), 99, NULL, 5000);

-- UJI 2: stok negatif -> harapan ERROR 4025 (melanggar ck_barang_stok)
UPDATE barang SET stok_barang = -1 WHERE id_barang = 1;

-- UJI 3: kode barang kembar -> harapan ERROR 1062
INSERT INTO barang (kode_barang, nama_barang, kategori_barang, harga_jual_barang)
VALUES ('ATK-001', 'Duplikat', 'ATK', 1000);

-- D.4: ubah struktur tanpa membuat ulang tabel
ALTER TABLE barang ADD COLUMN tgl_kedaluwarsa DATE NULL AFTER stok_min_barang;
DESCRIBE barang;
ALTER TABLE barang DROP COLUMN tgl_kedaluwarsa;      -- dibatalkan setelah dicoba

-- Bukti struktur untuk laporan
SHOW CREATE TABLE penjualan;
SHOW CREATE TABLE detail_penjualan;

-- Latihan E.1: CHECK stok_min tidak negatif, lalu buktikan penolakannya
-- (TULIS SENDIRI: ALTER TABLE ... ADD CONSTRAINT ck_barang_stokmin CHECK (...); lalu satu UPDATE yang ditolak)
-- Latihan E.2: ubah fk_penjualan_anggota menjadi ON DELETE SET NULL
-- (TULIS SENDIRI: DROP FOREIGN KEY lalu ADD CONSTRAINT ... ON DELETE SET NULL; diskusikan AB-02 & UU PDP di laporan)

-- Troubleshooting untuk Titik Analisis 3 (opsional, di basis data uji terpisah):
-- bandingkan galat bila DROP TABLE petugas dijalankan SEBELUM detail_penjualan/penjualan.
