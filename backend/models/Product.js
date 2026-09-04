const mongoose = require('mongoose');
const { Schema } = mongoose;

const searchMetricSchema = new Schema(
    {
        tag: { type: String, trim: true },
        count: { type: Number, default: 0 },
    },
    { _id: false }
);

const dailyMetricSchema = new Schema(
    {
        date: { type: Date, required: true },
        views: { type: Number, default: 0 },
        wishlists: { type: Number, default: 0 },
        searchCount: { type: Number, default: 0 },
        searches: { type: [searchMetricSchema], default: [] },
    },
    { _id: false }
);

const productSchema = new Schema(
    {
        artisan: {
            type: Schema.Types.ObjectId,
            ref: 'User',
            required: true,
        },
        name: {
            type: String,
            required: true,
            trim: true,
        },
        productNameHindi: {
            type: String,
            trim: true,
            default: '',
        },
        nameLocal: {
            type: String,
            default: '',
        },
        description: {
            type: String,
            default: '',
        },
        category: {
            type: String,
            required: true,
            trim: true,
        },
        subCategory: {
            type: String,
            default: '',
        },
        craftTechnique: {
            type: String,
            trim: true,
            default: '',
        },
        materials: {
            type: [String],
            default: [],
        },
        estimatedCost: {
            type: Number,
            min: 0,
            default: 0,
        },
        sellingPrice: {
            type: Number,
            min: 0,
            default: 0,
        },
        productionDays: {
            type: Number,
            min: 1,
            default: 1,
        },
        region: {
            type: String,
            trim: true,
            default: '',
        },
        images: {
            type: [Schema.Types.Mixed], // Supports array of URLs or { url, publicId } objects
            default: [],
        },
        aiMinPrice: {
            type: Number,
            min: 0,
            default: 0,
        },
        giTag: {
            type: Schema.Types.Mixed, // Supports string or { name, code, isVerified }
            default: null,
        },
        metadata: {
            aiGenerated: { type: Boolean, default: false },
            aiCraftTechniqueIdentified: { type: Boolean, default: false },
            isUnderpriced: { type: Boolean, default: false },
            fairPriceGap: { type: Number, default: 0 },
            underpriceWarningDismissed: { type: Boolean, default: false },
            confirmedAt: { type: Date },
        },
        analytics: {
            daily: {
                type: [dailyMetricSchema],
                default: [],
            },
        },
        views: {
            type: Number,
            default: 0,
        },
        wishlistCount: {
            type: Number,
            default: 0,
        },
        searchTags: {
            type: [String],
            default: [],
        },
        tags: {
            type: [String],
            default: [],
        },
        dimensions: {
            length: { type: Number, default: 0 },
            width: { type: Number, default: 0 },
            height: { type: Number, default: 0 },
            weight: { type: Number, default: 0 },
            unit: { type: String, default: 'cm' },
        },
        colors: {
            type: [String],
            default: [],
        },
        pricing: {
            costPrice: { type: Number, default: 0 },
            aiSuggestedPrice: { type: Number, default: 0 },
            sellingPrice: { type: Number },
            currency: { type: String, default: 'INR' },
        },
        stock: {
            type: Number,
            default: 1,
        },
        madeToOrder: {
            type: Boolean,
            default: false,
        },
        qualityScore: {
            type: Number,
            default: 5,
        },
        status: {
            type: String,
            enum: ['draft', 'active', 'sold', 'inactive'],
            default: 'active',
        },
        reviews: [
            {
                buyer: { type: Schema.Types.ObjectId, ref: 'User' },
                rating: { type: Number, min: 1, max: 5 },
                comment: String,
                createdAt: { type: Date, default: Date.now },
            },
        ],
        averageRating: {
            type: Number,
            default: 0,
        },
    },
    { timestamps: true }
);

// Synchronize pricing.sellingPrice with sellingPrice if needed
productSchema.pre('save', function () {
    if (this.sellingPrice && (!this.pricing || !this.pricing.sellingPrice)) {
        this.pricing = this.pricing || {};
        this.pricing.sellingPrice = this.sellingPrice;
    } else if (this.pricing?.sellingPrice && !this.sellingPrice) {
        this.sellingPrice = this.pricing.sellingPrice;
    }
});

productSchema.index({ name: 'text', description: 'text', searchTags: 'text', tags: 'text' });
productSchema.index({ category: 1, status: 1 });
productSchema.index({ 'analytics.daily.date': 1 });

module.exports = mongoose.model('Product', productSchema);