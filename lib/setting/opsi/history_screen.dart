import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = true;
  List<Map<String, dynamic>> _historyData = [];
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadHistoryData();
  }

  // Load history data manually (avoid index issues)
  Future<void> _loadHistoryData() async {
    User? user = _auth.currentUser;
    if (user == null) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'User not logged in';
      });
      return;
    }

    try {
      print("🔍 Loading history for user: ${user.email ?? user.uid}");
      
      // Simple query without orderBy (no index needed)
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection("news_analysis")
          .where("user", isEqualTo: user.email ?? user.uid)
          .get();

      print("🔍 Found ${snapshot.docs.length} documents");

      List<Map<String, dynamic>> data = [];
      for (var doc in snapshot.docs) {
        Map<String, dynamic> docData = doc.data() as Map<String, dynamic>;
        docData['id'] = doc.id; // Add document ID
        data.add(docData);
        print("🔍 Doc data: $docData");
      }

      // Manual sorting by timestamp (newest first)
      data.sort((a, b) {
        Timestamp? aTime = a['time'];
        Timestamp? bTime = b['time'];
        if (aTime == null && bTime == null) return 0;
        if (aTime == null) return 1;
        if (bTime == null) return -1;
        return bTime.compareTo(aTime); // Descending
      });

      setState(() {
        _historyData = data;
        _isLoading = false;
        _errorMessage = '';
      });

    } catch (e) {
      print("❌ Error loading history: $e");
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    User? user = _auth.currentUser;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor, // Gunakan background dari theme
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor ?? Theme.of(context).colorScheme.primary,
        title: Row(
          children: [
            Icon(Icons.history, color: Theme.of(context).colorScheme.primary),
            SizedBox(width: 8),
            Text(
              "History Analisis",
              style: TextStyle(
                color: Theme.of(context).appBarTheme.titleTextStyle?.color ?? Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_outline, color: Colors.red),
            onPressed: _showDeleteAllDialog,
            tooltip: "Hapus Semua History",
          ),
        ],
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          // Status banner
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(8),
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: user != null ? Colors.green[100] : Colors.red[100],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: user != null ? Colors.green : Colors.red,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  user != null ? Icons.check_circle : Icons.error,
                  color: user != null ? Colors.green : Colors.red,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    user != null 
                        ? "✅ User: ${user.email} | Data: ${_historyData.length} items"
                        : "❌ User belum login",
                    style: TextStyle(
                      color: user != null ? Colors.green[800] : Colors.red[800],
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Main content
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text("⏳ Memuat history..."),
          ],
        ),
      );
    }

    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error, size: 64, color: Colors.red),
              SizedBox(height: 16),
              Text(
                "❌ Error Loading History",
                style: TextStyle(fontSize: 18, color: Colors.red, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _errorMessage,
                  style: TextStyle(fontSize: 12, color: Colors.red[700]),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadHistoryData,
                child: Text("🔄 Coba Lagi"),
              ),
            ],
          ),
        ),
      );
    }

    if (_historyData.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey[400]),
            SizedBox(height: 16),
            Text(
              "📝 Belum ada history analisis",
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
            SizedBox(height: 8),
            Text(
              "Mulai analisis berita di TaskScreen!",
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      itemCount: _historyData.length,
      itemBuilder: (context, index) {
        return _buildHistoryCard(_historyData[index], index);
      },
    );
  }

  Widget _buildHistoryCard(Map<String, dynamic> data, int index) {
    try {
      String newsText = (data['text'] ?? 'Teks tidak tersedia').toString();
      String result = (data['result'] ?? 'Unknown').toString();
      String kesimpulan = (data['kesimpulan'] ?? 'Tidak ada kesimpulan').toString();
      double confidence = (data['confidence'] ?? 0.0).toDouble();
      
      // Safe timestamp handling
      String formattedDate = 'Waktu tidak tersedia';
      try {
        Timestamp? timestamp = data['time'];
        if (timestamp != null) {
          formattedDate = DateFormat('dd MMM yyyy, HH:mm').format(timestamp.toDate());
        }
      } catch (e) {
        print("❌ Date format error: $e");
        formattedDate = 'Error parsing date';
      }

      // Determine colors
      Color resultColor = result.toLowerCase() == 'fakta' ? Colors.green : Colors.red;
      String emoji = result.toLowerCase() == 'fakta' ? '✅' : '❌';

      return Card(
        margin: EdgeInsets.only(bottom: 12),
        elevation: 2,
        color: Theme.of(context).cardColor, // Card mengikuti theme
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
              ),
              child: Row(
                children: [
                  Text(
                    "#${index + 1}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.access_time, size: 14, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7)),
                  SizedBox(width: 4),
                  Text(
                    formattedDate,
                    style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7)),
                  ),
                  Spacer(),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: resultColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: resultColor.withOpacity(0.3)),
                    ),
                    child: Text(
                      "$emoji $result (${confidence.toStringAsFixed(1)}%)",
                      style: TextStyle(
                        color: resultColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User input section
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Theme.of(context).colorScheme.primary.withOpacity(0.18)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.person, size: 16, color: Theme.of(context).colorScheme.primary),
                            SizedBox(width: 4),
                            Text(
                              "Input User:",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 6),
                        Text(
                          newsText,
                          style: TextStyle(fontSize: 14, height: 1.4, color: Theme.of(context).colorScheme.onSurface),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 12),

                  // Bot response section
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Theme.of(context).dividerColor),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.smart_toy, size: 16, color: Theme.of(context).colorScheme.secondary),
                            SizedBox(width: 4),
                            Text(
                              "Analisis AI:",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 6),
                        Text(
                          kesimpulan,
                          style: TextStyle(fontSize: 14, height: 1.4, color: Theme.of(context).colorScheme.onSurface),
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

    } catch (e) {
      print("❌ Error building card $index: $e");
      return Card(
        margin: EdgeInsets.only(bottom: 12),
        color: Colors.red[50],
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            "❌ Error displaying item #${index + 1}: $e",
            style: TextStyle(color: Colors.red),
          ),
        ),
      );
    }
  }

  // Show delete all confirmation dialog
  void _showDeleteAllDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning, color: Colors.red),
            SizedBox(width: 8),
            Text("Hapus Semua History"),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Apakah Anda yakin ingin menghapus SEMUA history analisis?"),
            SizedBox(height: 8),
            Text(
              "⚠️ Tindakan ini tidak dapat dibatalkan!",
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Total data: ${_historyData.length} items",
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await _deleteAllHistory();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text("🗑️ Hapus Semua"),
          ),
        ],
      ),
    );
  }

  // Delete all history
  Future<void> _deleteAllHistory() async {
    User? user = _auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("❌ User tidak login!"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text("🗑️ Menghapus semua history..."),
            ],
          ),
        ),
      ),
    );

    try {
      // Get all documents for this user
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection("news_analysis")
          .where("user", isEqualTo: user.email ?? user.uid)
          .get();

      // Delete using batch
      WriteBatch batch = FirebaseFirestore.instance.batch();
      for (QueryDocumentSnapshot doc in snapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();

      // Close loading dialog
      Navigator.pop(context);

      // Refresh data
      await _loadHistoryData();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("✅ Berhasil menghapus ${snapshot.docs.length} history"),
          backgroundColor: Colors.green,
        ),
      );

    } catch (e) {
      // Close loading dialog
      Navigator.pop(context);
      
      print("❌ Error deleting all history: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("❌ Error: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}