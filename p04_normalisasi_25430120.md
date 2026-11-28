# Normalisasi Proyek - Perpustakaan Cendekia ABPA - Adilla Balqis Putri Antoni (25430120)

## Ketentuan minimum - centang saat terpenuhi
- [x] Satu dokumen sumber dari Pertemuan 2 dijadikan titik awal UNF
- [x] Dependensi fungsional **beserta kode AB** yang mendasarinya
- [x] Tahapan 1NF, 2NF, 3NF ditunjukkan, plus hasil pemeriksaan BCNF
- [x] Keputusan menyimpan/menghitung **setiap** nilai turunan, dengan alasan
- [x] ERD proyek diperbarui bila perlu; perubahan dicatat di bagian 7 dan di pesan commit

## 1. Dokumen sumber & relasi UNF
Dokumen sumber yang dijadikan titik awal normalisasi adalah **Dokumen 1: Slip Transaksi Peminjaman & Pengembalian Buku** pada **Perpustakaan Cendekia ABPA** (dari Pertemuan 2).

text
SLIP_TRANSAKSI_UNF (
  no_transaksi_peminjaman, tanggal_pinjam_peminjaman, batas_kembali_peminjaman, tanggal_kembali_peminjaman,
  id_anggota_anggota, nama_lengkap_anggota, kategori_anggota_anggota,
  id_petugas_petugas, nama_petugas_petugas,
  { kode_eksemplar_eksemplar_buku, id_buku_buku, judul_buku_buku, kondisi_kembali },
  jumlah_buku_dipinjam, keterlambatan_hari, tarif_denda_harian, total_denda,
  no_denda_denda, status_pembayaran_denda
)

## 2. Tahap 1NF
Menghilangkan grup berulang { kode_eksemplar_eksemplar_buku, id_buku_buku, judul_buku_buku, kondisi_kembali } dengan memecahnya menjadi satu baris per item eksemplar buku per transaksi, serta menghilangkan atribut turunan murni (jumlah_buku_dipinjam, keterlambatan_hari, total_denda) ke dalam catatan evaluasi nilai turunan (Bagian 6).

* *Kunci Komposit 1NF:* (no_transaksi_peminjaman, kode_eksemplar_eksemplar_buku)
text
SLIP_TRANSAKSI_1NF (
  no_transaksi_peminjaman (PK),
  kode_eksemplar_eksemplar_buku (PK),
  tanggal_pinjam_peminjaman,
  batas_kembali_peminjaman,
  tanggal_kembali_peminjaman,
  id_anggota_anggota,
  nama_lengkap_anggota,
  kategori_anggota_anggota,
  id_petugas_petugas,
  nama_petugas_petugas,
  id_buku_buku,
  judul_buku_buku,
  kondisi_kembali,
  no_denda_denda,
  tarif_denda_harian,
  status_pembayaran_denda
)

## 3. Dependensi fungsional

| FD | Dependensi | Dasar (AB-xx) |
|---|---|---|
| FD1 | no_transaksi_peminjaman -> tanggal_pinjam_peminjaman, batas_kembali_peminjaman, tanggal_kembali_peminjaman, id_anggota_anggota, id_petugas_petugas | AB-01, AB-05 (Satu nomor transaksi peminjaman mencatat satu waktu peminjaman, satu anggota peminjam, dan satu petugas layanan) |
| FD2 | id_anggota_anggota -> nama_lengkap_anggota, kategori_anggota_anggota | AB-01 (Setiap anggota terdaftar memiliki satu identitas unik yang menentukan nama dan kategori keanggotaannya) |
| FD3 | id_petugas_petugas -> nama_petugas_petugas | AB-08 (Setiap petugas perpustakaan diidentifikasi oleh kode petugas unik) |
| FD4 | kode_eksemplar_eksemplar_buku -> id_buku_buku | AB-03 (Setiap kode eksemplar fisik adalah unik dan merujuk pada tepat satu judul buku katalog) |
| FD5 | id_buku_buku -> judul_buku_buku | AB-03 (Satu kode katalog judul buku menentukan satu judul buku resmi) |
| FD6 | (no_transaksi_peminjaman, kode_eksemplar_eksemplar_buku) -> kondisi_kembali | AB-02, AB-04 (Kondisi fisik saat dikembalikan bergantung penuh pada kombinasi transaksi peminjaman dan eksemplar buku yang dipinjam) |
| FD7 | no_transaksi_peminjaman -> no_denda_denda, tarif_denda_harian, status_pembayaran_denda | AB-06 (Tagihan denda keterlambatan pada slip transaksi terikat pada nomor transaksi peminjaman dan tarif harian yang berlaku saat transaksi) |

## 4. Tahap 2NF
Memisahkan atribut yang hanya bergantung pada **sebagian kunci komposit** '(no_transaksi_peminjaman, kode_eksemplar_eksemplar_buku)' berdasarkan FD1, FD4, dan FD7 agar tidak terjadi dependensi persial:
1. *PEMINJAMAN* (dari FD1)
   no_transaksi_peminjaman (PK), tanggal_pinjam_peminjaman, batas_kembali_peminjaman, tanggal_kembali_peminjaman, id_anggota_anggota, nama_lengkap_anggota, kategori_anggota_anggota, id_petugas_petugas, nama_petugas_petugas
2. *DETAIL_PEMINJAMAN* (dari FD6 - kunci komposit penuh)
   no_transaksi_peminjaman (PK, FK), kode_eksemplar_eksemplar_buku (PK, FK), kondisi_kembali
3. *EKSEMPLAR_BUKU* (dari FD4)
   kode_eksemplar_eksemplar_buku (PK), id_buku_buku, judul_buku_buku
4. *DENDA* (dari FD7)
   no_denda_denda (PK), no_transaksi_peminjaman (FK), tarif_denda_harian, status_pembayaran_denda

## 5. Tahap 3NF
Menghilangkan *dependensi transitif* pada tabel hasil 2NF berdasarkan FD2, FD3, dan FD5:
* Pada PEMINJAMAN: no_transaksi_peminjaman -> id_anggota_anggota -> (nama_lengkap_anggota, kategori_anggota_anggota) dan no_transaksi_peminjaman -> id_petugas_petugas -> nama_petugas_petugas.
* Pada EKSEMPLAR_BUKU: kode_eksemplar_eksemplar_buku -> id_buku_buku -> judul_buku_buku.

Skema akhir yang sudah memenuhi *3NF*:
1. *ANGGOTA* (id_anggota_anggota (PK), nama_lengkap_anggota, kategori_anggota_anggota)
2. *PETUGAS* (id_petugas_petugas (PK), nama_petugas_petugas)
3. *BUKU* (id_buku_buku (PK), judul_buku_buku)
4. *EKSEMPLAR_BUKU* (kode_eksemplar_eksemplar_buku (PK), id_buku_buku (FK))
5. *PEMINJAMAN* (no_transaksi_peminjaman (PK), id_anggota_anggota (FK), id_petugas_petugas (FK), tanggal_pinjam_peminjaman, batas_kembali_peminjaman, tanggal_kembali_peminjaman)
6. *DETAIL_PEMINJAMAN* (no_transaksi_peminjaman (PK, FK), kode_eksemplar_eksemplar_buku (PK, FK), kondisi_kembali)
7. *DENDA* (no_denda_denda (PK), no_transaksi_peminjaman (FK), tarif_denda_harian, status_pembayaran_denda)

(Catatan: Entitas RESERVASI dari kebutuhan data P02 tetap dipertahankan dalam basis data untuk mendukung proses bisnis PB-03 meskipun tidak tercetak pada Slip Transaksi Peminjaman).

## 6. Pemeriksaan BCNF dan nilai turunan

| Tabel | Penentu | Kunci kandidat? | Hasil |
|---|---|---|---|
| ANGGOTA | id_anggota_anggota | Ya | Memenuhi BCNF |
| PETUGAS | id_petugas_petugas | Ya | Memenuhi BCNF |
| BUKU | id_buku_buku | Ya | Memenuhi BCNF |
| EKSEMPLAR_BUKU | kode_eksemplar_eksemplar_buku | Ya | Memenuhi BCNF |
| PEMINJAMAN | no_transaksi_peminjaman | Ya | Memenuhi BCNF |
| DETAIL_PEMINJAMAN | (no_transaksi_peminjaman, kode_eksemplar_eksemplar_buku) | Ya | Memenuhi BCNF |
| DENDA | no_denda_denda, no_transaksi_peminjaman | Ya (keduanya unik per transaksi denda) | Memenuhi BCNF |
| Nilai turunan | Disimpan / dihitung | Alasan |
|---|---|---|
| jumlah_buku_dipinjam | *Dihitung* | Dapat langsung dihitung secara akurat menggunakan fungsi agregasi COUNT(kode_eksemplar_eksemplar_buku) per no_transaksi_peminjaman pada tabel DETAIL_PEMINJAMAN tanpa perlu disimpan fisik. |
| keterlambatan_hari | *Dihitung* | Merupakan selisih hari DATEDIFF(tanggal_kembali_peminjaman, batas_kembali_peminjaman) (jika bernilai > 0) yang selalu konsisten dengan tanggal transaksi. |
| tarif_denda_harian | *Disimpan* | Disimpan pada tabel DENDA sebagai potret historis tarif saat pelanggaran terjadi agar kenaikan tarif denda di masa depan tidak mengubah nilai tagihan denda lama. |
| total_denda (dan nominal_bayar) | *Dihitung* (untuk tampilan slip), *Disimpan* pada nominal_bayar saat pelunasan | Total tagihan dihitung dari jumlah_buku_dipinjam * keterlambatan_hari * tarif_denda_harian, sedangkan nominal yang dibayarkan disimpan di DENDA sebagai arsip keuangan yang sah. |

## 7. Catatan perubahan ERD
Tidak ada perubahan struktur entitas utama pada ERD Pertemuan 3 (p03_erd_25430120), karena hasil normalisasi hingga 3NF dan BCNF dari dokumen slip transaksi menghasilkan 7 tabel utama (ANGGOTA, PETUGAS, BUKU, EKSEMPLAR_BUKU, PEMINJAMAN, DETAIL_PEMINJAMAN, DENDA) yang sudah selaras sepenuhnya dengan rancangan entitas dan atribut pada ERD Pertemuan 3 (ditambah entitas RESERVASI untuk proses bisnis reservasi).
