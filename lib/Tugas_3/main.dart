import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const TiketApp());
}

class TiketApp extends StatelessWidget {
  const TiketApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simulasi Pemesanan Tiket',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF3B5BFD),
        scaffoldBackgroundColor: const Color(0xFFF5F6FB),
      ),
      home: const HomePage(),
    );
  }
}

// =====================================================================
// MODEL (OOP) — abstract class, inheritance, mixin
// =====================================================================

/// Abstract class dasar untuk seluruh jenis tiket.
abstract class Tiket {
  final String nama;
  final double harga;
  Tiket(this.nama, this.harga);

  /// Setiap subclass WAJIB punya deskripsi masing-masing.
  String deskripsi();

  IconData get ikon;
  Color get warna;
}

/// Mixin yang menambahkan kemampuan menghitung harga diskon.
/// Bisa dipakai (with) oleh subclass tiket manapun yang butuh fitur ini.
mixin BisaDiskon {
  double hitungHargaDiskon(double harga, double persen) {
    if (persen < 0 || persen > 100) {
      throw ArgumentError('Persentase diskon harus di antara 0-100');
    }
    return harga - (harga * persen / 100);
  }
}

/// Subclass 1: Tiket Ekonomi — tidak memakai mixin diskon.
class TiketEkonomi extends Tiket {
  TiketEkonomi(super.nama, super.harga);

  @override
  String deskripsi() =>
      'Kelas ekonomi dengan kursi standar. Pilihan hemat untuk perjalanan '
      'tanpa mengurangi kenyamanan dasar.';

  @override
  IconData get ikon => Icons.event_seat;

  @override
  Color get warna => const Color(0xFF3B5BFD);
}

/// Subclass 2: Tiket VIP — memakai mixin BisaDiskon.
class TiketVIP extends Tiket with BisaDiskon {
  final String fasilitas;
  TiketVIP(
    super.nama,
    super.harga, {
    this.fasilitas = 'lounge eksklusif, snack premium & prioritas boarding',
  });

  @override
  String deskripsi() => 'Kelas VIP dengan kursi luas serta $fasilitas.';

  @override
  IconData get ikon => Icons.workspace_premium;

  @override
  Color get warna => const Color(0xFFB8860B);
}

/// Subclass 3 (tambahan): Tiket Promo — juga memakai mixin BisaDiskon.
class TiketPromo extends Tiket with BisaDiskon {
  TiketPromo(super.nama, super.harga);

  @override
  String deskripsi() =>
      'Tiket promo dengan harga spesial waktu terbatas! Buruan sebelum kehabisan.';

  @override
  IconData get ikon => Icons.local_fire_department;

  @override
  Color get warna => const Color(0xFFE0435C);
}

// =====================================================================
// CUSTOM EXCEPTION
// =====================================================================

class TiketHabisException implements Exception {
  final String message;
  TiketHabisException(this.message);

  @override
  String toString() => message;
}

// =====================================================================
// SERVICE (ASYNC) — simulasi pengambilan data & pemesanan
// =====================================================================

class TiketService {
  static final Random _random = Random();

  /// Simulasi mengambil daftar tiket dari server.
  static Future<List<Tiket>> ambilDaftarTiket() async {
    await Future.delayed(const Duration(seconds: 2));

    final gagalMemuat = _random.nextInt(10) < 2; // 20% peluang gagal
    if (gagalMemuat) {
      throw Exception(
          'Gagal memuat daftar tiket. Periksa koneksi internet Anda dan coba lagi.');
    }

    return [
      TiketEkonomi('Jakarta - Surabaya', 250000),
      TiketVIP('Jakarta - Denpasar', 850000),
      TiketPromo('Jakarta - Yogyakarta', 150000),
      TiketEkonomi('Jakarta - Medan', 400000),
      TiketVIP('Jakarta - Makassar', 950000),
      TiketPromo('Jakarta - Semarang', 120000),
    ];
  }

  /// Simulasi memesan satu tiket. Bisa gagal secara acak dengan
  /// melempar [TiketHabisException].
  static Future<String> pesanTiket(Tiket tiket) async {
    await Future.delayed(const Duration(seconds: 2));

    final habis = _random.nextInt(10) < 4; // 40% peluang habis
    if (habis) {
      throw TiketHabisException(
          'Maaf, tiket "${tiket.nama}" baru saja habis terjual. Silakan pilih tiket lain.');
    }

    final kodeBooking = 'BK${100000 + _random.nextInt(900000)}';
    return 'Pemesanan tiket "${tiket.nama}" berhasil!\nKode booking Anda: $kodeBooking';
  }
}

// =====================================================================
// UTIL
// =====================================================================

String formatRupiah(double harga) {
  final angka = harga.toInt().toString();
  final buffer = StringBuffer();
  for (int i = 0; i < angka.length; i++) {
    final posisiDariBelakang = angka.length - i;
    buffer.write(angka[i]);
    if (posisiDariBelakang > 1 && posisiDariBelakang % 3 == 1) {
      buffer.write('.');
    }
  }
  return 'Rp$buffer';
}

/// Stream generator hitung mundur promo (async*).
Stream<int> hitungMundur(int detikAwal) async* {
  int sisa = detikAwal;
  while (sisa >= 0) {
    yield sisa;
    if (sisa == 0) break;
    await Future.delayed(const Duration(seconds: 1));
    sisa--;
  }
}

// =====================================================================
// HOME PAGE — FutureBuilder (loading / error / data)
// =====================================================================

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Tiket>> _futureTiket;

  @override
  void initState() {
    super.initState();
    _futureTiket = TiketService.ambilDaftarTiket();
  }

  void _muatUlang() {
    setState(() {
      _futureTiket = TiketService.ambilDaftarTiket();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pesan Tiket Perjalanan'),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _muatUlang,
            icon: const Icon(Icons.refresh),
            tooltip: 'Muat ulang',
          ),
        ],
      ),
      body: Column(
        children: [
          const PromoCountdownBanner(),
          Expanded(
            child: FutureBuilder<List<Tiket>>(
              future: _futureTiket,
              builder: (context, snapshot) {
                // 1) KONDISI LOADING
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const _StatusView(
                    isLoading: true,
                    pesan: 'Memuat daftar tiket...',
                  );
                }

                // 2) KONDISI ERROR
                if (snapshot.hasError) {
                  return _StatusView(
                    icon: Icons.error_outline,
                    iconColor: Colors.redAccent,
                    pesan: '${snapshot.error}',
                    tombolLabel: 'Coba Lagi',
                    onTombol: _muatUlang,
                  );
                }

                // 3) KONDISI DATA
                final daftarTiket = snapshot.data ?? [];
                if (daftarTiket.isEmpty) {
                  return const _StatusView(
                    icon: Icons.inbox_outlined,
                    pesan: 'Belum ada tiket tersedia saat ini.',
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    _muatUlang();
                    await _futureTiket;
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                    itemCount: daftarTiket.length,
                    itemBuilder: (context, index) {
                      return TiketCard(tiket: daftarTiket[index]);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget serbaguna untuk menampilkan status loading / error / kosong.
class _StatusView extends StatelessWidget {
  final IconData? icon;
  final Color? iconColor;
  final bool isLoading;
  final String pesan;
  final String? tombolLabel;
  final VoidCallback? onTombol;

  const _StatusView({
    this.icon,
    this.iconColor,
    this.isLoading = false,
    required this.pesan,
    this.tombolLabel,
    this.onTombol,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isLoading)
              const CircularProgressIndicator()
            else if (icon != null)
              Icon(icon, size: 56, color: iconColor ?? Colors.grey),
            const SizedBox(height: 16),
            Text(
              pesan,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15, color: Colors.black87),
            ),
            if (tombolLabel != null) ...[
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: onTombol,
                child: Text(tombolLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// =====================================================================
// COUNTDOWN PROMO — StreamBuilder (BONUS)
// =====================================================================

class PromoCountdownBanner extends StatefulWidget {
  const PromoCountdownBanner({super.key});
  @override
  State<PromoCountdownBanner> createState() => _PromoCountdownBannerState();
}

class _PromoCountdownBannerState extends State<PromoCountdownBanner> {
  late final Stream<int> _stream;
  static const int _detikAwal = 300; // 5 menit

  @override
  void initState() {
    super.initState();
    _stream = hitungMundur(_detikAwal);
  }

  String _formatWaktu(int detik) {
    final menit = (detik ~/ 60).toString().padLeft(2, '0');
    final sisaDetik = (detik % 60).toString().padLeft(2, '0');
    return '$menit:$sisaDetik';
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: _stream,
      initialData: _detikAwal,
      builder: (context, snapshot) {
        final sisa = snapshot.data ?? 0;
        final habis = sisa <= 0;
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: habis
                  ? [Colors.grey.shade500, Colors.grey.shade400]
                  : [const Color(0xFFE0435C), const Color(0xFFFF8A5C)],
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Icon(habis ? Icons.event_busy : Icons.local_fire_department,
                  color: Colors.white),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  habis
                      ? 'Waktu promo telah berakhir'
                      : 'Waktu tersisa untuk memesan tiket promo',
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
              if (!habis)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _formatWaktu(sisa),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

// =====================================================================
// KARTU TIKET
// =====================================================================

class TiketCard extends StatelessWidget {
  final Tiket tiket;
  const TiketCard({super.key, required this.tiket});

  @override
  Widget build(BuildContext context) {
    final punyaDiskon = tiket is BisaDiskon;
    double? hargaDiskon;
    if (punyaDiskon) {
      hargaDiskon = (tiket as BisaDiskon).hitungHargaDiskon(tiket.harga, 15);
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _bukaBooking(context),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: tiket.warna.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(tiket.ikon, color: tiket.warna),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(tiket.nama,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15)),
                    const SizedBox(height: 4),
                    Text(
                      tiket.deskripsi(),
                      style: TextStyle(
                          color: Colors.grey.shade600, fontSize: 12.5),
                    ),
                    const SizedBox(height: 8),
                    if (punyaDiskon) ...[
                      Row(
                        children: [
                          Text(
                            formatRupiah(tiket.harga),
                            style: TextStyle(
                                decoration: TextDecoration.lineThrough,
                                color: Colors.grey.shade500,
                                fontSize: 12.5),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text('Diskon 15%',
                                style: TextStyle(
                                    color: Colors.green.shade700,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                      Text(
                        formatRupiah(hargaDiskon!),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: tiket.warna),
                      ),
                    ] else
                      Text(
                        formatRupiah(tiket.harga),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: tiket.warna),
                      ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  void _bukaBooking(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => BookingSheet(tiket: tiket),
    );
  }
}

// =====================================================================
// HALAMAN PEMESANAN — try / catch / finally
// =====================================================================

enum _StatusPesan { idle, proses, sukses, gagal }

class BookingSheet extends StatefulWidget {
  final Tiket tiket;
  const BookingSheet({super.key, required this.tiket});

  @override
  State<BookingSheet> createState() => _BookingSheetState();
}

class _BookingSheetState extends State<BookingSheet> {
  _StatusPesan _status = _StatusPesan.idle;
  String _pesanHasil = '';

  Future<void> _prosesPemesanan() async {
    setState(() {
      _status = _StatusPesan.proses;
      _pesanHasil = '';
    });

    try {
      final hasil = await TiketService.pesanTiket(widget.tiket);
      setState(() {
        _status = _StatusPesan.sukses;
        _pesanHasil = hasil;
      });
    } on TiketHabisException catch (e) {
      // Tangani kegagalan khusus: tiket habis
      setState(() {
        _status = _StatusPesan.gagal;
        _pesanHasil = e.toString();
      });
    } catch (e) {
      // Tangani error tak terduga lainnya
      setState(() {
        _status = _StatusPesan.gagal;
        _pesanHasil = 'Terjadi kesalahan tak terduga: $e';
      });
    } finally {
      // Selalu dijalankan, baik sukses maupun gagal
      debugPrint('Proses pemesanan untuk "${widget.tiket.nama}" selesai.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final tiket = widget.tiket;
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Icon(tiket.ikon, color: tiket.warna, size: 28),
              const SizedBox(width: 10),
              Expanded(
                child: Text(tiket.nama,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(tiket.deskripsi(),
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13.5)),
          const SizedBox(height: 16),
          Text('Total harga: ${formatRupiah(tiket.harga)}',
              style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 20),
          if (_status == _StatusPesan.sukses)
            _HasilBanner(
              warna: Colors.green,
              icon: Icons.check_circle,
              pesan: _pesanHasil,
            ),
          if (_status == _StatusPesan.gagal)
            _HasilBanner(
              warna: Colors.redAccent,
              icon: Icons.cancel,
              pesan: _pesanHasil,
            ),
          if (_status == _StatusPesan.sukses || _status == _StatusPesan.gagal)
            const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed:
                  _status == _StatusPesan.proses ? null : _prosesPemesanan,
              icon: _status == _StatusPesan.proses
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.confirmation_number_outlined),
              label: Text(_status == _StatusPesan.proses
                  ? 'Memproses pemesanan...'
                  : (_status == _StatusPesan.sukses
                      ? 'Pesan Lagi'
                      : 'Pesan Sekarang')),
              style: ElevatedButton.styleFrom(
                backgroundColor: tiket.warna,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HasilBanner extends StatelessWidget {
  final Color warna;
  final IconData icon;
  final String pesan;
  const _HasilBanner({
    required this.warna,
    required this.icon,
    required this.pesan,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: warna.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: warna.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: warna),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              pesan,
              style: const TextStyle(color: Colors.black87, height: 1.3),
            ),
          ),
        ],
      ),
    );
  }
}