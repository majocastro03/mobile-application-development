const Article = require('../models/article');

class ArticleService {
  static fetchArticles(token, callback) {
    if (!token) {
      return callback(new Error('Token de autenticación requerido'));
    }

    // Obtener artículos directamente de la base de datos
    Article.findAll((err, articles) => {
      if (err) {
        console.error('Error al consultar la base de datos:', err);
        return callback(err);
      }
      callback(null, articles);
    });
  }
}

module.exports = ArticleService;
