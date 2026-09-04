"""
Integration Tests for FastAPI Endpoints (app/main.py).
"""

import io
import json
import pytest
from unittest.mock import patch, AsyncMock
from PIL import Image
# pyrefly: ignore [missing-import]
from fastapi.testclient import TestClient

# pyrefly: ignore [missing-import]
from app.main import app
# pyrefly: ignore [missing-import]
from app.schemas import (
    ProductAnalysisResponse,
    CatalogGenerationResponse,
    CatalogContent,
)
# pyrefly: ignore [missing-import]
from app.vision import InvalidImageError


client = TestClient(app)


@pytest.fixture
def sample_jpeg_bytes() -> bytes:
    """Creates a simple 100x100 RGB JPEG image in memory for API testing."""
    img = Image.new("RGB", (100, 100), color=(139, 69, 19))
    buf = io.BytesIO()
    img.save(buf, format="JPEG")
    return buf.getvalue()


@pytest.fixture
def mock_product_analysis() -> ProductAnalysisResponse:
    """Mock product analysis result."""
    return ProductAnalysisResponse(
        product_name="Handcrafted Clay Pot",
        category="Pottery",
        craft_type="Terracotta",
        material="Clay",
        color="Brown",
        visual_characteristics=["Floral pattern"],
        description="A traditional terracotta clay pot.",
        tags=["pottery", "terracotta"],
        confidence=0.95,
    )


@pytest.fixture
def mock_catalog_generation() -> CatalogGenerationResponse:
    """Mock catalog generation result."""
    return CatalogGenerationResponse(
        title="Handcrafted Clay Pot",
        short_description="Elegant clay pot.",
        long_description="Traditional terracotta clay pot with floral patterns.",
        tags=["pottery", "terracotta"],
        english=CatalogContent(
            title="Handcrafted Clay Pot",
            description="Traditional terracotta clay pot with floral patterns.",
            tags=["pottery", "terracotta"],
        ),
        hindi=CatalogContent(
            title="हस्तनिर्मित मिट्टी का घड़ा",
            description="फूलों के पैटर्न वाला पारंपरिक टेराकोटा मिट्टी का घड़ा।",
            tags=["मिट्टी के बर्तन", "टेराकोटा"],
        ),
    )


def test_health_check_endpoint():
    """
    Verifies GET /health returns status ok.
    """
    response = client.get("/health")
    assert response.status_code == 200
    assert response.json() == {"status": "ok"}


def test_web_demo_ui_endpoint():
    """
    Verifies GET / serves the web demonstration interface HTML.
    """
    response = client.get("/")
    assert response.status_code == 200
    assert "KalaKriti AI" in response.text



def test_analyze_product_endpoint(sample_jpeg_bytes, mock_product_analysis):
    """
    Verifies POST /ai/analyze-product endpoint with image file upload.
    """
    with patch("app.main.VisionService.analyze_image", new_callable=AsyncMock) as mock_analyze:
        mock_analyze.return_value = mock_product_analysis

        files = {"image": ("test.jpg", sample_jpeg_bytes, "image/jpeg")}
        response = client.post("/ai/analyze-product", files=files)

        assert response.status_code == 200
        data = response.json()
        assert data["product_name"] == "Handcrafted Clay Pot"
        assert data["category"] == "Pottery"
        assert data["craft_type"] == "Terracotta"
        assert data["confidence"] == 0.95


def test_generate_catalog_endpoint(mock_product_analysis, mock_catalog_generation):
    """
    Verifies POST /ai/generate-catalog endpoint with ProductAnalysisResponse payload.
    """
    with patch("app.main.CatalogService.generate_catalog", new_callable=AsyncMock) as mock_generate:
        mock_generate.return_value = mock_catalog_generation

        payload = mock_product_analysis.model_dump()
        response = client.post("/ai/generate-catalog", json=payload)

        assert response.status_code == 200
        data = response.json()
        assert data["title"] == "Handcrafted Clay Pot"
        assert data["english"]["title"] == "Handcrafted Clay Pot"
        assert data["hindi"]["title"] == "हस्तनिर्मित मिट्टी का घड़ा"


def test_create_catalog_pipeline_endpoint(sample_jpeg_bytes, mock_product_analysis, mock_catalog_generation):
    """
    Verifies POST /ai/create-catalog end-to-end MVP pipeline endpoint.
    """
    with patch("app.main.VisionService.analyze_image", new_callable=AsyncMock) as mock_analyze, \
         patch("app.main.CatalogService.generate_catalog", new_callable=AsyncMock) as mock_generate:

        mock_analyze.return_value = mock_product_analysis
        mock_generate.return_value = mock_catalog_generation

        files = {"image": ("test.jpg", sample_jpeg_bytes, "image/jpeg")}
        response = client.post("/ai/create-catalog", files=files)

        assert response.status_code == 200
        data = response.json()
        assert "product" in data
        assert "catalog" in data
        assert data["product"]["product_name"] == "Handcrafted Clay Pot"
        assert data["catalog"]["english"]["title"] == "Handcrafted Clay Pot"
        assert data["catalog"]["hindi"]["title"] == "हस्तनिर्मित मिट्टी का घड़ा"


def test_create_catalog_invalid_image():
    """
    Verifies POST /ai/create-catalog handles invalid image errors with HTTP 400.
    """
    with patch("app.main.VisionService.analyze_image", new_callable=AsyncMock) as mock_analyze:
        mock_analyze.side_effect = InvalidImageError("Invalid or corrupted image format")

        files = {"image": ("corrupted.txt", b"not an image", "text/plain")}
        response = client.post("/ai/create-catalog", files=files)

        assert response.status_code == 400
        assert "Invalid or corrupted image format" in response.json()["detail"]
