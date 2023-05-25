# Pokemon-App

# Guidelines
Funios Morroc Group 7 Final Project Guidelines.

## Resource
Design = [Figma](https://www.figma.com/file/NLtwysGbxZxcHMryM95w0P/Untitled?node-id=206%3A1404)
Pokemon API = [API](https://docs.pokemontcg.io/)

### Code guidelines
1. Gunakan XiB, Storyboard dan Programatically (Setidaknya harus ada 1 view dari setiap jenis).
2. Minimal gunakan MVC Pattern, setidaknya sudah memisahkan `Data Loader/Sejenisnya` ke Class yang berbeda (Diperbolehkan menggunakan Pattern lain).
3. Variable and Type naming
    - UpperCamelCase untuk (classes, structures, enumerations, and protocols) `eg; class FeedViewController`
    - lowerCamelCase untuk (variable, IBOutlet, IBAction dan lainnya)  dan lainnya `eg; let titleLabel: UILabel`
4. Jangan buat `GOD` class/function selalu pisahkan responsibility yang dapat kalian pisahkan kesebuah function atau class/struct yang berbeda. `Always aim for clean and readable code.`
5. Pastikan tidak ada variable/function/class/dll yang ambigu, selalu beri variable/context yang jelas pada kodingan kalian.
6. Selalu perhatikan pengunaan memory `No Retain Cycles, No Memory Leaks, No Strong References`. Use `[weak self]` and Memory debug to make sure there is no leaks.
7. Pastikan menghandle 3 state ini 
    -  Loading -> Show Loading
    -  Success -> Show Data
    -  Failed -> Show Error <- Selalu tampilkan error yang jelas jangan tampilkan pesan error yang ambigu.
8. `Jangan` buat dan gunakan `Singleton`
9. `Jangan` pakai 3rd Party library baik itu SPM/PODS
