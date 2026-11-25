# Dokumen Kebutuhan Data - Koperasi Mahasiswa Sejahtera (Kopma)

Penyusun: Adilla Balqis Putri Antoni (25430120) · Kelas B

## 1. Latar belakang dan aktivitas organisasi

Kopma menjual alat tulis, makanan ringan, dan minuman di lingkungan kampus. Pembeli dapat berupa anggota
atau umum. Mahasiswa mendaftar sebagai anggota dengan NIM, nama, program studi, dan nomor HP, lalu
memperoleh nomor anggota berformat A-xxxx; anggota aktif mendapat diskon 5% per nota. Tiga kasir bekerja
bergantian per sif, petugas gudang memeriksa stok tiap sore dan memesan ke pemasok bila stok di bawah batas
minimum, dan ketua menerima laporan bulanan.

Keluhan yang menjadi pemicu: harga di nota lama tidak bisa dicek (ketua), stok di buku catatan kadang minus
(petugas gudang), dan anggota sering lupa kartu sehingga dicari lewat NIM (kasir).

## 2. Aktor dan proses bisnis

| Kode | Proses bisnis | Aktor | Pemicu |
|---|---|---|---|
| PB-01 | Mendaftarkan anggota | Kasir (atas permintaan mahasiswa) | Mahasiswa ingin menjadi anggota |
| PB-02 | Mencatat penjualan | Kasir | Pembeli membayar di kasir |
| PB-03 | Memesan barang ke pemasok | Petugas gudang | Stok di bawah batas minimum |
| PB-04 | Menerima barang dari pemasok | Petugas gudang | Barang datang bersama faktur |
| PB-05 | Menyusun laporan bulanan | Ketua koperasi | Awal bulan |
| PB-06 | Mengelola data pemasok baru dan pembaruan kontak | Petugas gudang | Pengadaan barang dari pemasok baru |

## 3. Dokumen sumber yang dianalisis

1. **Nota penjualan** (Gambar 2.5 modul): nomor nota, tanggal-jam, kasir, anggota, daftar barang beserta qty dan
   harga, subtotal, diskon, total, bayar. *Disimpan*: nomor, tanggal-jam, kasir, anggota, barang, qty, harga satuan,
   bayar. *Dihitung (turunan)*: subtotal per baris, jumlah, diskon, total, kembalian.
2. **Formulir pendaftaran anggota**: NIM, nama, program studi, nomor HP.
3. **Faktur pemasok**: nomor faktur, tanggal, pemasok, barang, qty, harga beli.

## 4. Entitas kandidat dan elemen data

| Entitas kandidat | Elemen data utama | Sumber |
|---|---|---|
| Anggota | nomor anggota, NIM, nama, program studi, nomor HP, status aktif, saldo poin | Formulir pendaftaran |
| Barang | kode, nama, kategori, harga jual, stok, batas minimum stok | Daftar barang, faktur |
| Penjualan | nomor nota, tanggal-jam, kasir, anggota (opsional), bayar, poin didapat, poin ditukar | Nota penjualan |
| Detail penjualan | nomor nota, barang, qty, harga saat transaksi | Nota penjualan |
| Petugas | kode petugas, nama, peran (kasir/gudang/ketua) | Wawancara |
| Pemasok | kode, nama, telepon, alamat | Faktur pemasok |
| Pembelian dan detailnya | nomor faktur, tanggal, pemasok, barang, qty, harga beli | Faktur pemasok |

## 5. Aturan bisnis

| Kode | Aturan bisnis |
|---|---|
| AB-01 | Setiap nota memiliki nomor unik dan minimal satu baris barang. |
| AB-02 | Penjualan boleh tanpa anggota (pembeli umum); jika ada, anggota harus berstatus aktif untuk memperoleh diskon 5%. |
| AB-03 | Stok barang tidak boleh negatif; penjualan ditolak bila qty melebihi stok tersedia. |
| AB-04 | Harga jual yang dipakai pada nota disimpan per baris dan tidak berubah meski harga barang kemudian naik. |
| AB-05 | NIM anggota unik; pencarian anggota dapat dilakukan lewat nomor anggota atau NIM. |
| AB-06 | Pesanan pembelian dibuat bila stok kurang dari batas minimum barang tersebut. |
| AB-07 | Anggota aktif memperoleh 1 poin per kelipatan belanja Rp 10.000 (`FLOOR(total / 10000)`). |
| AB-08 | Penukaran poin minimal 50 poin untuk potongan Rp 5.000 (kelipatan 50 poin) dan ditolak bila melebihi `saldo_poin` anggota. |

## 6. Kebutuhan informasi

| Kode | Kebutuhan informasi | Data yang diperlukan |
|---|---|---|
| KI-01 | Omzet dan jumlah nota per hari dan per bulan | Penjualan, detail penjualan |
| KI-02 | Lima barang terlaris per bulan berdasarkan qty | Detail penjualan, barang |
| KI-03 | Barang dengan stok di bawah batas minimum | Barang |
| KI-04 | Sepuluh anggota dengan belanja terbesar per bulan | Penjualan, detail penjualan, anggota |
| KI-05 | Daftar anggota beserta total poin diperoleh, poin ditukar, dan sisa `saldo_poin` per bulan | Anggota, penjualan |

## 7. Matriks CRUD

| Proses | Anggota | Barang | Penjualan | Detail | Pemasok | Pembelian |
|---|---|---|---|---|---|---|
| PB-01 Daftar & kelola anggota | C, R, U | | | | | |
| PB-02 Catat penjualan | R, U | R, U | C | C | | |
| PB-03 Pesan ke pemasok | | R | | | R | C |
| PB-04 Terima barang | | U | | | R | U |
| PB-05 Laporan bulanan | R | R | R | R | | R |
| PB-06 Kelola data pemasok | | | | | C, R, U | |


## 8. Kamus data awal (cuplikan, dengan penanggung jawab)

| Elemen | Arti | Contoh | Aturan | Penanggung jawab |
|---|---|---|---|---|
| no_anggota | Nomor anggota koperasi | A-0457 | Unik, format A-4 digit | Ketua |
| nim_anggota | NIM anggota | 2301010123 | Unik, 10 digit | Ketua |
| no_hp_anggota | Nomor HP anggota | 0812xxxx | Data pribadi, akses terbatas | Ketua |
| no_nota_penjualan | Nomor nota penjualan | PJ-2609-0142 | Unik per nota | Kasir |
| harga_satuan_detail_penjualan | Harga jual saat transaksi | 4000 | Bilangan bulat ≥ 0 (rupiah) | Kasir |
| stok_barang | Jumlah barang tersedia | 35 | Bilangan bulat ≥ 0 (AB-03) | Petugas gudang |
| saldo_poin_anggota | Sisa saldo poin loyalitas anggota saat ini | 120 | Bilangan bulat >= 0 (AB-07, AB-08) | Ketua |
| poin_didapat_penjualan | Jumlah poin yang diperoleh dari transaksi | 7 | Bilangan bulat >= 0, `FLOOR(total/10000)` | Kasir |
| poin_ditukar_penjualan | Jumlah poin yang ditukarkan untuk potongan | 50 | Kelipatan 50, `<= saldo_poin_anggota` | Kasir |

## 9. Kebutuhan non-fungsional data

- Volume: ±150 nota per hari.
- Retensi: data transaksi disimpan minimal lima tahun.
- Privasi: nomor HP anggota hanya boleh dilihat ketua (data pribadi; UU Pelindungan Data Pribadi).

## 10. Isu kualitas data yang diantisipasi

- Harga berubah-ubah sehingga nota lama tidak bisa diaudit bila harga tidak disimpan per baris (AB-04).
- Stok negatif akibat pencatatan manual (AB-03).
- Anggota ganda/ejaan nama berbeda; dicegah dengan NIM unik (AB-05).
