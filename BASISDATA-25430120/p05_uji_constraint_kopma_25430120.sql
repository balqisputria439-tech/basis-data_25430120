-- ============================================================
-- p05_uji_constraint_kopma_25430120.sql
-- Bukti constraint bekerja (Langkah D.3 sampai D.4 dan Latihan E)
-- Jalankan SATU PER SATU di klien mysql sebagai mhs_120.
-- Perintah bertanda [DITOLAK] memang harus menghasilkan galat.
-- ============================================================
USE kopma_120;

-- Data induk secukupnya (harus berhasil)
INSERT INTO petugas (kode_petugas, nama_petugas, peran_petugas)
VALUES ('K01', 'Rina', 'kasir'), ('G01', 'Budi', 'gudang');
INSERT INTO barang (kode_barang, nama_barang, kategori_barang, harga_jual_barang, stok_barang)
VALUES ('ATK-001', 'Pulpen Gel 0.5', 'ATK', 4000, 50),
       ('MKN-001', 'Roti Cokelat', 'makanan', 5000, 20);

-- ---- D.3 Membuktikan constraint (semua [DITOLAK]) ----
-- 1. Kunci tamu tidak dikenal (ERROR 1452)
INSERT INTO penjualan (no_nota_penjualan, tgl_penjualan, id_petugas, id_anggota, bayar_penjualan)
VALUES ('PJ-2609-0199', NOW(), 99, NULL, 5000);        -- [DITOLAK] petugas 99 tidak ada

-- 2. Stok negatif melanggar AB-03 (ERROR 4025)
UPDATE barang SET stok_barang = -1 WHERE id_barang = 1; -- [DITOLAK]

-- 3. Kode barang kembar (ERROR 1062)
INSERT INTO barang (kode_barang, nama_barang, kategori_barang, harga_jual_barang)
VALUES ('ATK-001', 'Duplikat', 'ATK', 1000);            -- [DITOLAK]

-- ---- D.4 Mengubah struktur ----
ALTER TABLE barang ADD COLUMN tgl_kedaluwarsa DATE NULL AFTER stok_min_barang;
SHOW CREATE TABLE barang;
ALTER TABLE barang DROP COLUMN tgl_kedaluwarsa;         -- dibatalkan setelah dicoba

-- ---- Latihan E1: stok_min_barang tidak boleh negatif ----
ALTER TABLE barang ADD CONSTRAINT ck_barang_stok_min CHECK (stok_min_barang >= 0);
UPDATE barang SET stok_min_barang = -1 WHERE id_barang = 1; -- [DITOLAK] ERROR 4025

-- ---- Latihan E2: ON DELETE SET NULL pada fk_penjualan_anggota ----
ALTER TABLE penjualan DROP FOREIGN KEY fk_penjualan_anggota;
ALTER TABLE penjualan ADD CONSTRAINT fk_penjualan_anggota
  FOREIGN KEY (id_anggota) REFERENCES anggota (id_anggota) ON DELETE SET NULL;
SHOW CREATE TABLE penjualan;

-- Kembalikan ke aturan semula (hapus anggota ditolak selama masih ada nota)
ALTER TABLE penjualan DROP FOREIGN KEY fk_penjualan_anggota;
ALTER TABLE penjualan ADD CONSTRAINT fk_penjualan_anggota
  FOREIGN KEY (id_anggota) REFERENCES anggota (id_anggota);

-- ---- Titik Analisis 3: urutan DROP yang salah ----
-- Hapus induk sebelum anak (ERROR 1451). Jalankan hanya untuk bukti,
-- lalu gunakan skrip p05_ddl_kopma_25430120.sql untuk membangun ulang.
DROP TABLE IF EXISTS petugas;                           -- [DITOLAK] masih dirujuk penjualan
