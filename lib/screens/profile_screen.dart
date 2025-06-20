import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>(); // Untuk validasi form password
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPasswordController =
      TextEditingController();

  User? _currentUser;
  String? _currentUserName;
  String? _currentUserPhone;

  bool _isPasswordChangeLoading = false; // State khusus untuk loading ganti password

  final Color primaryBackgroundColor = const Color(0xFF1F253F);
  final Color appBarAndNavBarColor = const Color(0xFF2B3356);
  final Color accentColor = const Color(0xFF5A72FF);
  final Color buttonColor = const Color(0xFF5A72FF); // Warna untuk tombol

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser;
    // Inisialisasi email controller dari Firebase Auth
    _emailController.text = _currentUser?.email ?? '';
    _loadUserProfile(); // Memuat data profil dari Firestore
  }

  Future<void> _loadUserProfile() async {
    if (_currentUser == null) return;

    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(_currentUser!.uid)
          .get();

      if (userDoc.exists) {
        final userData = userDoc.data();
        setState(() {
          _currentUserName = userData?['name'] ?? 'Pengguna';
          _currentUserPhone = userData?['phone'] ?? 'Belum ada nomor telepon';
          _nameController.text = _currentUserName!;
          _phoneController.text = _currentUserPhone!;
        });
      }
    } catch (e) {
      print("Error loading user profile: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Gagal memuat profil: $e"),
            backgroundColor: Colors.red),
      );
    }
  }

  Future<void> _updateProfile() async {
    if (_currentUser == null) return;

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_currentUser!.uid)
          .update({
        'name': _nameController.text.trim(),
        'phone': _phoneController.text.trim(),
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Profil berhasil diperbarui!"),
            backgroundColor: Colors.green),
      );
      // Perbarui tampilan lokal
      setState(() {
        _currentUserName = _nameController.text.trim();
        _currentUserPhone = _phoneController.text.trim();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Gagal memperbarui profil: $e"),
            backgroundColor: Colors.red),
      );
    }
  }

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) return;

    if (_newPasswordController.text != _confirmNewPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Konfirmasi password baru tidak cocok."),
            backgroundColor: Colors.orange),
      );
      return;
    }

    setState(() {
      _isPasswordChangeLoading = true;
    });

    try {
      AuthCredential credential = EmailAuthProvider.credential(
        email: _currentUser!.email!,
        password: _oldPasswordController.text,
      );

      await _currentUser!.reauthenticateWithCredential(credential);
      await _currentUser!.updatePassword(_newPasswordController.text);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Password berhasil diubah!"),
            backgroundColor: Colors.green),
      );

      // Bersihkan field password
      _oldPasswordController.clear();
      _newPasswordController.clear();
      _confirmNewPasswordController.clear();
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == 'wrong-password') {
        errorMessage = "Password lama salah.";
      } else if (e.code == 'too-many-requests') {
        errorMessage = "Terlalu banyak permintaan. Coba lagi nanti.";
      } else {
        errorMessage = "Gagal mengubah password: ${e.message}";
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
      );
    } finally {
      setState(() {
        _isPasswordChangeLoading = false;
      });
    }
  }

  Future<void> _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      // Navigasi ke layar login setelah logout
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Gagal logout: $e"), backgroundColor: Colors.red),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Profil Saya',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: appBarAndNavBarColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: _signOut,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: _currentUser == null
          ? const Center(
              child: Text(
                "Silakan login untuk melihat profil Anda.",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: accentColor,
                          child: Icon(
                            Icons.person,
                            size: 60,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _currentUserName ?? 'Loading...',
                          style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _currentUser?.email ?? 'Tidak ada email',
                          style: const TextStyle(
                              fontSize: 16, color: Colors.white70),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _currentUserPhone ?? 'Tidak ada nomor telepon',
                          style: const TextStyle(
                              fontSize: 16, color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Update Profil',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  buildProfileTextField('Nama', _nameController),
                  const SizedBox(height: 16),
                  buildProfileTextField('Email', _emailController, readOnly: true),
                  const SizedBox(height: 16),
                  buildProfileTextField('Nomor Telepon', _phoneController,
                      keyboardType: TextInputType.phone),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _updateProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        textStyle: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      child: const Text('Update Profil'),
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Ganti Password',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        buildProfileTextField('Password Lama', _oldPasswordController,
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Masukkan password lama Anda';
                              }
                              return null;
                            }),
                        const SizedBox(height: 16),
                        buildProfileTextField('Password Baru', _newPasswordController,
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Masukkan password baru';
                              }
                              if (value.length < 6) {
                                return 'Password minimal 6 karakter';
                              }
                              return null;
                            }),
                        const SizedBox(height: 16),
                        buildProfileTextField(
                            'Konfirmasi Password Baru', _confirmNewPasswordController,
                            obscureText: true, validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Konfirmasi password baru Anda';
                          }
                          if (value != _newPasswordController.text) {
                            return 'Password tidak cocok';
                          }
                          return null;
                        }),
                        const SizedBox(height: 24),
                        _buildLoadingButton(
                          onPressed: _changePassword,
                          label: 'Ganti Password',
                          isLoading: _isPasswordChangeLoading,
                          icon: Icons.vpn_key,
                          backgroundColor: buttonColor,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  // Widget helper untuk membuat TextField profil
  Widget buildProfileTextField(String label, TextEditingController controller,
      {bool obscureText = false,
      TextInputType keyboardType = TextInputType.text,
      String? Function(String?)? validator,
      bool readOnly = false}) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      readOnly: readOnly,
      style: const TextStyle(color: Colors.white),
      cursorColor: accentColor,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: appBarAndNavBarColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: accentColor, width: 2),
        ),
      ),
      validator: validator,
    );
  }

  // Widget helper untuk membuat tombol loading (seperti yang sudah ada)
  Widget _buildLoadingButton({
    required VoidCallback onPressed,
    required String label,
    required bool isLoading,
    required IconData icon,
    required Color backgroundColor,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        icon: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Icon(icon, color: Colors.white),
        label: Text(label),
      ),
    );
  }
}