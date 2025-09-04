import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../tema/theme.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  _PrivacyPolicyScreenState createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final List<Map<String, dynamic>> _privacyData = [
    {
      'title': '1. Informasi yang Kami Kumpulkan',
      'content': '''Kami mengumpulkan informasi yang Anda berikan secara langsung dan informasi yang dikumpulkan secara otomatis:

• **Informasi Akun**: Email, nama pengguna, dan kata sandi
• **Konten Analisis**: Teks berita yang Anda input untuk dianalisis
• **Data Penggunaan**: Frekuensi penggunaan fitur dan interaksi dengan aplikasi
• **Informasi Teknis**: Alamat IP, jenis perangkat, sistem operasi
• **Log Aktivitas**: Waktu akses, halaman yang dikunjungi, dan riwayat analisis

Semua data dikumpulkan untuk memberikan layanan terbaik dan meningkatkan akurasi sistem AI kami.''',
      'icon': Icons.info_rounded,
      'color': Color(0xFF6366F1),
    },
    {
      'title': '2. Cara Kami Menggunakan Informasi',
      'content': '''Informasi yang dikumpulkan digunakan untuk tujuan berikut:

• **Penyediaan Layanan**: Menganalisis berita dan memberikan hasil prediksi
• **Peningkatan AI**: Melatih dan meningkatkan akurasi model machine learning
• **Personalisasi**: Menyesuaikan pengalaman pengguna berdasarkan preferensi
• **Keamanan**: Melindungi akun dan mencegah penyalahgunaan layanan
• **Komunikasi**: Mengirim notifikasi penting dan pembaruan layanan
• **Analitik**: Memahami pola penggunaan untuk pengembangan fitur baru

Kami tidak akan menggunakan data Anda untuk tujuan komersial tanpa persetujuan eksplisit.''',
      'icon': Icons.settings_rounded,
      'color': Color(0xFF059669),
    },
    {
      'title': '3. Perlindungan dan Keamanan Data',
      'content': '''Kami menerapkan berbagai langkah keamanan untuk melindungi informasi Anda:

• **Enkripsi End-to-End**: Semua data dienkripsi selama transmisi dan penyimpanan
• **Akses Terbatas**: Hanya personel yang berwenang yang dapat mengakses data
• **Audit Berkala**: Pemeriksaan keamanan sistem secara rutin
• **Firewall & Monitoring**: Perlindungan terhadap akses tidak sah
• **Backup Aman**: Data di-backup dengan enkripsi tingkat enterprise
• **Sertifikasi Keamanan**: Mengikuti standar keamanan internasional

Meskipun demikian, tidak ada sistem yang 100% aman. Kami terus berupaya meningkatkan keamanan data Anda.''',
      'icon': Icons.security_rounded,
      'color': Color(0xFFEC4899),
    },
    {
      'title': '4. Berbagi Informasi dengan Pihak Ketiga',
      'content': '''Kami tidak menjual atau menyewakan informasi pribadi Anda. Namun, kami dapat berbagi data dalam situasi terbatas:

• **Penyedia Layanan**: Partner teknologi yang membantu operasional aplikasi
• **Kepatuhan Hukum**: Jika diwajibkan oleh hukum atau perintah pengadilan
• **Perlindungan Hak**: Untuk melindungi hak, properti, atau keamanan
• **Persetujuan**: Dengan persetujuan eksplisit dari Anda
• **Data Anonim**: Data yang telah dihilangkan identitas pribadi untuk penelitian

Semua pihak ketiga diwajibkan menandatangani perjanjian kerahasiaan yang ketat.''',
      'icon': Icons.share_rounded,
      'color': Color(0xFFF59E0B),
    },
    {
      'title': '5. Hak-Hak Pengguna',
      'content': '''Sebagai pengguna, Anda memiliki hak-hak berikut atas data pribadi Anda:

• **Hak Akses**: Meminta salinan data pribadi yang kami simpan
• **Hak Pembetulan**: Meminta perbaikan data yang tidak akurat
• **Hak Penghapusan**: Meminta penghapusan data pribadi Anda
• **Hak Pembatasan**: Membatasi pemrosesan data dalam kondisi tertentu
• **Hak Portabilitas**: Meminta transfer data ke layanan lain
• **Hak Menolak**: Menolak pemrosesan data untuk tujuan tertentu

Untuk menggunakan hak-hak ini, hubungi tim support kami melalui email yang tersedia.''',
      'icon': Icons.verified_user_rounded,
      'color': Color(0xFF8B5CF6),
    },
    {
      'title': '6. Penyimpanan dan Retensi Data',
      'content': '''Kami menyimpan data Anda selama diperlukan untuk tujuan yang dijelaskan dalam kebijakan ini:

• **Data Akun**: Disimpan selama akun aktif + 1 tahun setelah penghapusan
• **Data Analisis**: Disimpan selama 3 tahun untuk peningkatan model AI
• **Log Sistem**: Disimpan selama 1 tahun untuk keperluan keamanan
• **Data Backup**: Dihapus secara aman setelah periode retensi berakhir

Data akan dihapus secara permanen setelah periode retensi, kecuali jika diwajibkan oleh hukum untuk menyimpan lebih lama.''',
      'icon': Icons.storage_rounded,
      'color': Color(0xFF10B981),
    },
    {
      'title': '7. Cookie dan Teknologi Pelacakan',
      'content': '''Aplikasi kami menggunakan teknologi pelacakan untuk meningkatkan pengalaman pengguna:

• **Cookie Fungsional**: Untuk menyimpan preferensi dan sesi login
• **Cookie Analitik**: Untuk memahami penggunaan aplikasi (data anonim)
• **Local Storage**: Menyimpan pengaturan aplikasi secara lokal
• **Crash Analytics**: Mendeteksi dan memperbaiki bug aplikasi

Anda dapat mengelola preferensi cookie melalui pengaturan aplikasi. Menonaktifkan cookie tertentu mungkin mempengaruhi fungsionalitas aplikasi.''',
      'icon': Icons.cookie_rounded,
      'color': Color(0xFFFF6B6B),
    },
    {
      'title': '8. Transfer Data Internasional',
      'content': '''Data Anda mungkin diproses dan disimpan di server yang berlokasi di berbagai negara:

• **Lokasi Server**: Singapura, Amerika Serikat, dan Uni Eropa
• **Standar Perlindungan**: Mengikuti standar perlindungan data internasional
• **Klausul Kontrak**: Perjanjian transfer data yang sesuai dengan GDPR
• **Sertifikasi**: Server bersertifikat ISO 27001 dan SOC 2

Transfer dilakukan dengan jaminan perlindungan data yang setara dengan kebijakan ini.''',
      'icon': Icons.public_rounded,
      'color': Color(0xFF0088CC),
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeManager>(
      builder: (context, themeManager, child) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: SafeArea(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: CustomScrollView(
                  physics: BouncingScrollPhysics(),
                  slivers: [
                    // Modern App Bar
                    SliverAppBar(
                      expandedHeight: 120.0,
                      floating: true,
                      pinned: true,
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      leading: IconButton(
                        icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      flexibleSpace: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFF059669),
                              Color(0xFF10B981),
                            ],
                          ),
                        ),
                        child: FlexibleSpaceBar(
                          titlePadding: EdgeInsets.only(left: 56, bottom: 16),
                          title: Text(
                            "Privacy Policy",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Content
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header Section
                            _buildHeaderSection(isDark),
                            
                            SizedBox(height: 32),
                            
                            // Last Updated Info
                            _buildLastUpdatedSection(),
                            
                            SizedBox(height: 32),
                            
                            // Privacy Content
                            _buildPrivacyContent(),
                            
                            SizedBox(height: 32),
                            
                            // Contact Section
                            _buildContactSection(isDark),
                            
                            SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeaderSection(bool isDark) {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF059669),
            Color(0xFF10B981),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF059669).withOpacity(0.3),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.privacy_tip_rounded, color: Colors.white, size: 24),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Kebijakan Privasi",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "News Detection AI",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Text(
            "Privasi Anda adalah prioritas utama kami. Kebijakan ini menjelaskan bagaimana kami mengumpulkan, menggunakan, dan melindungi informasi pribadi Anda saat menggunakan layanan News Detection AI.",
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLastUpdatedSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.schedule_rounded,
            color: Theme.of(context).colorScheme.primary,
            size: 20,
          ),
          SizedBox(width: 12),
          Text(
            "Terakhir diperbarui: 5 Juni 2025",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacyContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          icon: Icons.privacy_tip_rounded,
          title: "Kebijakan Privasi Lengkap",
          iconColor: Color(0xFF059669),
        ),
        SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: _privacyData.length,
          itemBuilder: (context, index) {
            final privacy = _privacyData[index];
            return _buildPrivacyItem(privacy, index);
          },
        ),
      ],
    );
  }

  Widget _buildPrivacyItem(Map<String, dynamic> privacy, int index) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDark 
                ? Colors.black.withOpacity(0.3)
                : Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: index == 0, // First item expanded by default
          leading: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: privacy['color'].withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              privacy['icon'],
              color: privacy['color'],
              size: 20,
            ),
          ),
          title: Text(
            privacy['title'],
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(
                privacy['content'],
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
                  height: 1.6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactSection(bool isDark) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark 
                ? Colors.black.withOpacity(0.3)
                : Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xFF059669).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.contact_support_rounded,
                  color: Color(0xFF059669),
                  size: 20,
                ),
              ),
              SizedBox(width: 12),
              Text(
                "Pertanyaan Privasi?",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            "Jika Anda memiliki pertanyaan tentang kebijakan privasi ini atau ingin menggunakan hak-hak Anda, silakan hubungi Data Protection Officer kami:",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
              height: 1.5,
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Icon(
                Icons.email_rounded,
                color: Color(0xFF059669),
                size: 18,
              ),
              SizedBox(width: 8),
              Text(
                "privacy@newsdetection.com",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Color(0xFF059669),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.phone_rounded,
                color: Color(0xFF059669),
                size: 18,
              ),
              SizedBox(width: 8),
              Text(
                "+62 21-1234-5679 (Privacy Hotline)",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
    required Color iconColor,
  }) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        SizedBox(width: 12),
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
      ],
    );
  }
}