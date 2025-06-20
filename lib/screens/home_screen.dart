import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_uas_pab2/model/movie.dart'; // Import model Movie
import 'package:project_uas_pab2/screens/detail_screen.dart';
import 'package:project_uas_pab2/screens/search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Movie> _allMovies = [];
  List<Movie> _recommendedMovies = [];
  List<Movie> _highDemandMovies = [];
  Movie? _featuredMovie;

  final Color primaryBackgroundColor = const Color(0xFF1F253F);
  final Color appBarAndNavBarColor = const Color(0xFF2B3356);
  final Color accentColor = const Color(0xFF5A72FF);

  Future<void> _loadMovies() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('movies').get();
    final movies = snapshot.docs.map((doc) {
      // Gunakan factory constructor fromFirestore dari model Movie
      return Movie.fromFirestore(doc.data());
    }).toList(); //

    setState(() {
      _allMovies = movies;
      // Filter film untuk "Rekomendasi untuk Anda" (misal: rating > 4.0)
      _recommendedMovies =
          _allMovies.where((movie) => movie.rating >= 4.0).toList();
      // Filter film untuk "Sedang Banyak Diminati" (misal: rating > 3.5)
      _highDemandMovies =
          _allMovies.where((movie) => movie.rating >= 5.0).toList();

      // Pilih film unggulan secara acak atau film dengan rating tertinggi
      if (_allMovies.isNotEmpty) {
        _featuredMovie = _allMovies[Random().nextInt(_allMovies.length)];
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _loadMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'BioskopKu',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: appBarAndNavBarColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_box, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, '/add-movie');
            },
          ),
        ],
      ),
      body: _allMovies.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFeaturedMovieSection(),
                  const SizedBox(height: 20),
                  _buildMovieList('Rekomendasi untuk Anda', _recommendedMovies),
                  const SizedBox(height: 20),
                  _buildMovieList('Sedang Banyak Diminati', _highDemandMovies),
                  const SizedBox(height: 20),
                  _buildMovieList('Semua Film', _allMovies),
                ],
              ),
            ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorit',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        selectedItemColor: accentColor,
        unselectedItemColor: Colors.white54,
        backgroundColor: appBarAndNavBarColor,
        selectedLabelStyle: TextStyle(color: accentColor),
        unselectedLabelStyle: const TextStyle(color: Colors.white54),
        onTap: (index) {
          if (index == 0) {
            // Already on home, can refresh or do nothing
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SearchScreen(allMovies: _allMovies),
              ),
            );
          } else if (index == 2) {
            Navigator.pushNamed(context, '/favorite');
          } else if (index == 3) {
            Navigator.pushNamed(context, '/profile');
          }
        },
      ),
    );
  }

  Widget _buildFeaturedMovieSection() {
    if (_featuredMovie == null) {
      return const SizedBox.shrink();
    }
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailScreen(movie: _featuredMovie!),
          ),
        );
      },
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          ShaderMask(
            shaderCallback: (rect) {
              return const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black],
              ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
            },
            blendMode: BlendMode.darken,
            child: Image.network(
              _featuredMovie!.posterPath,
              height: 300,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 300,
                width: double.infinity,
                color: Colors.grey[800],
                child: const Icon(Icons.broken_image,
                    color: Colors.white54, size: 100),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _featuredMovie!.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _featuredMovie!.category,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
                Row(
                  children: List.generate(5, (index) {
                    return Icon(
                      index < _featuredMovie!.rating
                          ? Icons.star
                          : Icons.star_border,
                      color: Colors.amber,
                      size: 20,
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMovieList(String title, List<Movie> movies) {
    if (movies.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 200, // Tinggi tetap untuk daftar film horizontal
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailScreen(movie: movie),
                    ),
                  );
                },
                child: Container(
                  width: 120,
                  margin: EdgeInsets.only(left: index == 0 ? 16.0 : 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: movie.posterPath.isNotEmpty
                              ? Image.network(
                                  movie.posterPath,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(
                                    color: Colors.grey[700],
                                    child: const Icon(Icons.movie,
                                        color: Colors.white70),
                                  ),
                                )
                              : Container(
                                  color: Colors.grey[700],
                                  child: const Icon(Icons.movie,
                                      color: Colors.white70),
                                ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        movie.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      // Tampilkan rating bintang di sini juga
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
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
