import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 🔹 Login Method
  Future<String?> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null; // Null berarti sukses
    } on FirebaseAuthException catch (e) {
      return _handleAuthError(e);
    } catch (e) {
      return 'Terjadi kesalahan, coba lagi.';
    }
  }

  // 🔹 Registrasi dengan Nama
  Future<String?> signUp(String email, String password, String name) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // 🔹 Menambahkan nama pengguna setelah registrasi
      await userCredential.user?.updateDisplayName(name);
      await userCredential.user?.reload(); // Memastikan perubahan tersimpan

      return null; // Sukses
    } on FirebaseAuthException catch (e) {
      return _handleAuthError(e);
    } catch (e) {
      return 'Terjadi kesalahan, coba lagi.';
    }
  }

  // 🔹 Logout Method
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // 🔹 Mendapatkan Nama Pengguna Saat Ini
  String? getUserName() {
    return _auth.currentUser?.displayName ?? "User";
  }

  // 🔹 Error Handling
  String _handleAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'Format email tidak valid.';
      case 'user-not-found':
        return 'Email tidak terdaftar.';
      case 'wrong-password':
        return 'Password salah.';
      case 'email-already-in-use':
        return 'Email sudah digunakan.';
      case 'weak-password':
        return 'Gunakan password lebih kuat.';
      default:
        return 'Terjadi kesalahan, coba lagi.';
    }
  }
}
