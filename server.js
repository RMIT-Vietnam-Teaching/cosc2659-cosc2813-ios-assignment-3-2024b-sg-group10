const express = require('express');
const mongoose = require('mongoose');
const dotenv = require('dotenv');
const { MONGO_URI } = require('./config/config');

dotenv.config();

const app = express();
app.use(express.json());

mongoose.connect(MONGO_URI, {
  useNewUrlParser: true,
  useUnifiedTopology: true
})
.then(() => console.log('Connected to MongoDB'))
.catch(err => console.error('Failed to connect to MongoDB', err));

const adminRoutes = require('./routes/adminRoutes');
const userRoutes = require('./routes/userRoutes');
const notificationRoutes = require('./routes/notificationRoutes');


app.use('/admin', adminRoutes);
app.use('/user', userRoutes);
app.use('/notifications', notificationRoutes);


const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
