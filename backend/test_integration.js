const axios = require('axios');
const FormData = require('form-data');

const BASE_URL = 'http://localhost:5000/api';

async function runTests() {
    console.log('🧪 Starting KalakritiKonnect Backend Integration Tests...\n');

    let token = '';
    let testUserPhone = `+9198765${Math.floor(10000 + Math.random() * 90000)}`;
    let testUserPassword = 'password123';
    let catalogDraftToken = '';
    let productId = '';

    // ==========================================
    // 1. REGISTER TEST ARTISAN
    // ==========================================
    try {
        console.log('⏳ Test 1: Registering a new test artisan...');
        const res = await axios.post(`${BASE_URL}/auth/register`, {
            name: 'Test Ramesh Potter',
            phone: testUserPhone,
            password: testUserPassword,
            role: 'artisan',
            language: 'hi'
        });
        
        if (res.data.success && res.data.token) {
            token = res.data.token;
            console.log(`✅ Test 1 Passed! User registered. Phone: ${testUserPhone}`);
        } else {
            throw new Error('Registration response did not contain token.');
        }
    } catch (err) {
        console.error('❌ Test 1 Failed:', err.response ? err.response.data : err.message);
        process.exit(1);
    }

    // ==========================================
    // 2. LOGIN TEST ARTISAN
    // ==========================================
    try {
        console.log('\n⏳ Test 2: Logging in the test artisan...');
        const res = await axios.post(`${BASE_URL}/auth/login`, {
            phone: testUserPhone,
            password: testUserPassword
        });
        
        if (res.data.success && res.data.token) {
            console.log('✅ Test 2 Passed! Logged in successfully.');
        } else {
            throw new Error('Login response did not contain token.');
        }
    } catch (err) {
        console.error('❌ Test 2 Failed:', err.response ? err.response.data : err.message);
        process.exit(1);
    }

    // ==========================================
    // 3. VOICE CATALOGING (TRANSCRIPT)
    // ==========================================
    try {
        console.log('\n⏳ Test 3: Running Voice Cataloging with transcript...');
        const res = await axios.post(`${BASE_URL}/catalog/voice-catalog`, {
            transcript: 'Main Rajasthan se hoon. Maine clay se handmade terracotta planter pot banaya hai. Ek pot banane mein 40 rupaye lagte hain aur 2 din lagte hain.',
            language: 'hi'
        }, {
            headers: { Authorization: `Bearer ${token}` }
        });
        
        if (res.data.success && res.data.catalogDraftToken) {
            catalogDraftToken = res.data.catalogDraftToken;
            console.log('✅ Test 3 Passed! Voice Catalog draft generated successfully.');
            console.log('🤖 AI Extracted Details:', JSON.stringify(res.data.draftProductData, null, 2));
        } else {
            throw new Error('Voice catalog response did not contain draft token.');
        }
    } catch (err) {
        console.error('❌ Test 3 Failed:', err.response ? err.response.data : err.message);
        process.exit(1);
    }

    // ==========================================
    // 4. CONFIRM & PUBLISH WITH FAIR PRICE SHIELD
    // ==========================================
    try {
        console.log('\n⏳ Test 4: Confirming listing (Fair Price Shield Warning test)...');
        // We list at ₹50, which is below the evaluated minimum price (typically ₹120)
        const res = await axios.post(`${BASE_URL}/catalog/confirm`, {
            catalogDraftToken: catalogDraftToken,
            sellingPrice: 50,
            underpriceWarningDismissed: false,
            images: ['https://res.cloudinary.com/jrwabipw/image/upload/diya.jpg']
        }, {
            headers: { Authorization: `Bearer ${token}` }
        });
        
        if (res.data.success) {
            productId = res.data.product._id;
            console.log('✅ Test 4 Passed! Listing confirmed successfully.');
            console.log('🛡️ Fair Price Protection Status:', JSON.stringify(res.data.priceProtection, null, 2));
        } else {
            throw new Error('Confirm catalog response success is false.');
        }
    } catch (err) {
        console.error('❌ Test 4 Failed:', err.response ? err.response.data : err.message);
        process.exit(1);
    }

    // ==========================================
    // 5. GET PRODUCTS
    // ==========================================
    try {
        console.log('\n⏳ Test 5: Fetching active products...');
        const res = await axios.get(`${BASE_URL}/products`);
        
        if (res.data.success && res.data.products.length > 0) {
            console.log(`✅ Test 5 Passed! Fetched ${res.data.products.length} active products.`);
        } else {
            throw new Error('No products found in marketplace.');
        }
    } catch (err) {
        console.error('❌ Test 5 Failed:', err.response ? err.response.data : err.message);
        process.exit(1);
    }

    // ==========================================
    // 6. WHATSAPP BOT WEBHOOK SIMULATION
    // ==========================================
    try {
        console.log('\n⏳ Test 6: Simulating WhatsApp Bot Ingestion Webhook...');
        const res = await axios.post(`${BASE_URL}/catalog/whatsapp-bot`, {
            phone: testUserPhone,
            imageUrl: 'https://images.unsplash.com/photo-1612196808214-b8e1d6145a8c?w=500',
            userLanguage: 'hi'
        }, {
            headers: { 'x-whatsapp-bot-secret': 'your_whatsapp_webhook_secret_here' }
        });
        
        if (res.data.success) {
            console.log('✅ Test 6 Passed! WhatsApp bot processed webhook successfully.');
            console.log('🤖 Bot Reply Text:', res.data.whatsappReplyText);
        } else {
            throw new Error('WhatsApp bot response success is false.');
        }
    } catch (err) {
        console.error('❌ Test 6 Failed:', err.response ? err.response.data : err.message);
        process.exit(1);
    }

    console.log('\n🎉 ALL KALAKRITIKONNECT INTEGRATION TESTS PASSED SUCCESSFULLY! 🚀');
}

runTests();
