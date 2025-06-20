// lib/screens/add_screen.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_uas_pab2/model/movie.dart'; // Import model Movie

class AddMovieScreen extends StatefulWidget {
  const AddMovieScreen({Key? key}) : super(key: key);

  @override
  _AddMovieScreenState createState() => _AddMovieScreenState();
}

class _AddMovieScreenState extends State<AddMovieScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController posterPathController = TextEditingController();

  String? _selectedCategory;
  double _selectedRating = 0.0; // Tambahkan variabel untuk rating bintang

  final List<String> _categories = [
    'Horor',
    'Komedi',
    'Drama',
    'Romantis',
    'Thriller',
    'Action',
    'Sci-Fi',
    'Petualangan',
    'Keluarga',
  ];

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final Color primaryBackgroundColor = const Color(0xFF1F253F);
  final Color appBarAndNavBarColor = const Color(0xFF2B3356);
  final Color accentColor = const Color(0xFF5A72FF);

  void saveMovie() async {
    final title = titleController.text.trim();
    final description = descriptionController.text.trim();
    final posterPath = posterPathController.text.trim();
    final category = _selectedCategory; // Gunakan _selectedCategory
    final rating = _selectedRating; // Gunakan _selectedRating

    if (title.isEmpty ||
        description.isEmpty ||
        posterPath.isEmpty ||
        category == null ||
        rating == 0.0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Semua field harus diisi!"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final movie = Movie(
        title: title,
        description: description,
        posterPath: posterPath,
        category: category,
        rating: rating, // Simpan rating
      );

      await _firestore.collection('movies').add(movie.toJson());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Film berhasil ditambahkan!"),
          backgroundColor: Colors.green,
        ),
      );

      // Bersihkan field setelah sukses
      titleController.clear();
      descriptionController.clear();
      posterPathController.clear();
      setState(() {
        _selectedCategory = null; // Reset category dropdown
        _selectedRating = 0.0; // Reset rating
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Gagal menambahkan film: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    posterPathController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Tambah Film Baru',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: appBarAndNavBarColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildTextField('Judul Film', titleController),
              const SizedBox(height: 16),
              buildTextField('Deskripsi', descriptionController, maxLines: 5),
              const SizedBox(height: 16),
              buildTextField('URL Poster', posterPathController),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(
                  labelText: 'Kategori',
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
                dropdownColor: appBarAndNavBarColor,
                style: const TextStyle(color: Colors.white),
                items: _categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCategory = newValue;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Pilih kategori film';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Input Rating Bintang
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Rating:',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          index < _selectedRating
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.amber,
                        ),
                        onPressed: () {
                          setState(() {
                            _selectedRating = (index + 1).toDouble();
                          });
                        },
                      );
                    }),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: saveMovie,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    textStyle: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  child: const Text('Simpan Film'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Fungsi buildTextField tidak perlu diubah, tapi tidak digunakan untuk rating lagi.
  Widget buildTextField(String label, TextEditingController controller,
      {int maxLines = 1, TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
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
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      cursorColor: accentColor,
      keyboardType: keyboardType,
    );
  }
}
