-- ============================================================
-- p05_ddl_kopma_25430120.sql
-- Pertemuan 5: DDL dan constraint, studi kasus Kopma
-- Nama   : ADILLA BALQIS PUTRI ANTONI    NIM : 25430120
-- Basis data : kopma_120 (dijalankan oleh akun mhs_120)
-- Skrip ini dapat dijalankan ulang dari basis data kosong.
--
-- Catatan penamaan: nama kolom mengikuti skema kanonik buku
-- (Tabel 4.2 dan Gambar 3.2), misalnya tgl_penjualan dan
-- stok_min_barang, agar sesuai dengan contoh data Pertemuan 6.
-- Dua tambahan dari rancangan saya (Pertemuan 3 dan 4):
--   1. pemasok.kode_pemasok  (boleh NULL, UNIQUE)
--   2. pembelian.id_petugas  (boleh NULL, aturan AB-10)
-- ============================================================

USE kopma_120;

-- ------------------------------------------------------------
-- 1. Hapus tabel lama: urutan anak ke induk
-- ------------------------------------------------------------
DROP TABLE IF EXISTS detail_pembelian;
DROP TABLE IF EXISTS pembelian;
DROP TABLE IF EXISTS detail_penjualan;
DROP TABLE IF EXISTS penjualan;
DROP TABLE IF EXISTS pemasok;
DROP TABLE IF EXISTS barang;
DROP TABLE IF EXISTS anggota;
DROP TABLE IF EXISTS petugas;

-- ------------------------------------------------------------
-- 2. Tabel master (tanpa kunci tamu)
-- ------------------------------------------------------------
CREATE TABLE petugas (
  id_petugas    SMALLINT                      NOT NULL AUTO_INCREMENT,
  kode_petugas  CHAR(3)                       NOT NULL,
  nama_petugas  VARCHAR(100)                  NOT NULL,
  peran_petugas ENUM('kasir','gudang','ketua') NOT NULL,
  CONSTRAINT pk_petugas PRIMARY KEY (id_petugas),
  CONSTRAINT uq_petugas_kode UNIQUE KEY (kode_petugas)
) ENGINE=InnoDB;

CREATE TABLE anggota (
  id_anggota         INT                    NOT NULL AUTO_INCREMENT,
  no_anggota         CHAR(6)                NOT NULL,                 -- format A-0457
  nim_anggota        CHAR(10)               NOT NULL,                 -- kode, bukan angka hitung
  nama_anggota       VARCHAR(100)           NOT NULL,
  prodi_anggota      VARCHAR(60)            NOT NULL,
  no_hp_anggota      VARCHAR(15)            NULL,                     -- DATA PRIBADI: hanya ketua (view Pertemuan 13)
  status_anggota     ENUM('aktif','nonaktif') NOT NULL DEFAULT 'aktif', -- AB-02: diskon hanya anggota aktif
  tgl_daftar_anggota DATE                   NOT NULL,
  CONSTRAINT pk_anggota PRIMARY KEY (id_anggota),
  CONSTRAINT uq_anggota_no  UNIQUE KEY (no_anggota),
  CONSTRAINT uq_anggota_nim UNIQUE KEY (nim_anggota)                  -- AB-05: NIM unik
) ENGINE=InnoDB;

CREATE TABLE barang (
  id_barang         INT                              NOT NULL AUTO_INCREMENT,
  kode_barang       VARCHAR(10)                      NOT NULL,
  nama_barang       VARCHAR(100)                     NOT NULL,
  kategori_barang   ENUM('ATK','makanan','minuman')  NOT NULL,
  harga_jual_barang DECIMAL(12,2)                    NOT NULL,        -- uang: DECIMAL, bukan FLOAT
  stok_barang       INT                              NOT NULL DEFAULT 0,
  stok_min_barang   INT                              NOT NULL DEFAULT 5, -- AB-06: batas pemesanan ulang
  CONSTRAINT pk_barang PRIMARY KEY (id_barang),
  CONSTRAINT uq_barang_kode UNIQUE KEY (kode_barang),
  CONSTRAINT ck_barang_stok  CHECK (stok_barang >= 0),                -- AB-03: stok tidak boleh negatif
  CONSTRAINT ck_barang_harga CHECK (harga_jual_barang >= 0)
) ENGINE=InnoDB;

CREATE TABLE pemasok (
  id_pemasok      INT          NOT NULL AUTO_INCREMENT,
  kode_pemasok    VARCHAR(10)  NULL,                                  -- tambahan rancangan saya
  nama_pemasok    VARCHAR(100) NOT NULL,
  telepon_pemasok VARCHAR(15)  NULL,
  alamat_pemasok  VARCHAR(200) NULL,
  CONSTRAINT pk_pemasok PRIMARY KEY (id_pemasok),
  CONSTRAINT uq_pemasok_kode UNIQUE KEY (kode_pemasok)
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- 3. Tabel transaksi (dengan kunci tamu)
-- ------------------------------------------------------------
CREATE TABLE penjualan (
  id_penjualan      INT           NOT NULL AUTO_INCREMENT,
  no_nota_penjualan CHAR(12)      NOT NULL,                           -- format PJ-2609-0142
  tgl_penjualan     DATETIME      NOT NULL,                           -- jam dibutuhkan untuk KI-01
  id_petugas        SMALLINT      NOT NULL,                           -- nota wajib punya kasir
  id_anggota        INT           NULL,                               -- AB-02: pembeli umum boleh NULL
  bayar_penjualan   DECIMAL(12,2) NOT NULL,                           -- total tidak disimpan (keputusan Pertemuan 4)
  CONSTRAINT pk_penjualan PRIMARY KEY (id_penjualan),
  CONSTRAINT uq_penjualan_nota UNIQUE KEY (no_nota_penjualan),        -- AB-01: nomor nota unik
  CONSTRAINT fk_penjualan_petugas FOREIGN KEY (id_petugas) REFERENCES petugas (id_petugas),
  CONSTRAINT fk_penjualan_anggota FOREIGN KEY (id_anggota) REFERENCES anggota (id_anggota),
  CONSTRAINT ck_penjualan_bayar CHECK (bayar_penjualan >= 0)
) ENGINE=InnoDB;

CREATE TABLE detail_penjualan (
  id_penjualan                  INT           NOT NULL,
  id_barang                     INT           NOT NULL,
  qty_detail_penjualan          SMALLINT      NOT NULL,
  harga_satuan_detail_penjualan DECIMAL(12,2) NOT NULL,               -- AB-04: harga saat transaksi
  CONSTRAINT pk_detail_penjualan PRIMARY KEY (id_penjualan, id_barang),
  CONSTRAINT fk_detail_penjualan FOREIGN KEY (id_penjualan)
    REFERENCES penjualan (id_penjualan) ON DELETE CASCADE,            -- nota batal: rincian ikut terhapus
  CONSTRAINT fk_detail_barang FOREIGN KEY (id_barang)
    REFERENCES barang (id_barang),                                    -- barang yang pernah terjual tidak boleh dihapus
  CONSTRAINT ck_detail_qty   CHECK (qty_detail_penjualan > 0),
  CONSTRAINT ck_detail_harga CHECK (harga_satuan_detail_penjualan >= 0)
) ENGINE=InnoDB;

CREATE TABLE pembelian (
  id_pembelian        INT                      NOT NULL AUTO_INCREMENT,
  no_faktur_pembelian VARCHAR(20)              NOT NULL,              -- nomor faktur milik pemasok
  tgl_pembelian       DATE                     NOT NULL,
  id_pemasok          INT                      NOT NULL,
  id_petugas          SMALLINT                 NULL,                  -- AB-10: petugas penerima, NULL selama masih dipesan
  status_pembelian    ENUM('dipesan','diterima') NOT NULL DEFAULT 'dipesan',
  CONSTRAINT pk_pembelian PRIMARY KEY (id_pembelian),
  -- nomor faktur hanya unik per pemasok: dua pemasok boleh memakai nomor yang sama
  CONSTRAINT uq_pembelian_faktur UNIQUE KEY (id_pemasok, no_faktur_pembelian),
  CONSTRAINT fk_pembelian_pemasok FOREIGN KEY (id_pemasok) REFERENCES pemasok (id_pemasok),
  CONSTRAINT fk_pembelian_petugas FOREIGN KEY (id_petugas) REFERENCES petugas (id_petugas)
) ENGINE=InnoDB;

CREATE TABLE detail_pembelian (
  id_pembelian                INT           NOT NULL,
  id_barang                   INT           NOT NULL,
  qty_detail_pembelian        INT           NOT NULL,
  harga_beli_detail_pembelian DECIMAL(12,2) NOT NULL,                 -- harga modal per unit
  CONSTRAINT pk_detail_pembelian PRIMARY KEY (id_pembelian, id_barang),
  CONSTRAINT fk_detail_pembelian FOREIGN KEY (id_pembelian)
    REFERENCES pembelian (id_pembelian) ON DELETE CASCADE,
  CONSTRAINT fk_detail_pembelian_barang FOREIGN KEY (id_barang)
    REFERENCES barang (id_barang),
  CONSTRAINT ck_detail_pembelian_qty   CHECK (qty_detail_pembelian > 0),
  CONSTRAINT ck_detail_pembelian_harga CHECK (harga_beli_detail_pembelian >= 0)
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- 4. Pemeriksaan (jalankan manual setelah skrip selesai)
-- ------------------------------------------------------------
-- SHOW TABLES;
-- SHOW CREATE TABLE penjualan;
