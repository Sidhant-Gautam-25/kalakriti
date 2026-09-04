const path = require('path');
const dotenv = require('dotenv');
dotenv.config({ path: path.join(__dirname, '.env') });

// Always load backend/.env no matter where terminal is opened from
dotenv.config({ path: path.join(__dirname, '.env') });

console.log('Gemini key loaded:', !!process.env.GEMINI_API_KEY);

const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const morgan = require('morgan');
const { createServer } = require('http');
const { Server } = require('socket.io');

const connectDB = require('./config/database');
const errorHandler = require('./middleware/errorHandler');

const app = express();
const httpServer = createServer(app);
const io = new Server(httpServer, { cors: { origin: '*' } });

// Database Connection
connectDB();

const rateLimit = require('express-rate-limit');

// Rate limiting: Max 100 requests per 15 minutes per IP
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100, // limit each IP to 100 requests per windowMs
  message: { success: false, message: 'Too many requests, please try again later.' }
});

app.use('/api/', limiter);
// Global Middlewares
app.use(helmet());
app.use(cors());
app.use(express.json({ limit: '50mb' }));
app.use(express.urlencoded({ extended: true }));
if (process.env.NODE_ENV === 'development') app.use(morgan('dev'));

// Test Route
app.get('/', (req, res) => {
    res.json({ success: true, message: ' Artisan AI Backend API is Live!' });
});

// API Routes
app.use('/api/auth', require('./routes/auth'));
app.use('/api/catalog', require('./routes/catalog'));
app.use('/api/products', require('./routes/products'));
app.use('/api/orders', require('./routes/orders'));
app.use('/api/market', require('./routes/market'));
app.use('/api/payments', require('./routes/payments'));

// Real-time Chat Socket Connection
io.on('connection', (socket) => {
    console.log('🔌 Connected Client:', socket.id);

    socket.on('join_room', (roomId) => socket.join(roomId));

    socket.on('send_message', (data) => {
        io.to(data.roomId).emit('receive_message', data);
    });

    socket.on('disconnect', () => console.log(' Disconnected Client:', socket.id));
});

// Error handling
app.use(errorHandler);

const PORT = process.env.PORT || 5000;
httpServer.listen(PORT, () => {
    console.log(`\n Server running at: http://localhost:${PORT}`);
});