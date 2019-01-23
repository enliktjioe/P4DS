# Data Visualization
#### 21 Januari 2018

## Manipulasi Data
1. `str(df)`. Jika ada tipe data yang kurang sesuai, maka perlu dirubah. ada
beberapa macam explicit coerc.
2. `as.Date()`, jangan lupa pisahkan separator yang sesuai dan diurutkan dengan
record tanggal.
ex: `as.Date(x, format = "%Y-%m%-d")`
3. %Y untuk tahun 4 angka
4  %y untuk tahun 2 angka
5. %m untuk bulan 2 angka
6. %b bulan huruf
7. %d untuk tanggal
8. `as.numeric()`, untuk konversi tipe data ke numerik.
9. `as.character()` konversi tipe data karakter.
10. `as.factor()` dan lain-lainnya. faktor cocok digunakan untuk observasi data
row yang berulang.
11. packages `lubridate` untuk manipulasi data date.
12. `ydm_hms()` `ymd_hms()` `ydm()` `ymd()`. Kemudahan lubridate, kita hanya
perlu mengatur urutan record tanggalnya.
tidak perlu mengatur separatornya.
13. `weekdays(date)` untuk mengekstrak hari dari data Date
14. `month(date)` untuk mengekstrak bulan.
15. `year(date)` untuk tahun.

## Fungsi bawaan plot pada R

16. `Plot(,)` ketika ada sebuah input numerik dan kategorik (faktor) maka
 otomatis dihasilkan boxplot.
17. `plot(,)` ketika ada input numerik dan numerik, secara otomatis membuat
plot scatter plot.
