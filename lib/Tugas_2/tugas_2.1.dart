//tugas Mobile
void main() {
  // Data mahasiswa: Map<String, dynamic> untuk setiap mahasiswa,
  // disimpan dalam List<Map<String, dynamic>>
  final List<Map<String, dynamic>> mahasiswa = [
    {
      'nama': 'Budi Santoso',
      'nilai': <int>[85, 90, 78, 92, 88],
      'absensi': 2,
    },
    {
      'nama': 'Siti Rahayu',
      'nilai': <int>[55, 60, 58, 52, 45],
      'absensi': 4,
    },
    {
      'nama': 'Andi Wijaya',
      'nilai': <int>[70, 75, 68, 80, 72],
      'absensi': 1,
    },
    {
      'nama': 'Dewi Lestari',
      'nilai': <int>[95, 88, 91, 85, 90],
      'absensi': 0,
    },
    {
      'nama': 'Rudi Hartono',
      'nilai': <int>[40, 35, 50, 45, 30],
      'absensi': 5,
    },
  ];
 
  print('=== LAPORAN NILAI MAHASISWA ===\n');
 
  // Untuk menghitung statistik kelas
  final List<int> semuaNilai = [];
  final List<double> semuaRataRata = [];
 
  for (final mhs in mahasiswa) {
    final String nama = mhs['nama'] as String;
    final List<int> nilai = mhs['nilai'] as List<int>;
    final int absensi = mhs['absensi'] as int;
 
    final double rataRata = hitungRataRata(nilai);
    final String grade = tentukanGrade(rataRata);
    final bool lulus = cekKelulusan(rataRata: rataRata, absensi: absensi);
 
    semuaNilai.addAll(nilai);
    semuaRataRata.add(rataRata);
 
    tampilkanLaporan(
      nama: nama,
      nilai: nilai,
      rataRata: rataRata,
      grade: grade,
      lulus: lulus,
    );
  }
 
  tampilkanStatistikKelas(semuaNilai, semuaRataRata);
}
 
/// Menghitung rata-rata dari sebuah List<int> nilai ujian.
double hitungRataRata(List<int> nilai) {
  if (nilai.isEmpty) return 0.0;
  final int total = nilai.reduce((a, b) => a + b);
  return total / nilai.length;
}
 
/// Menentukan grade berdasarkan rata-rata nilai.
/// A: >= 85, B: >= 70, C: >= 60, D: >= 50, E: < 50
String tentukanGrade(double rataRata) {
  if (rataRata >= 85) {
    return 'A';
  } else if (rataRata >= 70) {
    return 'B';
  } else if (rataRata >= 60) {
    return 'C';
  } else if (rataRata >= 50) {
    return 'D';
  } else {
    return 'E';
  }
}
 
/// Mengecek status kelulusan mahasiswa.
/// Lulus jika rata-rata >= 60 dan absensi <= 3
bool cekKelulusan({required double rataRata, required int absensi}) {
  return rataRata >= 60 && absensi <= 3;
}
 
/// Menampilkan laporan nilai untuk satu mahasiswa.
void tampilkanLaporan({
  required String nama,
  required List<int> nilai,
  required double rataRata,
  required String grade,
  required bool lulus,
}) {
  print('Nama     : $nama');
  print('Nilai    : $nilai');
  print('Rata-rata: ${rataRata.toStringAsFixed(1)}');
  print('Grade    : $grade');
  print('Status   : ${lulus ? 'LULUS' : 'TIDAK LULUS'}');
  print('');
}
 
/// Menampilkan statistik kelas: nilai tertinggi, terendah, dan rata-rata kelas.
void tampilkanStatistikKelas(
  List<int> semuaNilai,
  List<double> semuaRataRata,
) {
  final int nilaiTertinggi = semuaNilai.reduce((a, b) => a > b ? a : b);
  final int nilaiTerendah = semuaNilai.reduce((a, b) => a < b ? a : b);
  final double rataRataKelas =
      semuaRataRata.reduce((a, b) => a + b) / semuaRataRata.length;
 
  print('=== STATISTIK KELAS ===');
  print('Nilai Tertinggi : $nilaiTertinggi');
  print('Nilai Terendah  : $nilaiTerendah');
  print('Rata-rata Kelas : ${rataRataKelas.toStringAsFixed(1)}');
}
 