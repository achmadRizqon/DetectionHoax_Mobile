import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// Gambar relevan sesuai isi contoh berita
const faktaImages = [
  // Jalan tol (peresmian tol)
  'assets/images/jkw.png',
  // Cuaca/BMKG
  'https://images.unsplash.com/photo-1501004318641-b39e6451bec6?auto=format&fit=crop&w=400&q=80',
];
const hoaxImages = [
  // Herbal/daun (hoax COVID-19)
  'assets/images/herbal.jpg',
  // Banjir
  'assets/images/banjir.jpg',
];

class Mengecek extends StatelessWidget {
  const Mengecek({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Contoh Berita Fakta & Hoax',
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
              'Yuk kenali perbedaan berita fakta dan hoax melalui contoh berikut:',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text('Contoh Berita Fakta', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.green)),
            const SizedBox(height: 10),
            _buildContohCard(
              context,
              faktaImages[0],
              'Presiden RI meresmikan jalan tol baru di Jawa Barat pada 15 Juli 2025.',
              'Kompas.com',
              true,
            ),
            _buildContohCard(
              context,
              faktaImages[1],
              'BMKG mengumumkan prakiraan cuaca ekstrem di wilayah Jakarta.',
              'bmkg.go.id',
              true,
            ),
            const SizedBox(height: 24),
            Text('Contoh Berita Hoax', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.red)),
            const SizedBox(height: 10),
            _buildContohCard(
              context,
              hoaxImages[0],
              'Minum air rebusan daun tertentu bisa menyembuhkan COVID-19.',
              'Pesan berantai WhatsApp, tidak ada bukti ilmiah.',
              false,
            ),
            _buildContohCard(
              context,
              hoaxImages[1],
              'Foto banjir besar di Jakarta tahun ini, padahal foto diambil tahun 2013.',
              'Media sosial, tidak valid.',
              false,
            ),
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

  // ...existing code...

  Widget _buildContohCard(BuildContext context, String imageUrl, String judul, String sumber, bool isFakta) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: isFakta ? Colors.green.withOpacity(0.07) : Colors.red.withOpacity(0.07),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isFakta ? Colors.green : Colors.red,
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: Image.asset(
              imageUrl,
              height: 140,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 140,
                color: Colors.grey[300],
                child: const Center(child: Icon(Icons.image_not_supported_rounded)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(isFakta ? Icons.check_circle_rounded : Icons.cancel_rounded,
                    color: isFakta ? Colors.green : Colors.red, size: 22),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(judul, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 15)),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.link_rounded, size: 15, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(sumber, style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[700])),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
