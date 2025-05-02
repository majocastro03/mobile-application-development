class Article {
  int id;
  String title;
  String description;
  String? imageUrl;
  double price;
  String? supplier;
  bool isFavorite;
  int? favoriteId;
  int? rating;

  Article({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl,
    required this.price,
    this.supplier,
    this.isFavorite = false,
    this.favoriteId,
    this.rating,
  });
  //Convertir el JSON en un objeto de tipo Articulo
  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'],
      title: json['titulo'] ?? 'Sin título',
      description: json['descripcion'] ?? 'Sin descripción',
      imageUrl: json['imagen_url'],
      price: json['precio']?.toDouble() ?? 0.0,
      supplier: json['proveedor'],
      isFavorite: json['es_favorito'] == 1,
      favoriteId: json['id_favorito'],
      rating: json['calificacion'],
    );
  }
}
