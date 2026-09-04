const mongoose = require('mongoose');

const chatSchema = new mongoose.Schema(
    {
        participants: [{ type: mongoose.Schema.Types.ObjectId, ref: 'User' }],
        product: { type: mongoose.Schema.Types.ObjectId, ref: 'Product' },
        messages: [
            {
                sender: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
                content: { type: String, required: true },
                createdAt: { type: Date, default: Date.now },
            },
        ],
        lastMessage: {
            content: String,
            sender: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
            createdAt: { type: Date, default: Date.now },
        },
    },
    { timestamps: true }
);

module.exports = mongoose.model('Chat', chatSchema);