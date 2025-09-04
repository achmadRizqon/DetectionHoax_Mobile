import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Verifikasi extends StatelessWidget {
  const Verifikasi({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tips Memverifikasi Berita',
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
              'Langkah-langkah memverifikasi berita di internet:',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            _buildTipsItem(context, 'Cek Sumber', 'Pastikan berita berasal dari media resmi atau sumber terpercaya.'),
            _buildTipsItem(context, 'Baca Seluruh Isi', 'Jangan hanya membaca judul, pahami isi dan konteksnya.'),
            _buildTipsItem(context, 'Cari Berita Serupa', 'Bandingkan dengan berita dari media lain yang kredibel.'),
            _buildTipsItem(context, 'Verifikasi ke Situs Cek Fakta', 'Gunakan situs seperti turnbackhoax.id, cekfakta.com, atau kominfo.go.id.'),
            _buildTipsItem(context, 'Periksa Tanggal dan Kronologi', 'Pastikan informasi tidak diambil dari peristiwa lama atau dipelintir.'),
            _buildTipsItem(context, 'Cek Gambar/Video', 'Gunakan reverse image search untuk memastikan keaslian gambar/video.'),
            _buildTipsItem(context, 'Jangan Mudah Terprovokasi', 'Berpikir kritis dan jangan langsung membagikan sebelum yakin.'),
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

  Widget _buildTipsItem(BuildContext context, String title, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.verified_rounded, color: Colors.green, size: 22),
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
