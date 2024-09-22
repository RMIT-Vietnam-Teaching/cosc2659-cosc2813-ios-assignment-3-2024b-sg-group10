const User = require('../models/userModel');
const jwt = require('jsonwebtoken');
const bcrypt = require('bcrypt');

const register = async (req, res) => {
    const { email, password, role, avatar } = req.body;

    try {
        const existingUser = await User.findOne({ email });
        if (existingUser) {
            return res.status(400).json({ message: 'Email đã được sử dụng' });
        }

        const hashedPassword = await bcrypt.hash(password, 10);

        const newUser = new User({
            email,
            password: hashedPassword,
            role,
            avatar
        });

        await newUser.save();

        const token = jwt.sign(
            { userId: newUser._id, role: newUser.role },
            process.env.SECRET_KEY,
            { expiresIn: '1d' }
        );

        res.status(201).json({ token, message: 'Đăng ký thành công' });
    } catch (error) {
        console.error('Error in register:', error);
        res.status(500).json({ message: 'Có lỗi xảy ra' });
    }
};

const login = async (req, res) => {
    const { email, password } = req.body;

    try {
        const user = await User.findOne({ email });
        if (!user) {
            return res.status(404).json({ message: 'Người dùng không tìm thấy' });
        }

        const isMatch = await bcrypt.compare(password, user.password);
        if (!isMatch) {
            return res.status(400).json({ message: 'Mật khẩu không đúng' });
        }

        const token = jwt.sign(
            { userId: user._id, role: user.role },
            process.env.SECRET_KEY,
            { expiresIn: '1d' }
        );

        res.status(200).json({ token });
    } catch (error) {
        console.error('Login error:', error);
        res.status(500).json({ message: 'Có lỗi xảy ra' });
    }
};

const logout = (req, res) => {
    res.status(200).json({ message: 'Đăng xuất thành công' });
};

module.exports = {
    register,
    login,
    logout
};
