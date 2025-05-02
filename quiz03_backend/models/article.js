const db = require('../config/db');

class Article {
  static findAll(callback) {
    db.query('SELECT * FROM articles', callback);
  }
}

module.exports = Article;
