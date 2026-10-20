# Normalisasi Kopma - Pertemuan 4

- **Nama:** ADILLA BALQIS PUTRI ANTONI
- **NIM:** 25430120
- **Dokumen sumber:** spreadsheet lama Kopma dan nota penjualan (Pertemuan 2)

## Anomali pada spreadsheet lama

| Jenis anomali | Contoh pada spreadsheet lama Kopma | Dampak |
|---|---|---|
| Anomali ubah | Anggota yang sama tertulis "Budi S." pada nota PJ-0142 dan "Budi Santoso" pada nota PJ-0150. Pemasok yang sama tertulis "CV Sumber ATK" dan "CV. Sumber A.T.K". | Satu fakta tertulis di banyak baris dan bisa tidak konsisten, sehingga laporan per anggota atau per pemasok terpecah. |
| Anomali sisip | Barang baru tidak dapat dicatat sebelum ada penjualannya, karena barang hanya muncul sebagai isi baris nota. | Barang yang sudah dibeli dari pemasok tetapi belum terjual tidak punya tempat di spreadsheet. |
| Anomali hapus | Menghapus nota PJ-0143 ikut menghapus informasi pemasok UD Segar, karena nota itu satu-satunya baris yang memuatnya. | Menghapus satu fakta (nota) membuat fakta lain (pemasok) hilang. |

## Dependensi fungsional

Dependensi ditulis dari aturan bisnis Pertemuan 2, bukan dari isi spreadsheet. Nama kolom mengikuti kamus data saya (misalnya tanggal_penjualan dan batas_minimum_barang), sedangkan buku memakai tgl_penjualan dan stok_min_barang.

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

Dua dependensi yang sengaja tidak ditulis karena salah:

| Dependensi yang salah | Mengapa salah |
|---|---|
| kode_barang -> harga_satuan_detail_penjualan | AB-04: harga pada nota dapat berbeda dari harga barang saat ini. Meskipun contoh data pulpen selalu Rp4.000, contoh data hanya dapat membantah dependensi, tidak dapat membuktikannya. |
| nama_anggota -> no_anggota | Dua anggota berbeda dapat memiliki nama yang sama, sehingga nama tidak menentukan nomor anggota. |

## Tahapan UNF, 1NF, 2NF, dan 3NF

Tanda * menandakan kunci tamu. bayar_penjualan muncul di tahap 3NF sebagai data yang memang dicatat pada nota (uang yang dibayarkan), bukan nilai turunan.

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

## Pemeriksaan BCNF

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

## Keputusan nilai turunan

| Nilai turunan | Rumus | Keputusan | Alasan |
|---|---|---|---|
| subtotal_detail_penjualan | qty x harga satuan saat transaksi | Dihitung, tidak disimpan | Kedua masukannya sudah tersimpan di baris yang sama, sehingga nilai yang disimpan hanya menambah risiko tidak sinkron. |
| jumlah_penjualan | jumlah semua subtotal pada satu nota | Dihitung, tidak disimpan | Selalu dapat diturunkan dari detail_penjualan. |
| diskon_penjualan | 5% dari jumlah bila anggota berstatus aktif | Dihitung, tidak disimpan | Mengikuti AB-02. Catatan: karena status anggota bisa berubah setelah nota dibuat, arsip historis (Buku 2) perlu membekukan nilainya. |
| total_penjualan | jumlah dikurangi diskon | Dihitung, tidak disimpan | Turunan dari dua nilai di atas. |

## Pencocokan dengan skema kanonik Kopma

Skema 3NF di atas dicocokkan dengan Tabel 4.2 buku. Perbedaan utama adalah kunci pengganti id_* sebagai kunci primer, sedangkan kode alami seperti no_nota_penjualan menjadi kunci unik.

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

