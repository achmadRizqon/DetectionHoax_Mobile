import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:provider/provider.dart';

import '../home/home_screen.dart';
import '../setting/setting_screen.dart';
import '../setting/tema/theme.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key, Function(ThemeMode p1)? toggleTheme});

  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  final TextEditingController _newsController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ScrollController _scrollController = ScrollController();

  // Static variables to preserve state across navigation
  static List<Map<String, dynamic>> _persistentChatMessages = [];
  static bool _persistentShowInputField = true;
  static String? _persistentCurrentUserId; // Track current user
  
  List<Map<String, dynamic>> _chatMessages = [];
  bool _isLoading = false;
  bool _isTyping = false;
  String _currentLanguage = 'id';
  bool _showInputField = true;

  @override
  bool get wantKeepAlive => true;

  // Animation controllers
  late AnimationController _pulseController;
  late AnimationController _scanController;
  late Animation<double> _scanAnimation;

  final String _huggingFaceEndpoint = "https://achmad021-api-model.hf.space/prediction";
  
  @override
  void initState() {
    super.initState();
    
    // Check if user has changed and clear data if necessary
    _checkUserChange();
    
    // Listen to auth state changes
    _auth.authStateChanges().listen((User? user) {
      _handleAuthStateChange(user);
    });
    
    // Restore state from static variables
    _chatMessages = List.from(_persistentChatMessages);
    _showInputField = _persistentShowInputField;
    
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
    
    _scanController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    
    
    _scanAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scanController, curve: Curves.easeInOut)
    );
  }

  // Function to check if user has changed
  void _checkUserChange() {
    User? currentUser = _auth.currentUser;
    String? currentUserId = currentUser?.uid;
    
    // If user has changed (logout, login with different account), clear data
    if (_persistentCurrentUserId != currentUserId) {
      _clearUserData();
      _persistentCurrentUserId = currentUserId;
      
      print("🔄 User changed detected. Data cleared.");
      print("👤 Previous user: $_persistentCurrentUserId");
      print("👤 Current user: $currentUserId");
    }
  }

  // Function to handle auth state changes
  void _handleAuthStateChange(User? user) {
    String? newUserId = user?.uid;
    
    // If user logged out or changed account
    if (_persistentCurrentUserId != newUserId) {
      _clearUserData();
      _persistentCurrentUserId = newUserId;
      
      setState(() {
        _chatMessages = List.from(_persistentChatMessages);
        _showInputField = _persistentShowInputField;
        _newsController.clear();
      });
      
      if (user == null) {
        print("🚪 User logged out. All data cleared.");
      } else {
        print("🔄 User changed to: ${user.email ?? user.uid}. Data cleared.");
      }
    }
  }

  // Function to clear all user-related data
  void _clearUserData() {
    _persistentChatMessages.clear();
    _persistentShowInputField = true;
    
    // Also clear current state if widget is active
    if (mounted) {
      setState(() {
        _chatMessages.clear();
        _showInputField = true;
        _isLoading = false;
        _isTyping = false;
      });
      _newsController.clear();
    }
  }

  // Function to manually clear data (dapat dipanggil dari luar jika diperlukan)
  // ignore: unused_element
  static void clearAllData() {
    _persistentChatMessages.clear();
    _persistentShowInputField = true;
    _persistentCurrentUserId = null;
    print("🧹 All static data manually cleared.");
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _scanController.dispose();
    super.dispose();
  }

  String _formatPredictionResult(Map<String, dynamic> data) {
    String prediction = data['prediction'] ?? 'unknown';
    double confidence = data['confidence'] ?? 0.0;
    // double similarity = data['similarity_score'] ?? 0.0;
    // bool thresholdMet = data['threshold_met'] ?? false;
    // double thresholdUsed = data['threshold_used'] ?? 0.0;
    
    Map<String, dynamic> probabilities = data['probabilities'] ?? {};
    double faktaProb = probabilities['fakta'] ?? 0.0;
    double hoaxProb = probabilities['hoax'] ?? 0.0;
    
    String conclusion = data['conclusion'] ?? '';
    // String reference = data['reference'] ?? '';

    String emoji = prediction.toLowerCase() == 'fakta' ? '✅' : '❌';
    String predictionText = prediction.toLowerCase() == 'fakta' ? 'FAKTA' : 'HOAX';

    StringBuffer result = StringBuffer();
    
    result.writeln('📊 HASIL ANALISIS BERITA\n');
    
    result.writeln('$emoji PREDIKSI: $predictionText');
    result.writeln('📈 Tingkat Keyakinan: ${confidence.toStringAsFixed(1)}%');
    // result.writeln('🔍 Skor Kemiripan: ${similarity.toStringAsFixed(1)}%');
    // result.writeln('🎯 Threshold: ${thresholdUsed.toStringAsFixed(0)}% ${thresholdMet ? '(Terpenuhi ✓)' : '(Tidak Terpenuhi ✗)'}');
    
    result.writeln('\n📋 DETAIL PROBABILITAS:');
    result.writeln('• Fakta: ${faktaProb.toStringAsFixed(1)}%');
    result.writeln('• Hoax: ${hoaxProb.toStringAsFixed(1)}%');
    
    if (conclusion.isNotEmpty) {
      result.writeln('\n💡 KESIMPULAN:');
      result.writeln(conclusion);
    }
    
    // if (reference.isNotEmpty) {
    //   result.writeln('\n📚 REFERENSI:');
    //   result.writeln(reference);
    // }
    
    result.writeln('\n⚠️ CATATAN: Hasil ini merupakan prediksi AI dan sebaiknya dikonfirmasi dengan sumber terpercaya.');

    return result.toString();
  }

  String _extractKesimpulan(Map<String, dynamic> data) {
    String prediction = data['prediction'] ?? 'unknown';
    double confidence = data['confidence'] ?? 0.0;
    String conclusion = data['conclusion'] ?? '';
    
    if (conclusion.isNotEmpty) {
      return conclusion;
    } else {
      String predictionText = prediction.toLowerCase() == 'fakta' ? 'FAKTA' : 'HOAX';
      return 'Berita ini diprediksi sebagai $predictionText dengan tingkat keyakinan ${confidence.toStringAsFixed(1)}%';
    }
  }

  Future<void> _fetchPredictionFromServer() async {
    String newsContent = _newsController.text.trim();

    if (newsContent.isEmpty || newsContent.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _currentLanguage == 'en' 
                ? "Text must be at least 10 characters!" 
                : "Teks harus diisi minimal 10 karakter!"
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    setState(() {
      _chatMessages.add({"sender": "user", "text": newsContent});
      _isLoading = true;
      _isTyping = true;
      _showInputField = false;
      _persistentChatMessages = List.from(_chatMessages);
      _persistentShowInputField = _showInputField;
    });
    _scanController.forward().then((_) => _scanController.repeat());
    _scrollToBottom();

    try {
      final url = Uri.parse(_huggingFaceEndpoint);
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'text': newsContent}),
      ).timeout(const Duration(seconds: 60));

      _scanController.stop();
      _scanController.reset();

      setState(() {
        _isTyping = false;
      });

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        // Asumsikan responseData sudah sesuai format lama (data, success, dsb)
        if (responseData['success'] == true && responseData.containsKey('data')) {
          Map<String, dynamic> data = responseData['data'];
          String formattedResult = _formatPredictionResult(data);
          setState(() {
            _chatMessages.add({
              "sender": "bot",
              "text": formattedResult,
              "isAnimated": true,
              "predictionData": data,
            });
          });
          _scrollToBottom();
          setState(() {
            _isLoading = false;
            _newsController.clear();
          });
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _persistentChatMessages = List.from(_chatMessages);
          });
          await _saveToFirestoreSimple(newsContent, data);
        } else {
          String errorMessage = responseData['message'] ?? 'Unknown error';
          _handleError("Server error: $errorMessage");
        }
      } else {
        _handleError("HTTP Error: "+response.statusCode.toString()+" - "+response.body);
      }
    } catch (e) {
      _scanController.stop();
      _scanController.reset();
      setState(() {
        _isTyping = false;
      });
      _handleError("Connection error: $e");
    }
  }

  Future<void> _saveToFirestoreSimple(String newsText, Map<String, dynamic> predictionData) async {
    User? user = _auth.currentUser;
    if (user == null) {
      print("❌ User not logged in!");
      return;
    }

    try {
      String prediction = predictionData['prediction'] ?? 'unknown';
      String predictionText = prediction.toLowerCase() == 'fakta' ? 'FAKTA' : 'HOAX';
      String kesimpulan = _extractKesimpulan(predictionData);
      
      Map<String, dynamic> dataToSave = {
        "user": user.email ?? user.uid,
        "text": newsText,
        "result": predictionText,
        "kesimpulan": kesimpulan,
        "time": FieldValue.serverTimestamp(),
        "confidence": predictionData['confidence'] ?? 0.0,
      };

      DocumentReference doc = await FirebaseFirestore.instance
          .collection("news_analysis")
          .add(dataToSave);
      
      print("✅ Data saved to Firestore!");
      print("📄 Doc ID: ${doc.id}");
      print("👤 User: ${dataToSave['user']}");
      print("📝 Text: ${newsText.substring(0, 50)}...");
      print("📊 Result: $predictionText");
      print("💡 Kesimpulan: $kesimpulan");
      
    } catch (e) {
      print("❌ Firestore error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error saving to database: $e"),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _handleError(String errorMessage) {
    setState(() {
      _isLoading = false;
      _isTyping = false;
      _chatMessages.add({
        "sender": "bot",
        "text": _currentLanguage == 'en'
            ? "❌ Sorry, there was an error analyzing the news:\n\n$errorMessage\n\nPlease check your internet connection and try again."
            : "❌ Maaf, terjadi kesalahan saat menganalisis berita:\n\n$errorMessage\n\nSilakan periksa koneksi internet Anda dan coba lagi.",
        "isAnimated": false,
      });
      
      // Update persistent state
      _persistentChatMessages = List.from(_chatMessages);
    });
    
    print("Error details: $errorMessage");
    _scrollToBottom();
  }

  // Function untuk memulai deteksi baru
  void _startNewDetection() {
    setState(() {
      _showInputField = true;
      _chatMessages.clear(); // Clear previous messages for fresh start
      _newsController.clear();
      
      // Update persistent state
      _persistentChatMessages.clear();
      _persistentShowInputField = true;
    });
  }

  // Professional result card widget
  Widget _buildAnalysisResult(Map<String, dynamic> message) {
    final data = message["predictionData"] as Map<String, dynamic>?;
    if (data == null) return SizedBox.shrink();

    String prediction = data['prediction'] ?? 'unknown';
    double confidence = data['confidence'] ?? 0.0;
    bool isFact = prediction.toLowerCase() == 'fakta';
    
    return Container(
      margin: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isFact 
              ? [Colors.green.shade50, Colors.green.shade100]
              : [Colors.red.shade50, Colors.red.shade100],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isFact ? Colors.green : Colors.red,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: (isFact ? Colors.green : Colors.red).withOpacity(0.2),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isFact ? Colors.green : Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isFact ? Icons.verified : Icons.warning,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "HASIL ANALISIS",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[600],
                          letterSpacing: 1,
                        ),
                      ),
                      Text(
                        isFact ? "BERITA FAKTA" : "TERINDIKASI HOAX",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isFact ? Colors.green[700] : Colors.red[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 16),
            
            // Confidence meter
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Tingkat Keyakinan",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                      ),
                      Text(
                        "${confidence.toStringAsFixed(1)}%",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isFact ? Colors.green[700] : Colors.red[700],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: confidence / 100,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isFact ? Colors.green : Colors.red,
                    ),
                    minHeight: 8,
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 16),
            
            // Full detailed text (animated only for new results)
            if (message["isAnimated"] == true)
              AnimatedTextKit(
                animatedTexts: [
                  TypewriterAnimatedText(
                    message["text"],
                    textStyle: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                    speed: Duration(milliseconds: 30),
                  ),
                ],
                totalRepeatCount: 1,
                isRepeatingAnimation: false,
                onFinished: () {
                  // Set animation to false after first play to prevent replay
                  setState(() {
                    message["isAnimated"] = false;
                    // Update persistent state when animation finishes
                    _persistentChatMessages = List.from(_chatMessages);
                  });
                },
              )
            else
              Text(
                message["text"],
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  height: 1.5,
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Professional input message widget
  Widget _buildInputMessage(String text) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person,
              color: Colors.white,
              size: 20,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "TEKS BERITA YANG DIANALISIS",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.primary,
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.onSurface,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Professional scanning indicator
  Widget _buildScanningIndicator() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue.shade50,
            Colors.blue.shade100,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.shade300),
      ),
      child: Column(
        children: [
          AnimatedBuilder(
            animation: _scanAnimation,
            builder: (context, child) {
              return Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: SweepGradient(
                    colors: [
                      Colors.blue.shade300,
                      Colors.blue.shade600,
                      Colors.blue.shade300,
                    ],
                    stops: [0.0, _scanAnimation.value, 1.0],
                  ),
                ),
                child: Container(
                  margin: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.psychology,
                    size: 36,
                    color: Colors.blue.shade600,
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 16),
          Text(
            "🔍 MENGANALISIS BERITA",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade700,
              letterSpacing: 1,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Sistem AI sedang memproses dan menganalisis konten berita...",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Colors.blue.shade600,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    
    return Consumer<ThemeManager>(
      builder: (context, themeManager, child) {
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: CustomScrollView(
            controller: _scrollController,
            slivers: [
              // Clean App Bar
              SliverAppBar(
                floating: false,
                pinned: true,
                elevation: 0,
                backgroundColor: Theme.of(context).colorScheme.primary,
                automaticallyImplyLeading: false,
                title: Text(
                  "Deteksi Berita Hoax",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                centerTitle: true,
                actions: [
                  if (!_showInputField && !_isLoading)
                    IconButton(
                      icon: Icon(Icons.add_circle, color: Colors.white, size: 28),
                      onPressed: _startNewDetection,
                      tooltip: "Deteksi Baru",
                    ),
                  SizedBox(width: 8),
                ],
              ),
              
              // Welcome message when no analysis yet
              if (_chatMessages.isEmpty && _showInputField)
                SliverToBoxAdapter(
                  child: Container(
                    margin: EdgeInsets.all(16),
                    padding: EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).colorScheme.primary.withOpacity(0.1),
                          Theme.of(context).colorScheme.primary.withOpacity(0.05),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.assignment_turned_in,
                          size: 64,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        SizedBox(height: 16),
                        Text(
                          "Selamat datang di Deteksi Berita Hoax",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Masukkan teks berita di bawah untuk memverifikasi keasliannya menggunakan teknologi AI",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                            height: 1.4,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              
              // Messages List
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (_isTyping && index == _chatMessages.length) {
                      return _buildScanningIndicator();
                    }
                    
                    final message = _chatMessages[index];
                    if (message["sender"] == "user") {
                      return _buildInputMessage(message["text"]);
                    } else {
                      // Check if this is a prediction result
                      if (message.containsKey("predictionData")) {
                        return _buildAnalysisResult(message);
                      } else {
                        // Error message
                        return Container(
                          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.red.shade300),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.error, color: Colors.red),
                              SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  message["text"],
                                  style: TextStyle(color: Colors.red.shade700),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    }
                  },
                  childCount: _chatMessages.length + (_isTyping ? 1 : 0),
                ),
              ),
              
              // Bottom Spacing
              SliverToBoxAdapter(
                child: SizedBox(height: _showInputField ? 220 : 80),
              ),
            ],
          ),
          
          // Professional Input Section - Show only when needed
          bottomSheet: _showInputField ? Container(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 32),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: Offset(0, -5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  "Masukkan teks berita untuk dianalisis",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _newsController,
                    maxLines: 4,
                    minLines: 3,
                    enabled: !_isLoading,
                    style: Theme.of(context).textTheme.bodyMedium,
                    decoration: InputDecoration(
                      hintText: 'Paste atau ketik berita yang ingin Anda verifikasi...',
                      hintStyle: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 14,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(20),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _fetchPredictionFromServer,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      elevation: 4,
                      shadowColor: Theme.of(context).colorScheme.primary.withOpacity(0.4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: _isLoading
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              ),
                              SizedBox(width: 12),
                              Text("Menganalisis...", style: TextStyle(fontSize: 16)),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.assignment_turned_in, size: 24),
                              SizedBox(width: 8),
                              Text(
                                "ANALISIS BERITA",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ],
            ),
          ) : null,
          
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
            selectedItemColor: Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
            unselectedItemColor: Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
            currentIndex: 1,
            onTap: (index) {
              if (index == 0) {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
              } else if (index == 2) {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const SettingScreen()));
              }
            },
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.assignment_turned_in), label: 'Tasks'),
              BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
            ],
          ),
        );
      },
    );
  }
}