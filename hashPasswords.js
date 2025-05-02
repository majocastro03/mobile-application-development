const sqlite3 = require('better-sqlite3');
const bcrypt = require('bcryptjs');

// Conexión a la base de datos SQLite
const db = new sqlite3('stockio.db');

// Función para hashear contraseñas existentes
function hashPasswords() {
  // Obtener todos los usuarios
  const users = db.prepare('SELECT id, password_hash FROM usuarios').all();

  users.forEach((user) => {
    console.log(`Hasheando contraseña para el usuario con ID: ${user.id}`);

    // Hashear la contraseña
    const hashedPassword = bcrypt.hashSync(user.password_hash, 8);

    // Actualizar la contraseña en la base de datos
    db.prepare('UPDATE usuarios SET password_hash = ? WHERE id = ?').run(hashedPassword, user.id);

    console.log(`Contraseña hasheada y actualizada para el usuario con ID: ${user.id}`);
  });

  console.log('Todas las contraseñas han sido hasheadas y actualizadas.');
}

// Ejecutar la función
hashPasswords();