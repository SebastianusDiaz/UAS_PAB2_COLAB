// lib/screens/search_screen.dart
import 'package:flutter/material.dart';
import 'package:project_uas_pab2/model/movie.dart'; // pastikan model Movie sudah ada
import 'package:project_uas_pab2/screens/detail_screen.dart';

class SearchScreen extends StatefulWidget {
  final List<Movie> allMovies;

  const SearchScreen({super.key, required this.allMovies});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Movie> _searchResults = [];

  final Color primaryBackgroundColor = const Color(0xFF1F253F);
  final Color appBarAndNavBarColor = const Color(0xFF2B3356);
  final Color accentColor = const Color(0xFF5A72FF);

  @override
  void initState() {
    super.initState();
    _searchResults = widget.allMovies; // Ini sudah menggunakan objek Movie yang benar
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _searchResults = widget.allMovies.where((movie) {
        return movie.title.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      appBar: AppBar(
        backgroundColor: appBarAndNavBarColor,
        title: const Text(
          'Cari Film',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Cari Film...',
                labelStyle: const TextStyle(color: Colors.white70),
                prefixIcon: const Icon(Icons.search, color: Colors.white70),
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
              style: const TextStyle(color: Colors.white),
              cursorColor: accentColor,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _searchResults.isEmpty
                  ? Center(
                      child: Text(
                        _searchController.text.isEmpty
                            ? 'Ketik nama film untuk mencari.'
                            : 'Film tidak ditemukan.',
                        style: const TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _searchResults.length,
                      itemBuilder: (context, index) {
                        final movie = _searchResults[index];
                        return Card(
                          color: appBarAndNavBarColor,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          child: ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: movie.posterPath.isNotEmpty
                                  ? Image.network(
                                      movie.posterPath,
                                      width: 50,
                                      height: 70,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
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
                                      child: const Icon(Icons.movie,
                                          color: Colors.white70),
                                    ),
                            ),
                            title: Text(
                              movie.title,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold), // Title color
                            ),
                            subtitle: Column(
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
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DetailScreen(movie: movie),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}