"""
Main FastAPI Application Entrypoint.

Provides API endpoints for:
- GET /: Web demonstration interface
- GET /health: Health check status endpoint
- POST /ai/analyze-product: Upload image & extract structured product JSON
- POST /ai/generate-catalog: Convert structured JSON into English/Hindi catalog copy
- POST /ai/create-catalog: End-to-end MVP pipeline (Image Upload -> Vision AI -> Catalogue Generator)
"""

from pathlib import Path
# pyrefly: ignore [missing-import]
from fastapi import FastAPI, File, UploadFile, HTTPException, status
# pyrefly: ignore [missing-import]
from fastapi.responses import FileResponse
# pyrefly: ignore [missing-import]
from fastapi.staticfiles import StaticFiles
from pydantic import BaseModel
from typing import List, Optional

# pyrefly: ignore [missing-import]
from app.config import config
# pyrefly: ignore [missing-import]
from app.schemas import (
    HealthCheckResponse,
    ProductAnalysisResponse,
    CatalogGenerationResponse,
    CreateCatalogPipelineResponse,
    PipelineCatalogContent,
)
# pyrefly: ignore [missing-import]
from app.vision import (
    VisionService,
    InvalidImageError,
    ConfigurationError as VisionConfigurationError,
    VisionAPIError,
    ResponseValidationError as VisionValidationError,
)
# pyrefly: ignore [missing-import]
from app.catalog import (
    CatalogService,
    CatalogConfigurationError,
    CatalogAPIError,
    CatalogResponseValidationError,
)

app = FastAPI(
    title=config.APP_NAME,
    description="AI-Driven Market Linkage and Smart Cataloging API for Marginalized Artisans",
    version="0.1.0",
)

# Mount static directory for web demo assets if present
static_dir = Path(__file__).resolve().parent.parent / "static"
if static_dir.exists():
    app.mount("/static", StaticFiles(directory=static_dir), name="static")


@app.get("/", include_in_schema=False)
async def serve_web_demo():
    """
    Serves the single-page web demonstration interface for the AI Smart Cataloguing module.
    """
    static_file = static_dir / "index.html"
    if static_file.exists():
        return FileResponse(static_file)
    return {"message": "KalaKriti AI Smart Cataloguing API"}


@app.get("/health", response_model=HealthCheckResponse, tags=["Health"])
async def health_check():
    """
    Health check endpoint to verify backend service availability.
    """
    return HealthCheckResponse(status="ok")


@app.post(
    "/ai/analyze-product",
    response_model=ProductAnalysisResponse,
    tags=["Product Analysis"],
    summary="Analyze artisan product image using Vision AI",
)
async def analyze_product(image: UploadFile = File(...)):
    """
    Upload an artisan product image (JPEG, PNG, WEBP) to extract structured product JSON attributes.
    """
    try:
        image_bytes = await image.read()
        vision_service = VisionService()
        return await vision_service.analyze_image(image_bytes)
    except InvalidImageError as e:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=str(e))
    except VisionConfigurationError as e:
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail=str(e))
    except (VisionAPIError, VisionValidationError) as e:
        raise HTTPException(status_code=status.HTTP_502_BAD_GATEWAY, detail=str(e))
    except Exception as e:
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail=f"Unexpected error: {str(e)}")


@app.post(
    "/ai/generate-catalog",
    response_model=CatalogGenerationResponse,
    tags=["Catalog Generation"],
    summary="Generate English and Hindi catalog listings from structured product JSON",
)
async def generate_catalog(product_data: ProductAnalysisResponse):
    """
    Accepts validated structured product JSON and generates factual, professional catalog listings in English and Hindi.
    """
    try:
        catalog_service = CatalogService()
        return await catalog_service.generate_catalog(product_data)
    except CatalogConfigurationError as e:
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail=str(e))
    except (CatalogAPIError, CatalogResponseValidationError) as e:
        raise HTTPException(status_code=status.HTTP_502_BAD_GATEWAY, detail=str(e))
    except Exception as e:
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail=f"Unexpected error: {str(e)}")


@app.post(
    "/ai/create-catalog",
    response_model=CreateCatalogPipelineResponse,
    tags=["Pipeline"],
    summary="End-to-end MVP catalog creation from image upload",
)
async def create_catalog(image: UploadFile = File(...)):
    """
    Complete end-to-end MVP pipeline:
    1. Upload artisan product image.
    2. Vision AI analyzes image to extract structured ProductAnalysis metadata.
    3. Catalogue Generator creates factual English & Hindi catalog copy.
    4. Returns unified ProductAnalysis and Multilingual Catalog response object.
    """
    try:
        image_bytes = await image.read()

        # Step 1: Execute Vision AI Analysis
        vision_service = VisionService()
        product_analysis = await vision_service.analyze_image(image_bytes)

        # Step 2: Execute Catalogue Generation
        catalog_service = CatalogService()
        catalog_response = await catalog_service.generate_catalog(product_analysis)

        # Step 3: Return combined MVP response
        return CreateCatalogPipelineResponse(
            product=product_analysis,
            catalog=PipelineCatalogContent(
                english=catalog_response.english,
                hindi=catalog_response.hindi,
            ),
        )
    except InvalidImageError as e:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=str(e))
    except (VisionConfigurationError, CatalogConfigurationError) as e:
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail=str(e))
    except (VisionAPIError, VisionValidationError, CatalogAPIError, CatalogResponseValidationError) as e:
        raise HTTPException(status_code=status.HTTP_502_BAD_GATEWAY, detail=str(e))
    except Exception as e:
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail=f"Unexpected error: {str(e)}")


@app.post("/predict/craft", tags=["Compatibility"])
async def predict_craft(file: UploadFile = File(...)):
    """
    Endpoint used by the Node.js Express backend to analyze a craft image.
    """
    try:
        image_bytes = await file.read()
        vision_service = VisionService()
        result = await vision_service.analyze_image(image_bytes)
        
        # Map to camelCase structure expected by Express backend
        return {
            "productName": result.product_name,
            "productNameHindi": "",
            "category": result.category,
            "craftTechnique": result.craft_type or "Unknown",
            "materials": [result.material] if result.material else [],
            "description": result.description or "",
            "tags": result.tags or [],
            "region": "Unknown",
            "confidence": result.confidence
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


class PricePredictionRequest(BaseModel):
    category: str
    craftTechnique: Optional[str] = None
    materials: List[str] = []


@app.post("/predict/price", tags=["Compatibility"])
async def predict_price(payload: PricePredictionRequest):
    """
    Predict fair price range, estimated cost, and production days based on product metadata.
    """
    category_lower = payload.category.lower()
    
    # Defaults
    estimated_cost = 100
    ai_min_price = 250
    selling_price = 300
    production_days = 2
    
    if "pottery" in category_lower or "clay" in category_lower:
        estimated_cost = 40
        ai_min_price = 120
        selling_price = 150
        production_days = 2
    elif "textile" in category_lower or "apparel" in category_lower or "saree" in category_lower:
        estimated_cost = 500
        ai_min_price = 1200
        selling_price = 1500
        production_days = 7
    elif "wood" in category_lower or "furniture" in category_lower:
        estimated_cost = 800
        ai_min_price = 2000
        selling_price = 2500
        production_days = 5
    elif "jewelry" in category_lower or "metal" in category_lower:
        estimated_cost = 300
        ai_min_price = 800
        selling_price = 1000
        production_days = 3
        
    return {
        "estimatedCost": estimated_cost,
        "aiMinPrice": ai_min_price,
        "sellingPrice": selling_price,
        "suggestedPriceMin": ai_min_price,
        "suggestedPriceMax": int(selling_price * 1.2),
        "productionDays": production_days
    }
