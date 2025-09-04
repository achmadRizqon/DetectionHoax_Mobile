import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Panduan extends StatelessWidget {
  const Panduan({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Panduan Lengkap Saring Sebelum Sharing',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Panduan Lengkap Edukasi Anti Hoax',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Saring sebelum sharing adalah prinsip penting agar kita tidak ikut menyebarkan hoax atau informasi palsu. Berikut panduan lengkap yang bisa kamu terapkan:',
              style: GoogleFonts.poppins(fontSize: 15),
            ),
            const SizedBox(height: 24),
            _buildPanduanItem(context, '1. Jangan Langsung Percaya', 'Selalu skeptis terhadap informasi yang baru didapat, apalagi jika sumbernya tidak jelas.'),
            _buildPanduanItem(context, '2. Cek Sumber dan Kredibilitas', 'Pastikan informasi berasal dari media resmi atau sumber terpercaya.'),
            _buildPanduanItem(context, '3. Baca dan Pahami Isi Berita', 'Jangan hanya membaca judul, pahami isi dan konteksnya.'),
            _buildPanduanItem(context, '4. Bandingkan dengan Media Lain', 'Cari berita serupa di media lain yang kredibel.'),
            _buildPanduanItem(context, '5. Verifikasi ke Situs Cek Fakta', 'Gunakan situs seperti turnbackhoax.id, cekfakta.com, atau kominfo.go.id.'),
            _buildPanduanItem(context, '6. Periksa Tanggal dan Kronologi', 'Pastikan informasi tidak diambil dari peristiwa lama atau dipelintir.'),
            _buildPanduanItem(context, '7. Cek Gambar/Video', 'Gunakan reverse image search untuk memastikan keaslian gambar/video.'),
            _buildPanduanItem(context, '8. Jangan Mudah Terprovokasi', 'Berpikir kritis dan jangan langsung membagikan sebelum yakin.'),
            const SizedBox(height: 32),
            Center(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                icon: const Icon(Icons.home_rounded),
                label: const Text('Kembali ke Beranda'),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPanduanItem(BuildContext context, String title, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.menu_book_rounded, color: Colors.blue, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 15)),
                Text(desc, style: GoogleFonts.poppins(fontSize: 13, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
