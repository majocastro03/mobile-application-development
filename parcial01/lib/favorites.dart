import 'package:flutter/material.dart';
import 'package:parcial01/models/article.dart';
import 'services/article_service.dart';

class Favorites extends StatefulWidget {
  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  late Future<List<Article>> _favorites;
  bool _isGridView = true;

  @override
  void initState() {
    super.initState();
    _favorites = ArticleService.getFavorites();
  }

  Future<void> _refreshFavorites() async {
    setState(() {
      _favorites = ArticleService.getFavorites();
    });
  }

  Widget _buildFavoriteRow(Article article, BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Row(
        children: [
          Container(
            width: 100,
            height: 100,
            child: Center(
              child: article.imageUrl != null
                  ? Image.network(
                      article.imageUrl!,
                      fit: BoxFit.cover,
                      width: 100,
                      height: 100,
                    )
                  : Text(
                      'Imagen',
                      style: TextStyle(color: Colors.white),
                    ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('Vendedor: ${article.supplier ?? "Desconocido"}'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Calificación'),
                      IconButton(
                        icon: Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onPressed: () async {
                          try {
                            await ArticleService.removeFavorite(article.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Eliminado de favoritos')),
                            );
                            _refreshFavorites();
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error: $e')),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoriteGridItem(Article article, BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              child: Center(
                child: article.imageUrl != null
                    ? Image.network(
                        article.imageUrl!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      )
                    : Text(
                        'Imagen',
                        style: TextStyle(color: Colors.white),
                      ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  article.title,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('Vendedor: ${article.supplier ?? "Desconocido"}'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Calificación'),
                    IconButton(
                      icon: Icon(Icons.star, color: Colors.amber),
                      onPressed: () async {
                        try {
                          await ArticleService.removeFavorite(article.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Eliminado de favoritos')),
                          );
                          _refreshFavorites();
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error: $e')),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Favoritos"),
        actions: [
          IconButton(
            icon: Icon(_isGridView ? Icons.list : Icons.grid_view),
            onPressed: () {
              setState(() {
                _isGridView = !_isGridView;
              });
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshFavorites,
        child: FutureBuilder<List<Article>>(
          future: _favorites,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No hay favoritos disponibles'));
            } else {
              final favorites = snapshot.data!;
              if (_isGridView) {
                return Container(
                  margin: EdgeInsets.all(8),
                  child: GridView.builder(
                    padding: EdgeInsets.all(8),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: favorites.length,
                    itemBuilder: (context, index) {
                      return _buildFavoriteGridItem(favorites[index], context);
                    },
                  ),
                );
              } else {
                return Container(
                  margin: EdgeInsets.all(8),
                  child: ListView.builder(
                    padding: EdgeInsets.all(8),
                    itemCount: favorites.length,
                    itemBuilder: (context, index) {
                      return _buildFavoriteRow(favorites[index], context);
                    },
                  ),
                );
              }
            }
          },
        ),
      ),
    );
  }
}
