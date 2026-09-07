// Abstract Class
abstract class Produk {
  int id, stok;
  String nama;
  double harga;

  Produk(this.id, this.nama, this.harga, this.stok);

  String deskripsi();
}

// Mixin (FIX ERROR)
mixin BisaDiskon on Produk {
  double hitungHargaDiskon(double persen) =>
      harga - (harga * persen / 100);

  bool validasiDiskon(double persen) =>
      persen >= 0 && persen <= 100;
}

// Produk Digital
class ProdukDigital extends Produk with BisaDiskon {
  double ukuranMB;
  String formatFile;

  ProdukDigital(
      super.id,
      super.nama,
      super.harga,
      super.stok,
      this.ukuranMB,
      this.formatFile);

  @override
  String deskripsi() => "$nama ($formatFile, ${ukuranMB}MB)";
}

// Produk Fisik
class ProdukFisik extends Produk with BisaDiskon {
  double beratGram;
  String dimensi;

  ProdukFisik(
      super.id,
      super.nama,
      super.harga,
      super.stok,
      this.beratGram,
      this.dimensi);

  @override
  String deskripsi() => "$nama (${beratGram}g, $dimensi)";
}

// Custom Exception
class StokHabisException implements Exception {
  @override
  String toString() => "Stok produk habis!";
}

class ProdukTidakAda implements Exception {
  @override
  String toString() => "Produk tidak ditemukan!";
}

// Keranjang
class Keranjang {
  List<Produk> daftar = [];

  void tambah(Produk p) {
    if (p.stok <= 0) throw StokHabisException();
    daftar.add(p);
    p.stok--;
  }

  void hapus(Produk p) {
    if (!daftar.remove(p)) throw ProdukTidakAda();
    p.stok++;
  }

  double totalHarga() =>
      daftar.fold(0, (total, p) => total + p.harga);
}

// Service Async
class TokoService {
  List<Produk> produk;

  TokoService(this.produk);

  Future<Produk> cariProduk(String nama) async {
    await Future.delayed(Duration(seconds: 1));

    try {
      return produk.firstWhere(
          (p) => p.nama.toLowerCase() == nama.toLowerCase());
    } catch (_) {
      throw ProdukTidakAda();
    }
  }

  Future<void> prosesCheckout(Keranjang k) async {
    await Future.delayed(Duration(seconds: 1));

    if (k.daftar.isEmpty) throw ProdukTidakAda();

    print("Checkout berhasil!");
    print("Total Bayar: Rp${k.totalHarga()}");
  }
}

// Main Program
void main() async {
  var ebook =
      ProdukDigital(1, "Ebook Dart", 50000, 5, 15, "PDF");
  var keyboard =
      ProdukFisik(2, "Keyboard", 300000, 2, 700, "40x15x5 cm");

  var toko = TokoService([ebook, keyboard]);
  var keranjang = Keranjang();

  try {
    print(ebook.deskripsi());
    print(keyboard.deskripsi());

    var p = await toko.cariProduk("Ebook Dart");
    keranjang.tambah(p);

    print("Total Harga: Rp${keranjang.totalHarga()}");

    if (ebook.validasiDiskon(10)) {
      print("Harga Diskon 10%: Rp${ebook.hitungHargaDiskon(10)}");
    }

    await toko.prosesCheckout(keranjang);
  } catch (e) {
    print("Error: $e");
  }

  // Contoh Produk Tidak Ada
  try {
    await toko.cariProduk("Laptop");
  } catch (e) {
    print("Error Cari Produk: $e");
  }

  // Contoh Stok Habis
  try {
    var mouse =
        ProdukFisik(3, "Mouse", 100000, 0, 200, "10x5x3 cm");
    keranjang.tambah(mouse);
  } catch (e) {
    print("Error Stok: $e");
  }
}