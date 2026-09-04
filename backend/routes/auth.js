const express = require('express');
const router = express.Router();
const jwt = require('jsonwebtoken');
const User = require('../models/User');
const { protect } = require('../middleware/auth');

const signToken = (userId) => {
    return jwt.sign(
        { userId },
        process.env.JWT_SECRET || 'kalakriti_default_secret_key_2025',
        { expiresIn: '30d' }
    );
};

// -------------------------------------------------------------
// 1. REGISTER / COMPLETE PROFILE (Upsert: Create or Update)
// -------------------------------------------------------------
// -------------------------------------------------------------
// 1. REGISTER / COMPLETE PROFILE (Returns 201 Created)
// -------------------------------------------------------------
router.post('/register', async (req, res, next) => {
    try {
        const { name, phone, password, role, language } = req.body;

        if (!phone) {
            return res.status(400).json({ success: false, message: 'Phone number is required.' });
        }

        let user = await User.findOne({ phone });

        if (user) {
            // Update existing user from OTP step
            if (name) user.name = name;
            if (role) user.role = role;
            if (language) user.language = language;
            if (password) user.password = password;
            user.isVerified = true;
            await user.save();
        } else {
            // Create fresh user
            user = await User.create({
                name: name || (role === 'buyer' ? 'Craft Buyer' : 'Artisan'),
                phone,
                password,
                role: role || 'artisan',
                language: language || 'hi',
                isVerified: true
            });
        }

        const token = signToken(user._id);

        // ✅ Return 201 Created so Flutter considers it a 100% success
        return res.status(201).json({
            success: true,
            status: 'success',
            message: 'Registered successfully',
            token,
            user,
            data: {
                token,
                user
            }
        });
    } catch (err) {
        console.error('Error in register:', err);
        next(err);
    }
});
// -------------------------------------------------------------
// 2. LOGIN (Password-based)
// -------------------------------------------------------------
router.post('/login', async (req, res, next) => {
    try {
        const { phone, password } = req.body;
        const user = await User.findOne({ phone }).select('+password');
        if (!user || !(await user.comparePassword(password))) {
            return res.status(401).json({ success: false, message: 'Invalid phone or password.' });
        }

        const token = signToken(user._id);
        user.password = undefined;
        res.json({ success: true, token, user });
    } catch (err) {
        next(err);
    }
});

// -------------------------------------------------------------
// 3. SEND OTP
// -------------------------------------------------------------
router.post('/send-otp', async (req, res, next) => {
    try {
        const { phone, name, role } = req.body;
        if (!phone) {
            return res.status(400).json({ success: false, message: 'Phone number is required.' });
        }

        let user = await User.findOne({ phone });

        if (!user) {
            user = await User.create({
                name: name || 'Artisan',
                phone,
                role: role || 'artisan'
            });
        }

        // Generate OTP via User model or random 6-digit fallback
        const otp = typeof user.generateOTP === 'function'
            ? user.generateOTP()
            : Math.floor(100000 + Math.random() * 900000).toString();

        await user.save();

        console.log('\n========================================');
        console.log(` 📱 LOGIN OTP FOR ${phone}: [ ${otp} ]`);
        console.log(` 🔑 MASTER BYPASS CODE: [ 123456 ]`);
        console.log('========================================\n');

        res.json({
            success: true,
            message: 'OTP generated successfully.',
            devOtp: otp
        });
    } catch (err) {
        console.error('Error in send-otp:', err);
        next(err);
    }
});

// -------------------------------------------------------------
// 4. VERIFY OTP
// -------------------------------------------------------------
router.post('/verify-otp', async (req, res, next) => {
    try {
        const { phone, otp } = req.body;
        if (!phone || !otp) {
            return res.status(400).json({ success: false, message: 'Phone and OTP are required.' });
        }

        let user = await User.findOne({ phone });
        if (!user) {
            return res.status(404).json({ success: false, message: 'User not found. Please request OTP first.' });
        }

        // Master bypass for testing
        const isMasterBypass = otp === '123456' || otp === '000000';
        const isDbOtpValid = typeof user.verifyOTP === 'function'
            ? user.verifyOTP(otp)
            : (user.otp === otp);

        if (!isMasterBypass && !isDbOtpValid) {
            return res.status(400).json({ success: false, message: 'Invalid or expired OTP.' });
        }

        user.otp = undefined;
        user.otpExpires = undefined;
        user.isVerified = true;
        await user.save();

        const token = signToken(user._id);
        res.json({
            success: true,
            token,
            user
        });
    } catch (err) {
        console.error('Error in verify-otp:', err);
        next(err);
    }
});

// -------------------------------------------------------------
// 5. UPDATE ROLE DIRECTLY (Helper endpoint)
// -------------------------------------------------------------
router.put('/role', protect, async (req, res, next) => {
    try {
        const { role } = req.body;
        if (!['artisan', 'buyer', 'admin'].includes(role)) {
            return res.status(400).json({ success: false, message: 'Invalid role.' });
        }

        const user = await User.findByIdAndUpdate(
            req.user._id,
            { role },
            { new: true }
        );

        res.json({ success: true, user });
    } catch (err) {
        next(err);
    }
});

// -------------------------------------------------------------
// 6. CURRENT USER PROFILE
// -------------------------------------------------------------
router.get('/me', protect, (req, res) => {
    res.json({ success: true, user: req.user });
});

module.exports = router;