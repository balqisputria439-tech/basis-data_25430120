# Dokumen Kebutuhan Data - Perpustakaan Cendekia ABPA

- Nama : ADILLA BALQIS PUTRI ANTONI
- NIM : 25430120
- Tema : Perpustakaan (kode tema: perpus), basis data `perpus_120`


## 1. Latar belakang dan aktivitas organisasi

Perpustakaan Cendekia ABPA adalah perpustakaan fiktif di lingkungan kampus. Layanannya melayani mahasiswa dan dosen yang terdaftar sebagai anggota. Perpustakaan menyimpan koleksi buku. Satu judul buku dapat memiliki beberapa eksemplar fisik yang masing-masing memiliki kode inventaris sendiri.

Alur kerjanya adalah sebagai berikut. Calon anggota mendaftar dengan nomor identitas (NIM atau NIP), nama, dan nomor HP, lalu memperoleh nomor anggota berformat AG-xxxx. Petugas perpustakaan mengelola katalog: menambah judul baru dan mencatat eksemplar yang masuk. Saat anggota meminjam, petugas mencatat peminjaman dan memberikan slip peminjaman yang memuat tanggal jatuh tempo. Saat buku dikembalikan, petugas mencatat tanggal kembali dan kondisi buku. Bila terlambat, sistem menghitung denda, lalu petugas menerima pembayaran denda. Setiap awal bulan, kepala perpustakaan menerima laporan peminjaman, buku terpopuler, peminjaman terlambat, dan total denda.

Asumsi yang dipakai dalam dokumen ini (dirancang sendiri untuk kasus fiktif ini):
- Lama peminjaman adalah 7 hari kalender.
- Satu peminjaman terdiri dari satu atau beberapa eksemplar (detail peminjaman).
- Anggota yang masih memiliki denda belum lunas tidak boleh meminjam lagi.

## 2. Aktor dan proses bisnis

| Kode | Proses bisnis | Aktor | Pemicu |
|---|---|---|---|
| PB-01 | Mendaftarkan anggota | Petugas | Mahasiswa atau dosen ingin menjadi anggota |
| PB-02 | Mengelola katalog buku dan eksemplar | Petugas | Ada judul atau eksemplar baru, atau data perlu diperbarui |
| PB-03 | Mencatat peminjaman | Petugas | Anggota membawa buku ke meja layanan untuk dipinjam |
| PB-04 | Mencatat pengembalian dan menghitung denda | Petugas | Anggota mengembalikan buku |
| PB-05 | Menerima pembayaran denda | Petugas | Anggota membayar denda |
| PB-06 | Menyusun laporan bulanan | Kepala perpustakaan | Awal bulan |
| PB-07 | Mengelola data petugas dan status keanggotaan | Kepala perpustakaan | Ada petugas baru, atau keanggotaan berakhir atau diaktifkan kembali |

## 3. Dokumen sumber yang dianalisis

Dokumen sumber fiktif yang dirancang sendiri: **Slip Peminjaman Buku Perpustakaan Cendekia ABPA**.

```
=========================================
  PERPUSTAKAAN CENDEKIA ABPA
  SLIP PEMINJAMAN BUKU
=========================================
No. Peminjaman : PM-2610-0031
Tanggal Pinjam : 18 Oktober 2026
Jatuh Tempo    : 25 Oktober 2026
Petugas        : Rina (PTG-02)

Anggota        : AG-0012  Dewi Lestari
                 NIM 25430120   Status: aktif
-----------------------------------------
No  Kode Eksemplar   Judul Buku
1   EKS-0101-02      Basis Data Dasar
2   EKS-0207-01      Pemrograman Web
-----------------------------------------
Jumlah buku    : 2
Tarif denda    : Rp3.000 per hari per buku
Tanda tangan petugas: ____________
=========================================
```

Pembedahan isian slip:

| Isian pada slip | Disimpan / dihitung | Entitas |
|---|---|---|
| No. peminjaman | Disimpan | Peminjaman |
| Tanggal pinjam | Disimpan | Peminjaman |
| Jatuh tempo | Dihitung (tanggal pinjam + 7 hari), boleh disimpan sebagai catatan aturan saat itu | Peminjaman (turunan) |
| Petugas | Disimpan sebagai rujukan ke petugas | Peminjaman -> Petugas |
| Nomor anggota | Disimpan sebagai rujukan ke anggota | Peminjaman -> Anggota |
| Nama anggota dan NIM | Diambil dari data anggota melalui rujukan | Anggota |
| Status anggota | Diambil dari data anggota (diperiksa saat meminjam) | Anggota |
| Kode eksemplar | Disimpan sebagai rujukan ke eksemplar | Detail peminjaman -> Eksemplar |
| Judul buku | Diambil dari data buku melalui eksemplar | Buku |
| Jumlah buku | Dihitung dari banyaknya baris detail | Turunan |
| Tarif denda | Aturan; dicatat pada denda saat denda terbentuk | Denda |

## 4. Entitas kandidat dan elemen data

| Entitas kandidat | Elemen data utama | Sumber |
|---|---|---|
| Anggota | nomor anggota, nomor identitas, nama, nomor HP, status, tanggal daftar | Formulir pendaftaran |
| Buku | kode buku, judul, pengarang, penerbit, tahun terbit, ISBN, kategori | Katalog |
| Eksemplar | kode eksemplar, buku (judul), status, lokasi rak, tanggal masuk | Daftar inventaris |
| Petugas | kode petugas, nama, peran (pustakawan/kepala) | Data kepegawaian |
| Peminjaman | nomor peminjaman, tanggal pinjam, jatuh tempo, anggota, petugas | Slip peminjaman |
| Detail peminjaman | peminjaman, eksemplar, tanggal kembali, kondisi saat kembali | Slip peminjaman |
| Denda | nomor denda, detail peminjaman, jumlah hari telat, tarif per hari saat itu, status bayar, tanggal bayar | Kuitansi denda |

Catatan: "Buku" dan "Eksemplar" sengaja dipisah karena satu judul dapat memiliki banyak eksemplar (perhatian khusus tema Perpustakaan).

## 5. Aturan bisnis

| Kode | Aturan bisnis | Asal dari proses |
|---|---|---|
| AB-01 | Setiap peminjaman memiliki nomor unik dan minimal satu baris detail eksemplar. | PB-03 |
| AB-02 | Satu peminjaman maksimal 5 eksemplar (P + 2 dengan P = 3). | PB-03 |
| AB-03 | Hanya anggota berstatus aktif yang boleh meminjam. | PB-03, PB-07 |
| AB-04 | Satu eksemplar hanya boleh dipinjam bila berstatus tersedia, dan tidak boleh berada di dua peminjaman yang masih berjalan sekaligus. | PB-03 |
| AB-05 | Satu judul buku boleh memiliki banyak eksemplar. Setiap eksemplar memiliki kode inventaris unik. | PB-02 |
| AB-06 | Eksemplar berstatus rusak atau hilang tidak boleh dipinjam. | PB-02, PB-03 |
| AB-07 | Lama peminjaman 7 hari. Jatuh tempo = tanggal pinjam + 7 hari. | PB-03 |
| AB-08 | Denda Rp3.000 per hari per eksemplar yang terlambat, dihitung mulai sehari setelah jatuh tempo (P = 3). | PB-04 |
| AB-09 | Tarif denda per hari disimpan pada baris denda, sehingga denda lama tidak berubah bila tarif naik. | PB-04 |
| AB-10 | Nomor anggota dan nomor identitas anggota unik. Pencarian anggota dapat lewat keduanya. | PB-01 |
| AB-11 | Anggota yang memiliki denda belum lunas tidak boleh meminjam lagi. | PB-03, PB-05 |
| AB-12 | Tanggal kembali tidak boleh lebih awal dari tanggal pinjam. | PB-04 |

## 6. Kebutuhan informasi

| Kode | Kebutuhan informasi | Data yang diperlukan |
|---|---|---|
| KI-01 | Jumlah peminjaman per hari dan per bulan | Peminjaman |
| KI-02 | Lima buku paling sering dipinjam per bulan | Detail peminjaman, eksemplar, buku |
| KI-03 | Daftar peminjaman yang melewati jatuh tempo dan belum dikembalikan | Peminjaman, detail peminjaman, anggota |
| KI-04 | Total denda terbentuk dan total denda terbayar per bulan | Denda |
| KI-05 | Sepuluh anggota paling aktif meminjam per bulan | Peminjaman, anggota |
| KI-06 | Jumlah eksemplar tersedia dan sedang dipinjam per judul buku | Buku, eksemplar |

## 7. Matriks CRUD

C = create, R = read, U = update, D = delete.

| Proses | Anggota | Buku | Eksemplar | Petugas | Peminjaman | Detail | Denda |
|---|---|---|---|---|---|---|---|
| PB-01 Daftar anggota | C | | | | | | |
| PB-02 Kelola katalog | | C, R, U | C, R, U | | | | |
| PB-03 Catat peminjaman | R | R | R, U | R | C | C | R |
| PB-04 Catat pengembalian | R | | U | R | R | U | C |
| PB-05 Terima bayar denda | R | | | R | | R | R, U |
| PB-06 Laporan bulanan | R | R | R | | R | R | R |
| PB-07 Kelola petugas dan status anggota | R, U | | | C, R, U | | | |

Pemeriksaan:
- Setiap kolom entitas memiliki minimal satu huruf C: Anggota (PB-01), Buku dan Eksemplar (PB-02), Petugas (PB-07), Peminjaman dan Detail (PB-03), Denda (PB-04).
- Setiap baris proses memiliki minimal satu isian.
- Huruf D sengaja tidak dipakai. Data riwayat peminjaman dan denda dipertahankan. Anggota dinonaktifkan melalui status, bukan dihapus.

## 8. Kamus data awal

| Elemen | Arti | Contoh | Aturan | Penanggung jawab |
|---|---|---|---|---|
| no_anggota | Nomor anggota perpustakaan | AG-0012 | Unik, format AG diikuti 4 digit | Kepala perpustakaan |
| no_identitas_anggota | NIM atau NIP anggota | 25430120 | Unik (AB-10) | Kepala perpustakaan |
| nama_anggota | Nama lengkap anggota | Dewi Lestari | Wajib diisi | Kepala perpustakaan |
| no_hp_anggota | Nomor HP anggota | 0812xxxx | Data pribadi, akses terbatas | Kepala perpustakaan |
| status_anggota | Status keanggotaan | aktif | Hanya aktif atau nonaktif (AB-03) | Kepala perpustakaan |
| tanggal_daftar_anggota | Tanggal pendaftaran | 2026-08-20 | Tidak boleh di masa depan | Petugas |
| kode_buku | Kode judul buku | BK-0101 | Unik | Petugas |
| judul_buku | Judul buku | Basis Data Dasar | Wajib diisi | Petugas |
| pengarang_buku | Nama pengarang | Dedi Irawan | Wajib diisi | Petugas |
| penerbit_buku | Nama penerbit | Penerbit Kampus | Boleh kosong | Petugas |
| tahun_terbit_buku | Tahun terbit | 2024 | 4 digit, tidak di masa depan | Petugas |
| isbn_buku | Nomor ISBN | 978-xxx | Unik bila ada | Petugas |
| kategori_buku | Kelompok subjek buku | Komputer | Wajib diisi | Petugas |
| kode_eksemplar | Kode inventaris eksemplar | EKS-0101-02 | Unik (AB-05) | Petugas |
| status_eksemplar | Status ketersediaan fisik | tersedia | tersedia, dipinjam, rusak, atau hilang (AB-04, AB-06) | Petugas |
| lokasi_rak_eksemplar | Lokasi rak penyimpanan | Rak B-3 | Wajib diisi | Petugas |
| tanggal_masuk_eksemplar | Tanggal eksemplar masuk | 2026-07-01 | Tidak di masa depan | Petugas |
| kode_petugas | Kode petugas | PTG-02 | Unik | Kepala perpustakaan |
| nama_petugas | Nama petugas | Rina | Wajib diisi | Kepala perpustakaan |
| peran_petugas | Peran petugas | pustakawan | pustakawan atau kepala | Kepala perpustakaan |
| no_peminjaman | Nomor peminjaman | PM-2610-0031 | Unik (AB-01) | Petugas |
| tanggal_pinjam_peminjaman | Tanggal peminjaman | 2026-10-18 | Tidak di masa depan | Petugas |
| tanggal_jatuh_tempo_peminjaman | Batas pengembalian | 2026-10-25 | Tanggal pinjam + 7 hari (AB-07) | Petugas |
| tanggal_kembali_detail_peminjaman | Tanggal eksemplar dikembalikan | 2026-10-27 | Tidak lebih awal dari tanggal pinjam (AB-12); kosong bila belum kembali | Petugas |
| kondisi_kembali_detail_peminjaman | Kondisi buku saat kembali | baik | baik, rusak, atau hilang | Petugas |
| no_denda | Nomor denda | DN-2610-0005 | Unik | Petugas |
| hari_telat_denda | Jumlah hari keterlambatan | 2 | Bilangan bulat >= 1 | Petugas |
| tarif_per_hari_denda | Tarif denda per hari saat itu | 3000 | Bilangan bulat >= 0 (rupiah), dicatat per denda (AB-08, AB-09) | Kepala perpustakaan |
| status_bayar_denda | Status pelunasan denda | belum lunas | lunas atau belum lunas (AB-11) | Petugas |
| tanggal_bayar_denda | Tanggal denda dibayar | 2026-10-28 | Kosong bila belum lunas; tidak lebih awal dari tanggal kembali | Petugas |

Nilai turunan yang tidak dimasukkan sebagai kolom penyimpan pada tahap ini (dibahas di Modul 4): jatuh tempo (bisa dihitung), jumlah buku per peminjaman, dan total denda (hari telat x tarif per hari).

## 9. Kebutuhan non-fungsional data

**Perhitungan parameter personal (P)**

NIM = 25430120, dua digit terakhir = 20.

- 20 mod 9 = 2 (karena 9 x 2 = 18, sisa 2)
- P = 2 + 1 = **3**

Penggunaan P:

| Penggunaan | Rumus | Hasil |
|---|---|---|
| Batas maksimal eksemplar per peminjaman | P + 2 | **5** |
| Denda per hari | P (ribu rupiah) | **Rp3.000** |
| Perkiraan volume transaksi harian | 40 + 5 x P | **55** transaksi per hari |

**Volume.** Sekitar 55 peminjaman per hari, atau kurang lebih 1.650 per bulan.

**Retensi.** Data peminjaman dan denda disimpan minimal lima tahun untuk kebutuhan laporan tahunan dan audit.

**Data pribadi dan hak akses.** Data berikut termasuk data pribadi anggota dan dibatasi aksesnya, sejalan dengan kewajiban pengendali data dalam Undang-Undang Pelindungan Data Pribadi.

| Data pribadi | Siapa yang boleh melihat | Siapa yang tidak boleh |
|---|---|---|
| no_hp_anggota | Kepala perpustakaan dan petugas yang sedang melayani | Anggota lain, pihak luar |
| no_identitas_anggota | Kepala perpustakaan dan petugas | Pihak luar |
| nama_anggota (terkait riwayat pinjam) | Kepala perpustakaan dan petugas | Anggota lain, pihak luar |

Laporan yang dibagikan ke luar (misalnya buku terpopuler) hanya memuat data teragregasi tanpa identitas anggota.

## 10. Isu kualitas data yang diantisipasi

| No | Isu | Dimensi kualitas | Cara mencegah |
|---|---|---|---|
| 1 | Anggota terdaftar ganda dengan nomor identitas sama | Keunikan | Nomor identitas unik (AB-10) |
| 2 | Eksemplar tercatat tersedia padahal sedang dipinjam | Konsistensi | Status eksemplar diperbarui saat pinjam dan kembali (AB-04) |
| 3 | Tanggal kembali lebih awal dari tanggal pinjam | Validitas | Aturan AB-12 |
| 4 | Satu judul buku ditulis berbeda-beda sehingga laporan terpopuler terpecah | Konsistensi, akurasi | Pisahkan entitas Buku dari Eksemplar, rujuk lewat kode buku (AB-05) |
| 5 | Tarif denda lama berubah setelah tarif naik | Akurasi historis | Simpan tarif per denda (AB-09) |
| 6 | Nomor HP anggota salah format atau kosong | Validitas, kelengkapan | Aturan format pada kamus data |
| 7 | Total denda tidak cocok dengan hari telat x tarif | Akurasi | Perlakukan total sebagai nilai turunan |
