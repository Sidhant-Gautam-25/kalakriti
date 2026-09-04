"""
Unit & Integration Tests for Catalog Service (app/catalog.py).
"""

import json
import pytest
from unittest.mock import patch, AsyncMock

# pyrefly: ignore [missing-import]
from app.catalog import (
    CatalogService,
    CatalogConfigurationError,
    CatalogAPIError,
    CatalogResponseValidationError,
)
# pyrefly: ignore [missing-import]
from app.schemas import ProductAnalysisResponse, CatalogGenerationResponse, CatalogContent


@pytest.fixture
def catalog_service() -> CatalogService:
    """Fixture for CatalogService initialized with a valid dummy API key."""
    service = CatalogService()
    service.api_key = "test_gemini_api_key"
    return service


@pytest.fixture
def normal_product_analysis() -> ProductAnalysisResponse:
    """Fixture for a complete product analysis response."""
    return ProductAnalysisResponse(
        product_name="Handcrafted Terracotta Vase",
        category="Pottery",
        craft_type="Terracotta",
        material="Clay",
        color="Terracotta Brown",
        visual_characteristics=["Etched floral patterns", "Narrow neck", "Smooth matte finish"],
        description="A traditional terracotta clay vase featuring hand-etched floral motifs.",
        tags=["pottery", "terracotta", "handmade", "vase", "indian craft"],
        confidence=0.95,
    )


@pytest.fixture
def product_missing_material() -> ProductAnalysisResponse:
    """Fixture for a product analysis response with material=None."""
    return ProductAnalysisResponse(
        product_name="Artisanal Wall Hanging",
        category="Home Decor",
        craft_type="Macrame",
        material=None,
        color="Off-white",
        visual_characteristics=["Geometric knotting", "Fringed border"],
        description="Hand-knotted wall hanging with boho design.",
        tags=["decor", "macrame", "wall hanging"],
        confidence=0.88,
    )


@pytest.fixture
def product_missing_craft_type() -> ProductAnalysisResponse:
    """Fixture for a product analysis response with craft_type=None."""
    return ProductAnalysisResponse(
        product_name="Painted Wooden Box",
        category="Storage",
        craft_type=None,
        material="Teak Wood",
        color="Multicolor",
        visual_characteristics=["Peacock motif", "Brass latch"],
        description="Hand-painted wooden storage box with intricate peacock artwork.",
        tags=["box", "wooden", "storage", "hand-painted"],
        confidence=0.92,
    )


@pytest.fixture
def sample_catalog_response_dict() -> dict:
    """Fixture providing a standard valid catalog output structure matching CatalogGenerationResponse schema."""
    return {
        "title": "Handcrafted Terracotta Clay Vase",
        "short_description": "Elegant hand-etched clay vase made by traditional potters.",
        "long_description": "Enhance your living space with this beautiful terracotta vase featuring intricate floral engravings.",
        "tags": ["pottery", "terracotta", "handmade", "home-decor"],
        "english": {
            "title": "Handcrafted Terracotta Clay Vase",
            "description": "An exquisite terracotta clay vase featuring detailed floral motifs and a smooth matte finish.",
            "tags": ["pottery", "terracotta", "vase"]
        },
        "hindi": {
            "title": "हस्तनिर्मित टेराकोटा मिट्टी का फूलदान",
            "description": "सुंदर नक्काशीदार फूलों के पैटर्न वाला पारंपरिक टेराकोटा मिट्टी का फूलदान।",
            "tags": ["मिट्टी के बर्तन", "टेराकोटा", "फूलदान"]
        }
    }


@pytest.mark.anyio
async def test_normal_product(catalog_service, normal_product_analysis, sample_catalog_response_dict):
    """
    Test Case 1: Normal Product
    Verifies catalogue generation for a product with all fields present.
    """
    with patch.object(catalog_service, "_call_gemini_api", new_callable=AsyncMock) as mock_api:
        mock_api.return_value = json.dumps(sample_catalog_response_dict)

        catalog = await catalog_service.generate_catalog(normal_product_analysis)

        assert isinstance(catalog, CatalogGenerationResponse)
        assert catalog.title == "Handcrafted Terracotta Clay Vase"
        assert catalog.short_description.startswith("Elegant")
        assert catalog.english.title == "Handcrafted Terracotta Clay Vase"
        assert catalog.hindi.title == "हस्तनिर्मित टेराकोटा मिट्टी का फूलदान"
        assert len(catalog.tags) == 4
        assert len(catalog.english.tags) == 3
        assert len(catalog.hindi.tags) == 3

        mock_api.assert_called_once()


@pytest.mark.anyio
async def test_missing_material(catalog_service, product_missing_material, sample_catalog_response_dict):
    """
    Test Case 2: Missing Material
    Verifies catalogue generation when product material is None.
    """
    response_data = sample_catalog_response_dict.copy()
    response_data["title"] = "Artisanal Macrame Wall Hanging"
    response_data["english"] = response_data["english"].copy()
    response_data["english"]["title"] = "Artisanal Macrame Wall Hanging"
    
    with patch.object(catalog_service, "_call_gemini_api", new_callable=AsyncMock) as mock_api:
        mock_api.return_value = json.dumps(response_data)

        catalog = await catalog_service.generate_catalog(product_missing_material)

        assert isinstance(catalog, CatalogGenerationResponse)
        assert catalog.title == "Artisanal Macrame Wall Hanging"
        assert catalog.english.description is not None
        assert catalog.hindi.description is not None
        mock_api.assert_called_once()


@pytest.mark.anyio
async def test_missing_craft_type(catalog_service, product_missing_craft_type, sample_catalog_response_dict):
    """
    Test Case 3: Missing Craft Type
    Verifies catalogue generation when product craft_type is None.
    """
    response_data = sample_catalog_response_dict.copy()
    response_data["title"] = "Hand-Painted Wooden Storage Box"
    response_data["english"] = response_data["english"].copy()
    response_data["english"]["title"] = "Hand-Painted Wooden Storage Box"

    with patch.object(catalog_service, "_call_gemini_api", new_callable=AsyncMock) as mock_api:
        mock_api.return_value = json.dumps(response_data)

        catalog = await catalog_service.generate_catalog(product_missing_craft_type)

        assert isinstance(catalog, CatalogGenerationResponse)
        assert catalog.title == "Hand-Painted Wooden Storage Box"
        assert catalog.english.title == "Hand-Painted Wooden Storage Box"
        mock_api.assert_called_once()


@pytest.mark.anyio
async def test_malformed_ai_response_invalid_json(catalog_service, normal_product_analysis):
    """
    Test Case 4a: Malformed AI Response (Non-JSON String)
    Verifies that invalid JSON output from AI raises CatalogResponseValidationError.
    """
    with patch.object(catalog_service, "_call_gemini_api", new_callable=AsyncMock) as mock_api:
        mock_api.return_value = "This is not JSON data, just plain text from AI model."

        with pytest.raises(CatalogResponseValidationError) as exc_info:
            await catalog_service.generate_catalog(normal_product_analysis)

        assert "not valid JSON" in str(exc_info.value)


@pytest.mark.anyio
async def test_malformed_ai_response_missing_fields(catalog_service, normal_product_analysis):
    """
    Test Case 4b: Malformed AI Response (Incomplete JSON structure)
    Verifies that JSON lacking required fields (e.g. missing hindi section) raises CatalogResponseValidationError.
    """
    incomplete_json = {
        "title": "Incomplete Product Catalog",
        "short_description": "Short desc",
        # Missing long_description, english, hindi, tags
    }

    with patch.object(catalog_service, "_call_gemini_api", new_callable=AsyncMock) as mock_api:
        mock_api.return_value = json.dumps(incomplete_json)

        with pytest.raises(CatalogResponseValidationError) as exc_info:
            await catalog_service.generate_catalog(normal_product_analysis)

        assert "failed schema validation" in str(exc_info.value)


@pytest.mark.anyio
async def test_missing_api_key_raises_configuration_error(normal_product_analysis):
    """
    Verifies that missing GEMINI_API_KEY raises CatalogConfigurationError.
    """
    service = CatalogService()
    service.api_key = ""

    with pytest.raises(CatalogConfigurationError) as exc_info:
        await service.generate_catalog(normal_product_analysis)

    assert "GEMINI_API_KEY is not configured" in str(exc_info.value)
