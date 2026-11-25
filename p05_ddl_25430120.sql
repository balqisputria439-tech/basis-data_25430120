-- p05_ddl_25430120.sql  - DDL proyek: <ISI nama organisasi>
-- Pemilik: Adilla Balqis Putri Antoni (25430120)   Basis data: perpus_120   Akun: dev_120
-- Wajib dapat dijalankan ulang dari basis data kosong.
--
-- PANDUAN (hapus blok ini setelah selesai):
--  1. Mulai dengan USE perpus_120; lalu blok DROP TABLE IF EXISTS (urutan ANAK -> INDUK).
--  2. Buat tabel dari skema 3NF Pertemuan 4: induk dulu, anak kemudian.
--  3. Setiap tabel punya PRIMARY KEY; setiap relasi ERD jadi FOREIGN KEY; kolom FK bertipe SAMA PERSIS
--     (termasuk SIGNED/UNSIGNED) dengan kolom yang dirujuk (kalau tidak: ERROR 1005 errno 150).
--  4. Tiap aturan bisnis yang bisa dijaga struktur -> constraint, dengan KOMENTAR kode AB-xx:
--       NOT NULL / UNIQUE / CHECK (aturan satu baris) / DEFAULT / ENUM (nilai terbatas).
--  5. Nama constraint: pk_<tabel>, fk_<tabel>_<tujuan>, uq_<tabel>_<kolom>, ck_<tabel>_<apa>.
--  6. Aturan batas P+2 = 3+2 = ISI SENDIRI per transaksi:
--       - menyangkut SATU baris (mis. qty per item)  -> wujudkan dengan CHECK;
--       - menyangkut JUMLAH BARIS per transaksi      -> CHECK tidak bisa (melibatkan banyak baris);
--         beri komentar "-- AB-xx: belum terjaga, diselesaikan di Modul 14".
--  7. Pilih tipe data dan catat alasannya di tabel pemetaan (laporan): uang -> DECIMAL, kode tetap -> CHAR,
--     tanggal -> DATE/DATETIME sesuai kebutuhan laporan, nilai terbatas -> ENUM.
--  8. Jangan beri CHARACTER SET pada tabel; warisi dari basis data (utf8mb4_unicode_ci).

USE perpus_120;

-- DROP TABLE IF EXISTS ...;   -- ISI SENDIRI (anak -> induk)

-- CREATE TABLE ... ;          -- ISI SENDIRI (induk -> anak)
