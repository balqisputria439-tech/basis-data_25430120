-- ============================================================
-- p05_uji_constraint_25430120.sql
-- Bukti singkat constraint proyek bekerja (bahan screenshot)
-- Jalankan SATU PER SATU di klien mysql sebagai dev_120.
-- Perintah bertanda [DITOLAK] memang harus menghasilkan galat.
-- ============================================================
USE perpus_120;

INSERT INTO anggota (no_anggota, no_identitas_anggota, nama_anggota, tanggal_daftar_anggota)
VALUES ('AG-0001', '25430120', 'Adilla Balqis Putri Antoni', '2026-10-20');
INSERT INTO petugas (kode_petugas, nama_petugas, peran_petugas)
VALUES ('PTG-01', 'Rina', 'pustakawan');
INSERT INTO buku (kode_buku, judul_buku, pengarang_buku, kategori_buku)
VALUES ('BK-0101', 'Basis Data Dasar', 'Dedi Irawan', 'Komputer');
INSERT INTO eksemplar (kode_eksemplar, id_buku, lokasi_rak_eksemplar, tanggal_masuk_eksemplar)
VALUES ('EKS-0101-01', 1, 'Rak B-3', '2026-10-20');

-- 1. UNIQUE: nomor anggota kembar (ERROR 1062)             -> AB-10
INSERT INTO anggota (no_anggota, no_identitas_anggota, nama_anggota, tanggal_daftar_anggota)
VALUES ('AG-0001', '25430999', 'Kembar', '2026-10-20');     -- [DITOLAK]

-- 2. FOREIGN KEY: peminjaman oleh anggota yang tidak ada (ERROR 1452)
INSERT INTO peminjaman (no_peminjaman, tanggal_pinjam_peminjaman, id_anggota, id_petugas)
VALUES ('PM-2610-0001', '2026-10-20', 99, 1);               -- [DITOLAK]

-- 3. CHECK: lama pinjam harus positif (ERROR 4025)         -> AB-07
INSERT INTO peminjaman (no_peminjaman, tanggal_pinjam_peminjaman, lama_pinjam_hari_peminjaman, id_anggota, id_petugas)
VALUES ('PM-2610-0002', '2026-10-20', 0, 1, 1);             -- [DITOLAK]

-- 4. CHECK: format nomor anggota (ERROR 4025)
INSERT INTO anggota (no_anggota, no_identitas_anggota, nama_anggota, tanggal_daftar_anggota)
VALUES ('XX-9', '25430888', 'Format salah', '2026-10-20');  -- [DITOLAK]

SHOW CREATE TABLE peminjaman;
