-- p01_lingkungan_25430120.sql
-- Password sengaja diganti penanda. JANGAN commit password asli.

-- Basis data dan akun praktik (Kopma)
CREATE DATABASE IF NOT EXISTS kopma_120
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE USER IF NOT EXISTS 'mhs_120'@'localhost' IDENTIFIED BY '<password_kerja>';
GRANT ALL PRIVILEGES ON kopma_120.* TO 'mhs_120'@'localhost';

-- Akun tamu: hanya boleh membaca (Latihan E1)
CREATE USER IF NOT EXISTS 'tamu_120'@'localhost' IDENTIFIED BY '<password_tamu>';
GRANT SELECT ON kopma_120.* TO 'tamu_120'@'localhost';

-- Basis data dan akun proyek Perpustakaan (Milestone 1)
CREATE DATABASE IF NOT EXISTS perpus_120
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE USER IF NOT EXISTS 'dev_120'@'localhost' IDENTIFIED BY '<password_dev>';
GRANT ALL PRIVILEGES ON perpus_120.* TO 'dev_120'@'localhost';

FLUSH PRIVILEGES;