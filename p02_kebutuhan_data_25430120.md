# Dokumen Kebutuhan Data - <ISI: nama organisasi fiktif proyekmu>

Penyusun: Adilla Balqis Putri Antoni (25430120) · Tema: Perpustakaan

> **Cara memakai berkas ini.** Semua teks bertanda `ISI SENDIRI` harus kamu tulis dari organisasi
> fiktifmu (lihat README). Hapus semua kotak panduan (`> **Panduan**`) sebelum commit akhir.
> Contoh Kopma di `p02_kebutuhan_data_kopma_25430120.md` boleh dijadikan **model bentuk**, bukan disalin isinya.

## Ketentuan minimum (dari modul) - centang saat terpenuhi

- [ ] ≥ 4 proses bisnis · [ ] ≥ 6 entitas kandidat · [ ] ≥ 8 aturan bisnis · [ ] ≥ 5 kebutuhan informasi
- [ ] Matriks CRUD lengkap (tidak ada entitas tanpa huruf C, kecuali dijelaskan)
- [ ] Kamus data ≥ 20 elemen, ada kolom penanggung jawab
- [ ] Kebutuhan non-fungsional, termasuk data pribadi dan siapa boleh mengakses
- [ ] ≥ 1 dokumen sumber fiktif rancanganmu sendiri + pembedahannya
- [ ] Perhitungan P ada di bagian 9

## 1. Latar belakang dan aktivitas organisasi
ISI SENDIRI.

> **Panduan**: kembangkan paragraf README. Tulis siapa pelakunya, apa yang mereka lakukan sehari-hari, dan
> 2-3 "keluhan" bergaya kutipan wawancara (seperti ketua/gudang/kasir di Kopma) yang memicu kebutuhan data.
> Tiap keluhan sebaiknya nanti terlacak ke satu aturan bisnis atau kebutuhan informasi.

## 2. Aktor dan proses bisnis

| Kode | Proses bisnis | Aktor | Pemicu |
|---|---|---|---|
| PB-01 | ISI SENDIRI | | |
| PB-02 | | | |
| PB-03 | | | |
| PB-04 | | | |

> **Panduan**: tandai kata kerja di narasimu (langkah D.2 modul). Satu proses = satu kegiatan oleh satu aktor
> dengan satu pemicu jelas. Jangan lupa proses *pemeliharaan data* (mis. "mengelola data X") supaya matriks CRUD
> tidak punya entitas yatim (Troubleshooting Modul 2, masalah 4).

## 3. Dokumen sumber yang dianalisis
ISI SENDIRI - minimal satu dokumen fiktif rancanganmu (formulir/nota/slip/laporan).

> **Panduan**: sertakan gambar atau tabel dokumennya, lalu bedah seperti nota Kopma: kolom *disimpan* vs
> *dihitung (turunan)*. Titik awal per tema ada di Tabel 2.8 modul (cek baris tema Perpustakaan, termasuk
> "perhatian khusus"-nya).

## 4. Entitas kandidat dan elemen data

| Entitas kandidat | Elemen data utama | Sumber |
|---|---|---|
| ISI SENDIRI | | |

> **Panduan**: entitas = **kata benda/kejadian yang dicatat**, bukan kata kerja ("Peminjaman", bukan "Meminjam").

## 5. Aturan bisnis

| Kode | Aturan bisnis |
|---|---|
| AB-01 | ISI SENDIRI |

> **Panduan**: minimal 8. Wajib ada satu aturan **batas maksimal item per transaksi = P + 2 = 3 + 2**
> dan satu aturan **diskon/denda harian Rp 3.000** (lihat bagian 9). Tulis dalam bentuk yang bisa diuji
> ("ditolak bila ..."), karena AB-xx akan dirujuk sampai Modul 14.

## 6. Kebutuhan informasi

| Kode | Kebutuhan informasi | Data yang diperlukan |
|---|---|---|
| KI-01 | ISI SENDIRI | |

> **Panduan**: minimal 5, dalam bentuk pertanyaan yang pada akhirnya dijawab SELECT (ranking, total per
> periode, daftar yang melewati batas, dst).

## 7. Matriks CRUD
ISI SENDIRI - baris = proses PB, kolom = entitas.

## 8. Kamus data awal (≥ 20 elemen)

| Elemen | Arti | Contoh | Aturan | Penanggung jawab |
|---|---|---|---|---|
| ISI SENDIRI | | | | |

> **Panduan**: pakai pola penamaan buku: `nama_atribut_entitas` (mis. `harga_satuan_detail_penjualan`).
> Tandai kolom yang berisi data pribadi di kolom Aturan.

## 9. Kebutuhan non-fungsional data

**Perhitungan parameter P (wajib tampil):**

- 2 digit terakhir NIM = ISI SENDIRI → P = (2 digit terakhir mod 9) + 1 = **3**
- Batas maksimal item per transaksi = P + 2 = **ISI SENDIRI**
- Diskon/denda harian = P ribu rupiah = **ISI SENDIRI**
- Perkiraan volume transaksi harian = 40 + 5 × P = **ISI SENDIRI**

> **Panduan**: (a) tulis angka yang kamu hitung sendiri, lalu cocokkan dengan keluaran `siapkan.py`
> (P hasil skrip = 3). (b) Tambahkan retensi data dan **daftar data pribadi + siapa yang boleh melihat**
> (tema klinik: data kesehatan bersifat spesifik, akses sangat terbatas).

## 10. Isu kualitas data yang diantisipasi
ISI SENDIRI.
