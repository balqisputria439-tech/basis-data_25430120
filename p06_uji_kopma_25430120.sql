-- ============================================================
-- p06_uji_kopma_25430120.sql
-- Skenario uji Kopma (Langkah D.2 sampai D.4). Jalankan sebagai mhs_120
-- setelah p05_ddl_kopma dan p06_data_kopma dijalankan.
--
-- Cara memakai: buka klien mysql, lalu jalankan SATU PER SATU di dalam
-- SATU sesi. Seluruh pengujian berada di dalam transaksi dan diakhiri
-- ROLLBACK, sehingga data sampel kembali seperti semula.
-- Perintah bertanda [DITOLAK] memang harus menghasilkan galat.
-- Salin hasil NYATA dari layar ke p06_uji_kopma_25430120.md.
-- ============================================================
USE kopma_120;
START TRANSACTION;

-- UJ-01 (AB-02) Nota baru dengan anggota aktif -> diterima
INSERT INTO penjualan (no_nota_penjualan, tgl_penjualan, id_petugas, id_anggota, bayar_penjualan)
VALUES ('PJ-2609-0901', '2026-09-28 09:00:00',
        (SELECT id_petugas FROM petugas WHERE kode_petugas = 'K01'),
        (SELECT id_anggota FROM anggota WHERE no_anggota = 'A-0458'), 10000);

-- UJ-02 (AB-02) Nota tanpa anggota (pembeli umum) -> diterima, id_anggota NULL
INSERT INTO penjualan (no_nota_penjualan, tgl_penjualan, id_petugas, id_anggota, bayar_penjualan)
VALUES ('PJ-2609-0902', '2026-09-28 09:30:00',
        (SELECT id_petugas FROM petugas WHERE kode_petugas = 'K01'), NULL, 5000);
SELECT no_nota_penjualan, id_anggota FROM penjualan WHERE no_nota_penjualan IN ('PJ-2609-0901','PJ-2609-0902');

-- UJ-03 (AB-03, ck_barang_stok) Stok diubah menjadi -5 -> [DITOLAK] ERROR 4025
UPDATE barang SET stok_barang = -5 WHERE kode_barang = 'ATK-001';

-- UJ-04 (AB-01, uq_penjualan_nota) Nomor nota yang sudah ada -> [DITOLAK] ERROR 1062
INSERT INTO penjualan (no_nota_penjualan, tgl_penjualan, id_petugas, id_anggota, bayar_penjualan)
VALUES ('PJ-2609-0142', '2026-09-28 10:00:00',
        (SELECT id_petugas FROM petugas WHERE kode_petugas = 'K01'), NULL, 5000);

-- UJ-05 (ck_detail_qty) Detail dengan qty 0 -> [DITOLAK] ERROR 4025
INSERT INTO detail_penjualan (id_penjualan, id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan)
SELECT p.id_penjualan, b.id_barang, 0, b.harga_jual_barang FROM penjualan p, barang b
WHERE p.no_nota_penjualan = 'PJ-2609-0143' AND b.kode_barang = 'ATK-001';

-- UJ-06 (AB-05, uq_anggota_nim) Anggota dengan NIM kembar -> [DITOLAK] ERROR 1062
INSERT INTO anggota (no_anggota, nim_anggota, nama_anggota, prodi_anggota, tgl_daftar_anggota)
VALUES ('A-0999', '2501010457', 'Nama Berbeda', 'Manajemen', '2026-09-28');

-- UJ-07 (fk_penjualan_petugas) Penjualan oleh petugas tidak dikenal -> [DITOLAK] ERROR 1452
INSERT INTO penjualan (no_nota_penjualan, tgl_penjualan, id_petugas, id_anggota, bayar_penjualan)
VALUES ('PJ-2609-0903', '2026-09-28 10:30:00', 99, NULL, 5000);

-- UJ-08 (kebijakan lab) UPDATE tanpa WHERE di mode aman -> [DITOLAK] ERROR 1175
SET SESSION sql_safe_updates = 1;
UPDATE barang SET harga_jual_barang = harga_jual_barang * 1.1;

-- Bagian D.3: UPDATE dengan syarat kunci diterima di mode aman
UPDATE barang SET harga_jual_barang = harga_jual_barang * 1.1
WHERE kategori_barang = 'ATK' AND id_barang > 0;

-- Titik Analisis 1: harga barang naik, nota lama tidak ikut berubah
UPDATE barang SET harga_jual_barang = 4500 WHERE kode_barang = 'ATK-001';
SELECT p.no_nota_penjualan, b.kode_barang, d.harga_satuan_detail_penjualan AS harga_pada_nota, b.harga_jual_barang AS harga_barang_kini
FROM detail_penjualan d JOIN penjualan p ON p.id_penjualan = d.id_penjualan JOIN barang b ON b.id_barang = d.id_barang
WHERE p.no_nota_penjualan = 'PJ-2609-0142' AND b.kode_barang = 'ATK-001';

-- Titik Analisis 2 (D.3 langkah 6): nota uji dihapus -> detailnya ikut terhapus (CASCADE)
INSERT INTO penjualan (no_nota_penjualan, tgl_penjualan, id_petugas, id_anggota, bayar_penjualan)
VALUES ('PJ-2609-0999', '2026-09-28 11:00:00',
        (SELECT id_petugas FROM petugas WHERE kode_petugas = 'K02'), NULL, 10000);
INSERT INTO detail_penjualan (id_penjualan, id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan)
SELECT p.id_penjualan, b.id_barang, 1, b.harga_jual_barang FROM penjualan p, barang b
WHERE p.no_nota_penjualan = 'PJ-2609-0999' AND b.kode_barang = 'ATK-003';
SELECT COUNT(*) AS detail_sebelum_hapus FROM detail_penjualan d JOIN penjualan p ON p.id_penjualan = d.id_penjualan WHERE p.no_nota_penjualan = 'PJ-2609-0999';
DELETE FROM penjualan WHERE no_nota_penjualan = 'PJ-2609-0999';
SELECT COUNT(*) AS detail_sesudah_hapus FROM detail_penjualan d JOIN penjualan p ON p.id_penjualan = d.id_penjualan WHERE p.no_nota_penjualan = 'PJ-2609-0999';

-- Petugas yang pernah melayani penjualan tidak dapat dihapus -> [DITOLAK] ERROR 1451
DELETE FROM petugas WHERE kode_petugas = 'K03';

-- UJ-09 (Titik Analisis 3, diperkirakan GAGAL) Qty melebihi stok -> seharusnya ditolak
-- Roti Cokelat hanya tersisa 1, tetapi detail dengan qty 500 DITERIMA server.
INSERT INTO detail_penjualan (id_penjualan, id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan)
SELECT p.id_penjualan, b.id_barang, 500, b.harga_jual_barang FROM penjualan p, barang b
WHERE p.no_nota_penjualan = 'PJ-2609-0901' AND b.kode_barang = 'MKN-001';
-- Pengurangan stok barulah yang ditolak CHECK, sehingga nota dan stok tidak sinkron:
UPDATE barang SET stok_barang = stok_barang - 500 WHERE kode_barang = 'MKN-001';  -- [DITOLAK] ERROR 4025

SET SESSION sql_safe_updates = 0;
ROLLBACK;   -- seluruh data uji dibatalkan
