"""
Unit & Integration Tests for Vision Service (app/vision.py).
"""

import io
import pytest
from pathlib import Path
from PIL import Image

from app.vision import (
    VisionService,
    InvalidImageError,
    ConfigurationError,
    ResponseValidationError,
)
from app.schemas import ProductAnalysisResponse


@pytest.fixture
def sample_jpeg_bytes() -> bytes:
    """Creates a simple 100x100 RGB JPEG image in memory for testing."""
    img = Image.new("RGB", (100, 100), color=(139, 69, 19))  # Terracotta brown color
    buf = io.BytesIO()
    img.save(buf, format="JPEG")
    return buf.getvalue()


@pytest.fixture
def sample_image_path(tmp_path, sample_jpeg_bytes) -> Path:
    """Saves a temporary sample JPEG image to disk."""
    file_path = tmp_path / "sample_clay_pot.jpg"
    file_path.write_bytes(sample_jpeg_bytes)
    return file_path


def test_image_validation_valid_jpeg(sample_jpeg_bytes):
    """Verifies that a valid JPEG byte stream passes validation and returns correct MIME type."""
    service = VisionService()
    image_bytes, mime_type = service._validate_and_read_image(sample_jpeg_bytes)
    assert mime_type == "image/jpeg"
    assert len(image_bytes) > 0


def test_image_validation_nonexistent_file():
    """Verifies that attempting to read a non-existent file path raises InvalidImageError."""
    service = VisionService()
    with pytest.raises(InvalidImageError, match="Image file does not exist"):
        service._validate_and_read_image("non_existent_image.jpg")


def test_image_validation_corrupted_file(tmp_path):
    """Verifies that a non-image file raises InvalidImageError."""
    invalid_file = tmp_path / "fake_image.jpg"
    invalid_file.write_text("This is not a real image file content.")
    
    service = VisionService()
    with pytest.raises(InvalidImageError, match="Invalid or corrupted image"):
        service._validate_and_read_image(invalid_file)


def test_missing_api_key_raises_configuration_error(sample_jpeg_bytes, monkeypatch):
    """Verifies that calling analyze_image without a valid API key raises ConfigurationError."""
    service = VisionService()
    service.api_key = ""  # Clear API key
    
    with pytest.raises(ConfigurationError, match="GEMINI_API_KEY is not configured"):
        import asyncio
        asyncio.run(service.analyze_image(sample_jpeg_bytes))


def test_parse_and_validate_response_valid():
    """Verifies that parsing a valid JSON response returns a ProductAnalysisResponse object."""
    valid_json = """
    {
        "product_name": "Terracotta Handcrafted Vase",
        "category": "Home Decor",
        "craft_type": "Terracotta Pottery",
        "material": "Clay",
        "color": "Terracotta Brown",
        "visual_characteristics": ["Etched floral pattern", "Narrow neck"],
        "description": "A traditional clay vase with hand-carved motifs.",
        "tags": ["pottery", "handcrafted", "terracotta", "clay"],
        "confidence": 0.95
    }
    """
    service = VisionService()
    result = service._parse_and_validate_response(valid_json)
    
    assert isinstance(result, ProductAnalysisResponse)
    assert result.product_name == "Terracotta Handcrafted Vase"
    assert result.category == "Home Decor"
    assert result.craft_type == "Terracotta Pottery"
    assert result.material == "Clay"
    assert result.confidence == 0.95


def test_parse_and_validate_response_invalid_json():
    """Verifies that invalid JSON output from model raises ResponseValidationError."""
    invalid_json = "{ product_name: Terracotta Vase, category: Home Decor "
    service = VisionService()
    
    with pytest.raises(ResponseValidationError, match="not valid JSON"):
        service._parse_and_validate_response(invalid_json)


def test_parse_and_validate_response_missing_required_fields():
    """Verifies that JSON missing required schema fields raises ResponseValidationError."""
    missing_fields_json = '{"material": "Clay", "color": "Brown"}'
    service = VisionService()
    
    with pytest.raises(ResponseValidationError, match="failed schema validation"):
        service._parse_and_validate_response(missing_fields_json)
