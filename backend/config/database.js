const mongoose = require('mongoose');
const dns = require('dns');

// Configure reliable DNS servers to resolve MongoDB Atlas SRV records on local networks/Windows
try {
    dns.setServers(['8.8.8.8', '8.8.4.4', '1.1.1.1']);
} catch (dnsErr) {
    // Fallback gracefully if setServers is not supported in current environment
}

let mongodInstance = null;

const connectDB = async () => {
    const uri = process.env.MONGODB_URI;

    if (uri) {
        try {
            const conn = await mongoose.connect(uri, {
                serverSelectionTimeoutMS: 5000,
            });
            console.log(`✅ MongoDB Connected: ${conn.connection.host}`);
            return conn;
        } catch (error) {
            console.warn(`\n⚠️  MongoDB Connection Failed: ${error.message}`);
            if (error.message.includes('querySrv ENOTFOUND') || error.message.includes('ENOTFOUND')) {
                console.warn(`👉 The Atlas cluster host could not be resolved. This happens if the cluster is paused, deleted, or network access is restricted.`);
            }
        }
    } else {
        console.warn('\n⚠️  MONGODB_URI is not configured in .env');
    }

    // Development In-Memory Fallback
    try {
        console.log('🔄 Launching In-Memory MongoDB for local development...');
        const { MongoMemoryServer } = require('mongodb-memory-server');
        mongodInstance = await MongoMemoryServer.create();
        const memUri = mongodInstance.getUri();
        const conn = await mongoose.connect(memUri);
        console.log(`✅ In-Memory MongoDB Connected: ${memUri}`);
        console.log(`💡 Local database is ready for testing! (Add your Atlas MONGODB_URI in .env when ready)\n`);
        return conn;
    } catch (fallbackError) {
        console.error(`❌ In-Memory Fallback Error: ${fallbackError.message}`);
        console.warn('⚠️  Server will continue running, but DB-dependent endpoints may fail.\n');
    }
};

module.exports = connectDB;