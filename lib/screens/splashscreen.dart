import 'package:flutter/material.dart';
import './auth/login_screen.dart'; // Pastikan path sudah benar

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    
    // Pastikan navigasi berjalan setelah frame pertama selesai
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _navigateToLogin();
    });
  }

  Future<void> _navigateToLogin() async {
    await Future.delayed(const Duration(seconds: 3));

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Warna latar belakang
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/Logo.png', // Pastikan file logo ada di folder assets
              height: 200, // Sesuaikan ukuran gambar
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(
              color: Colors.blue, // Ganti warna agar terlihat di latar putih
            ),
            const SizedBox(height: 10),
            const Text(
              'Loading...',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
