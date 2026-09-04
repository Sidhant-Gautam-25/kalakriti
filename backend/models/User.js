const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');

const userSchema = new mongoose.Schema(
    {
        name: { type: String, required: true, trim: true },
        phone: { type: String, required: true, unique: true, trim: true },
        email: { type: String, trim: true, lowercase: true },
        password: { type: String, minlength: 6, select: false },
        role: { type: String, enum: ['artisan', 'buyer', 'admin'], default: 'artisan' },
        language: { type: String, default: 'hi' },
        profileImage: { type: String, default: '' },
        isVerified: { type: Boolean, default: false },

        artisanProfile: {
            craftTypes: { type: [String], default: [] },
            location: {
                village: { type: String, default: '' },
                district: { type: String, default: '' },
                state: { type: String, default: '' },
                pincode: { type: String, default: '' },
                isVerified: { type: Boolean, default: false },
            },
            giTag: { type: String, default: '' },
            shg: {
                name: { type: String, default: '' },
                isVerified: { type: Boolean, default: false },
            },
            shgName: { type: String, default: '' },
            isSHGMember: { type: Boolean, default: false },
            bankDetails: {
                accountNumber: { type: String, default: '' },
                ifscCode: { type: String, default: '' },
                upiId: { type: String, default: '' },
            },
            story: { type: String, default: '' },
            rating: { type: Number, default: 0 },
            totalSales: { type: Number, default: 0 },
            totalEarnings: { type: Number, default: 0 },
        },

        buyerProfile: {
            type: { type: String, default: 'individual' },
            addresses: [
                {
                    label: { type: String, default: 'Home' },
                    address: String,
                    city: String,
                    state: String,
                    pincode: String,
                },
            ],
            interests: { type: [String], default: [] },
        },

        otp: {
            code: String,
            expiresAt: Date,
        },
    },
    { timestamps: true }
);

userSchema.pre('save', async function () {
    if (!this.isModified('password') || !this.password) return;
    const salt = await bcrypt.genSalt(10);
    this.password = await bcrypt.hash(this.password, salt);
});

userSchema.methods.comparePassword = async function (candidatePassword) {
    return await bcrypt.compare(candidatePassword, this.password);
};

userSchema.methods.generateOTP = function () {
    const otp = Math.floor(100000 + Math.random() * 900000).toString();
    this.otp = {
        code: otp,
        expiresAt: new Date(Date.now() + 10 * 60 * 1000), // 10 mins
    };
    return otp;
};

userSchema.methods.verifyOTP = function (inputOTP) {
    if (!this.otp || !this.otp.code) return false;
    if (new Date() > this.otp.expiresAt) return false;
    return this.otp.code === inputOTP;
};

module.exports = mongoose.model('User', userSchema);