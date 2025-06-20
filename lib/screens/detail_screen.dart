// lib/screens/detail_screen.dart
import 'package:flutter/material.dart';
import 'package:project_uas_pab2/model/movie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DetailScreen extends StatefulWidget {
  final Movie movie;

  const DetailScreen({super.key, required this.movie});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool _isFavorite = false;
  final User? currentUser = FirebaseAuth.instance.currentUser;

  final Color primaryBackgroundColor = const Color(0xFF1F253F);
  final Color appBarAndNavBarColor = const Color(0xFF2B3356);
  final Color accentColor = const Color(0xFF5A72FF);

  @override
  void initState() {
    super.initState();
    _checkIsFavorite();
  }

  Future<void> _checkIsFavorite() async {
    if (currentUser == null) return;

    final userId = currentUser!.uid;
    final docRef = FirebaseFirestore.instance
        .collection('favorites')
        .doc(userId)
        .collection('user_favorites')
        .doc(widget.movie.title); // Menggunakan judul film sebagai ID dokumen

    final docSnapshot = await docRef.get();
    setState(() {
      _isFavorite = docSnapshot.exists;
    });
  }

  Future<void> _toggleFavorite() async {
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Anda harus login untuk menambahkan ke favorit."),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final userId = currentUser!.uid;
    final docRef = FirebaseFirestore.instance
        .collection('favorites')
        .doc(userId)
        .collection('user_favorites')
        .doc(widget.movie.title);

    try {
      if (_isFavorite) {
        await docRef.delete();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Dihapus dari favorit"),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        await docRef.set(widget.movie.toJson());
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Ditambahkan ke favorit"),
            backgroundColor: Colors.green,
          ),
        );
      }
      setState(() {
        _isFavorite = !_isFavorite;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Gagal memperbarui favorit: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            floating: false,
            pinned: true,
            backgroundColor: appBarAndNavBarColor,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                widget.movie.posterPath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[800],
                  child: Center(
                    child: Icon(Icons.movie, color: Colors.white70, size: 80),
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  _isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: _isFavorite ? Colors.red : Colors.white,
                  size: 30,
                ),
                onPressed: _toggleFavorite,
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.movie.title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Kategori: ${widget.movie.category}',
                    style: const TextStyle(fontSize: 18, color: Colors.white70),
                  ),
                  const SizedBox(height: 5),
                  // Menampilkan Rating
                  Row(
                    children: [
                      Text(
                        'Rating: ',
                        style: const TextStyle(
                            fontSize: 18, color: Colors.white70),
                      ),
                      ...List.generate(5, (starIndex) {
                        return Icon(
                          starIndex <
                                  widget.movie.rating
                                      .floor() // Gunakan .floor()
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.amber,
                          size: 18, // Ukuran bintang di detail screen
                        );
                      }),
                      const SizedBox(width: 8),
                      Text(
                        '${widget.movie.rating}/5', // Tampilkan angka rating juga
                        style: const TextStyle(
                            fontSize: 18, color: Colors.white70),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Sinopsis:',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.movie.description,
                    style: const TextStyle(
                        fontSize: 16, height: 1.5, color: Colors.white70),
                  ),
                  const SizedBox(height: 30),
                  // Jika Anda punya tombol booking, pastikan tidak menggunakan jadwal
                  // Misalnya: Tombol booking bisa diaktifkan jika film sudah rilis atau logika lain
                  // ElevatedButton(
                  //   onPressed: () {
                  //     // Logic for booking
                  //   },
                  //   child: const Text('Pesan Tiket'),
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
