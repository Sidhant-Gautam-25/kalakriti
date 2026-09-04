const { uploadToCloudinary } = require('../config/cloudinary');

const uploadProductImage = async (fileBuffer, userId) => {
    // If Cloudinary keys are placeholders, fallback to dummy link for quick testing
    if (!process.env.CLOUDINARY_CLOUD_NAME || process.env.CLOUDINARY_CLOUD_NAME.includes('your_cloud')) {
        console.warn('⚠️ Cloudinary keys not set. Using placeholder image URL.');
        return {
            url: 'https://images.unsplash.com/photo-1582562124811-c09040d0a901?w=800',
            publicId: 'dummy_image_' + Date.now(),
        };
    }

    const result = await uploadToCloudinary(fileBuffer, `artisans/${userId}`);
    return {
        url: result.secure_url,
        publicId: result.public_id,
    };
};

module.exports = { uploadProductImage };