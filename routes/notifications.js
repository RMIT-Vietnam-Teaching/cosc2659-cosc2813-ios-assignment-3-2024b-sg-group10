const express = require('express');
const router = express.Router();
const notificationController = require('../controllers/notificationController');
const authMiddleware = require('../middlewares/authMiddleware');
const adminMiddleware = require('../middlewares/adminMiddleware');
router.post('/', authMiddleware, notificationController.createNotification);
router.get('/', authMiddleware, notificationController.getAllNotifications);
router.get('/:id', authMiddleware, notificationController.getNotificationById);
router.put('/:id', authMiddleware, adminMiddleware, notificationController.updateNotificationById);
router.delete('/:id', authMiddleware, adminMiddleware, notificationController.deleteNotificationById);

module.exports = router;
