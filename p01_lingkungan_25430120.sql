-- p01_lingkungan_25430120.sql
-- Pertemuan 1 - Lingkungan kerja MariaDB. Pemilik: Adilla Balqis Putri Antoni (25430120)
-- Password sengaja diganti penanda. JANGAN commit password asli.
-- Dijalankan sebagai root:  mysql -u root -p < p01_lingkungan_25430120.sql
-- Skrip ini dapat dijalankan berulang kali (latihan E.2).

-- =====================================================================
-- BAGIAN A. Langkah D (kasus contoh Kopma)
-- =====================================================================
CREATE DATABASE IF NOT EXISTS kopma_120
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE USER IF NOT EXISTS 'mhs_120'@'localhost' IDENTIFIED BY '<password_mhs>';
GRANT ALL PRIVILEGES ON kopma_120.* TO 'mhs_120'@'localhost';

-- Pengamanan root (D.3) dijalankan interaktif, TIDAK disimpan di sini karena memuat password:
--   ALTER USER 'root'@'localhost' IDENTIFIED BY '<password_root>';
--   ALTER USER 'root'@'127.0.0.1' IDENTIFIED BY '<password_root>';
--   ALTER USER 'root'@'::1'       IDENTIFIED BY '<password_root>';

-- =====================================================================
-- BAGIAN B. Latihan E.1 - akun tamu hanya-baca
-- =====================================================================
CREATE USER IF NOT EXISTS 'tamu_120'@'localhost' IDENTIFIED BY '<password_tamu>';
GRANT SELECT ON kopma_120.* TO 'tamu_120'@'localhost';
-- Uji (jalankan sebagai tamu_120, di luar skrip ini):
--   USE kopma_120;
--   CREATE TABLE uji (id INT);     -- ERROR 1142 (42000): perintah CREATE ditolak karena tamu_120 hanya punya hak SELECT (baca saja)

-- =====================================================================
-- BAGIAN C. Milestone Proyek 1 (basis data & akun proyek)
-- =====================================================================
CREATE DATABASE IF NOT EXISTS perpus_120
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE USER IF NOT EXISTS 'dev_120'@'localhost' IDENTIFIED BY '<password_dev>';
GRANT ALL PRIVILEGES ON perpus_120.* TO 'dev_120'@'localhost';

-- Bukti yang diminta (jalankan di luar skrip, ambil screenshot):
--   mysql -u mhs_120 -p   ->  SELECT VERSION(), CURRENT_USER();  SELECT @@sql_mode;  SHOW DATABASES;
--   mysql -u dev_120 -p   ->  SHOW DATABASES;   USE kopma_120;   (harus ditolak: ERROR 1044)

SHOW GRANTS FOR 'mhs_120'@'localhost';
SHOW GRANTS FOR 'dev_120'@'localhost';
