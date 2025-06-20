import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;

  void loginUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Login berhasil"),
          backgroundColor: Colors.green, // Warna snackbar berhasil
        ),
      );

      Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Login gagal: ${e.message}"),
          backgroundColor: Colors.red, // Warna snackbar gagal
        ),
      );
    }

    setState(() => isLoading = false);
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // --- DEFINISI WARNA SAMA DENGAN HOME SCREEN ---
    final Color primaryBackgroundColor =
        Color(0xFF1F253F); // Latar belakang utama
    final Color appBarAndNavBarColor =
        Color(0xFF2B3356); // Warna untuk AppBar dan card/input background
    final Color accentColor =
        Color(0xFF5A72FF); // Warna aksen untuk tombol dan indikator
    // --- AKHIR DEFINISI WARNA ---

    return Scaffold(
      backgroundColor: primaryBackgroundColor, // Background utama Scaffold
      appBar: AppBar(
        title: const Text(
          "Login",
          style: TextStyle(color: Colors.white), // Warna teks AppBar putih
        ),
        backgroundColor: appBarAndNavBarColor, // Warna AppBar
        elevation: 0, // Hapus bayangan
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Logo or header
                // Ganti FlutterLogo dengan logo atau gambar yang sesuai tema Anda
                Icon(Icons.movie,
                    size: 100,
                    color: accentColor), // Contoh ikon film sebagai logo
                const SizedBox(height: 32),

                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    labelStyle:
                        TextStyle(color: Colors.white70), // Warna label input
                    filled: true,
                    fillColor: appBarAndNavBarColor, // Background input field
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none, // Hapus border
                    ),
                    focusedBorder: OutlineInputBorder(
                      // Border saat fokus
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                          color: accentColor, width: 2), // Warna border fokus
                    ),
                    prefixIcon: Icon(Icons.email,
                        color: Colors.white54), // Warna ikon prefix
                  ),
                  keyboardType: TextInputType.emailAddress,
                  style:
                      TextStyle(color: Colors.white), // Warna teks yang diketik
                  validator: (value) =>
                      value!.isEmpty ? 'Email tidak boleh kosong' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: "Password",
                    labelStyle:
                        TextStyle(color: Colors.white70), // Warna label input
                    filled: true,
                    fillColor: appBarAndNavBarColor, // Background input field
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none, // Hapus border
                    ),
                    focusedBorder: OutlineInputBorder(
                      // Border saat fokus
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                          color: accentColor, width: 2), // Warna border fokus
                    ),
                    prefixIcon: Icon(Icons.lock,
                        color: Colors.white54), // Warna ikon prefix
                  ),
                  obscureText: true,
                  style:
                      TextStyle(color: Colors.white), // Warna teks yang diketik
                  validator: (value) => (value == null || value.length < 6)
                      ? 'Minimal 6 karakter'
                      : null,
                ),
                const SizedBox(height: 24),

                isLoading
                    ? CircularProgressIndicator(
                        color: accentColor) // Warna loading sesuai aksen
                    : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: loginUser,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                accentColor, // Warna tombol login sesuai aksen
                            foregroundColor: Colors.white, // Warna teks tombol
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(8), // Sudut membulat
                            ),
                            textStyle: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          child: const Text("Login"),
                        ),
                      ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  style: TextButton.styleFrom(
                    foregroundColor:
                        accentColor, // Warna teks tombol daftar sesuai aksen
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                  child: const Text("Belum punya akun? Daftar di sini"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
