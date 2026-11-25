# Dokumen Kebutuhan Data - Perpustakaan Cendekia ABPA

Penyusun: Adilla Balqis Putri Antoni (25430120) · Tema: Perpustakaan


## Ketentuan minimum (dari modul) - centang saat terpenuhi

- [x] ≥ 4 proses bisnis · [x] ≥ 6 entitas kandidat · [x] ≥ 8 aturan bisnis · [x] ≥ 5 kebutuhan informasi
- [x] Matriks CRUD lengkap (tidak ada entitas tanpa huruf C, kecuali dijelaskan)
- [x] Kamus data ≥ 20 elemen, ada kolom penanggung jawab
- [x] Kebutuhan non-fungsional, termasuk data pribadi dan siapa boleh mengakses
- [x] ≥ 1 dokumen sumber fiktif rancanganmu sendiri + pembedahannya
- [x] Perhitungan P ada di bagian 9

## 1. Latar belakang dan aktivitas organisasi
**Perpustakaan Cendekia ABPA** adalah perpustakaan yang melayani anggota terdaftar-terdiri dari pelajar, mahasiswa, dan warga sekitar-untuk meminjam buku koleksi fisik, membaca di tempat, serta melakukan reservasi judul buku baru . Operasional harian perpustakaan dijalankan oleh beberapa pelaku utama dengan tugas masing-masing:
* **Kepala Perpustakaan:** Mengatur pengadaan koleksi buku baru, menyetujui penghapusan koleksi buku yang rusak/hilang, serta mengevaluasi laporan sirkulasi dang keanggotaan.
* **Pustakawan Meja Layanan:** Mencatat pendaftaran anggota baru, melayani transaksi peminjaman dan pengembalian eksemplar buku, mengelola reservasi judul buku, serta menghitung dan mencatat pembayaran denda keterlambatan.
* **Anggota Terdaftar:** Mengajukan pendaftaran keanggotaan, mencari ketersediaan buku, melakukan reservasi judul buku, serta meminjam dan mengembalikan eksemplar buku.

Selama ini, seluruh pencatatan peminjaman dan inventaris masih dilakukan menggunakan buku *ledger* kertas sehingga memunculkan berbagai kendala operasional dalam aktivitas sehari-hari:
> *"Setiap kali anggota ingin meminjam atau mereservasi judul tertentu, saya harus mengecek rak dan membuka lembar buku ledger satu per satu untuk memastikan apakah eksemplar buku masih tersedia atau sedang dipinjam."* _ **Rina (Pustakawan Meja Layanan)**

> *"Saat antrean pengambilan sedang ramai, perhitungan denda keterlambatan sering keliru dan memakan waktu lama karena selisih hari harus dihitung manual dari catatan kertas."* _ **Bima (Pustakawan Meja Layanan)**

> *"Saya sulit mengambil keputusan pengadaan atau penghapusan koleksi secara tepat waktu karena data stok eksemplar yang hilang, rusak, dan paling sering dipinjam tidak pernah sinkron dengan buku ledger layanan."* _ **Drs. Hendra (Kepala Perpustakaan)**


## 2. Aktor dan proses bisnis

| Kode | Proses bisnis | Aktor | Pemicu |
|---|---|---|---|
| PB-01 | Mendaftarkan anggota baru dan memperbarui status keanggotaan | Pustakawan Meja Layanan | Calon anggota menyerahkan formulir pendaftaran atau mengajukan pembaruan data |
| PB-02 | Mengelola katalog judul buku dan data eksemplar koleksi | Kepala Perpustakaan | Penerimaan buku baru dari pengadaan/donasi atau laporan eksemplar rusak/hilang |
| PB-03 | Mencatat reservasi judul buku oleh anggota | Pustakawan Meja Layanan | Anggota mengajukan permintaan reservasi judul buku yang stok eksemplarnya sedang habis |
| PB-04 | Mencatat transaksi peminjaman eksemplar buku | Pustakawan Meja Layanan | Anggota aktif membawa eksemplar buku yang tersedia ke meja layanan untuk dipinjam |
| PB-05 | Mencatat pengembalian buku dan menghitung denda keterlambatan | Pustakawan Meja Layanan | Anggota mengembalikan eksemplar buku pinjaman di meja layanan |
| PB-06 | Menyusun laporan sirkulasi bulanan dan evaluasi penghapusan koleksi | Kepala Perpustakaan | Akhir periode bulanan atau jadwal evaluasi inventaris perpustakaan |

## 3. Dokumen sumber yang dianalisis

### Dokumen 1: Slip Transaksi Peminjaman & Pengembalian Buku

```text
========================================================================
                  PERPUSTAKAAN CENDEKIA ABPA
        Jl. Pendidikan No. 12 · Layanan Sirkulasi Koleksi
------------------------------------------------------------------------
No. Transaksi : TRX-202611-0042       Tanggal Pinjam  : 18-11-2026
ID Anggota    : AGT-0120              Batas Kembali   : 25-11-2026
Nama Anggota  : Adilla Balqis Putri Antoni   Tanggal Kembali : 27-11-2026
Kategori      : Mahasiswa             Petugas         : Rina (PTG-02)
------------------------------------------------------------------------
No | Kode Eksemplar | Judul Buku                   | Kondisi Kembali
------------------------------------------------------------------------
 1 | EKS-0014-01    | Basis Data Relasional        | Baik
 2 | EKS-0089-02    | Algoritma & Pemrograman      | Baik
------------------------------------------------------------------------
Jumlah Buku Dipinjam : 2 eksemplar
Keterlambatan        : 2 hari
Tarif Denda / Hari   : Rp 3.000
Total Denda          : Rp 12.000 (2 buku x 2 hari x Rp 3.000)
Status Pembayaran    : Lunas (No. Denda: DND-202611-0019)
========================================================================
```

### Pembedahan Elemen Dokumen (Disimpan vs. Dihitung)

| Elemen pada Dokumen | Status Data | Keterangan & Entitas Tujuan |
|---|---|---|
| `No. Transaksi`, `Tanggal Pinjam`, `Batas Kembali`, `Tanggal Kembali` | **Disimpan** | Atribut utama transaksi pada entitas `PEMINJAMAN` |
| `ID Anggota`, `Nama Anggota`, `Kategori` | **Disimpan** | Data master pada entitas `ANGGOTA` (`ID Anggota` sebagai kunci tamu di `PEMINJAMAN`) |
| `Petugas` (`ID Petugas`, `Nama Petugas`) | **Disimpan** | Data master pada entitas `PETUGAS` (`ID Petugas` sebagai kunci tamu di `PEMINJAMAN`) |
| `Kode Eksemplar`, `Kondisi Kembali` | **Disimpan** | `Kode Eksemplar` di entitas `EKSEMPLAR_BUKU`; `Kondisi Kembali` di `DETAIL_PEMINJAMAN` |
| `Judul Buku` | **Disimpan** | Data bibliografi pada entitas `BUKU` (terhubung lewat `EKSEMPLAR_BUKU`) |
| `Tarif Denda / Hari`, `No. Denda`, `Status Pembayaran` | **Disimpan** | Dicatat pada entitas `DENDA` apabila terjadi keterlambatan atau kerusakan |
| `Jumlah Buku Dipinjam` | **Dihitung (Turunan)** | Dihitung otomatis dengan fungsi `COUNT` baris item pada `DETAIL_PEMINJAMAN` |
| `Keterlambatan (hari)` | **Dihitung (Turunan)** | Selisih `Tanggal Kembali - Batas Kembali` (jika hasil > 0) |
| `Total Denda` | **Dihitung (Turunan)** | Hasil perkalian `Jumlah Buku Dipinjam × Keterlambatan × Tarif Denda` |

## 4. Entitas kandidat dan elemen data

| Entitas kandidat | Elemen data utama | Sumber |
|---|---|---|
| ANGGOTA | id_anggota (PK), nama_lengkap, kategori_anggota, no_identitas, no_telepon, alamat, tanggal_daftar, status_aktif | Formulir Pendaftaran Anggota & Slip Transaksi |
| PETUGAS | id_petugas (PK), nama_petugas, jabatan, username, status_aktif | Slip Transaksi & Struktur Organisasi Perpustakaan |
| BUKU | id_buku (PK), isbn, judul_buku, penulis, penerbit, tahun_terbit, kategori_koleksi | Katalog Koleksi & Slip Transaksi |
| EKSEMPLAR_BUKU | kode_eksemplar (PK), id_buku (FK), nomor_salinan, lokasi_rak, kondisi_fisik, status_ketersediaan | Slip Transaksi & Buku Inventaris Rak |
| PEMINJAMAN | no_transaksi (PK), id_anggota (FK), id_petugas (FK), tanggal_pinjam, batas_kembali, tanggal_kembali, status_transaksi | Slip Transaksi Peminjaman & Pengembalian |
| DETAIL_PEMINJAMAN | id_detail (PK), no_transaksi (FK), kode_eksemplar (FK), kondisi_pinjam, kondisi_kembali | Rincian Baris Buku pada Slip Transaksi |
| RESERVASI | id_reservasi (PK), id_anggota (FK), id_buku (FK), tanggal_reservasi, batas_ambil, status_reservasi | Layanan Reservasi Judul Buku (README.md) |
| DENDA | no_denda (PK), no_transaksi (FK), jenis_denda, tarif_harian, nominal_bayar, tanggal_bayar, status_pembayaran | Slip Transaksi & Aturan Sirkulasi |


## 5. Aturan bisnis

| Kode | Aturan bisnis |
|---|---|
| AB-01 | Transaksi peminjaman atau reservasi *ditolak bila* status keanggotaan anggota bukan Aktif atau anggota masih memiliki tagihan DENDA berstatus Belum Lunas. |
| AB-02 | Satu transaksi peminjaman memiliki batas maksimal item sebanyak *P + 2 = 3 + 2 = 5 eksemplar buku; penambahan item ke-6 dalam satu no_transaksi **ditolak*. |
| AB-03 | Setiap judul buku (BUKU) dapat memiliki satu atau lebih salinan fisik (EKSEMPLAR_BUKU) dengan kode_eksemplar unik; penyimpanan kode eksemplar duplikat *ditolak*. |
| AB-04 | Peminjaman terhadap suatu kode_eksemplar *ditolak bila* atribut status_ketersediaan eksemplar tersebut bukan Tersedia (misalnya sedang Dipinjam, Rusak Berat, atau Hilang). |
| AB-05 | Lama waktu peminjaman standar adalah 7 hari kalender; pencatatan batas_kembali lebih awal dari tanggal_pinjam *ditolak*. |
| AB-06 | Keterlambatan pengembalian melewati batas_kembali dikenakan denda harian sebesar *Rp 3.000* per eksemplar per hari; transaksi pengembalian terlambat *ditolak bila* nominal tagihan DENDA belum tercatat. |
| AB-07 | Permintaan RESERVASI pada suatu id_buku *ditolak bila* masih terdapat minimal satu salinan pada EKSEMPLAR_BUKU untuk judul tersebut yang berstatus Tersedia. |
| AB-08 | Penghapusan eksemplar koleksi dari peredaran *ditolak bila* tidak disetujui Kepala Perpustakaan atau eksemplar tersebut masih tercatat dalam transaksi PEMINJAMAN yang berstatus Berjalan. |


## 6. Kebutuhan informasi

| Kode | Kebutuhan informasi | Data yang diperlukan |
|---|---|---|
| KI-01 | Judul buku apa saja yang paling sering dipinjam dalam satu bulan terakhir (peringkat 5 teratas)? | BUKU.id_buku, BUKU.judul_buku, EKSEMPLAR_BUKU.kode_eksemplar, DETAIL_PEMINJAMAN.no_transaksi, PEMINJAMAN.tanggal_pinjam |
| KI-02 | Siapa saja anggota yang saat ini memiliki pinjaman melewati batas_kembali beserta jumlah hari keterlambatannya? | ANGGOTA.id_anggota, ANGGOTA.nama_lengkap, ANGGOTA.no_telepon, PEMINJAMAN.no_transaksi, PEMINJAMAN.batas_kembali, PEMINJAMAN.status_transaksi |
| KI-03 | Berapa total pendapatan denda keterlambatan dan kerusakan yang sudah lunas per bulan? | DENDA.no_denda, DENDA.nominal_bayar, DENDA.tanggal_bayar, DENDA.status_pembayaran |
| KI-04 | Judul buku mana saja yang memiliki antrean reservasi terbanyak tetapi seluruh eksemplarnya sedang dipinjam atau rusak? | BUKU.id_buku, BUKU.judul_buku, RESERVASI.id_reservasi, RESERVASI.status_reservasi, EKSEMPLAR_BUKU.status_ketersediaan |
| KI-05 | Berapa jumlah eksemplar buku yang berstatus Tersedia, Dipinjam, Rusak Berat, dan Hilang untuk setiap kategori koleksi? | BUKU.kategori_koleksi, EKSEMPLAR_BUKU.kode_eksemplar, EKSEMPLAR_BUKU.status_ketersediaan |


## 7. Matriks CRUD
| Proses | ANGGOTA | PETUGAS | BUKU | EKSEMPLAR_BUKU | PEMINJAMAN | DETAIL_PEMINJAMAN | RESERVASI | DENDA |
|---|---|---|---|---|---|---|---|---|
| *PB-01* (Daftar & kelola anggota) | *C, R, U* | R | - | - | R | - | - | R |
| *PB-02* (Kelola katalog & eksemplar) | - | *C, R, U* | *C, R, U* | *C, R, U, D* | - | - | R | - |
| *PB-03* (Catat reservasi judul buku) | R | R | R | R | - | - | *C, R, U* | - |
| *PB-04* (Catat peminjaman buku) | R | R | R | R, U | *C, R* | *C, R* | R, U | R |
| *PB-05* (Catat pengembalian & denda) | R, U | R | R | R, U | R, U | R, U | R | *C, R, U* |
| *PB-06* (Laporan & evaluasi koleksi) | R | R | R | R, U | R | R | R | R |

Keterangan: Semua 8 entitas memiliki minimal satu operasi **C (Create)* sehingga tidak terdapat entitas yatim.*

## 8. Kamus data awal (≥ 20 elemen)

| Elemen | Arti | Contoh | Aturan | Penanggung jawab |
|---|---|---|---|---|
| id_anggota_anggota | Kode unik identitas anggota perpustakaan | AGT-0120 | Primary Key, wajib diisi, format AGT-XXXX | Pustakawan Meja Layanan |
| nama_lengkap_anggota | Nama lengkap anggota sesuai kartu identitas | Adilla Balqis Putri Antoni | Wajib diisi, teks maksimal 100 karakter *[Data Pribadi]* | Pustakawan Meja Layanan |
| kategori_anggota_anggota | Kelompok status keanggotaan | Mahasiswa | Wajib diisi, nilai: Pelajar, Mahasiswa, Warga Umum | Pustakawan Meja Layanan |
| no_identitas_anggota | Nomor induk (NIK/NIM/NIS) anggota terdaftar | 25430120 | Wajib diisi, unik, maksimal 20 karakter *[Data Pribadi]* | Pustakawan Meja Layanan |
| no_telepon_anggota | Nomor ponsel aktif anggota untuk notifikasi | 081278901234 | Wajib diisi, angka 10–15 digit *[Data Pribadi]* | Pustakawan Meja Layanan |
| alamat_anggota | Alamat domisili tempat tinggal anggota | Jl. Melati No. 5, Sukadana | Wajib diisi, teks maksimal 200 karakter *[Data Pribadi]* | Pustakawan Meja Layanan |
| status_aktif_anggota | Status keaktifan hak pinjam anggota | Aktif | Wajib diisi, nilai: Aktif, Nonaktif, Ditangguhkan | Pustakawan Meja Layanan |
| id_petugas_petugas | Kode unik petugas perpustakaan | PTG-02 | Primary Key, wajib diisi, format PTG-XX | Kepala Perpustakaan |
| nama_petugas_petugas | Nama lengkap petugas perpustakaan | Rina Oktaviani | Wajib diisi, teks maksimal 100 karakter *[Data Pribadi]* | Kepala Perpustakaan |
| jabatan_petugas | Peran atau jabatan petugas di perpustakaan | Pustakawan Layanan | Wajib diisi, nilai: Kepala Perpustakaan, Pustakawan Layanan | Kepala Perpustakaan |
| id_buku_buku | Kode unik katalog judul buku | BK-0014 | Primary Key, wajib diisi, format BK-XXXX | Kepala Perpustakaan |
| isbn_buku | Nomor standar internasional buku | 978-602-1234-56-7 | Unik (bila ada), format ISBN 10 atau 13 digit | Kepala Perpustakaan |
| judul_buku_buku | Judul utama buku sesuai sampul katalog | Basis Data Relasional | Wajib diisi, teks maksimal 150 karakter | Kepala Perpustakaan |
| penulis_buku | Nama pengarang atau penulis buku | Abdul Kadir | Wajib diisi, teks maksimal 100 karakter | Kepala Perpustakaan |
| kategori_koleksi_buku | Klasifikasi subjek koleksi buku | Ilmu Komputer | Wajib diisi, teks maksimal 50 karakter | Kepala Perpustakaan |
| kode_eksemplar_eksemplar_buku | Kode barcode unik tiap salinan fisik buku | EKS-0014-01 | Primary Key, wajib diisi, unik per salinan fisik | Kepala Perpustakaan |
| status_ketersediaan_eksemplar_buku | Status sirkulasi salinan fisik buku saat ini | Tersedia | Wajib diisi, nilai: Tersedia, Dipinjam, Rusak Berat, Hilang | Pustakawan Meja Layanan |
| no_transaksi_peminjaman | Nomor bukti transaksi peminjaman buku | TRX-202611-0042 | Primary Key, wajib diisi, format TRX-YYYYMM-XXXX | Pustakawan Meja Layanan |
| tanggal_pinjam_peminjaman | Tanggal buku mulai dipinjam anggota | 2026-11-18 | Wajib diisi, format tanggal YYYY-MM-DD | Pustakawan Meja Layanan |
| batas_kembali_peminjaman | Tanggal jatuh tempo pengembalian buku | 2026-11-25 | Wajib diisi, otomatis tanggal_pinjam + 7 hari | Pustakawan Meja Layanan |
| tanggal_kembali_peminjaman | Tanggal aktual buku dikembalikan anggota | 2026-11-27 | Boleh kosong saat berjalan, >= tanggal_pinjam | Pustakawan Meja Layanan |
| id_detail_detail_peminjaman | Nomor urut item buku dalam satu transaksi | 1 | Primary Key, wajib diisi, maksimal 5 item per transaksi | Pustakawan Meja Layanan |
| id_reservasi_reservasi | Nomor bukti antrean pemesanan judul buku | RSV-202611-0007 | Primary Key, wajib diisi, format RSV-YYYYMM-XXXX | Pustakawan Meja Layanan |
| no_denda_denda | Nomor bukti tagihan/pembayaran denda | DND-202611-0019 | Primary Key, wajib diisi, tarif Rp 3.000/hari/buku | Pustakawan Meja Layanan |
| status_pembayaran_denda | Status pelunasan denda oleh anggota | Lunas | Wajib diisi, nilai: Belum Lunas, Lunas | Pustakawan Meja Layanan |

## 9. Kebutuhan non-fungsional data

1. *Keamanan & Privasi Data Pribadi:* Elemen data pribadi anggota dan petugas (nama_lengkap_anggota, no_identitas_anggota, no_telepon_anggota, alamat_anggota, dan nama_petugas_petugas) wajib dilindungi dan hanya dapat diakses oleh akun dev_120 (Pustakawan Meja Layanan dan Kepala Perpustakaan). Anggota biasa tidak diperbolehkan melihat data pribadi anggota lain.
2. *Hak Akses & Pemisahan Peran:* Pustakawan Meja Layanan hanya memiliki hak tambah/ubah pada transaksi sirkulasi (PEMINJAMAN, DETAIL_PEMINJAMAN, RESERVASI, DENDA) dan pendaftaran ANGGOTA, sedangkan penghapusan koleksi (EKSEMPLAR_BUKU) dan perubahan data PETUGAS hanya boleh dilakukan oleh Kepala Perpustakaan.
3. *Kinerja & Kapasitas Pencarian:* Pencarian ketersediaan judul buku dan kode eksemplar harus merespons dalam waktu kurang dari 2 detik dengan kapasitas penyimpanan minimum 5.000 judul buku dan 55 transaksi harian.
4. *Integritas & Pencadangan Data:* Setiap perubahan status ketersediaan eksemplar saat peminjaman dan pengembalian harus bersifat atomik (tidak boleh selisih antara transaksi dan status rak), serta basis data perpus_120 wajib dicadangkan (backup) secara berkala setiap hari setelah jam tutup layanan.

*Perhitungan parameter P (wajib tampil):*

- 2 digit terakhir NIM = *20* -> P = (20 mod 9) + 1 = *3*
- Batas maksimal item per transaksi = P + 2 = *5*
- Diskon/denda harian = P ribu rupiah = *3* (Rp 3.000 per eksemplar per hari)
- Perkiraan volume transaksi harian = 40 + 5 x P = *55*
-

## 9. Kebutuhan non-fungsional data

**Perhitungan parameter P (wajib tampil):**

1. *Keamanan, Daftar Data Pribadi & Hak Akses:* Elemen data pribadi dalam basis data perpus_120 meliputi *nama_lengkap_anggota, *no_identitas_anggota*, *no_telepon_anggota*, *alamat_anggota*, serta *nama_petugas_petugas*. Seluruh data pribadi tersebut hanya boleh dilihat dan dikelola oleh akun *dev_120** (Pustakawan Meja Layanan dan Kepala Perpustakaan), sedangkan anggota biasa tidak diperbolehkan mengakses data pribadi milik anggota maupun petugas lain.
2. *Pemisahan Peran Operasional:* Pustakawan Meja Layanan memiliki hak tambah/ubah pada transaksi sirkulasi (PEMINJAMAN, DETAIL_PEMINJAMAN, RESERVASI, DENDA) dan pendaftaran ANGGOTA, sedangkan penghapusan koleksi (EKSEMPLAR_BUKU) dan pengelolaan data PETUGAS hanya boleh dilakukan oleh Kepala Perpustakaan.
3. *Retensi & Pencadangan Data:* Data transaksi peminjaman dan pembayaran denda wajib disimpan minimal selama *5 tahun* untuk keperluan audit dan laporan inventaris tahunan perpustakaan, sedangkan data anggota berstatus Nonaktif lebih dari 3 tahun tanpa tunggakan denda dapat diarsipkan. Basis data perpus_120 dicadangkan (backup) secara berkala setiap hari setelah jam tutup layanan.
4. *Kinerja & Kapasitas Pencarian:* Pencarian ketersediaan judul buku dan kode eksemplar harus merespons dalam waktu kurang dari 2 detik dengan kapasitas minimum 5.000 judul buku dan 55 transaksi harian.

*Perhitungan parameter P (wajib tampil):*

- 2 digit terakhir NIM = *20* -> P = (20 mod 9) + 1 = *3*
- Batas maksimal item per transaksi = P + 2 = *5*
- Diskon/denda harian = P ribu rupiah = *3* (Rp 3.000 per eksemplar per hari)
- Perkiraan volume transaksi harian = 40 + 5 x P = *55*


## 10. Isu kualitas data yang diantisipasi
| No | Isu Kualitas Data | Dampak Jika Tidak Diantisipasi | Rencana Pencegahan / Kontrol |
|---|---|---|---|
| 1 | *Duplikasi data anggota* (satu orang mendaftar dua kali untuk menghindari batas pinjam atau tunggakan denda) | Satu anggota bisa meminjam lebih dari 5 buku atau menghindari blokir denda | Menerapkan batasan UNIQUE pada atribut no_identitas_anggota (NIK/NIM/NIS) dan validasi pencarian sebelum pembuatan ID anggota baru |
| 2 | *Ketidaksinkronan status ketersediaan eksemplar* (status_ketersediaan masih Tersedia padahal sedang dipinjam, atau sebaliknya) | Pustakawan salah menginformasikan stok buku di rak dan berisiko terjadi peminjaman ganda atas satu eksemplar fisik | Memperbarui status_ketersediaan_eksemplar_buku secara otomatis dalam satu transaksi atomik saat pencatatan peminjaman dan pengembalian |
| 3 | *Inkonsistensi format penulisan atribut* (seperti penulisan nomor telepon, format tanggal, atau nilai status Aktif/aktif/Ya) | Gagal melakukan pencarian, pengurutan tanggal, atau penyaringan status keanggotaan dan ketersediaan buku | Menerapkan tipe data DATE untuk tanggal, format baku pada kode transaksi, serta pembatasan nilai (ENUM/CHECK) untuk kolom status |
| 4 | *Data yatim (*orphan records)** pada detail peminjaman atau denda akibat penghapusan data induk anggota/buku secara langsung | Laporan sirkulasi dan riwayat denda menjadi rusak karena merujuk pada ID anggota atau kode eksemplar yang hilang | Menerapkan aturan integritas referensial (FOREIGN KEY dengan ON DELETE RESTRICT) sehingga data master yang memiliki riwayat transaksi tidak bisa dihapus sembarangan |
