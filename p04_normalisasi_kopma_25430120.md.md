# LAPORAN PRAKTIKUM BASIS DATA

**Pertemuan 04: Normalisasi dan Skema Relasional**

Tema proyek: Perpustakaan (Perpustakaan Cendekia ABPA)

- **Nama:** ADILLA BALQIS PUTRI ANTONI
- **NIM:** 25430120
- **Kelas:** B
- **Pertemuan ke-:** 4
- **Tanggal pelaksanaan:** [isi tanggal pelaksanaan]
- **Dosen/Asisten:** [isi nama dosen atau asisten]

## 1. Tujuan Praktikum

Pada pertemuan ini saya belajar menguji ERD dengan normalisasi. Saya mengenali anomali ubah, sisip, dan hapus, menurunkan dependensi fungsional dari aturan bisnis, lalu menormalisasi relasi sampai 3NF dan memeriksa BCNF. Saya juga memutuskan apakah nilai turunan disimpan atau dihitung, kemudian mendokumentasikan skema relasional akhirnya.

## 2. Ringkasan Dasar Teori

Data yang disimpan berulang dalam satu tabel besar menimbulkan tiga anomali: anomali ubah (satu fakta tertulis di banyak baris), anomali sisip (fakta tidak bisa dicatat sebelum ada fakta lain), dan anomali hapus (menghapus satu fakta menghilangkan fakta lain). Normalisasi menghilangkan anomali itu secara bertahap.

Atribut B bergantung secara fungsional pada A (A -> B) bila setiap nilai A menentukan tepat satu nilai B. Dependensi diturunkan dari aturan bisnis, bukan ditebak dari contoh data. 1NF menuntut nilai atomik tanpa grup berulang, 2NF menghilangkan ketergantungan pada sebagian kunci komposit, dan 3NF menghilangkan rantai A -> B -> C antaratribut bukan kunci. BCNF menuntut setiap penentu adalah kunci kandidat. Nilai turunan sebaiknya dihitung bila semua masukannya tersimpan dan tidak berubah.

## 3. Hasil Langkah Percobaan

### 3.1 D.1 Dari UNF ke 1NF (Kopma)

Spreadsheet lama Kopma menunjukkan ketiga anomali berikut.

| Jenis anomali | Contoh pada spreadsheet lama Kopma | Dampak |
|---|---|---|
| Anomali ubah | Anggota yang sama tertulis "Budi S." pada nota PJ-0142 dan "Budi Santoso" pada nota PJ-0150. Pemasok yang sama tertulis "CV Sumber ATK" dan "CV. Sumber A.T.K". | Satu fakta tertulis di banyak baris dan bisa tidak konsisten, sehingga laporan per anggota atau per pemasok terpecah. |
| Anomali sisip | Barang baru tidak dapat dicatat sebelum ada penjualannya, karena barang hanya muncul sebagai isi baris nota. | Barang yang sudah dibeli dari pemasok tetapi belum terjual tidak punya tempat di spreadsheet. |
| Anomali hapus | Menghapus nota PJ-0143 ikut menghapus informasi pemasok UD Segar, karena nota itu satu-satunya baris yang memuatnya. | Menghapus satu fakta (nota) membuat fakta lain (pemasok) hilang. |

Relasi nota ditulis dalam bentuk UNF, lalu grup berulang barang dihilangkan sehingga kunci primer menjadi komposit (no_nota_penjualan, kode_barang). Hasil lengkap UNF sampai 3NF ada pada tabel tahapan di bagian 3.3.

### 3.2 D.2 Dependensi fungsional Kopma

Dependensi diturunkan dari aturan bisnis Pertemuan 2. Nama kolom mengikuti kamus data saya (misalnya tanggal_penjualan), sedangkan buku memakai tgl_penjualan.

| FD | Dependensi fungsional | Dasar |
|---|---|---|
| FD1 | no_nota_penjualan -> tanggal_penjualan, kode_petugas, no_anggota | AB-01 (nota bernomor unik) dan AB-02 (paling banyak satu anggota per nota) |
| FD2 | kode_petugas -> nama_petugas, peran_petugas | Kode petugas unik (kamus data) |
| FD3 | no_anggota -> nim_anggota, nama_anggota, prodi_anggota, no_hp_anggota, status_anggota | AB-05 (NIM unik) dan nomor anggota unik |
| FD4 | kode_barang -> nama_barang, kategori_barang, harga_jual_barang, stok_barang, batas_minimum_barang | Kode barang unik (kamus data) |
| FD5 | (no_nota_penjualan, kode_barang) -> qty_detail_penjualan, harga_satuan_detail_penjualan | AB-04 (harga pada nota disimpan per baris) |
| FD6 | qty_detail_penjualan, harga_satuan_detail_penjualan -> subtotal_detail_penjualan | Nilai turunan (qty x harga) |
| FD7 | no_faktur_pembelian -> tanggal_pembelian, status_pembelian, kode_pemasok, kode_petugas | AB-06 dan AB-10 |
| FD8 | kode_pemasok -> nama_pemasok, telepon_pemasok, alamat_pemasok | Kode pemasok unik (kamus data) |
| FD9 | (no_faktur_pembelian, kode_barang) -> qty_detail_pembelian, harga_beli_detail_pembelian | Faktur pemasok mencatat harga beli per baris |

| Dependensi yang salah | Mengapa salah |
|---|---|
| kode_barang -> harga_satuan_detail_penjualan | AB-04: harga pada nota dapat berbeda dari harga barang saat ini. Meskipun contoh data pulpen selalu Rp4.000, contoh data hanya dapat membantah dependensi, tidak dapat membuktikannya. |
| nama_anggota -> no_anggota | Dua anggota berbeda dapat memiliki nama yang sama, sehingga nama tidak menentukan nomor anggota. |

### 3.3 D.3 Menuju 2NF dan 3NF

Langkah 2NF memisahkan FD1 dan FD4 yang hanya bergantung pada sebagian kunci. Langkah 3NF memisahkan rantai ke petugas dan anggota, lalu nilai turunan tidak disimpan. Pola yang sama dipakai pada pembelian, detail_pembelian, dan pemasok. Tanda * menandakan kunci tamu.

| Tahap | Relasi | Kunci | Yang dihilangkan |
|---|---|---|---|
| UNF | NOTA_UNF (no_nota_penjualan, tanggal_penjualan, kode_petugas, nama_petugas, no_anggota, nama_anggota, {kode_barang, nama_barang, qty_detail_penjualan, harga_satuan_detail_penjualan, subtotal_detail_penjualan}, jumlah_penjualan, diskon_penjualan, total_penjualan) | no_nota_penjualan | Belum ada. Satu nota menyimpan grup barang yang berulang. |
| 1NF | NOTA_1NF (no_nota_penjualan, kode_barang, tanggal_penjualan, kode_petugas, nama_petugas, no_anggota, nama_anggota, nama_barang, qty_detail_penjualan, harga_satuan_detail_penjualan, subtotal_detail_penjualan, jumlah_penjualan, diskon_penjualan, total_penjualan) | (no_nota_penjualan, kode_barang) | Grup berulang barang. Satu baris untuk setiap barang pada setiap nota. |
| 2NF | PENJUALAN_2NF (no_nota_penjualan, tanggal_penjualan, kode_petugas, nama_petugas, no_anggota, nama_anggota, jumlah_penjualan, diskon_penjualan, total_penjualan) | no_nota_penjualan | Ketergantungan sebagian pada kunci komposit (FD1). |
|  | BARANG_2NF (kode_barang, nama_barang) | kode_barang | Ketergantungan sebagian pada kunci komposit (FD4). |
|  | DETAIL_2NF (no_nota_penjualan, kode_barang, qty_detail_penjualan, harga_satuan_detail_penjualan, subtotal_detail_penjualan) | (no_nota_penjualan, kode_barang) | Sisanya bergantung pada seluruh kunci (FD5). |
| 3NF | PENJUALAN (no_nota_penjualan, tanggal_penjualan, kode_petugas*, no_anggota*, bayar_penjualan) | no_nota_penjualan | Rantai no_nota_penjualan -> kode_petugas -> nama_petugas dan no_nota_penjualan -> no_anggota -> nama_anggota (FD2, FD3). |
|  | DETAIL_PENJUALAN (no_nota_penjualan*, kode_barang*, qty_detail_penjualan, harga_satuan_detail_penjualan) | (no_nota_penjualan, kode_barang) | Nilai turunan subtotal tidak disimpan (FD6). |
|  | BARANG (kode_barang, nama_barang, kategori_barang, harga_jual_barang, stok_barang, batas_minimum_barang) | kode_barang | - |
|  | PETUGAS (kode_petugas, nama_petugas, peran_petugas) | kode_petugas | Hasil pemisahan dari PENJUALAN. |
|  | ANGGOTA (no_anggota, nim_anggota, nama_anggota, prodi_anggota, no_hp_anggota, status_anggota, tanggal_daftar_anggota) | no_anggota | Hasil pemisahan dari PENJUALAN. |
|  | PEMBELIAN (no_faktur_pembelian, tanggal_pembelian, status_pembelian, kode_pemasok*, kode_petugas*) | no_faktur_pembelian | Pola yang sama dengan PENJUALAN (FD7, FD8). |
|  | DETAIL_PEMBELIAN (no_faktur_pembelian*, kode_barang*, qty_detail_pembelian, harga_beli_detail_pembelian) | (no_faktur_pembelian, kode_barang) | Pola yang sama dengan DETAIL_PENJUALAN (FD9). |
|  | PEMASOK (kode_pemasok, nama_pemasok, telepon_pemasok, alamat_pemasok) | kode_pemasok | Informasi pemasok disimpan sekali. |

![Tabel tahapan UNF, 1NF, 2NF, 3NF Kopma di GitHub (p04_normalisasi_kopma_25430120.md)](img/p04_ss_tahapan_kopma.png)

*Tangkapan layar: Tabel tahapan UNF, 1NF, 2NF, 3NF Kopma di GitHub (p04_normalisasi_kopma_25430120.md) (jam Windows terlihat)*

**Keputusan nilai turunan Kopma:**

| Nilai turunan | Rumus | Keputusan | Alasan |
|---|---|---|---|
| subtotal_detail_penjualan | qty x harga satuan saat transaksi | Dihitung, tidak disimpan | Kedua masukannya sudah tersimpan di baris yang sama, sehingga nilai yang disimpan hanya menambah risiko tidak sinkron. |
| jumlah_penjualan | jumlah semua subtotal pada satu nota | Dihitung, tidak disimpan | Selalu dapat diturunkan dari detail_penjualan. |
| diskon_penjualan | 5% dari jumlah bila anggota berstatus aktif | Dihitung, tidak disimpan | Mengikuti AB-02. Catatan: karena status anggota bisa berubah setelah nota dibuat, arsip historis (Buku 2) perlu membekukan nilainya. |
| total_penjualan | jumlah dikurangi diskon | Dihitung, tidak disimpan | Turunan dari dua nilai di atas. |

### 3.4 D.4 Pencocokan skema kanonik dan pemeriksaan BCNF

| Tabel | Kunci primer | Kunci unik | Kunci tamu | Beda dengan Tabel 4.2 buku |
|---|---|---|---|---|
| petugas | id_petugas | kode_petugas | - | Sama |
| anggota | id_anggota | no_anggota, nim_anggota | - | Sama |
| barang | id_barang | kode_barang | - | Sama |
| pemasok | id_pemasok | kode_pemasok | - | Ada kunci unik kode_pemasok (di buku tidak ada) |
| penjualan | id_penjualan | no_nota_penjualan | id_petugas, id_anggota (boleh NULL) | Sama |
| detail_penjualan | (id_penjualan, id_barang) | - | id_penjualan, id_barang | Sama |
| pembelian | id_pembelian | no_faktur_pembelian | id_pemasok, id_petugas (boleh NULL) | Ada kunci unik no_faktur_pembelian dan kunci tamu id_petugas (AB-10) |
| detail_pembelian | (id_pembelian, id_barang) | - | id_pembelian, id_barang | Sama |

Perbedaan dengan Tabel 4.2 buku ada pada kunci unik kode_pemasok, kunci unik no_faktur_pembelian, dan kunci tamu id_petugas pada pembelian. Kunci tamu id_petugas berasal dari aturan baru AB-10 hasil Titik Analisis 3 Pertemuan 3. Selain itu nama kolom mengikuti kamus data saya.

**Hasil pemeriksaan BCNF:**

| Tabel | Penentu (determinan) | Semua penentu kunci kandidat? | Hasil |
|---|---|---|---|
| petugas | id_petugas, kode_petugas | Ya | BCNF |
| anggota | id_anggota, no_anggota, nim_anggota | Ya (nama_anggota tidak unik sehingga bukan penentu) | BCNF |
| barang | id_barang, kode_barang | Ya | BCNF |
| pemasok | id_pemasok, kode_pemasok | Ya (nama_pemasok tidak unik) | BCNF |
| penjualan | id_penjualan, no_nota_penjualan | Ya | BCNF |
| detail_penjualan | (id_penjualan, id_barang) | Ya | BCNF |
| pembelian | id_pembelian, no_faktur_pembelian | Ya | BCNF |
| detail_pembelian | (id_pembelian, id_barang) | Ya | BCNF |

Semua tabel memenuhi BCNF. Seluruhnya disimpan di p04_normalisasi_kopma_25430120.md dengan commit p04: normalisasi kopma.

## 4. Jawaban Titik Analisis

**Titik Analisis 1: mengapa harga_satuan_detail_penjualan berada pada kunci (no_nota_penjualan, kode_barang).**

Karena AB-04 menyatakan harga pada nota dapat berbeda dari harga barang saat ini. Harga yang berlaku saat transaksi adalah fakta tentang baris nota itu, bukan fakta tentang barang. Bila kolom ini dipindah ke tabel barang (kode_barang -> harga), setiap kali harga barang dinaikkan semua nota lama ikut berubah. Laporan omzet tahun lalu akan dihitung dengan harga hari ini, sehingga angkanya salah dan tidak dapat diperiksa lagi.

**Titik Analisis 2: mengapa keputusan "total tidak disimpan" tetap konsisten dengan arsip penjualan yang menyimpan total.**

Keduanya konsisten karena mengikuti satu prinsip: simpan bila nilai harus dibekukan, hitung bila nilai harus selalu mengikuti sumbernya. Tabel penjualan dan detail_penjualan adalah data operasional yang masih dapat dikoreksi, sehingga total dihitung agar selalu cocok dengan detailnya. Arsip penjualan adalah potret historis yang tidak boleh berubah, misalnya laporan bulan lalu harus tetap sama walau status anggota atau persentase diskon berubah. Karena itu arsip justru menyimpan total.

**Titik Analisis 3: di mana informasi "barang ini dipasok oleh siapa" disimpan.**

Informasi itu tersimpan pada jalur pemasok -> pembelian -> detail_pembelian -> barang. Setiap pembelian menunjuk satu pemasok, dan detail_pembelian menunjuk barang yang dibeli. Keuntungannya dibanding satu nama pemasok di tabel barang: satu barang dapat dipasok beberapa pemasok dan berganti dari waktu ke waktu, riwayatnya tercatat per faktur, dan nama pemasok disimpan sekali di tabel pemasok sehingga tidak muncul ejaan yang berbeda-beda seperti "CV Sumber ATK" dan "CV. Sumber A.T.K".

## 5. Hasil Latihan dan Modifikasi

### Latihan E1: beberapa nomor telepon untuk setiap pemasok

Kebutuhan ini melanggar 1NF bila nomor disimpan dalam satu kolom berisi daftar (misalnya "0812..., 0274...") atau dalam kolom telepon1, telepon2. Normalisasinya:

| Tahap | Relasi | Kunci |
|---|---|---|
| UNF | PEMASOK_UNF (kode_pemasok, nama_pemasok, alamat_pemasok, {nomor_telepon_pemasok, keterangan_telepon_pemasok}) | kode_pemasok |
| 1NF | PEMASOK_1NF (kode_pemasok, nomor_telepon_pemasok, nama_pemasok, alamat_pemasok, keterangan_telepon_pemasok) | (kode_pemasok, nomor_telepon_pemasok) |
| 2NF | PEMASOK (kode_pemasok, nama_pemasok, alamat_pemasok) | kode_pemasok |
|  | TELEPON_PEMASOK (kode_pemasok*, nomor_telepon_pemasok, keterangan_telepon_pemasok) | (kode_pemasok, nomor_telepon_pemasok) |
| 3NF dan BCNF | Tidak ada rantai antaratribut bukan kunci, dan semua penentu adalah kunci kandidat | - |

Dengan kunci pengganti, relasi barunya menjadi telepon_pemasok (id_telepon_pemasok, id_pemasok*, nomor_telepon_pemasok, keterangan_telepon_pemasok) dengan kunci unik (id_pemasok, nomor_telepon_pemasok). Kolom telepon_pemasok dihapus dari tabel pemasok. Relasinya: satu pemasok memiliki nol atau banyak telepon_pemasok.

### Latihan E2: contoh data yang melanggar 3NF

Bila nama_anggota disimpan di tabel penjualan, terbentuk rantai no_nota_penjualan -> no_anggota -> nama_anggota, yaitu ketergantungan transitif yang melanggar 3NF. Contoh data (tabel hipotetis penjualan_buruk):

| no_nota_penjualan | tanggal_penjualan | no_anggota | nama_anggota |
|---|---|---|---|
| PJ-0142 | 2026-09-24 | A-0457 | Budi S. |
| PJ-0143 | 2026-09-24 | NULL | NULL |
| PJ-0150 | 2026-09-25 | A-0457 | Budi S. |
| PJ-0161 | 2026-09-27 | A-0457 | Budi S. |

Anggota A-0457 mengoreksi namanya menjadi "Budi Santoso", tetapi kueri ubah hanya mengenai satu nota:

```sql
UPDATE penjualan_buruk SET nama_anggota = 'Budi Santoso' WHERE no_nota_penjualan = 'PJ-0150';
```

Hasilnya, anggota A-0457 kini tertulis dengan dua nama berbeda (PJ-0150 bernama "Budi Santoso", PJ-0142 dan PJ-0161 masih "Budi S."). Itulah anomali ubah. Contoh ini sudah saya uji pada basis data uji dan hasilnya sama. Pada rancangan 3NF, nama hanya disimpan sekali di tabel anggota sehingga satu UPDATE cukup.

## 6. Tugas Mandiri: Milestone Proyek 04

Berkas: p04_normalisasi_25430120.md, dengan ERD yang diperbarui p04_erd_25430120.drawio dan p04_erd_25430120.png. Dokumen sumber: Slip Peminjaman Buku Perpustakaan Cendekia ABPA dari Pertemuan 2.

**Anomali pada dokumen sumber**

| Jenis anomali | Contoh pada slip peminjaman | Dampak |
|---|---|---|
| Anomali ubah | Nama dan status anggota tertulis ulang pada setiap baris eksemplar. Bila nama dikoreksi di satu baris saja, baris lain tetap lama. | Satu fakta tersimpan di banyak baris dan bisa tidak konsisten. |
| Anomali sisip | Judul buku baru tidak dapat dicatat sebelum ada eksemplar yang dipinjam, karena judul hanya muncul di baris peminjaman. | Katalog tidak dapat diisi lebih dulu. |
| Anomali hapus | Menghapus satu-satunya peminjaman yang memuat sebuah eksemplar ikut menghapus informasi judul buku dan eksemplarnya. | Menghapus transaksi menghilangkan data katalog. |

**Dependensi fungsional beserta kode AB**

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

| Dependensi yang salah | Mengapa salah |
|---|---|
| no_anggota -> tanggal_pinjam_peminjaman | Satu anggota dapat meminjam berkali-kali pada tanggal yang berbeda. |
| kode_buku -> kode_eksemplar | AB-05: satu judul dapat memiliki banyak eksemplar. |
| (konstanta Rp3.000) -> tarif_per_hari_denda | AB-09: tarif disimpan per denda karena tarif dapat naik. Tarif lama tidak boleh berubah. |

**Tahapan UNF, 1NF, 2NF, dan 3NF**

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

![Tabel tahapan UNF, 1NF, 2NF, 3NF proyek di GitHub (p04_normalisasi_25430120.md)](img/p04_ss_tahapan_proyek.png)

*Tangkapan layar: Tabel tahapan UNF, 1NF, 2NF, 3NF proyek di GitHub (p04_normalisasi_25430120.md) (jam Windows terlihat)*

**Pemeriksaan BCNF**

| Tabel | Penentu (determinan) | Semua penentu kunci kandidat? | Hasil |
|---|---|---|---|
| anggota | id_anggota, no_anggota, no_identitas_anggota | Ya (nama_anggota tidak unik sehingga bukan penentu) | BCNF |
| petugas | id_petugas, kode_petugas | Ya | BCNF |
| buku | id_buku, kode_buku, isbn_buku (unik bila ada) | Ya (judul_buku tidak unik) | BCNF |
| eksemplar | id_eksemplar, kode_eksemplar | Ya | BCNF |
| peminjaman | id_peminjaman, no_peminjaman | Ya | BCNF |
| detail_peminjaman | (id_peminjaman, id_eksemplar) | Ya | BCNF |
| denda | id_denda, no_denda, (id_peminjaman, id_eksemplar) | Ya | BCNF |

Pemisahan denda dari detail_peminjaman bukan tuntutan 3NF, karena atribut denda sama-sama bergantung pada seluruh kunci detail. Pemisahan dipertahankan karena atribut denda opsional (nol atau satu per detail) dan denda punya kunci kandidat sendiri, no_denda. Bila digabung kembali, kebanyakan baris detail berisi NULL pada kolom denda.

**Keputusan nilai turunan beserta alasannya**

| Nilai turunan | Rumus | Keputusan | Alasan |
|---|---|---|---|
| jumlah_buku_peminjaman | banyak baris detail_peminjaman pada satu peminjaman | Dihitung, tidak disimpan | Selalu dapat dihitung dari detail. Batas maksimal 5 (AB-02) diperiksa saat baris detail ditambahkan. |
| tanggal_jatuh_tempo_peminjaman | tanggal_pinjam + lama_pinjam_hari | Dihitung. Masukannya disimpan: atribut baru lama_pinjam_hari_peminjaman | AB-07 dapat berubah di masa depan. Bila jatuh tempo hanya dihitung dari aturan terkini, peminjaman lama ikut bergeser. Yang dibekukan adalah lama pinjam yang berlaku saat peminjaman, bukan hasil hitungnya. |
| hari_telat_denda | selisih hari antara tanggal_kembali dan jatuh tempo, bila positif | Dihitung, tidak disimpan | Kedua masukannya tersimpan dan tidak berubah setelah buku dikembalikan. |
| total_denda | hari_telat x tarif_per_hari_denda | Dihitung, tidak disimpan | Kedua masukannya tersimpan. Tarif dibekukan per denda (AB-09), sehingga hasilnya selalu sama. |
| tarif_per_hari_denda | bukan nilai turunan | Disimpan | AB-09: tarif dapat naik, tetapi denda lama tidak boleh berubah. |

**Perubahan pada ERD proyek**

| No | Perubahan pada ERD | Alasan |
|---|---|---|
| 1 | peminjaman: atribut turunan tanggal_jatuh_tempo_peminjaman dihapus, atribut lama_pinjam_hari_peminjaman ditambahkan | FD1 dan FD2. Yang dibekukan adalah masukan yang dapat berubah (AB-07) |
| 2 | denda: hari_telat_denda dan total_denda dihapus | FD10 dan FD11. Keduanya turunan dari atribut yang sudah tersimpan |
| 3 | Seluruh relasi dan kardinalitas tidak berubah | Normalisasi tidak menemukan entitas atau relasi yang salah |

![Gambar 6.1 ERD proyek setelah normalisasi (revisi Pertemuan 4)](../p04_erd_25430120.png)

*Gambar 6.1 ERD proyek setelah normalisasi (revisi Pertemuan 4)*

![ERD proyek revisi dibuka di draw.io](img/p04_ss_drawio_proyek.png)

*Tangkapan layar: ERD proyek revisi dibuka di draw.io (jam Windows terlihat)*

**Skema relasional akhir**

| Tabel | Kunci primer | Kunci unik | Kunci tamu |
|---|---|---|---|
| anggota | id_anggota | no_anggota, no_identitas_anggota | - |
| petugas | id_petugas | kode_petugas | - |
| buku | id_buku | kode_buku, isbn_buku (bila ada) | - |
| eksemplar | id_eksemplar | kode_eksemplar | id_buku |
| peminjaman | id_peminjaman | no_peminjaman | id_anggota, id_petugas |
| detail_peminjaman | (id_peminjaman, id_eksemplar) | - | id_peminjaman, id_eksemplar |
| denda | id_denda | no_denda, (id_peminjaman, id_eksemplar) | (id_peminjaman, id_eksemplar) ke detail_peminjaman |

**Catatan untuk Pertemuan 5.** Skema ini menjadi dasar skrip DDL, dan setiap kunci serta aturan bisnis harus muncul sebagai constraint.

| Jenis | Constraint yang akan dibuat pada Pertemuan 5 |
|---|---|
| UNIQUE | no_anggota, no_identitas_anggota, kode_petugas, kode_buku, isbn_buku, kode_eksemplar, no_peminjaman, no_denda, dan (id_peminjaman, id_eksemplar) pada denda |
| FOREIGN KEY | Seluruh kunci tamu pada tabel skema relasional di atas |
| CHECK / ENUM | tarif_per_hari_denda >= 0, lama_pinjam_hari_peminjaman > 0, status_anggota, status_eksemplar, kondisi_kembali, dan status_bayar_denda bernilai tetap |
| Trigger atau transaksi (Modul 14) | AB-02 (maksimal 5 eksemplar), AB-04 (eksemplar harus tersedia), AB-11 (anggota tanpa denda belum lunas), dan AB-12 (tanggal kembali tidak lebih awal dari tanggal pinjam), karena melibatkan lebih dari satu tabel |

## 7. Pembahasan dan Kendala

Hal yang paling terasa adalah perbedaan antara "bukan tuntutan normalisasi" dan "tidak perlu". Pemisahan denda dari detail_peminjaman tidak dipaksa oleh 3NF, tetapi tetap beralasan karena atribut denda opsional. Sebaliknya, penelusuran FD2 menunjukkan jatuh tempo tidak boleh dibiarkan sebagai atribut turunan yang tersimpan, sehingga yang dibekukan adalah lama pinjam yang berlaku saat peminjaman.

Kendala yang saya temui:

- [tulis kendala nyata yang kamu alami, misalnya bingung membedakan ketergantungan sebagian dan transitif, atau sulit memutuskan nilai turunan]
- [tulis cara kamu mengatasinya]
## 8. Kesimpulan

Normalisasi menguji ERD dan menghasilkan skema yang bebas anomali. Dependensi fungsional harus diturunkan dari aturan bisnis, bukan dari contoh data. Nilai turunan sebaiknya dihitung, kecuali masukannya dapat berubah sehingga masukan itu yang dibekukan. Pada proyek saya, ERD berubah pada tiga atribut: lama_pinjam_hari_peminjaman ditambahkan, serta hari_telat_denda dan total_denda dihapus.

## 9. Pernyataan Penggunaan AI

Saya menggunakan Claude (Anthropic) pada pertemuan ini untuk menjelaskan isi modul, menyusun draf berkas p04_normalisasi_kopma_25430120.md dan p04_normalisasi_25430120.md, membuat ERD revisi, serta menyusun kerangka laporan ini. Dependensi fungsional, tahapan normalisasi, dan keputusan nilai turunan sudah saya baca, dan saya dapat menjelaskan alasan setiap keputusan dari aturan bisnisnya.

[ubah bagian ini bila pemakaianmu berbeda, dan sebutkan bagian yang kamu tulis atau ubah sendiri]

## 10. Bukti Git

- **Repositori:** https://github.com/balqisputria439-tech/basisdata-25430120
- **Pesan commit Kopma:** p04: normalisasi kopma
- **Pesan commit proyek:** p04: normalisasi proyek perpustakaan
- **Kode commit (hash):** [isi 7 karakter pertama dari git log --oneline]

## Checklist

**Checklist umum**

- [ ] Identitas: nama, NIM, kelas, pertemuan, tanggal, dosen/asisten
- [ ] Tujuan ditulis dengan bahasa sendiri (maksimal 5 baris)
- [ ] Ringkasan teori (maksimal setengah halaman, tanpa menyalin buku)
- [ ] Langkah percobaan (D): tangkapan layar diberi keterangan
- [ ] Titik Analisis dijawab lengkap dengan alasan
- [ ] Latihan (E): dokumen hasil latihan
- [ ] Tugas Mandiri (F): berkas, bukti, dan penjelasan keputusan desain
- [ ] Pembahasan dan kendala
- [ ] Kesimpulan (2 sampai 4 kalimat)
- [ ] Pernyataan penggunaan AI
- [ ] Bukti Git (tautan repositori dan hash commit)
- [ ] Keaslian: tangkapan layar memperlihatkan jam sistem; nama objek, judul diagram, dan tanda tangan digital memuat nama dan NIM

**Checklist khusus Pertemuan 4**

- [ ] Berkas wajib: p04_normalisasi_25430120.md (proyek)
- [ ] Bukti tangkapan layar: tabel tahapan UNF, 1NF, 2NF, 3NF
- [ ] Analisis wajib: daftar dependensi fungsional; keputusan menyimpan atau menghitung nilai turunan beserta alasannya
