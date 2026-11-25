#!/usr/bin/env python3
"""
siapkan.py - mengisi identitas ke seluruh berkas template (jalankan SEKALI).

Pemakaian (di folder basisdata-<NIM>):
    python siapkan.py --nim 2301010123 --nama "Nama Lengkap" --kelas "3A"

Yang dilakukan:
  1. Mengganti penanda __NIM__, __3D__, __NAMA__, __KELAS__, __TEMA__, __P__ di isi berkas.
  2. Mengganti nama berkas/folder yang memuat __NIM__.
  3. Menampilkan tema proyek dan parameter P hasil hitungan dari NIM kamu.
Jika Python tidak ada: pakai VS Code -> Ctrl+Shift+H (cari di semua berkas) dan ganti penanda satu per satu.
"""
import argparse, os, sys

TEMA = [(0, 24, "perpus", "Perpustakaan"), (25, 49, "klinik", "Klinik"),
        (50, 74, "toko", "Toko daring"), (75, 99, "akad", "Akademik")]
EXT = (".md", ".sql", ".py", ".txt", ".gitignore", ".mmd")

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--nim", required=True)
    ap.add_argument("--nama", required=True)
    ap.add_argument("--kelas", required=True)
    a = ap.parse_args()
    if not (a.nim.isdigit() and len(a.nim) >= 3):
        sys.exit("NIM harus berupa angka (minimal 3 digit).")
    d2 = int(a.nim[-2:])
    kode, nama_tema = next((k, n) for lo, hi, k, n in TEMA if lo <= d2 <= hi)
    P = (d2 % 9) + 1
    sub = {"__NIM__": a.nim, "__3D__": a.nim[-3:], "__NAMA__": a.nama,
           "__KELAS__": a.kelas, "__TEMA__": kode, "__TEMA_NAMA__": nama_tema,
           "__P__": str(P)}
    root = os.path.dirname(os.path.abspath(__file__))
    me = os.path.abspath(__file__)
    # 1) isi berkas
    for dp, dn, fn in os.walk(root):
        if ".git" in dp.split(os.sep):
            continue
        for f in fn:
            p = os.path.join(dp, f)
            if p == me or not (f.endswith(EXT) or f == ".gitignore"):
                continue
            with open(p, encoding="utf-8") as fh:
                t = fh.read()
            for k, v in sub.items():
                t = t.replace(k, v)
            with open(p, "w", encoding="utf-8", newline="\n") as fh:
                fh.write(t)
    # 2) nama berkas (bottom-up)
    for dp, dn, fn in os.walk(root, topdown=False):
        for n in fn + dn:
            if "__NIM__" in n:
                os.rename(os.path.join(dp, n), os.path.join(dp, n.replace("__NIM__", a.nim)))
    print(f"Tema proyek      : {nama_tema} (kode_tema = {kode})")
    print(f"Basis data proyek: {kode}_{a.nim[-3:]}   akun: dev_{a.nim[-3:]}")
    print(f"P = ({d2} mod 9) + 1 = {P}")
    print(f"  batas item per transaksi (P+2)       = {P+2}")
    print(f"  diskon/denda harian (ribu rupiah)    = {P}")
    print(f"  perkiraan volume harian (40+5P)      = {40+5*P}")
    print(f"  minimal baris transaksi utama (10xP) = {10*P}")
    print("Selesai. Aman dijalankan lagi saat menambah modul baru (hanya penanda yang tersisa yang diganti).")

if __name__ == "__main__":
    main()
