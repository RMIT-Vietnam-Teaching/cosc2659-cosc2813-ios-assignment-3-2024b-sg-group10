const User = require('../models/userModel');

const getAllUsers = async (req, res) => {
    try {
        const users = await User.find({}, 'email role avatar');
        res.status(200).json(users);
    } catch (error) {
        res.status(500).json({ message: 'Có lỗi xảy ra' });
    }
};

const getUserById = async (req, res) => {
    const { id } = req.params;
    try {
        // Tìm người dùng theo ID và lấy các trường cần thiết
        const user = await User.findById(id, 'email role avatar');
        
        if (!user) {
            return res.status(404).json({ message: 'Người dùng không tìm thấy' });
        }

        // Trả về thông tin người dùng
        res.status(200).json({
            userId: user._id,
            email: user.email,
            role: user.role,
            avatar: user.avatar 
        });
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Có lỗi xảy ra' });
    }
};

const searchUsers = async (req, res) => {
    const { query } = req.query;
    try {
        const users = await User.find({ email: new RegExp(query, 'i') }, 'email role');
        res.status(200).json(users);
    } catch (error) {
        res.status(500).json({ message: 'Có lỗi xảy ra' });
    }
};

const deleteUser = async (req, res) => {
    const { id } = req.params;
    try {
        const user = await User.findByIdAndDelete(id);
        if (!user) {
            return res.status(404).json({ message: 'Người dùng không tìm thấy' });
        }
        res.status(200).json({ message: 'Người dùng đã được xóa thành công' });
    } catch (error) {
        res.status(500).json({ message: 'Có lỗi xảy ra' });
    }
};
const updateUser = async (req, res) => {
    const { id } = req.params;
    const { email, role, avatar } = req.body;

    try {
        if (req.user.id !== id && req.user.role !== 'admin') {
            return res.status(403).json({ message: 'Bạn không có quyền cập nhật thông tin của người dùng này' });
        }

        const updatedUser = await User.findByIdAndUpdate(id, { email, role, avatar }, { new: true });
        if (!updatedUser) {
            return res.status(404).json({ message: 'Người dùng không tìm thấy' });
        }
        res.status(200).json(updatedUser);
    } catch (error) {
        res.status(500).json({ message: 'Có lỗi xảy ra khi cập nhật người dùng' });
    }
};

module.exports = {
    getAllUsers,
    getUserById,
    searchUsers,
    deleteUser,
    updateUser
};
