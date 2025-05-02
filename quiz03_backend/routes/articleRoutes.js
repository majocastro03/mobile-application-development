const express = require('express');
const ArticleController = require('../controllers/articleController');
const authenticateJWT = require('../middlewares/authMiddleware');
const router = express.Router();

router.get('/articles', authenticateJWT, ArticleController.getArticles);

module.exports = router;
