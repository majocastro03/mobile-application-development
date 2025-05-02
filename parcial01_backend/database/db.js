const sqlite3 = require('better-sqlite3');

// Conexión a la base de datos SQLite
const db = new sqlite3('stockio.db');

module.exports = db;