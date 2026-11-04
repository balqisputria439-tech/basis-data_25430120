-- ============================================================
-- p06_uji_25430120.sql
-- Skenario uji proyek Perpustakaan Cendekia ABPA. Jalankan sebagai dev_120
-- setelah p05_ddl_25430120 dan p06_data_25430120 dijalankan.
--
-- Cara memakai: buka klien mysql, lalu jalankan SATU PER SATU di dalam
-- SATU sesi. Seluruh pengujian berada di dalam transaksi dan diakhiri
-- ROLLBACK, sehingga data sampel kembali seperti semula.
-- Perintah bertanda [DITOLAK] memang harus menghasilkan galat.
-- Salin hasil NYATA dari layar ke p06_uji_25430120.md.
-- ============================================================
USE perpus_120;
START TRANSACTION;

-- UJ-01 (AB-01, AB-02) Peminjaman oleh anggota aktif dengan 3 eksemplar -> diterima
INSERT INTO peminjaman (no_peminjaman, tanggal_pinjam_peminjaman, lama_pinjam_hari_peminjaman, id_anggota, id_petugas)
VALUES ('PM-2610-0901', '2026-10-31', 7, (SELECT id_anggota FROM anggota WHERE no_anggota = 'AG-0001'), (SELECT id_petugas FROM petugas WHERE kode_petugas = 'PTG-01'));
INSERT INTO detail_peminjaman (id_peminjaman, id_eksemplar) VALUES ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2610-0901'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EKS-0101-01'));
INSERT INTO detail_peminjaman (id_peminjaman, id_eksemplar) VALUES ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2610-0901'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EKS-0103-01'));
INSERT INTO detail_peminjaman (id_peminjaman, id_eksemplar) VALUES ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2610-0901'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EKS-0104-02'));
SELECT no_peminjaman, COUNT(*) AS jumlah_eksemplar FROM peminjaman p JOIN detail_peminjaman d ON d.id_peminjaman = p.id_peminjaman WHERE p.no_peminjaman = 'PM-2610-0901' GROUP BY p.no_peminjaman;

-- UJ-02 (AB-12) Pengembalian tepat waktu -> diterima (tanggal dan kondisi dicatat bersamaan)
UPDATE detail_peminjaman SET tanggal_kembali_detail_peminjaman = '2026-10-31', kondisi_kembali_detail_peminjaman = 'baik'
WHERE id_peminjaman = (SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2610-0901') AND id_eksemplar = (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EKS-0101-01');

-- UJ-03 (AB-08, AB-09) Eksemplar terlambat 4 hari -> denda dengan tarif bawaan Rp3.000 diterima
INSERT INTO peminjaman (no_peminjaman, tanggal_pinjam_peminjaman, lama_pinjam_hari_peminjaman, id_anggota, id_petugas)
VALUES ('PM-2610-0902', '2026-10-01', 7, (SELECT id_anggota FROM anggota WHERE no_anggota = 'AG-0002'), (SELECT id_petugas FROM petugas WHERE kode_petugas = 'PTG-02'));
INSERT INTO detail_peminjaman (id_peminjaman, id_eksemplar) VALUES ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2610-0902'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EKS-0104-02'));
UPDATE detail_peminjaman SET tanggal_kembali_detail_peminjaman = '2026-10-12', kondisi_kembali_detail_peminjaman = 'baik'
WHERE id_peminjaman = (SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2610-0902') AND id_eksemplar = (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EKS-0104-02');
INSERT INTO denda (no_denda, id_peminjaman, id_eksemplar) VALUES ('DN-2610-0901', (SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2610-0902'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EKS-0104-02'));
SELECT DATEDIFF(d.tanggal_kembali_detail_peminjaman, DATE_ADD(p.tanggal_pinjam_peminjaman, INTERVAL p.lama_pinjam_hari_peminjaman DAY)) AS hari_telat,
       n.tarif_per_hari_denda
FROM denda n JOIN detail_peminjaman d ON d.id_peminjaman = n.id_peminjaman AND d.id_eksemplar = n.id_eksemplar
     JOIN peminjaman p ON p.id_peminjaman = d.id_peminjaman
WHERE n.no_denda = 'DN-2610-0901';   -- hari_telat = 4 (total denda 4 x 3000 = 12000, dihitung, tidak disimpan)

-- UJ-04 (AB-10, uq_anggota_no) Nomor anggota kembar -> [DITOLAK] ERROR 1062
INSERT INTO anggota (no_anggota, no_identitas_anggota, nama_anggota, tanggal_daftar_anggota)
VALUES ('AG-0001', '25430999', 'Nama Berbeda', '2026-10-31');

-- UJ-05 (AB-10, uq_anggota_identitas) Nomor identitas kembar -> [DITOLAK] ERROR 1062
INSERT INTO anggota (no_anggota, no_identitas_anggota, nama_anggota, tanggal_daftar_anggota)
VALUES ('AG-0099', '25430101', 'Nama Berbeda', '2026-10-31');

-- UJ-06 (ck_anggota_no) Format nomor anggota salah -> [DITOLAK] ERROR 4025
INSERT INTO anggota (no_anggota, no_identitas_anggota, nama_anggota, tanggal_daftar_anggota)
VALUES ('XX-9', '25430998', 'Format Salah', '2026-10-31');

-- UJ-07 (AB-03, fk_peminjaman_anggota) Peminjaman oleh anggota yang tidak ada -> [DITOLAK] ERROR 1452
INSERT INTO peminjaman (no_peminjaman, tanggal_pinjam_peminjaman, lama_pinjam_hari_peminjaman, id_anggota, id_petugas)
VALUES ('PM-2610-0903', '2026-10-31', 7, 9999, (SELECT id_petugas FROM petugas WHERE kode_petugas = 'PTG-01'));

-- UJ-08 (AB-07, ck_peminjaman_lama) Lama pinjam 0 hari -> [DITOLAK] ERROR 4025
INSERT INTO peminjaman (no_peminjaman, tanggal_pinjam_peminjaman, lama_pinjam_hari_peminjaman, id_anggota, id_petugas)
VALUES ('PM-2610-0904', '2026-10-31', 0, (SELECT id_anggota FROM anggota WHERE no_anggota = 'AG-0001'), (SELECT id_petugas FROM petugas WHERE kode_petugas = 'PTG-01'));

-- UJ-09 (AB-04, pk_detail_peminjaman) Eksemplar yang sama dua kali dalam satu peminjaman -> [DITOLAK] ERROR 1062
INSERT INTO detail_peminjaman (id_peminjaman, id_eksemplar) VALUES ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2610-0901'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EKS-0103-01'));

-- UJ-10 (AB-12, ck_detail_kembali) Tanggal kembali diisi tanpa kondisi -> [DITOLAK] ERROR 4025
UPDATE detail_peminjaman SET tanggal_kembali_detail_peminjaman = '2026-10-31'
WHERE id_peminjaman = (SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2610-0901') AND id_eksemplar = (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EKS-0103-01');

-- UJ-11 (AB-08, uq_denda_detail) Denda kedua untuk eksemplar yang sama -> [DITOLAK] ERROR 1062
INSERT INTO denda (no_denda, id_peminjaman, id_eksemplar) VALUES ('DN-2610-0902', (SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2610-0902'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EKS-0104-02'));

-- UJ-12 (AB-11, ck_denda_bayar) Denda berstatus lunas tanpa tanggal bayar -> [DITOLAK] ERROR 4025
INSERT INTO denda (no_denda, id_peminjaman, id_eksemplar, status_bayar_denda) VALUES ('DN-2610-0903', (SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2610-0001'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EKS-0103-02'), 'lunas');

-- UJ-13 (fk_peminjaman_petugas, RESTRICT) Menghapus petugas yang pernah mencatat peminjaman -> [DITOLAK] ERROR 1451
DELETE FROM petugas WHERE kode_petugas = 'PTG-01';

-- UJ-14 (AB-02, diperkirakan GAGAL) Satu peminjaman berisi 6 eksemplar (batas P + 2 = 5)
-- Seharusnya ditolak, tetapi seluruh 6 baris DITERIMA karena CHECK hanya melihat satu baris.
INSERT INTO peminjaman (no_peminjaman, tanggal_pinjam_peminjaman, lama_pinjam_hari_peminjaman, id_anggota, id_petugas)
VALUES ('PM-2610-0905', '2026-10-31', 7, (SELECT id_anggota FROM anggota WHERE no_anggota = 'AG-0003'), (SELECT id_petugas FROM petugas WHERE kode_petugas = 'PTG-03'));
INSERT INTO detail_peminjaman (id_peminjaman, id_eksemplar) VALUES ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2610-0905'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EKS-0101-01'));
INSERT INTO detail_peminjaman (id_peminjaman, id_eksemplar) VALUES ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2610-0905'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EKS-0101-03'));
INSERT INTO detail_peminjaman (id_peminjaman, id_eksemplar) VALUES ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2610-0905'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EKS-0101-04'));
INSERT INTO detail_peminjaman (id_peminjaman, id_eksemplar) VALUES ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2610-0905'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EKS-0103-01'));
INSERT INTO detail_peminjaman (id_peminjaman, id_eksemplar) VALUES ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2610-0905'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EKS-0104-02'));
INSERT INTO detail_peminjaman (id_peminjaman, id_eksemplar) VALUES ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2610-0905'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EKS-0106-01'));
SELECT COUNT(*) AS jumlah_eksemplar FROM detail_peminjaman WHERE id_peminjaman = (SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2610-0905');   -- hasil 6 berarti uji GAGAL

ROLLBACK;   -- seluruh data uji dibatalkan
