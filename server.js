const express = require('express');
const app = express();
const connectDB = require('./config/db');
const authRoutes = require('./routes/authRoutes');
const trafficReportRoutes = require('./routes/trafficReportRoutes');
const userRoutes = require('./routes/userRoutes');
const errorMiddleware = require('./middlewares/errorMiddleware');
const notificationRoutes = require('./routes/notifications');

app.use(express.json());
app.use('/api/auth', authRoutes);
app.use('/api/reports', trafficReportRoutes);
app.use('/api/users', userRoutes);
app.use('/api/notifications', notificationRoutes);

app.use(errorMiddleware);

const PORT = process.env.PORT || 5001;

connectDB();

app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});
