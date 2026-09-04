const axios = require('axios');

const ML_URL = process.env.ML_SERVICE_URL || 'http://127.0.0.1:8000';

async function analyzeCraft(imageBuffer) {
    const FormData = require('form-data');
    const form = new FormData();
    form.append('file', imageBuffer, 'product.jpg');

    const res = await axios.post(`${ML_URL}/predict/craft`, form, {
        headers: form.getHeaders(),
        timeout: 30000,
    });
    return res.data;
}

async function predictPrice(payload) {
    const res = await axios.post(`${ML_URL}/predict/price`, payload, {
        timeout: 20000,
    });
    return res.data;
}

module.exports = { analyzeCraft, predictPrice };