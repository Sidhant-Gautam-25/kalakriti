const mongoose = require('mongoose');

const orderSchema = new mongoose.Schema(
    {
        orderNumber: { type: String, unique: true },
        buyer: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
        items: [
            {
                product: { type: mongoose.Schema.Types.ObjectId, ref: 'Product', required: true },
                artisan: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
                quantity: { type: Number, required: true, min: 1 },
                price: { type: Number, required: true },
            },
        ],
        subtotal: { type: Number, required: true },
        shippingCost: { type: Number, default: 0 },
        platformFee: { type: Number, default: 0 },
        totalAmount: { type: Number, required: true },
        shippingAddress: {
            address: { type: String, required: true },
            city: { type: String, required: true },
            state: { type: String, required: true },
            pincode: { type: String, required: true },
            phone: { type: String, required: true },
        },
        payment: {
            method: { type: String, enum: ['upi', 'cod', 'razorpay'], default: 'razorpay' },
            status: { type: String, enum: ['pending', 'paid', 'failed'], default: 'pending' },
            razorpayOrderId: String,
            razorpayPaymentId: String,
        },
        status: {
            type: String,
            enum: ['placed', 'confirmed', 'in_production', 'shipped', 'delivered', 'cancelled'],
            default: 'placed',
        },
        statusHistory: [
            {
                status: String,
                timestamp: { type: Date, default: Date.now },
                note: String,
            },
        ],
    },
    { timestamps: true }
);

orderSchema.pre('save', function () {
    if (!this.orderNumber) {
        this.orderNumber = `ART-${Date.now().toString().slice(-6)}-${Math.floor(100 + Math.random() * 900)}`;
    }
});

module.exports = mongoose.model('Order', orderSchema);