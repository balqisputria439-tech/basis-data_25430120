# Normalisasi Proyek Perpustakaan Cendekia ABPA - Pertemuan 4

- **Nama:** ADILLA BALQIS PUTRI ANTONI
- **NIM:** 25430120
- **Dokumen sumber:** Slip Peminjaman Buku (Pertemuan 2)

## Dokumen sumber dan anomali

Dokumen sumber adalah Slip Peminjaman Buku Perpustakaan Cendekia ABPA dari Pertemuan 2. Kolom pengembalian (tanggal kembali, kondisi, dan denda) diisi petugas pada saat PB-04, sehingga ikut dianggap bagian dari relasi awal.

| Jenis anomali | Contoh pada slip peminjaman | Dampak |
|---|---|---|
| Anomali ubah | Nama dan status anggota tertulis ulang pada setiap baris eksemplar. Bila nama dikoreksi di satu baris saja, baris lain tetap lama. | Satu fakta tersimpan di banyak baris dan bisa tidak konsisten. |
| Anomali sisip | Judul buku baru tidak dapat dicatat sebelum ada eksemplar yang dipinjam, karena judul hanya muncul di baris peminjaman. | Katalog tidak dapat diisi lebih dulu. |
| Anomali hapus | Menghapus satu-satunya peminjaman yang memuat sebuah eksemplar ikut menghapus informasi judul buku dan eksemplarnya. | Menghapus transaksi menghilangkan data katalog. |

## Dependensi fungsional

| FD | Dependensi fungsional | AB / dasar |
|---|---|---|
| FD1 | no_peminjaman -> tanggal_pinjam_peminjaman, lama_pinjam_hari_peminjaman, kode_petugas, no_anggota | AB-01, AB-03, AB-07 (satu peminjaman: satu tanggal, satu lama pinjam, satu petugas, satu anggota) |
| FD2 | tanggal_pinjam_peminjaman, lama_pinjam_hari_peminjaman -> tanggal_jatuh_tempo_peminjaman | AB-07 (jatuh tempo = tanggal pinjam + lama pinjam). Nilai turunan |
| FD3 | kode_petugas -> nama_petugas, peran_petugas | Kode petugas unik (kamus data) |
| FD4 | no_anggota -> no_identitas_anggota, nama_anggota, no_hp_anggota, status_anggota, tanggal_daftar_anggota | AB-10 (nomor anggota dan nomor identitas unik) |
| FD5 | no_identitas_anggota -> no_anggota | AB-10 (nomor identitas juga kunci kandidat) |
| FD6 | kode_eksemplar -> kode_buku, status_eksemplar, lokasi_rak_eksemplar, tanggal_masuk_eksemplar | AB-05 (setiap eksemplar milik satu judul, kode inventaris unik) |
| FD7 | kode_buku -> judul_buku, pengarang_buku, penerbit_buku, tahun_terbit_buku, isbn_buku, kategori_buku | AB-05 (kode buku unik) |
| FD8 | (no_peminjaman, kode_eksemplar) -> tanggal_kembali_detail_peminjaman, kondisi_kembali_detail_peminjaman | AB-12 (tanggal kembali dicatat per eksemplar) |
| FD9 | (no_peminjaman, kode_eksemplar) -> no_denda, tarif_per_hari_denda, status_bayar_denda, tanggal_bayar_denda | AB-08 dan AB-09 (denda per eksemplar yang terlambat, tarif disimpan per denda) |
| FD10 | tanggal_kembali_detail_peminjaman, tanggal_jatuh_tempo_peminjaman -> hari_telat_denda | AB-08. Nilai turunan |
| FD11 | hari_telat_denda, tarif_per_hari_denda -> total_denda | AB-08. Nilai turunan |
| FD12 | no_peminjaman -> jumlah_buku_peminjaman | AB-02 (banyak baris detail). Nilai turunan |

Dependensi yang sengaja tidak ditulis karena salah:

| Dependensi yang salah | Mengapa salah |
|---|---|
| no_anggota -> tanggal_pinjam_peminjaman | Satu anggota dapat meminjam berkali-kali pada tanggal yang berbeda. |
| kode_buku -> kode_eksemplar | AB-05: satu judul dapat memiliki banyak eksemplar. |
| (konstanta Rp3.000) -> tarif_per_hari_denda | AB-09: tarif disimpan per denda karena tarif dapat naik. Tarif lama tidak boleh berubah. |

## Tahapan UNF, 1NF, 2NF, dan 3NF

Tanda * menandakan kunci tamu. Atribut yang tidak tertulis pada slip (misalnya peran_petugas, no_hp_anggota, dan atribut buku lainnya) ditambahkan pada tahap 3NF dari kamus data Pertemuan 2.

| Tahap | Relasi | Kunci | Yang dihilangkan |
|---|---|---|---|
| UNF | PEMINJAMAN_UNF (no_peminjaman, tanggal_pinjam_peminjaman, tanggal_jatuh_tempo_peminjaman, kode_petugas, nama_petugas, no_anggota, nama_anggota, no_identitas_anggota, status_anggota, {kode_eksemplar, kode_buku, judul_buku, tanggal_kembali_detail_peminjaman, kondisi_kembali_detail_peminjaman, hari_telat_denda, tarif_per_hari_denda, status_bayar_denda, total_denda}, jumlah_buku_peminjaman) | no_peminjaman | Belum ada. Satu slip menyimpan grup eksemplar yang berulang. |
| 1NF | PEMINJAMAN_1NF (no_peminjaman, kode_eksemplar, tanggal_pinjam_peminjaman, tanggal_jatuh_tempo_peminjaman, kode_petugas, nama_petugas, no_anggota, nama_anggota, no_identitas_anggota, status_anggota, kode_buku, judul_buku, tanggal_kembali_detail_peminjaman, kondisi_kembali_detail_peminjaman, hari_telat_denda, tarif_per_hari_denda, status_bayar_denda, total_denda, jumlah_buku_peminjaman) | (no_peminjaman, kode_eksemplar) | Grup berulang eksemplar. Satu baris untuk setiap eksemplar pada setiap peminjaman. |
| 2NF | PEMINJAMAN_2NF (no_peminjaman, tanggal_pinjam_peminjaman, tanggal_jatuh_tempo_peminjaman, kode_petugas, nama_petugas, no_anggota, nama_anggota, no_identitas_anggota, status_anggota, jumlah_buku_peminjaman) | no_peminjaman | Ketergantungan sebagian pada kunci komposit (FD1). |
|  | EKSEMPLAR_2NF (kode_eksemplar, kode_buku, judul_buku) | kode_eksemplar | Ketergantungan sebagian pada kunci komposit (FD6). |
|  | DETAIL_2NF (no_peminjaman, kode_eksemplar, tanggal_kembali_detail_peminjaman, kondisi_kembali_detail_peminjaman, hari_telat_denda, tarif_per_hari_denda, status_bayar_denda, total_denda) | (no_peminjaman, kode_eksemplar) | Sisanya bergantung pada seluruh kunci (FD8, FD9). |
| 3NF | PEMINJAMAN (no_peminjaman, tanggal_pinjam_peminjaman, lama_pinjam_hari_peminjaman, kode_petugas*, no_anggota*) | no_peminjaman | Rantai ke nama_petugas dan data anggota (FD3, FD4); tanggal_jatuh_tempo_peminjaman dan jumlah_buku_peminjaman dihapus sebagai nilai turunan (FD2, FD12). |
|  | DETAIL_PEMINJAMAN (no_peminjaman*, kode_eksemplar*, tanggal_kembali_detail_peminjaman, kondisi_kembali_detail_peminjaman) | (no_peminjaman, kode_eksemplar) | hari_telat_denda dan total_denda dihapus sebagai nilai turunan (FD10, FD11); atribut denda dipisah ke DENDA. |
|  | DENDA (no_denda, no_peminjaman*, kode_eksemplar*, tarif_per_hari_denda, status_bayar_denda, tanggal_bayar_denda) | no_denda | Atribut denda bersifat opsional (nol atau satu per detail). |
|  | EKSEMPLAR (kode_eksemplar, kode_buku*, status_eksemplar, lokasi_rak_eksemplar, tanggal_masuk_eksemplar) | kode_eksemplar | judul_buku dipindah ke BUKU (FD7). |
|  | BUKU (kode_buku, judul_buku, pengarang_buku, penerbit_buku, tahun_terbit_buku, isbn_buku, kategori_buku) | kode_buku | Hasil pemisahan dari EKSEMPLAR. |
|  | PETUGAS (kode_petugas, nama_petugas, peran_petugas) | kode_petugas | Hasil pemisahan dari PEMINJAMAN. |
|  | ANGGOTA (no_anggota, no_identitas_anggota, nama_anggota, no_hp_anggota, status_anggota, tanggal_daftar_anggota) | no_anggota | Hasil pemisahan dari PEMINJAMAN. |

## Pemeriksaan BCNF

| Tabel | Penentu (determinan) | Semua penentu kunci kandidat? | Hasil |
|---|---|---|---|
| anggota | id_anggota, no_anggota, no_identitas_anggota | Ya (nama_anggota tidak unik sehingga bukan penentu) | BCNF |
| petugas | id_petugas, kode_petugas | Ya | BCNF |
| buku | id_buku, kode_buku, isbn_buku (unik bila ada) | Ya (judul_buku tidak unik) | BCNF |
| eksemplar | id_eksemplar, kode_eksemplar | Ya | BCNF |
| peminjaman | id_peminjaman, no_peminjaman | Ya | BCNF |
| detail_peminjaman | (id_peminjaman, id_eksemplar) | Ya | BCNF |
| denda | id_denda, no_denda, (id_peminjaman, id_eksemplar) | Ya | BCNF |

Pemisahan denda dari detail_peminjaman bukan tuntutan 3NF, karena atribut denda sama-sama bergantung pada seluruh kunci detail. Pemisahan dipertahankan karena atribut denda opsional (nol atau satu per detail) dan denda punya kunci kandidat sendiri, no_denda. Bila digabung kembali, kebanyakan baris detail berisi NULL pada kolom denda, sehingga pemisahan ini tidak berlebihan.

## Keputusan nilai turunan

| Nilai turunan | Rumus | Keputusan | Alasan |
|---|---|---|---|
| jumlah_buku_peminjaman | banyak baris detail_peminjaman pada satu peminjaman | Dihitung, tidak disimpan | Selalu dapat dihitung dari detail. Batas maksimal 5 (AB-02) diperiksa saat baris detail ditambahkan. |
| tanggal_jatuh_tempo_peminjaman | tanggal_pinjam + lama_pinjam_hari | Dihitung. Masukannya disimpan: atribut baru lama_pinjam_hari_peminjaman | AB-07 dapat berubah di masa depan. Bila jatuh tempo hanya dihitung dari aturan terkini, peminjaman lama ikut bergeser. Yang dibekukan adalah lama pinjam yang berlaku saat peminjaman, bukan hasil hitungnya. |
| hari_telat_denda | selisih hari antara tanggal_kembali dan jatuh tempo, bila positif | Dihitung, tidak disimpan | Kedua masukannya tersimpan dan tidak berubah setelah buku dikembalikan. |
| total_denda | hari_telat x tarif_per_hari_denda | Dihitung, tidak disimpan | Kedua masukannya tersimpan. Tarif dibekukan per denda (AB-09), sehingga hasilnya selalu sama. |
| tarif_per_hari_denda | bukan nilai turunan | Disimpan | AB-09: tarif dapat naik, tetapi denda lama tidak boleh berubah. |

## Perubahan pada ERD

| No | Perubahan pada ERD | Alasan |
|---|---|---|
| 1 | peminjaman: atribut turunan tanggal_jatuh_tempo_peminjaman dihapus, atribut lama_pinjam_hari_peminjaman ditambahkan | FD1 dan FD2. Yang dibekukan adalah masukan yang dapat berubah (AB-07) |
| 2 | denda: hari_telat_denda dan total_denda dihapus | FD10 dan FD11. Keduanya turunan dari atribut yang sudah tersimpan |
| 3 | Seluruh relasi dan kardinalitas tidak berubah | Normalisasi tidak menemukan entitas atau relasi yang salah |

ERD yang diperbarui disimpan sebagai p04_erd_25430120.drawio dan p04_erd_25430120.png. Kamus data Pertemuan 2 perlu menyesuaikan tiga perubahan di atas.

## Skema relasional akhir

| Tabel | Kunci primer | Kunci unik | Kunci tamu |
|---|---|---|---|
| anggota | id_anggota | no_anggota, no_identitas_anggota | - |
| petugas | id_petugas | kode_petugas | - |
| buku | id_buku | kode_buku, isbn_buku (bila ada) | - |
| eksemplar | id_eksemplar | kode_eksemplar | id_buku |
| peminjaman | id_peminjaman | no_peminjaman | id_anggota, id_petugas |
| detail_peminjaman | (id_peminjaman, id_eksemplar) | - | id_peminjaman, id_eksemplar |
| denda | id_denda | no_denda, (id_peminjaman, id_eksemplar) | (id_peminjaman, id_eksemplar) ke detail_peminjaman |

## Catatan untuk Pertemuan 5

Skema ini menjadi dasar skrip DDL. Setiap kunci dan aturan bisnis harus muncul sebagai constraint.

| Jenis | Constraint yang akan dibuat pada Pertemuan 5 |
|---|---|
| UNIQUE | no_anggota, no_identitas_anggota, kode_petugas, kode_buku, isbn_buku, kode_eksemplar, no_peminjaman, no_denda, dan (id_peminjaman, id_eksemplar) pada denda |
| FOREIGN KEY | Seluruh kunci tamu pada tabel skema relasional di atas |
| CHECK / ENUM | tarif_per_hari_denda >= 0, lama_pinjam_hari_peminjaman > 0, status_anggota, status_eksemplar, kondisi_kembali, dan status_bayar_denda bernilai tetap |
| Trigger atau transaksi (Modul 14) | AB-02 (maksimal 5 eksemplar), AB-04 (eksemplar harus tersedia), AB-11 (anggota tanpa denda belum lunas), dan AB-12 (tanggal kembali tidak lebih awal dari tanggal pinjam), karena melibatkan lebih dari satu tabel |

