const express = require('express');
const router = express.Router();
const Order = require('../models/Order');
const { protect } = require('../middleware/auth');

router.post('/create-order', protect, async (req, res, next) => {
    try {
        const { orderId } = req.body;
        const order = await Order.findById(orderId);
        if (!order) return res.status(404).json({ success: false, message: 'Order not found.' });

        // Mock payment order ID for hackathon speed
        const mockRazorpayOrderId = `order_${Date.now()}`;
        order.payment.razorpayOrderId = mockRazorpayOrderId;
        await order.save();

        res.json({
            success: true,
            data: {
                orderId: mockRazorpayOrderId,
                amount: order.totalAmount * 100,
                currency: 'INR',
            },
        });
    } catch (err) {
        next(err);
    }
});

module.exports = router;