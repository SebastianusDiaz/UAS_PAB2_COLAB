// favorite_screen.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_uas_pab2/model/movie.dart'; // <<< PASTIKAN INI ADA
import 'package:project_uas_pab2/screens/detail_screen.dart'; // Import DetailScreen untuk navigasi

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    final Color primaryBackgroundColor = const Color(0xFF1F253F);
    final Color appBarAndNavBarColor = const Color(0xFF2B3356);
    final Color accentColor = const Color(0xFF5A72FF);

    if (userId == null) {
      return Scaffold(
        backgroundColor: primaryBackgroundColor,
        appBar: AppBar(
          title: const Text(
            "Favorit",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: appBarAndNavBarColor,
          elevation: 0,
        ),
        body: const Center(
          child: Text(
            "Silakan login terlebih dahulu untuk melihat daftar favorit.",
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      appBar: AppBar(
        title: const Text(
          "Favorit",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: appBarAndNavBarColor,
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('favorites')
            .doc(userId)
            .collection('user_favorites')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
                child: Text('Error: ${snapshot.error}',
                    style: const TextStyle(color: Colors.red)));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "Belum ada film favorit.",
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            );
          }

          final favoriteMovies = snapshot.data!.docs.map((doc) {
            // Gunakan factory constructor fromFirestore dari model Movie
            return Movie.fromFirestore(doc.data() as Map<String, dynamic>);
          }).toList();

          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: favoriteMovies.length,
            itemBuilder: (context, index) {
              final movie = favoriteMovies[index];
              return Card(
                color: appBarAndNavBarColor,
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: movie.posterPath.isNotEmpty
                        ? Image.network(
                            movie.posterPath,
                            fit: BoxFit.cover,
                            width: 50,
                            height: 70,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                              color: Colors.grey[700],
                              width: 50,
                              height: 70,
                              child: const Icon(Icons.movie,
                                  color: Colors.white70),
                            ),
                          )
                        : Container(
                            color: Colors.grey[700],
                            width: 50,
                            height: 70,
                            child:
                                const Icon(Icons.movie, color: Colors.white70),
                          ),
                  ),
                  title: Text(
                    movie.title,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    // Ubah menjadi Column
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movie.category,
                        style: const TextStyle(color: Colors.white70),
                      ),
                      // Tampilkan rating bintang di sini
                      Row(
                        children: List.generate(5, (starIndex) {
                          return Icon(
                            starIndex < movie.rating
                                ? Icons.star
                                : Icons.star_border,
                            color: Colors.amber,
                            size: 16,
                          );
                        }),
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () async {
                      try {
                        final docId = movie
                            .title; // Menggunakan judul film sebagai ID dokumen
                        await FirebaseFirestore.instance
                            .collection('favorites')
                            .doc(userId)
                            .collection('user_favorites')
                            .doc(docId)
                            .delete();

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Dihapus dari favorit"),
                            backgroundColor: Colors.green,
                          ),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Gagal menghapus: $e"),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                  ),
                  onTap: () {
                    // Aktifkan navigasi ke DetailScreen saat item favorit di-tap
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailScreen(movie: movie),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
