const ArticleService = require('../services/articleService');

class ArticleController {
  static getArticles(req, res) {
    const token = req.header('Authorization')?.split(' ')[1];

    ArticleService.fetchArticles(token, (err, articles) => {
      if (err) return res.status(500).send('Error al obtener los artículos: ' + err.message);
      res.json(articles);
    });
  }
}

module.exports = ArticleController;
