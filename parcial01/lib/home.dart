import 'package:flutter/material.dart';
import 'package:parcial01/models/article.dart';
import 'favorites.dart';
import 'login.dart';
import 'services/article_service.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<List<Article>> _articles;
  //Cambiar vista de cuadricula a lista
  bool _isGridView = true;

  @override
  void initState() {
    super.initState();
    _articles = ArticleService.getArticles();
  }

  Future<void> _refreshArticles() async {
    setState(() {
      _articles = ArticleService.getArticles();
    });
  }

  Widget _buildGridItem(Article article, BuildContext context) {
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
                    Text('Calificación: ${article.rating ?? "Sin calificar"}'),
                    IconButton(
                      icon: Icon(
                        article.isFavorite ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                      ),
                      onPressed: () async {
                        try {
                          if (article.isFavorite) {
                            // Si ya es favorito, eliminarlo
                            await ArticleService.removeFavorite(
                                article.favoriteId!);
                          } else {
                            // Si no es favorito, agregarlo
                            await ArticleService.addFavorite(article.id);
                          }
                          setState(() {
                            article.isFavorite = !article.isFavorite;
                          });
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

  Widget _buildListItem(Article article, BuildContext context) {
    return Card(
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
                      Text(
                          'Calificación: ${article.rating ?? "Sin calificar"}'),
                      IconButton(
                        icon: Icon(
                          article.isFavorite ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                        ),
                        onPressed: () async {
                          try {
                            if (article.isFavorite) {
                              // Si ya es favorito, eliminarlo
                              await ArticleService.removeFavorite(
                                  article.favoriteId!);
                            } else {
                              // Si no es favorito, agregarlo
                              await ArticleService.addFavorite(article.id);
                            }
                            setState(() {
                              article.isFavorite = !article.isFavorite;
                            });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Artículos"),
        actions: [
          // Cambiar vista
          IconButton(
            icon: Icon(_isGridView ? Icons.list : Icons.grid_view),
            onPressed: () {
              setState(() {
                _isGridView = !_isGridView;
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Favorites()),
              ).then((_) {
                // Actualizar los artículos al regresar de la pantalla de favoritos
                _refreshArticles();
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await ArticleService.logout();
              Navigator.pushReplacement(
                context,
                //Cerrar la sesión
                MaterialPageRoute(builder: (context) => Login()),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshArticles,
        child: FutureBuilder<List<Article>>(
          future: _articles,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No hay artículos disponibles'));
            } else {
              final articles = snapshot.data!;

              // Mostrar vista de cuadrícula o lista según _isGridView
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
                    itemCount: articles.length,
                    itemBuilder: (context, index) {
                      return _buildGridItem(articles[index], context);
                    },
                  ),
                );
              } else {
                return Container(
                  margin: EdgeInsets.all(8),
                  child: ListView.builder(
                    padding: EdgeInsets.all(8),
                    itemCount: articles.length,
                    itemBuilder: (context, index) {
                      return _buildListItem(articles[index], context);
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
