# Dokumen Kebutuhan Data - Koperasi Mahasiswa Sejahtera (Kopma)

- Nama : ADILLA BALQIS PUTRI ANTONI
- NIM : 25430120
- Kelas : B

## 1. Latar belakang dan aktivitas organisasi

Koperasi Mahasiswa Sejahtera (Kopma) adalah koperasi fiktif di lingkungan kampus yang menjual alat tulis, makanan ringan, dan minuman. Pembeli dapat berupa anggota atau masyarakat umum. Mahasiswa mendaftar sebagai anggota dengan NIM, nama, program studi, dan nomor HP, lalu memperoleh nomor anggota berformat A-xxxx. Anggota aktif memperoleh diskon 5% untuk setiap nota.

Tiga kasir bekerja bergantian per sif. Kasir mencatat penjualan dan mencetak nota. Setiap sore petugas gudang memeriksa stok. Bila stok suatu barang di bawah batas minimum, petugas gudang membuat pesanan pembelian ke pemasok. Ketika barang datang, stok bertambah sesuai faktur pemasok. Setiap awal bulan, ketua koperasi menerima laporan omzet, barang terlaris, barang dengan stok menipis, dan anggota paling aktif.

Tiga keluhan dari wawancara menjadi pemicu analisis:

| Sumber | Keluhan | Kebutuhan data yang tersirat |
|---|---|---|
| Ketua | Harga naik, nota lama membingungkan | Harga saat transaksi disimpan per baris nota (AB-04) |
| Petugas gudang | Stok di buku catatan kadang minus | Stok tidak boleh negatif (AB-03) |
| Kasir | Anggota lupa kartu, dicari lewat NIM | NIM unik dan dapat dipakai untuk pencarian (AB-05) |

## 2. Aktor dan proses bisnis

| Kode | Proses bisnis | Aktor | Pemicu |
|---|---|---|---|
| PB-01 | Mendaftarkan anggota | Kasir (atas permintaan mahasiswa) | Mahasiswa ingin menjadi anggota |
| PB-02 | Mencatat penjualan | Kasir | Pembeli membayar di kasir |
| PB-03 | Memesan barang ke pemasok | Petugas gudang | Stok di bawah batas minimum |
| PB-04 | Menerima barang dari pemasok | Petugas gudang | Barang datang bersama faktur |
| PB-05 | Menyusun laporan bulanan | Ketua koperasi | Awal bulan |
| PB-06 | Mengelola data pemasok (tambahan dari Titik Analisis 3) | Petugas gudang | Ada pemasok baru atau data pemasok berubah |
| PB-07 | Mengelola status anggota (tambahan dari Titik Analisis 3) | Ketua koperasi | Keanggotaan berakhir atau diaktifkan kembali |
| PB-08 | Mengelola data petugas | Ketua koperasi | Ada petugas baru atau pergantian peran |

## 3. Dokumen sumber yang dianalisis

1. Narasi studi kasus Kopma.
2. Kutipan wawancara (ketua, petugas gudang, kasir).
3. Nota penjualan Kopma. Pembedahan elemen datanya:

| Isian pada nota | Disimpan / dihitung | Entitas |
|---|---|---|
| Nomor nota | Disimpan | Penjualan |
| Tanggal dan jam | Disimpan | Penjualan |
| Nama kasir | Disimpan sebagai rujukan ke petugas | Penjualan -> Petugas |
| Nomor anggota (bila ada) | Disimpan sebagai rujukan ke anggota | Penjualan -> Anggota |
| Nama barang | Diambil dari data barang melalui rujukan | Detail penjualan -> Barang |
| Qty | Disimpan | Detail penjualan |
| Harga satuan saat transaksi | Disimpan (AB-04) | Detail penjualan |
| Subtotal per baris | Dihitung (qty x harga) | Turunan |
| Diskon 5% | Dihitung dari status anggota aktif | Turunan |
| Total bayar | Dihitung dari subtotal dikurangi diskon | Turunan |
| Uang bayar | Disimpan | Penjualan |
| Kembalian | Dihitung (bayar dikurangi total) | Turunan |

## 4. Entitas kandidat dan elemen data

| Entitas kandidat | Elemen data utama | Sumber |
|---|---|---|
| Anggota | nomor anggota, NIM, nama, program studi, nomor HP, status aktif | Formulir pendaftaran |
| Barang | kode, nama, kategori, harga jual, stok, batas minimum stok | Daftar barang, faktur |
| Penjualan | nomor nota, tanggal-jam, kasir, anggota (opsional), bayar | Nota penjualan |
| Detail penjualan | nomor nota, barang, qty, harga saat transaksi | Nota penjualan |
| Petugas | kode petugas, nama, peran (kasir/gudang/ketua) | Wawancara |
| Pemasok | kode, nama, telepon, alamat | Faktur pemasok |
| Pembelian dan detailnya | nomor faktur, tanggal, pemasok, barang, qty, harga beli | Faktur pemasok |

## 5. Aturan bisnis

| Kode | Aturan bisnis | Asal dari proses |
|---|---|---|
| AB-01 | Setiap nota memiliki nomor unik dan minimal satu baris barang. | PB-02 |
| AB-02 | Penjualan boleh tanpa anggota (pembeli umum). Jika ada anggota, anggota harus berstatus aktif untuk memperoleh diskon 5%. | PB-02 |
| AB-03 | Stok barang tidak boleh negatif. Penjualan ditolak bila qty melebihi stok tersedia. | PB-02 |
| AB-04 | Harga jual yang dipakai pada nota disimpan per baris dan tidak berubah meski harga barang kemudian naik. | PB-02 |
| AB-05 | NIM anggota unik. Pencarian anggota dapat dilakukan lewat nomor anggota atau NIM. | PB-01 |
| AB-06 | Pesanan pembelian dibuat bila stok kurang dari batas minimum barang tersebut. | PB-03 |

## 6. Kebutuhan informasi

| Kode | Kebutuhan informasi | Data yang diperlukan |
|---|---|---|
| KI-01 | Omzet dan jumlah nota per hari dan per bulan | Penjualan, detail penjualan |
| KI-02 | Lima barang terlaris per bulan berdasarkan qty | Detail penjualan, barang |
| KI-03 | Barang dengan stok di bawah batas minimum | Barang |
| KI-04 | Sepuluh anggota dengan belanja terbesar per bulan | Penjualan, detail penjualan, anggota |

## 7. Matriks CRUD

C = create, R = read, U = update, D = delete.

| Proses | Anggota | Barang | Penjualan | Detail | Pemasok | Pembelian | Petugas |
|---|---|---|---|---|---|---|---|
| PB-01 Daftar anggota | C | | | | | | |
| PB-02 Catat penjualan | R | R, U | C | C | | | R |
| PB-03 Pesan ke pemasok | | R | | | R | C | R |
| PB-04 Terima barang | | U | | | R | U | R |
| PB-05 Laporan bulanan | R | R | R | R | | R | |
| PB-06 Kelola data pemasok | | | | | C, R, U | | |
| PB-07 Kelola status anggota | R, U | | | | | | |
| PB-08 Kelola data petugas | | | | | | | C, R, U |

Pemeriksaan: setiap kolom entitas memiliki minimal satu huruf C, dan setiap baris proses memiliki minimal satu isian. Kolom Pemasok semula tidak punya C (celah pada PB-01 sampai PB-05), sehingga ditambahkan PB-06. Kolom Petugas ditambahkan karena sumber data petugas juga memerlukan proses pembuatannya (PB-08). Huruf D tidak dipakai karena data historis dipertahankan. Anggota dinonaktifkan melalui status, bukan dihapus.

## 8. Kamus data awal

| Elemen | Arti | Contoh | Aturan | Penanggung jawab |
|---|---|---|---|---|
| no_anggota | Nomor anggota koperasi | A-0457 | Unik, format A diikuti 4 digit | Ketua |
| nim_anggota | NIM anggota | 2301010123 | Unik, 10 digit | Ketua |
| nama_anggota | Nama lengkap anggota | Siti Aminah | Wajib diisi | Ketua |
| prodi_anggota | Program studi anggota | Ilmu Komputer | Wajib diisi | Ketua |
| no_hp_anggota | Nomor HP anggota | 0812xxxx | Data pribadi, akses terbatas | Ketua |
| status_anggota | Status keanggotaan | aktif | Hanya aktif atau nonaktif | Ketua |
| kode_barang | Kode barang | BRG-012 | Unik | Petugas gudang |
| nama_barang | Nama barang | Pulpen Hitam | Wajib diisi | Petugas gudang |
| kategori_barang | Kelompok barang | alat tulis | Alat tulis, makanan, atau minuman | Petugas gudang |
| harga_jual_barang | Harga jual terkini | 4000 | Bilangan bulat >= 0 (rupiah) | Ketua |
| stok_barang | Jumlah barang tersedia | 35 | Bilangan bulat >= 0 (AB-03) | Petugas gudang |
| batas_minimum_barang | Ambang stok memicu pemesanan | 10 | Bilangan bulat >= 0 (AB-06) | Petugas gudang |
| no_nota_penjualan | Nomor nota penjualan | PJ-2609-0142 | Unik per nota | Kasir |
| tanggal_penjualan | Tanggal dan jam transaksi | 2026-09-14 10:32 | Tidak boleh di masa depan | Kasir |
| bayar_penjualan | Uang yang dibayarkan | 20000 | Bilangan bulat >= total | Kasir |
| qty_detail_penjualan | Jumlah barang per baris nota | 3 | Bilangan bulat >= 1, tidak melebihi stok | Kasir |
| harga_satuan_detail_penjualan | Harga jual saat transaksi | 4000 | Bilangan bulat >= 0 (AB-04) | Kasir |
| kode_petugas | Kode petugas | PTG-02 | Unik | Ketua |
| nama_petugas | Nama petugas | Budi | Wajib diisi | Ketua |
| peran_petugas | Peran petugas | kasir | Kasir, gudang, atau ketua | Ketua |
| kode_pemasok | Kode pemasok | PMS-03 | Unik | Petugas gudang |
| nama_pemasok | Nama pemasok | CV Maju Jaya | Wajib diisi | Petugas gudang |
| no_faktur_pembelian | Nomor faktur pembelian | FK-2609-0007 | Unik | Petugas gudang |

## 9. Kebutuhan non-fungsional data

- Volume: sekitar 150 nota per hari.
- Retensi: data transaksi disimpan minimal lima tahun.
- Privasi: nomor HP anggota adalah data pribadi dan hanya boleh dilihat oleh ketua. Pembatasan ini sejalan dengan kewajiban pengendali data dalam Undang-Undang Pelindungan Data Pribadi.

## 10. Isu kualitas data yang diantisipasi

| Isu | Dimensi kualitas | Cara mencegah |
|---|---|---|
| Stok bernilai negatif | Validitas | Aturan AB-03 dan pemeriksaan sebelum menyimpan penjualan |
| Harga nota lama berubah karena harga barang naik | Akurasi, konsistensi | Simpan harga per baris nota (AB-04) |
| Anggota terdaftar ganda dengan NIM sama | Keunikan | NIM unik (AB-05) |
| Nomor HP salah format | Validitas | Aturan format pada kamus data |
| Subtotal dan total tidak cocok dengan rinciannya | Konsistensi | Perlakukan sebagai nilai turunan, keputusan akhir di Modul 4 |
