# Panduan Kerja: VS Code + Git + MariaDB (Pertemuan 1-6)

Dokumen ini hanya untuk kamu (boleh tidak di-commit; hapus dari repositori jika dosen tidak memintanya).

## A. Sekali saja: menyiapkan VS Code

1. Pasang **Visual Studio Code**.
2. Buka folder repositori: `File > Open Folder... > basisdata-<NIM>`.
3. Ekstensi yang berguna (Ctrl+Shift+X):
   - **Markdown All in One** (opsional; pratinjau bawaan sudah cukup).
   - **SQL Tools** + driver MySQL/MariaDB, **atau** cukup edit `.sql` lalu jalankan lewat terminal (cara di bagian C).
4. Terminal bawaan: `` Ctrl+` ``. Pilih profil **Command Prompt** agar perintah `mysql` mengenali PATH
   (lihat Panduan Instalasi, Langkah 2). Jika PATH tidak bisa diubah, pakai tombol **Shell** di XAMPP Control Panel.
5. Jalankan `python siapkan.py --nim <NIM> --nama "<Nama>" --kelas "<Kelas>"` **sekali** untuk mengisi identitas.

## B. Menulis laporan Markdown

- Satu laporan per pertemuan: `laporan/pNN_laporan_<NIM>.md`.
- Pratinjau: **Ctrl+Shift+V** (atau Ctrl+K lalu V untuk berdampingan).
- Gambar: simpan di `laporan/img/`, tanpa spasi pada nama, huruf besar/kecil harus sama persis
  (GitHub membedakannya). Sintaks: `![keterangan](img/p01_versi.png)`
- Screenshot di Windows: **Win+Shift+S**. **Pastikan terlihat**: nama akun (`mhs_<3d>` / `dev_<3d>`) dan **jam sistem Windows**.
  Screenshot tanpa identitas tidak dinilai.

## C. Menjalankan berkas .sql dari VS Code/terminal

```bat
:: dari folder repositori
mysql -u mhs_120 -p kopma_120 < p05_ddl_kopma_25430120.sql
```

Atau masuk interaktif lalu `source`:

```bat
mysql -u mhs_120 -p
MariaDB [(none)]> USE kopma_120;
MariaDB [kopma_120]> source p05_ddl_kopma_25430120.sql
```

Untuk menyimpan **keluaran kueri sebagai teks** (diminta laporan): `mysql ... --table < berkas.sql > hasil.txt`.

## D. Rutinitas Git tiap pertemuan

```bat
git status
git add .
git commit -m "pNN: deskripsi singkat"
git push
git log --oneline -5          :: salin hash commit ke bagian "Bukti Git" di laporan
```

Format pesan commit: `p01: inisialisasi repositori dan skrip lingkungan`, `p02: dokumen kebutuhan data kopma`, dst.
Minimal **satu commit bermakna per pertemuan**; jangan menumpuk di akhir semester.

## E. Daftar periksa sebelum push

- [ ] Tidak ada password asli di berkas mana pun (`git grep -i "password"` untuk memeriksa).
- [ ] Skrip `.sql` bisa dijalankan ulang dari basis data kosong.
- [ ] Pratinjau Markdown menampilkan gambar & tabel dengan benar.
- [ ] Checklist di akhir laporan dicentang **hanya** untuk yang benar-benar ada di repositori.
- [ ] Bagian "Pernyataan Penggunaan AI" diisi jujur.
