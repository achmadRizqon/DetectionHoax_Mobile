import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MengenalHoax extends StatelessWidget {
  const MengenalHoax({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Mengenali Berita Hoax',
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
              'Apa itu Berita Hoax?',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Hoax adalah informasi palsu yang sengaja dibuat untuk menipu atau menyesatkan. Hoax seringkali menyebar dengan cepat melalui media sosial dan aplikasi pesan.',
              style: GoogleFonts.poppins(fontSize: 14),
            ),
            const SizedBox(height: 32),
            Text(
              'Ciri-ciri Berita Hoax',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text('- Judul Provokatif'),
            Text('- Sumber Tidak Jelas'),
            Text('- Bahasa Tidak Netral'),
            Text('- Gambar/Video Editan'),
            Text('- Desakan untuk Menyebarkan'),
            const SizedBox(height: 32),
            Text(
              'Tips Menghindari Hoax',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text('- Cek Sumber'),
            Text('- Baca Seluruh Isi'),
            Text('- Verifikasi ke Situs Cek Fakta'),
            Text('- Jangan Mudah Terprovokasi'),
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
}
