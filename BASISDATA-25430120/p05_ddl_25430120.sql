-- ============================================================
-- p05_ddl_25430120.sql
-- Pertemuan 5: DDL dan constraint, proyek Perpustakaan Cendekia ABPA
-- Nama   : ADILLA BALQIS PUTRI ANTONI    NIM : 25430120
-- Basis data : perpus_120 (dijalankan oleh akun dev_120)
-- Skrip ini dapat dijalankan ulang dari basis data kosong.
--
-- Dasar rancangan : p04_normalisasi_25430120.md dan p04_erd_25430120
-- Kode AB-xx dan PB-xx merujuk p02_kebutuhan_data_25430120.md
-- Parameter P = 3 (20 mod 9 = 2, P = 2 + 1):
--   * batas 5 eksemplar per peminjaman (P + 2)  -> Modul 14 (lihat bagian 5)
--   * denda Rp3.000 per hari (P ribu rupiah)    -> DEFAULT tarif_per_hari_denda
-- ============================================================

USE perpus_120;

-- ------------------------------------------------------------
-- 1. Hapus tabel lama: urutan anak ke induk
-- ------------------------------------------------------------
DROP TABLE IF EXISTS denda;
DROP TABLE IF EXISTS detail_peminjaman;
DROP TABLE IF EXISTS peminjaman;
DROP TABLE IF EXISTS eksemplar;
DROP TABLE IF EXISTS buku;
DROP TABLE IF EXISTS petugas;
DROP TABLE IF EXISTS anggota;

-- ------------------------------------------------------------
-- 2. Tabel master (tanpa kunci tamu)
-- ------------------------------------------------------------
CREATE TABLE anggota (
  id_anggota             INT                      NOT NULL AUTO_INCREMENT,
  no_anggota             CHAR(7)                  NOT NULL,                  -- format AG-0012
  no_identitas_anggota   VARCHAR(20)              NOT NULL,                  -- NIM atau NIP
  nama_anggota           VARCHAR(100)             NOT NULL,
  no_hp_anggota          VARCHAR(15)              NULL,                      -- DATA PRIBADI: akses terbatas
  status_anggota         ENUM('aktif','nonaktif') NOT NULL DEFAULT 'aktif',  -- AB-03: hanya anggota aktif boleh meminjam
  tanggal_daftar_anggota DATE                     NOT NULL,
  CONSTRAINT pk_anggota PRIMARY KEY (id_anggota),
  CONSTRAINT uq_anggota_no        UNIQUE KEY (no_anggota),                   -- AB-10: nomor anggota unik
  CONSTRAINT uq_anggota_identitas UNIQUE KEY (no_identitas_anggota),         -- AB-10: nomor identitas unik
  CONSTRAINT ck_anggota_no CHECK (no_anggota REGEXP '^AG-[0-9]{4}$')         -- format sesuai kamus data
) ENGINE=InnoDB;

CREATE TABLE petugas (
  id_petugas    SMALLINT                      NOT NULL AUTO_INCREMENT,
  kode_petugas  CHAR(6)                       NOT NULL,                      -- format PTG-02
  nama_petugas  VARCHAR(100)                  NOT NULL,
  peran_petugas ENUM('pustakawan','kepala')   NOT NULL,
  CONSTRAINT pk_petugas PRIMARY KEY (id_petugas),
  CONSTRAINT uq_petugas_kode UNIQUE KEY (kode_petugas)
) ENGINE=InnoDB;

CREATE TABLE buku (
  id_buku           INT          NOT NULL AUTO_INCREMENT,
  kode_buku         CHAR(7)      NOT NULL,                                   -- format BK-0101
  judul_buku        VARCHAR(200) NOT NULL,
  pengarang_buku    VARCHAR(100) NOT NULL,
  penerbit_buku     VARCHAR(100) NULL,                                       -- kamus data: boleh kosong
  tahun_terbit_buku YEAR         NULL,                                       -- "tidak di masa depan": Modul 14
  isbn_buku         VARCHAR(17)  NULL,                                       -- unik bila ada
  kategori_buku     VARCHAR(50)  NOT NULL,
  CONSTRAINT pk_buku PRIMARY KEY (id_buku),
  CONSTRAINT uq_buku_kode UNIQUE KEY (kode_buku),
  CONSTRAINT uq_buku_isbn UNIQUE KEY (isbn_buku)                             -- NULL boleh berulang
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- 3. Tabel dengan kunci tamu
-- ------------------------------------------------------------
CREATE TABLE eksemplar (
  id_eksemplar            INT                                          NOT NULL AUTO_INCREMENT,
  kode_eksemplar          CHAR(11)                                     NOT NULL,   -- format EKS-0101-02
  id_buku                 INT                                          NOT NULL,   -- AB-05: satu judul banyak eksemplar
  status_eksemplar        ENUM('tersedia','dipinjam','rusak','hilang') NOT NULL DEFAULT 'tersedia', -- AB-04, AB-06
  lokasi_rak_eksemplar    VARCHAR(20)                                  NOT NULL,
  tanggal_masuk_eksemplar DATE                                         NOT NULL,
  CONSTRAINT pk_eksemplar PRIMARY KEY (id_eksemplar),
  CONSTRAINT uq_eksemplar_kode UNIQUE KEY (kode_eksemplar),                 -- AB-05: kode inventaris unik
  CONSTRAINT fk_eksemplar_buku FOREIGN KEY (id_buku) REFERENCES buku (id_buku)
    -- RESTRICT (bawaan): judul yang punya eksemplar tidak boleh dihapus
) ENGINE=InnoDB;

CREATE TABLE peminjaman (
  id_peminjaman                INT      NOT NULL AUTO_INCREMENT,
  no_peminjaman                CHAR(12) NOT NULL,                           -- format PM-2610-0031
  tanggal_pinjam_peminjaman    DATE     NOT NULL,
  lama_pinjam_hari_peminjaman  TINYINT  NOT NULL DEFAULT 7,                 -- AB-07: aturan lama pinjam saat itu (hasil Pertemuan 4)
  id_anggota                   INT      NOT NULL,                           -- peminjam wajib anggota
  id_petugas                   SMALLINT NOT NULL,                           -- PB-03: petugas pencatat
  CONSTRAINT pk_peminjaman PRIMARY KEY (id_peminjaman),
  CONSTRAINT uq_peminjaman_no UNIQUE KEY (no_peminjaman),                   -- AB-01: nomor peminjaman unik
  CONSTRAINT fk_peminjaman_anggota FOREIGN KEY (id_anggota) REFERENCES anggota (id_anggota),
  CONSTRAINT fk_peminjaman_petugas FOREIGN KEY (id_petugas) REFERENCES petugas (id_petugas),
  CONSTRAINT ck_peminjaman_lama CHECK (lama_pinjam_hari_peminjaman > 0)     -- AB-07
) ENGINE=InnoDB;

CREATE TABLE detail_peminjaman (
  id_peminjaman                     INT  NOT NULL,
  id_eksemplar                      INT  NOT NULL,
  tanggal_kembali_detail_peminjaman DATE NULL,                              -- NULL selama belum dikembalikan
  kondisi_kembali_detail_peminjaman ENUM('baik','rusak','hilang') NULL,
  CONSTRAINT pk_detail_peminjaman PRIMARY KEY (id_peminjaman, id_eksemplar),
  CONSTRAINT fk_detail_peminjaman FOREIGN KEY (id_peminjaman)
    REFERENCES peminjaman (id_peminjaman) ON DELETE CASCADE,               -- peminjaman salah input: rincian ikut dibatalkan
  CONSTRAINT fk_detail_eksemplar FOREIGN KEY (id_eksemplar)
    REFERENCES eksemplar (id_eksemplar),                                    -- eksemplar yang pernah dipinjam tidak boleh dihapus
  -- tanggal dan kondisi kembali dicatat bersamaan saat PB-04
  CONSTRAINT ck_detail_kembali CHECK (
    (tanggal_kembali_detail_peminjaman IS NULL AND kondisi_kembali_detail_peminjaman IS NULL)
    OR (tanggal_kembali_detail_peminjaman IS NOT NULL AND kondisi_kembali_detail_peminjaman IS NOT NULL))
) ENGINE=InnoDB;

CREATE TABLE denda (
  id_denda             INT           NOT NULL AUTO_INCREMENT,
  no_denda             CHAR(12)      NOT NULL,                              -- format DN-2610-0005
  id_peminjaman        INT           NOT NULL,
  id_eksemplar         INT           NOT NULL,
  tarif_per_hari_denda DECIMAL(12,2) NOT NULL DEFAULT 3000.00,              -- AB-08, AB-09: tarif disimpan per denda (P = 3)
  status_bayar_denda   ENUM('belum lunas','lunas') NOT NULL DEFAULT 'belum lunas', -- AB-11
  tanggal_bayar_denda  DATE          NULL,
  CONSTRAINT pk_denda PRIMARY KEY (id_denda),
  CONSTRAINT uq_denda_no UNIQUE KEY (no_denda),
  CONSTRAINT uq_denda_detail UNIQUE KEY (id_peminjaman, id_eksemplar),      -- relasi 0..1: satu detail paling banyak satu denda
  CONSTRAINT fk_denda_detail FOREIGN KEY (id_peminjaman, id_eksemplar)
    REFERENCES detail_peminjaman (id_peminjaman, id_eksemplar),             -- RESTRICT: denda tidak hilang diam-diam
  CONSTRAINT ck_denda_tarif CHECK (tarif_per_hari_denda >= 0),
  -- status lunas harus sejalan dengan tanggal bayar
  CONSTRAINT ck_denda_bayar CHECK (
    (status_bayar_denda = 'lunas' AND tanggal_bayar_denda IS NOT NULL)
    OR (status_bayar_denda = 'belum lunas' AND tanggal_bayar_denda IS NULL))
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- 4. Aturan bisnis yang BELUM dapat dijaga constraint
--    (ditandai untuk Modul 14: trigger atau transaksi)
-- ------------------------------------------------------------
-- AB-01 : minimal satu baris detail per peminjaman
-- AB-02 : maksimal 5 eksemplar per peminjaman (P + 2). CHECK hanya melihat
--         satu baris, sedangkan aturan ini menghitung banyak baris.
-- AB-03 : peminjam harus berstatus aktif (lintas tabel)
-- AB-04 : eksemplar harus berstatus tersedia saat dipinjam (lintas tabel)
-- AB-08 : denda hanya dibuat bila tanggal kembali lewat jatuh tempo
-- AB-11 : anggota dengan denda belum lunas tidak boleh meminjam lagi
-- AB-12 : tanggal kembali tidak boleh lebih awal dari tanggal pinjam
-- Batas tahun terbit tidak di masa depan (kamus data)

-- ------------------------------------------------------------
-- 5. Pemeriksaan (jalankan manual setelah skrip selesai)
-- ------------------------------------------------------------
-- SHOW TABLES;
-- SHOW CREATE TABLE peminjaman;
