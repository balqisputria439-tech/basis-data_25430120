# Normalisasi Kopma - Adilla Balqis Putri Antoni (25430120)

## 1. Anomali pada spreadsheet lama
Masalah nyata dari cerita pertemuan: nama anggota sama ditulis dua cara (anomali **ubah**), ejaan pemasok
berubah-ubah, dan harga pulpen berbeda pada bulan yang sama. Anomali **sisip**/**hapus** diamati pada Gambar 4.1 modul.

## 2. UNF → 1NF

```
NOTA_UNF (no_nota_penjualan, tgl_penjualan, kode_petugas, nama_petugas, no_anggota, nama_anggota,
          { kode_barang, nama_barang, qty_detail_penjualan, harga_satuan_detail_penjualan,
            subtotal_detail_penjualan },
          jumlah_penjualan, diskon_penjualan, total_penjualan)

NOTA_1NF (no_nota_penjualan, kode_barang, tgl_penjualan, kode_petugas, nama_petugas, no_anggota,
          nama_anggota, nama_barang, qty_detail_penjualan, harga_satuan_detail_penjualan,
          subtotal_detail_penjualan, jumlah_penjualan, diskon_penjualan, total_penjualan)
          -- kunci primer komposit: (no_nota_penjualan, kode_barang)
```

## 3. Dependensi fungsional (diturunkan dari aturan bisnis)

| FD | Dependensi | Dasar |
|---|---|---|
| FD1 | no_nota_penjualan → tgl_penjualan, kode_petugas, no_anggota | AB-01 |
| FD2 | kode_petugas → nama_petugas | satu kode = satu petugas |
| FD3 | no_anggota → nama_anggota | AB-05 |
| FD4 | kode_barang → nama_barang | kode barang unik |
| FD5 | (no_nota_penjualan, kode_barang) → qty_detail_penjualan, harga_satuan_detail_penjualan | AB-04 |
| FD6 | qty_detail_penjualan, harga_satuan_detail_penjualan → subtotal_detail_penjualan | turunan |

## 4. 2NF
FD1 dan FD4 hanya bergantung pada **sebagian** kunci komposit → dipisah:
`penjualan` (kunci no_nota_penjualan), `barang` (kunci kode_barang), sisanya menjadi `detail_penjualan`.

## 5. 3NF
Di `penjualan` ada rantai no_nota_penjualan → kode_petugas → nama_petugas dan
no_nota_penjualan → no_anggota → nama_anggota → `petugas` dan `anggota` dipisah.

## 6. Nilai turunan
`subtotal_detail_penjualan`, `jumlah_penjualan`, `diskon_penjualan`, dan `total_penjualan` **tidak disimpan** di
tabel operasional (dihitung dari detail + status anggota), sehingga tidak mungkin tidak konsisten.

## 7. Skema hasil 3NF (garis bawah = PK, `*` = FK)

```
PENJUALAN (no_nota_penjualan, tgl_penjualan, kode_petugas*, no_anggota*, bayar_penjualan)
DETAIL_PENJUALAN (no_nota_penjualan*, kode_barang*, qty_detail_penjualan, harga_satuan_detail_penjualan)
BARANG (kode_barang, nama_barang, kategori_barang, harga_jual_barang, stok_barang, stok_min_barang)
PETUGAS (kode_petugas, nama_petugas, peran_petugas)
ANGGOTA (no_anggota, nim_anggota, nama_anggota, prodi_anggota, no_hp_anggota, status_anggota, tgl_daftar_anggota)
```

## 8. Skema kanonik (acuan seluruh buku)

| Tabel | Kunci primer | Kunci unik | Kunci tamu |
|---|---|---|---|
| petugas | id_petugas | kode_petugas | – |
| anggota | id_anggota | no_anggota, nim_anggota | – |
| barang | id_barang | kode_barang | – |
| pemasok | id_pemasok | – | – |
| penjualan | id_penjualan | no_nota_penjualan | id_petugas, id_anggota (boleh NULL) |
| detail_penjualan | (id_penjualan, id_barang) | – | id_penjualan, id_barang |
| pembelian | id_pembelian | – | id_pemasok |
| detail_pembelian | (id_pembelian, id_barang) | – | id_pembelian, id_barang |

## 9. Pemeriksaan BCNF per tabel

> **ISI SENDIRI.** Panduan: untuk **tiap** tabel di bagian 8, tulis semua penentu (ruas kiri FD) pada tabel
> itu, lalu tanyakan: "apakah penentu ini kunci kandidat?" (kunci kandidat = PK **atau** kolom UNIQUE).
> Contoh pola jawaban: *"Tabel anggota: penentu id_anggota, no_anggota, nim_anggota - ketiganya kunci kandidat → BCNF."*
> Ingat Troubleshooting 3: kunci pengganti tidak menghapus FD, jadi uji juga dengan kunci alami.

| Tabel | Penentu | Kunci kandidat? | Hasil |
|---|---|---|---|
| petugas | ISI SENDIRI | | |
| anggota | | | |
| barang | | | |
| pemasok | | | |
| penjualan | | | |
| detail_penjualan | | | |
| pembelian | | | |
| detail_pembelian | | | |
