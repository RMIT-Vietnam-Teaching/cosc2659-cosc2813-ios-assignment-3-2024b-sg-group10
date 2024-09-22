const Notification = require('../models/Notification');

// Create a new notification
exports.createNotification = async (req, res) => {
    try {
        const { title, message } = req.body;
        const newNotification = new Notification({ title, message });
        await newNotification.save();
        res.status(201).json(newNotification);
    } catch (err) {
        res.status(400).json({ error: err.message });
    }
};

exports.getAllNotifications = async (req, res) => {
    try {
        const notifications = await Notification.find();
        res.json(notifications);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
};
exports.getNotificationById = async (req, res) => {
    try {
        const notification = await Notification.findById(req.params.id);
        if (!notification) return res.status(404).json({ error: 'Notification not found' });
        res.json(notification);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
};

// Update a specific notification by ID
exports.updateNotificationById = async (req, res) => {
    try {
        const { title, message } = req.body;
        const notification = await Notification.findByIdAndUpdate(
            req.params.id,
            { title, message },
            { new: true }
        );
        if (!notification) return res.status(404).json({ error: 'Notification not found' });
        res.json(notification);
    } catch (err) {
        res.status(400).json({ error: err.message });
    }
};

// Delete a specific notification by ID
exports.deleteNotificationById = async (req, res) => {
    try {
        const notification = await Notification.findByIdAndDelete(req.params.id);
        if (!notification) return res.status(404).json({ error: 'Notification not found' });
        res.json({ message: 'Notification deleted successfully' });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
};
