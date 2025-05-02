const express = require('express');
const authRoutes = require('./routes/authRoutes');
const articleRoutes = require('./routes/articleRoutes');
const dotenv = require('dotenv');
dotenv.config();

const app = express();
app.use(express.json());

const cors = require('cors');
app.use(cors());

app.use('/api', authRoutes);
app.use('/api', articleRoutes);

const port = process.env.PORT || 5000;
app.listen(port, () => {
  console.log(`Servidor corriendo en el puerto ${port}`);
});
