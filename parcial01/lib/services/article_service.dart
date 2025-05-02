import 'package:http/http.dart' as http;
import 'package:parcial01/models/article.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ArticleService {
  //Obtener todos los articulos
  static Future<List<Article>> getArticles() async {
    final preferences = await SharedPreferences.getInstance();
    final token = preferences.getString('token');
    final userId = preferences.getInt('userId');

    if (token == null || userId == null) {
      throw Exception('No se encontró un token o usuario válido');
    }

    final response = await http.get(
      Uri.parse('http://localhost:5000/api/articles?usuario_id=$userId'),
      headers: {'Authorization': 'Bearer $token'},
    );
    print(response.body);
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Article.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar los artículos: ${response.body}');
    }
  }

  //Obtener los articulos favoritos del usuario loggeado
  static Future<List<Article>> getFavorites() async {
    final preferences = await SharedPreferences.getInstance();
    final token = preferences.getString('token');

    if (token == null) {
      throw Exception('No se encontró un token válido');
    }

    final response = await http.get(
      Uri.parse('http://localhost:5000/api/favorites'),
      headers: {'Authorization': token},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Article.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar los favoritos: ${response.body}');
    }
  }

  // Agregar un artículo a favoritos
  static Future<void> addFavorite(int articleId) async {
    final preferences = await SharedPreferences.getInstance();
    final token = preferences.getString('token');

    if (token == null) {
      throw Exception('No se encontró un token válido');
    }

    final response = await http.post(
      Uri.parse('http://localhost:5000/api/favorites'),
      headers: {'Authorization': token, 'Content-Type': 'application/json'},
      body: jsonEncode({'articulo_id': articleId}),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al agregar a favoritos: ${response.body}');
    }
  }

  // Eliminar un artículo de favoritos
  static Future<void> removeFavorite(int articleId) async {
    print(articleId);
    final preferences = await SharedPreferences.getInstance();
    final token = preferences.getString('token');

    if (token == null) {
      throw Exception('No se encontró un token válido');
    }

    final response = await http.delete(
      Uri.parse('http://localhost:5000/api/favorites/$articleId'),
      headers: {'Authorization': token},
    );

    if (response.statusCode != 200) {
      throw Exception('Error al eliminar de favoritos: ${response.body}');
    }
  }

  //Cerrar sesión eliminando el token y el userId de SharedPreferences
  static Future<void> logout() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }
}
