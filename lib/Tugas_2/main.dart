import 'package:flutter/material.dart';

void main() {
  runApp(const PerpustakaanApp());
}

class PerpustakaanApp extends StatelessWidget {
  const PerpustakaanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Katalog Buku Perpustakaan',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: const Color(0xFFF5F6FA),
        useMaterial3: true,
      ),
      home: const KatalogBukuPage(),
    );
  }
}


String kategoriRating(double rating) {
  if (rating >= 4.5) {
    return 'Sangat Baik';
  } else if (rating >= 3.5) {
    return 'Baik';
  } else {
    return 'Cukup';
  }
}

/// Menentukan warna badge kategori rating (fungsi tambahan ke-2).
Color warnaKategoriRating(String kategori) {
  switch (kategori) {
    case 'Sangat Baik':
      return Colors.green;
    case 'Baik':
      return Colors.orange;
    default:
      return Colors.grey;
  }
}


// HALAMAN UTAMA: DAFTAR KATALOG BUKU

class KatalogBukuPage extends StatefulWidget {
  const KatalogBukuPage({super.key});

  @override
  State<KatalogBukuPage> createState() => _KatalogBukuPageState();
}

class _KatalogBukuPageState extends State<KatalogBukuPage> {
 
  final List<Map<String, dynamic>> daftarBuku = [
    {
      'judul': 'Laskar Pelangi',
      'pengarang': 'Andrea Hirata',
      'tahunTerbit': 2005,
      'rating': 4.7,
      'tersedia': true,
      'genre': 'Fiksi',
    },
    {
      'judul': 'Bumi Manusia',
      'pengarang': 'Pramoedya Ananta Toer',
      'tahunTerbit': 1980,
      'rating': 4.8,
      'tersedia': false,
      'genre': 'Sejarah',
    },
    {
      'judul': 'Filosofi Teras',
      'pengarang': 'Henry Manampiring',
      'tahunTerbit': 2018,
      'rating': 4.4,
      'tersedia': true,
      'genre': 'Pengembangan Diri',
    },
    {
      'judul': 'Negeri 5 Menara',
      'pengarang': 'Ahmad Fuadi',
      'tahunTerbit': 2009,
      'rating': 4.2,
      'tersedia': true,
      'genre': 'Fiksi',
    },
    {
      'judul': 'Sapiens',
      'pengarang': 'Yuval Noah Harari',
      'tahunTerbit': 2011,
      'rating': 4.6,
      'tersedia': false,
      'genre': 'Sains',
    },
    {
      'judul': 'Atomic Habits',
      'pengarang': 'James Clear',
      'tahunTerbit': 2018,
      'rating': 3.3,
      'tersedia': true,
      'genre': 'Pengembangan Diri',
    },
    {
      'judul': 'Cantik Itu Luka',
      'pengarang': 'Eka Kurniawan',
      'tahunTerbit': 2002,
      'rating': 3.9,
      'tersedia': true,
      'genre': 'Fiksi',
    },
  ];

  String kataKunci = '';

  
  List<Map<String, dynamic>> get bukuTersaring {
    if (kataKunci.isEmpty) return daftarBuku;
    return daftarBuku
        .where((buku) => (buku['judul'] as String)
            .toLowerCase()
            .contains(kataKunci.toLowerCase()))
        .toList();
  }


  Set<String> get genreUnik {
    return daftarBuku.map((buku) => buku['genre'] as String).toSet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Katalog Buku Perpustakaan'),
        centerTitle: true,
      ),
      body: Column(
        children: [

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Genre Tersedia',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 8,
              runSpacing: 4,
              children: genreUnik
                  .map(
                    (genre) => Chip(
                      label: Text(genre),
                      backgroundColor: Colors.indigo.shade50,
                      labelStyle: const TextStyle(color: Colors.indigo),
                      side: BorderSide(color: Colors.indigo.shade100),
                    ),
                  )
                  .toList(),
            ),
          ),


          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cari judul buku...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  kataKunci = value;
                });
              },
            ),
          ),

         
          Expanded(
            child: bukuTersaring.isEmpty
                ? const Center(
                    child: Text(
                      'Buku tidak ditemukan',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    itemCount: bukuTersaring.length,
                    itemBuilder: (context, index) {
                      final buku = bukuTersaring[index];
                      return KartuBuku(
                        buku: buku,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DetailBukuPage(buku: buku),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}



class KartuBuku extends StatelessWidget {
  final Map<String, dynamic> buku;
  final VoidCallback onTap;

  const KartuBuku({super.key, required this.buku, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final String judul = buku['judul'] as String;
    final String pengarang = buku['pengarang'] as String;
    final int tahunTerbit = buku['tahunTerbit'] as int;
    final double rating = buku['rating'] as double;
    final bool tersedia = buku['tersedia'] as bool;

    final String kategori = kategoriRating(rating);

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      judul,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  // ---------- Badge Tersedia/Dipinjam (ternary) ----------
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: tersedia
                          ? Colors.green.withOpacity(0.15)
                          : Colors.red.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      tersedia ? 'Tersedia' : 'Dipinjam',
                      style: TextStyle(
                        color: tersedia ? Colors.green[800] : Colors.red[800],
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'oleh $pengarang · $tahunTerbit',
                style: TextStyle(color: Colors.grey[600], fontSize: 13),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 18),
                  const SizedBox(width: 4),
                  Text(
                    rating.toStringAsFixed(1),
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: warnaKategoriRating(kategori).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      kategori,
                      style: TextStyle(
                        color: warnaKategoriRating(kategori),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    buku['genre'] as String,
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}



class DetailBukuPage extends StatefulWidget {
  final Map<String, dynamic> buku;

  const DetailBukuPage({super.key, required this.buku});

  @override
  State<DetailBukuPage> createState() => _DetailBukuPageState();
}

class _DetailBukuPageState extends State<DetailBukuPage> {
  
  String? catatanPeminjam;

  final TextEditingController _controllerCatatan = TextEditingController();

  @override
  void dispose() {
    _controllerCatatan.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final buku = widget.buku;
    final String judul = buku['judul'] as String;
    final String pengarang = buku['pengarang'] as String;
    final int tahunTerbit = buku['tahunTerbit'] as int;
    final double rating = buku['rating'] as double;
    final bool tersedia = buku['tersedia'] as bool;
    final String genre = buku['genre'] as String;
    final String kategori = kategoriRating(rating);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Buku'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              judul,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'oleh $pengarang',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            const SizedBox(height: 16),

            _baris('Tahun Terbit', '$tahunTerbit'),
            _baris('Genre', genre),
            _baris('Rating', '${rating.toStringAsFixed(1)} ($kategori)'),

            
            Row(
              children: [
                const Text(
                  'Status: ',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: tersedia
                        ? Colors.green.withOpacity(0.15)
                        : Colors.red.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    tersedia ? 'Tersedia' : 'Dipinjam',
                    style: TextStyle(
                      color: tersedia ? Colors.green[800] : Colors.red[800],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            const Divider(height: 32),

            Text(
              'Catatan Peminjam',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),

        
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Text(
                catatanPeminjam ?? '(Tidak ada catatan)',
                style: TextStyle(
                  fontStyle: catatanPeminjam == null
                      ? FontStyle.italic
                      : FontStyle.normal,
                  color: catatanPeminjam == null
                      ? Colors.grey[600]
                      : Colors.black87,
                ),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: _controllerCatatan,
              decoration: InputDecoration(
                hintText: 'Tulis catatan tentang buku ini...',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    final teks = _controllerCatatan.text.trim();
                    // Jika input kosong, catatan tetap null
                    catatanPeminjam = teks.isEmpty ? null : teks;
                  });
                },
                icon: const Icon(Icons.save),
                label: const Text('Simpan Catatan'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _baris(String label, String nilai) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Text(': $nilai'),
        ],
      ),
    );
  }
}