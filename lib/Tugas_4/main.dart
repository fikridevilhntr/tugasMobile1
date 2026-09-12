import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Restaurant Detail',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFFE85D2C),
        scaffoldBackgroundColor: const Color(0xFFF7F5F2),
        fontFamily: 'Roboto',
      ),
      home: const RestaurantDetailPage(),
    );
  }
}

class MenuItem {
  final String name;
  final String price;
  final String imageUrl;

  const MenuItem({
    required this.name,
    required this.price,
    required this.imageUrl,
  });
}

class RestaurantDetailPage extends StatelessWidget {
  const RestaurantDetailPage({super.key});

  static const List<MenuItem> popularMenu = [
    MenuItem(
      name: 'Nasi Goreng Spesial',
      price: 'Rp 28.000',
      imageUrl:
          'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=400',
    ),
    MenuItem(
      name: 'Sate Ayam Madura',
      price: 'Rp 25.000',
      imageUrl:
          'https://images.unsplash.com/photo-1529563021893-cc83c992d75d?w=400',
    ),
    MenuItem(
      name: 'Es Teh Manis Segar',
      price: 'Rp 8.000',
      imageUrl:
          'https://images.unsplash.com/photo-1556679343-c7306c1976bc?w=400',
    ),
    MenuItem(
      name: 'Ayam Bakar Madu',
      price: 'Rp 32.000',
      imageUrl:
          'https://images.unsplash.com/photo-1598515213692-5f252f11e6f1?w=400',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFE85D2C);

    return Scaffold(
      // 1. AppBar dengan judul nama restoran dan tombol share
      appBar: AppBar(
        title: const Text(
          'Warung Sedap Rasa',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            tooltip: 'Bagikan',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Link restoran dibagikan!')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 2. Gambar restoran fullwidth (Stack: gambar + badge diskon)
            Stack(
              children: [
                Image.network(
                  'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=800',
                  width: double.infinity,
                  height: 220,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: double.infinity,
                    height: 220,
                    color: Colors.grey[300],
                    child: const Icon(Icons.restaurant, size: 64),
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Promo 20%',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // 3. Container info utama
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Warung Sedap Rasa',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 20),
                        const SizedBox(width: 4),
                        const Text(
                          '4.8',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const Text(
                          ' (1.240 ulasan)',
                          style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Masakan Indonesia',
                            style: TextStyle(
                              color: primaryColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 18,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            'Jl. Kenari No. 12, Kelurahan Marikurubu, Ternate, Maluku Utara',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // 4. Row untuk 3 statistik: jarak, waktu buka, harga rata-rata
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _StatItem(
                      icon: Icons.directions_walk,
                      label: 'Jarak',
                      value: '1.2 km',
                    ),
                    const _VerticalDivider(),
                    _StatItem(
                      icon: Icons.access_time,
                      label: 'Jam Buka',
                      value: '09:00-21:00',
                    ),
                    const _VerticalDivider(),
                    _StatItem(
                      icon: Icons.attach_money,
                      label: 'Harga Rata2',
                      value: 'Rp 25rb',
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 5. Deskripsi restoran
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tentang Restoran',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Warung Sedap Rasa menyajikan hidangan khas Nusantara dengan '
                    'cita rasa otentik dan bahan-bahan segar pilihan. Berdiri sejak '
                    'tahun 2010, kami berkomitmen menghadirkan kenyamanan dan '
                    'kepuasan bagi setiap pelanggan yang datang menikmati sajian '
                    'kuliner rumahan yang lezat dan hangat.',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey[700], height: 1.5),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 6. Section 'Menu Populer' dengan Card menu (Stack: gambar+nama+harga)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: const Text(
                'Menu Populer',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 190,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: popularMenu.length,
                separatorBuilder: (context, index) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final item = popularMenu[index];
                  return _MenuCard(item: item);
                },
              ),
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),
      // 7. FloatingActionButton untuk reservasi
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.event_available, size: 40, color: primaryColor),
                  const SizedBox(height: 12),
                  const Text(
                    'Reservasi berhasil diajukan!',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
            ),
          );
        },
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.calendar_month),
        label: const Text('Reservasi'),
      ),
    );
  }
}

// Widget bantu untuk statistik (Column di dalam Row)
class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: const Color(0xFFE85D2C), size: 22),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(fontSize: 11, color: Colors.grey[600]),
        ),
      ],
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  const _VerticalDivider();

  @override
  Widget build(BuildContext context) {
    return Container(height: 40, width: 1, color: Colors.grey[300]);
  }
}

// Widget bantu untuk Card menu populer (Stack: gambar + nama + harga)
class _MenuCard extends StatelessWidget {
  final MenuItem item;

  const _MenuCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: SizedBox(
        width: 140,
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            Image.network(
              item.imageUrl,
              width: 140,
              height: 190,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 140,
                height: 190,
                color: Colors.grey[300],
                child: const Icon(Icons.fastfood, size: 40),
              ),
            ),
            Container(
              width: 140,
              padding: const EdgeInsets.fromLTRB(10, 30, 10, 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.85),
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    item.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.price,
                    style: const TextStyle(
                      color: Colors.amberAccent,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}