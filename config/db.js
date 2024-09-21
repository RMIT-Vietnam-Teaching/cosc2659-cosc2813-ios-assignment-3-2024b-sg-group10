const mongoose = require('mongoose');
require('dotenv').config();

const connectDB = async () => {
    try {
        await mongoose.connect(process.env.MONGO_URI, {
            useNewUrlParser: true,
            useUnifiedTopology: true
        });
        console.log('Kết nối tới cơ sở dữ liệu thành công');
    } catch (error) {
        console.error('Lỗi kết nối cơ sở dữ liệu:', error);
        process.exit(1);
    }
};

module.exports = connectDB;
