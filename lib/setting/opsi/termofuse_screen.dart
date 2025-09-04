import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../tema/theme.dart';

class TermsOfUseScreen extends StatefulWidget {
  const TermsOfUseScreen({super.key});

  @override
  _TermsOfUseScreenState createState() => _TermsOfUseScreenState();
}

class _TermsOfUseScreenState extends State<TermsOfUseScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final List<Map<String, dynamic>> _termsData = [
    {
      'title': '1. Penerimaan Persyaratan',
      'content': '''Dengan mengunduh, menginstal, atau menggunakan aplikasi News Detection AI, Anda menyetujui untuk terikat oleh persyaratan penggunaan ini. Jika Anda tidak setuju dengan persyaratan ini, mohon untuk tidak menggunakan aplikasi kami.

Aplikasi ini dirancang untuk membantu pengguna dalam mengidentifikasi potensi berita palsu menggunakan teknologi kecerdasan buatan. Namun, hasil prediksi tidak boleh dijadikan satu-satunya sumber untuk menentukan kebenaran suatu informasi.''',
      'icon': Icons.verified_user_rounded,
      'color': Color(0xFF6366F1),
    },
    {
      'title': '2. Penggunaan Layanan',
      'content': '''Anda diizinkan untuk menggunakan aplikasi ini untuk tujuan yang sah dan sesuai dengan hukum yang berlaku. Anda setuju untuk tidak:

• Menggunakan aplikasi untuk tujuan ilegal atau merugikan
• Mengunggah konten yang melanggar hak cipta atau hak kekayaan intelektual
• Mencoba mengakses sistem secara tidak sah atau melakukan aktivitas hacking
• Menyebarkan malware atau virus melalui aplikasi
• Menggunakan aplikasi untuk menyebarkan informasi palsu atau menyesatkan''',
      'icon': Icons.rule_rounded,
      'color': Color(0xFF059669),
    },
    {
      'title': '3. Akurasi dan Batasan AI',
      'content': '''Aplikasi menggunakan teknologi AI dengan tingkat akurasi sekitar 85%. Namun, kami tidak dapat menjamin 100% akurasi dari hasil prediksi. Hasil analisis harus digunakan sebagai panduan awal, bukan keputusan final.

Pengguna disarankan untuk:
• Memverifikasi informasi dari sumber terpercaya lainnya
• Menggunakan hasil analisis sebagai salah satu pertimbangan
• Tidak menyebarkan berita tanpa verifikasi yang memadai
• Memahami bahwa teknologi AI dapat memiliki keterbatasan''',
      'icon': Icons.psychology_rounded,
      'color': Color(0xFFF59E0B),
    },
    {
      'title': '4. Privasi dan Data',
      'content': '''Kami menghormati privasi Anda dan berkomitmen untuk melindungi data pribadi. Informasi yang dikumpulkan meliputi:

• Data analisis berita yang Anda inputkan
• Informasi akun pengguna (email, nama)
• Data penggunaan aplikasi untuk peningkatan layanan

Data Anda akan:
• Dienkripsi dan disimpan dengan aman
• Tidak dibagikan kepada pihak ketiga tanpa persetujuan
• Digunakan hanya untuk peningkatan layanan
• Dapat dihapus atas permintaan Anda''',
      'icon': Icons.security_rounded,
      'color': Color(0xFFEC4899),
    },
    {
      'title': '5. Hak Kekayaan Intelektual',
      'content': '''Semua konten dalam aplikasi, termasuk tetapi tidak terbatas pada teks, grafik, logo, ikon, gambar, klip audio, unduhan digital, kompilasi data, dan perangkat lunak adalah milik eksklusif News Detection AI atau pemberi lisensinya.

Anda tidak diizinkan untuk:
• Menyalin, memodifikasi, atau mendistribusikan konten aplikasi
• Melakukan reverse engineering pada aplikasi
• Menggunakan nama, logo, atau merek dagang kami tanpa izin
• Membuat aplikasi serupa berdasarkan teknologi kami''',
      'icon': Icons.copyright_rounded,
      'color': Color(0xFF8B5CF6),
    },
    {
      'title': '6. Pembaruan dan Perubahan',
      'content': '''Kami berhak untuk memperbarui atau mengubah persyaratan penggunaan ini kapan saja tanpa pemberitahuan sebelumnya. Perubahan akan efektif segera setelah diposting dalam aplikasi.

Dengan terus menggunakan aplikasi setelah perubahan, Anda menyetujui persyaratan yang telah direvisi. Kami menyarankan Anda untuk memeriksa halaman ini secara berkala untuk mengetahui pembaruan terbaru.''',
      'icon': Icons.update_rounded,
      'color': Color(0xFF10B981),
    },
    {
      'title': '7. Penghentian Layanan',
      'content': '''Kami berhak untuk menghentikan atau menangguhkan akses Anda ke aplikasi tanpa pemberitahuan sebelumnya jika:

• Anda melanggar persyaratan penggunaan ini
• Terdapat aktivitas yang mencurigakan atau ilegal
• Diperlukan untuk pemeliharaan teknis
• Karena alasan hukum atau regulasi

Setelah penghentian, Anda harus berhenti menggunakan aplikasi dan menghapusnya dari perangkat Anda.''',
      'icon': Icons.block_rounded,
      'color': Color(0xFFEF4444),
    },
    {
      'title': '8. Batasan Tanggung Jawab',
      'content': '''Aplikasi disediakan "sebagaimana adanya" tanpa jaminan apapun. Kami tidak bertanggung jawab atas:

• Kerugian yang timbul dari penggunaan hasil prediksi AI
• Gangguan atau kesalahan dalam layanan
• Kehilangan data atau informasi
• Kerugian finansial atau reputasi akibat penggunaan aplikasi

Tanggung jawab kami terbatas pada penyediaan layanan sesuai kemampuan terbaik kami.''',
      'icon': Icons.warning_amber_rounded,
      'color': Color(0xFFFF6B6B),
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
                              Color(0xFF8B5CF6),
                              Color(0xFF6366F1),
                            ],
                          ),
                        ),
                        child: FlexibleSpaceBar(
                          titlePadding: EdgeInsets.only(left: 56, bottom: 16),
                          title: Text(
                            "Terms of Use",
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
                            // Welcome Section
                            _buildHeaderSection(isDark),
                            
                            SizedBox(height: 32),
                            
                            // Last Updated Info
                            _buildLastUpdatedSection(),
                            
                            SizedBox(height: 32),
                            
                            // Terms Content
                            _buildTermsContent(),
                            
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
            Color(0xFF8B5CF6),
            Color(0xFF6366F1),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF8B5CF6).withOpacity(0.3),
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
                child: Icon(Icons.description_rounded, color: Colors.white, size: 24),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Persyaratan Penggunaan",
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
            "Mohon baca dengan seksama persyaratan penggunaan aplikasi News Detection AI. Dengan menggunakan aplikasi ini, Anda menyetujui semua ketentuan yang berlaku.",
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

  Widget _buildTermsContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          icon: Icons.article_rounded,
          title: "Ketentuan dan Persyaratan",
          iconColor: Color(0xFF8B5CF6),
        ),
        SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: _termsData.length,
          itemBuilder: (context, index) {
            final term = _termsData[index];
            return _buildTermItem(term, index);
          },
        ),
      ],
    );
  }

  Widget _buildTermItem(Map<String, dynamic> term, int index) {
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
              color: term['color'].withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              term['icon'],
              color: term['color'],
              size: 20,
            ),
          ),
          title: Text(
            term['title'],
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(
                term['content'],
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
                  color: Color(0xFF10B981).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.contact_support_rounded,
                  color: Color(0xFF10B981),
                  size: 20,
                ),
              ),
              SizedBox(width: 12),
              Text(
                "Butuh Bantuan?",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            "Jika Anda memiliki pertanyaan tentang persyaratan penggunaan ini, silakan hubungi tim support kami:",
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
                color: Color(0xFF6366F1),
                size: 18,
              ),
              SizedBox(width: 8),
              Text(
                "legal@newsdetection.com",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Color(0xFF6366F1),
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
                color: Color(0xFF10B981),
                size: 18,
              ),
              SizedBox(width: 8),
              Text(
                "+62 21-1234-5678",
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