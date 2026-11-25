-- p06_data_25430120.sql - data sampel proyek: <ISI nama organisasi>
-- Pemilik: Adilla Balqis Putri Antoni (25430120)   Basis data: perpus_120
-- Dijalankan setelah p05_ddl_25430120.sql. Wajib dapat diulang dari basis data kosong.
--
-- KETENTUAN (hapus blok ini setelah selesai):
--  * Setiap tabel induk >= 5 baris.
--  * Tabel transaksi utama >= 10 x P = 10 x 3 = ISI SENDIRI baris, tersebar pada >= 3 tanggal berbeda.
--  * Data realistis (bukan 'abc' / 'test1'); nama fiktif tidak boleh sama dengan mahasiswa lain.
--  * Mulai dari induk. Ambil nilai kunci tamu dengan INSERT ... SELECT memakai kode alami,
--    jangan menebak AUTO_INCREMENT (Troubleshooting 2).
--  * Harga/tarif yang harus tercatat historis disalin ke baris transaksi (pola AB-04 Kopma).
--  * Tips mengisi banyak baris: satu INSERT dengan banyak tuple VALUES (...), (...), ...;
--    jaga jumlah item per transaksi <= P + 2 = ISI SENDIRI.

USE perpus_120;

-- ISI SENDIRI
