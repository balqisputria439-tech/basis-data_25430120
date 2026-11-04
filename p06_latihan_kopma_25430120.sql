-- ============================================================
-- p06_latihan_kopma_25430120.sql
-- Latihan E1 dan E2 Pertemuan 6. Jalankan sebagai mhs_120.
-- PERHATIAN: skrip ini MENGUBAH data secara permanen (tanpa ROLLBACK).
-- Untuk memulihkan data awal, jalankan ulang p05_ddl_kopma_25430120.sql
-- lalu p06_data_kopma_25430120.sql.
-- ============================================================
USE kopma_120;

-- ---- Latihan E1: arsipkan anggota nonaktif yang mendaftar sebelum 2025 ----
-- Syarat: anggota yang masih punya penjualan TIDAK ikut diarsipkan atau dihapus
-- (NOT EXISTS). Anggota A-0120 memenuhi syarat, A-0133 punya nota PJ-2609-0021.
DROP TABLE IF EXISTS anggota_arsip;
CREATE TABLE anggota_arsip LIKE anggota;

INSERT INTO anggota_arsip
SELECT a.* FROM anggota a
WHERE a.status_anggota = 'nonaktif'
  AND a.tgl_daftar_anggota < '2025-01-01'
  AND NOT EXISTS (SELECT 1 FROM penjualan p WHERE p.id_anggota = a.id_anggota);

SELECT no_anggota, nama_anggota, status_anggota, tgl_daftar_anggota FROM anggota_arsip;   -- hanya A-0120

DELETE FROM anggota WHERE id_anggota IN (SELECT id_anggota FROM anggota_arsip);

SELECT no_anggota, nama_anggota, status_anggota FROM anggota ORDER BY no_anggota;          -- A-0120 hilang, A-0133 tetap ada

-- ---- Latihan E2: naikkan harga semua barang kategori makanan 5%, dibulatkan ke ratusan terdekat ----
SELECT kode_barang, nama_barang, harga_jual_barang AS harga_lama FROM barang WHERE kategori_barang = 'makanan';

UPDATE barang
SET harga_jual_barang = ROUND(harga_jual_barang * 1.05 / 100) * 100
WHERE kategori_barang = 'makanan' AND id_barang > 0;       -- id_barang > 0 agar lolos mode aman (sql_safe_updates)

SELECT kode_barang, nama_barang, harga_jual_barang AS harga_baru FROM barang WHERE kategori_barang = 'makanan';
-- Perkiraan: Roti Cokelat 5000 -> 5300, Wafer Cokelat 3000 -> 3200
