# KalakritiKonnect

AI-driven market linkage and smart cataloging platform designed to empower traditional Indian artisans. The platform converts voice descriptions and craft photos into structured marketplace listings, protects artisans with a Fair Price Shield, provides seasonal Demand Radar analytics, and authenticates heritage crafts.

---

## Project Structure

This repository is organized as a monorepo containing three core components:

- **Backend (Node.js / Express)**: Main API server managing database operations, authentication, AI cataloging workflows, payments, and real-time communication.
- **Frontend (Flutter)**: Cross-platform mobile and web application for artisans and buyers.
- **AI Service (Python / FastAPI)**: Vision and image processing service for advanced craft recognition and metadata extraction.

```
KalakritiKonnect/
├── ai_service/          # FastAPI Python microservice (Vision AI)
├── backend/             # Express.js core API (controllers, models, routes)
├── frontend/            # Flutter cross-platform client app
├── config/              # Server configuration and database setup
├── server.js            # Node.js entry point
├── package.json         # Node.js dependencies
└── README.md
```

---

## Key Features

### 1. Voice and Multimodal Cataloging
- Converts spoken descriptions in Hindi, Hinglish, or English into structured marketplace listings using Google Gemini AI.
- Automatically extracts product names, categories, craft techniques, materials, production costs, timelines, and region.
- Generates a signed catalog draft token (HMAC-SHA256) to ensure integrity between cataloging and listing.

### 2. Fair Price Protection Shield
- Prevents exploitation and underpricing by comparing listing prices against AI-evaluated minimum fair values.
- Warns artisans when an entered selling price is below the recommended threshold.

### 3. Demand Radar and Seasonal Insights
- Analyzes product views, searches, wishlist data, and completed sales.
- Incorporates Indian festive and seasonal demand factors (e.g., Diwali, Holi, wedding season) to suggest trending crafts and optimal pricing.

### 4. Heritage Authenticity Score
- Evaluates craft authenticity on a 0–100 scale.
- Displays verified badges such as GI Tag Declared, Direct Artisan, SHG Member, and Handmade Technique Identified.

### 5. WhatsApp Bot Integration
- Allows artisans without smartphones to list products by sending craft photos and voice notes over WhatsApp.
- Employs SSRF-safe URL validation and automated Gemini vision processing.

---

## Tech Stack

- **Backend**: Node.js, Express.js, MongoDB (Mongoose), Socket.io
- **AI & ML**: Google Gemini API, FastAPI (Python), Pillow, Pydantic
- **Frontend**: Flutter (Dart)
- **Security**: Crypto HMAC-SHA256, JWT authentication, Helmet, Express Rate Limit
- **Media & Payments**: Cloudinary, Razorpay

---

## Getting Started

### Prerequisites
- Node.js (v18 or higher)
- Python (v3.9 or higher)
- Flutter SDK (v3.0 or higher)
- MongoDB instance (local or Atlas URI)

---

### 1. Backend Setup

1. Install dependencies:
   ```bash
   npm install
   ```

2. Configure environment variables by creating a `.env` file in the root directory:
   ```env
   PORT=5000
   NODE_ENV=development
   JWT_SECRET=your_jwt_secret
   MONGODB_URI=your_mongodb_connection_string

   GEMINI_API_KEY=your_gemini_api_key
   GEMINI_MODEL=gemini-1.5-flash

   CATALOG_DRAFT_SECRET=your_catalog_secret_key
   WHATSAPP_BOT_SECRET=your_whatsapp_secret_key

   CLOUDINARY_CLOUD_NAME=your_cloudinary_name
   CLOUDINARY_API_KEY=your_cloudinary_api_key
   CLOUDINARY_API_SECRET=your_cloudinary_api_secret

   RAZORPAY_KEY_ID=your_razorpay_key_id
   RAZORPAY_KEY_SECRET=your_razorpay_key_secret
   ```

3. Start the backend server:
   - Development:
     ```bash
     npm run dev
     ```
   - Production:
     ```bash
     npm start
     ```
   The backend API will run on `http://localhost:5000`.

---

### 2. AI Service Setup (Python)

1. Navigate to the AI service folder:
   ```bash
   cd ai_service
   ```

2. Create and activate a virtual environment:
   - Windows:
     ```powershell
     python -m venv venv
     .\venv\Scripts\activate
     ```
   - Linux/macOS:
     ```bash
     python3 -m venv venv
     source venv/bin/activate
     ```

3. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```

4. Start the FastAPI service:
   ```bash
   uvicorn app.main:app --reload --port 8000
   ```
   Interactive API documentation will be available at `http://localhost:8000/docs`.

---

### 3. Frontend Setup (Flutter)

1. Navigate to the frontend directory:
   ```bash
   cd frontend
   ```

2. Fetch Flutter packages:
   ```bash
   flutter pub get
   ```

3. Run the application:
   ```bash
   flutter run
   ```

---

## API Reference Summary

| Method | Endpoint | Access | Description |
|---|---|---|---|
| POST | `/api/catalog/voice-catalog` | Artisan | Generate a catalog draft from a voice transcript |
| POST | `/api/catalog/confirm` | Artisan | Confirm a product listing with fair price validation |
| POST | `/api/catalog/whatsapp-bot` | Webhook | Process incoming craft image and generate a draft |
| GET | `/api/market/demand-insights` | Public | Retrieve seasonal market demand insights |
| GET | `/api/products/:id` | Public | Get product details with authenticity score |

---

## Author & Maintainer

- **Developer**: Sidhant Gautam
- **Repository**: [https://github.com/Sidhant-Gautam-25/kalakriti](https://github.com/Sidhant-Gautam-25/kalakriti)
