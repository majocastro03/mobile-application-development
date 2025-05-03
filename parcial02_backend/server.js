const express = require('express');
const authRoutes = require('./src/routes/auth.route');
const messageRoutes = require('./src/routes/messages.route');
const userRoutes = require('./src/routes/users.route'); 
require('dotenv').config();

const app = express();

// Middleware
app.use(express.json());

// Rutas
app.use('/api/auth', authRoutes);
app.use('/api/messages', messageRoutes);
app.use('/api/users', userRoutes);

// Iniciar servidor
const PORT = process.env.PORT || 3000;
app.listen(PORT, '0.0.0.0', () => {
  console.log(`Servidor corriendo en el puerto ${PORT}`);
});