// model/movie.dart
class Movie {
  final String title;
  final String description;
  final String posterPath; // This will store the image URL from Firebase Storage
  final String category;
  final double rating; // Pastikan ini double

  Movie({
    required this.title,
    required this.description,
    required this.posterPath,
    required this.category,
    required this.rating,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'posterPath': posterPath,
      'category': category,
      'rating': rating,
    };
  }

  factory Movie.fromFirestore(Map<String, dynamic> data) {
    return Movie(
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      posterPath: data['posterPath'] ?? '',
      category: data['category'] ?? '',
      rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
    );
  }
}