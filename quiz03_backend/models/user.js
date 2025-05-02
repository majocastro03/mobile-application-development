const db = require('../config/db');

class User {
  static findByUsername(username, callback) {
    db.query('SELECT * FROM users WHERE username = ?', [username], callback);
  }

  static findById(id, callback) {
    db.query('SELECT * FROM users WHERE id = ?', [id], callback);
  }
}

module.exports = User;
