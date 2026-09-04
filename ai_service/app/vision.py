"""
Vision AI Service Module.

Responsible for accepting an artisan product image (file path or raw bytes),
sending it to the multimodal AI provider (Google Gemini), and extracting
structured product information adhering strictly to the ProductAnalysisResponse schema.

All AI-provider interaction and response validation are isolated within this module.
"""

import os
import json
import io
from pathlib import Path
from typing import Union, Optional
# pyrefly: ignore [missing-import]
from PIL import Image
# pyrefly: ignore [missing-import]
from pydantic import ValidationError

# pyrefly: ignore [missing-import]
from app.config import config
# pyrefly: ignore [missing-import]
from app.schemas import ProductAnalysisResponse


# --- Custom Exception Classes for Vision Service ---

class VisionServiceError(Exception):
    """Base exception for all Vision Service errors."""
    pass


class ConfigurationError(VisionServiceError):
    """Raised when API keys or required configurations are missing or invalid."""
    pass


class InvalidImageError(VisionServiceError):
    """Raised when an image file is missing, unreadable, corrupted, or unsupported."""
    pass


class VisionAPIError(VisionServiceError):
    """Raised when the AI provider API returns an error, fails authentication, or times out."""
    pass


class ResponseValidationError(VisionServiceError):
    """Raised when AI response is not valid JSON or fails Pydantic schema validation."""
    pass


class VisionService:
    """
    Vision AI Service for analyzing artisan product images.
    Encapsulates image validation, multimodal AI calls, and schema verification.
    """

    def __init__(self, prompt_path: Optional[Union[str, Path]] = None):
        """
        Initialize the Vision Service and load the analysis prompt template.
        
        Args:
            prompt_path: Optional custom path to product_analysis.txt prompt file.
        """
        self.api_key = config.GEMINI_API_KEY
        self.provider = config.AI_PROVIDER.lower()
        
        # Determine prompt file path relative to project root if not specified
        if prompt_path is None:
            base_dir = Path(__file__).resolve().parent.parent
            prompt_path = base_dir / "prompts" / "product_analysis.txt"
        
        self.prompt_path = Path(prompt_path)
        self.prompt_text = self._load_prompt()

    def _load_prompt(self) -> str:
        """
        Loads the system prompt text from file.
        """
        if not self.prompt_path.exists():
            raise ConfigurationError(f"Prompt template file not found at: {self.prompt_path}")
        try:
            with open(self.prompt_path, "r", encoding="utf-8") as f:
                return f.read().strip()
        except Exception as e:
            raise ConfigurationError(f"Failed to read prompt file: {str(e)}")

    def _validate_and_read_image(self, image_input: Union[str, Path, bytes]) -> tuple[bytes, str]:
        """
        Validates image input type, checks readability, verifies file format via Pillow,
        and returns raw bytes and MIME type.
        
        Supported formats: JPEG, PNG, WEBP.
        """
        if isinstance(image_input, (str, Path)):
            path = Path(image_input)
            if not path.exists():
                raise InvalidImageError(f"Image file does not exist at path: {path}")
            try:
                with open(path, "rb") as f:
                    image_bytes = f.read()
            except Exception as e:
                raise InvalidImageError(f"Failed to read image file from disk: {str(e)}")
        elif isinstance(image_input, bytes):
            image_bytes = image_input
        else:
            raise InvalidImageError("Input image must be a valid file path (str/Path) or raw bytes.")

        if not image_bytes:
            raise InvalidImageError("Provided image data is empty (0 bytes).")

        # Verify image format and integrity using Pillow
        try:
            img = Image.open(io.BytesIO(image_bytes))
            img.verify()
            img_format = (img.format or "").upper()
        except Exception as e:
            raise InvalidImageError(f"Invalid or corrupted image file: {str(e)}")

        mime_map = {
            "JPEG": "image/jpeg",
            "JPG": "image/jpeg",
            "PNG": "image/png",
            "WEBP": "image/webp",
        }

        if img_format not in mime_map:
            raise InvalidImageError(
                f"Unsupported image format '{img_format}'. Supported formats: JPEG, PNG, WEBP."
            )

        return image_bytes, mime_map[img_format]

    async def analyze_image(self, image_input: Union[str, Path, bytes]) -> ProductAnalysisResponse:
        """
        Analyzes an artisan product image using Vision AI and returns structured information.

        Args:
            image_input: File path (str/Path) or raw image bytes.

        Returns:
            ProductAnalysisResponse: Validated Pydantic schema object.
        """
        # Step 1: Validate API key configuration
        if not self.api_key or self.api_key == "your_gemini_api_key_here":
            raise ConfigurationError(
                "GEMINI_API_KEY is not configured. Please add your API key to the .env file."
            )

        # Step 2: Validate image and determine MIME type
        image_bytes, mime_type = self._validate_and_read_image(image_input)

        # Step 3: Send request to Vision AI model
        raw_response_text = await self._call_gemini_api(image_bytes, mime_type)

        # Step 4: Parse JSON and validate schema using Pydantic
        return self._parse_and_validate_response(raw_response_text)

    async def _call_gemini_api(self, image_bytes: bytes, mime_type: str) -> str:
        """
        Sends the image and prompt to Google Gemini API using google-genai SDK or fallback.
        """
        try:
            # Try official google-genai SDK first
            try:
                # pyrefly: ignore [missing-import]
                from google import genai
                # pyrefly: ignore [missing-import]
                from google.genai import types

                client = genai.Client(api_key=self.api_key)
                
                response = client.models.generate_content(
                    model="gemini-3.6-flash",
                    contents=[
                        types.Part.from_bytes(data=image_bytes, mime_type=mime_type),
                        self.prompt_text,
                    ],
                    config=types.GenerateContentConfig(
                        response_mime_type="application/json",
                        response_schema=ProductAnalysisResponse,
                        temperature=0.1,  # Low temperature for objective facts
                    ),
                )
                
                if not response or not response.text:
                    raise VisionAPIError("AI model returned an empty response.")
                
                return response.text

            except ImportError:
                # Fallback to google-generativeai SDK
                # pyrefly: ignore [missing-import]
                import google.generativeai as genai
                genai.configure(api_key=self.api_key)
                model = genai.GenerativeModel("gemini-3.6-flash")
                
                image_part = {
                    "mime_type": mime_type,
                    "data": image_bytes
                }
                
                response = model.generate_content(
                    [self.prompt_text, image_part],
                    generation_config={"response_mime_type": "application/json"}
                )
                
                if not response or not response.text:
                    raise VisionAPIError("AI model returned an empty response.")
                    
                return response.text

        except (ConfigurationError, InvalidImageError, VisionAPIError):
            raise
        except Exception as e:
            error_msg = str(e)
            if "API_KEY" in error_msg.upper() or "UNAUTHENTICATED" in error_msg.upper():
                raise VisionAPIError(f"API Authentication Failed: Verify GEMINI_API_KEY in .env. Details: {error_msg}")
            elif "QUOTA" in error_msg.upper() or "RESOURCE_EXHAUSTED" in error_msg.upper():
                raise VisionAPIError("AI Provider rate limit or quota exceeded. Please try again later.")
            elif "TIMEOUT" in error_msg.upper() or "DEADLINE" in error_msg.upper():
                raise VisionAPIError("Request to AI service timed out. Please check network connectivity.")
            else:
                raise VisionAPIError(f"Vision AI API Call Error: {error_msg}")

    def _parse_and_validate_response(self, response_text: str) -> ProductAnalysisResponse:
        """
        Parses JSON text response and validates it against ProductAnalysisResponse.
        Catches invalid JSON, missing fields, or wrong field data types.
        """
        cleaned_text = response_text.strip()
        
        # Clean markdown codeblocks if present
        if cleaned_text.startswith("```"):
            lines = cleaned_text.splitlines()
            if lines[0].startswith("```"):
                lines = lines[1:]
            if lines and lines[-1].startswith("```"):
                lines = lines[:-1]
            cleaned_text = "\n".join(lines).strip()

        # Step 1: Parse JSON syntax
        try:
            data = json.loads(cleaned_text)
        except json.JSONDecodeError as e:
            raise ResponseValidationError(
                f"AI model output is not valid JSON. Error: {str(e)}. Raw Output snippet: '{response_text[:150]}...'"
            )

        if not isinstance(data, dict):
            raise ResponseValidationError(f"Expected JSON object from AI model, but received {type(data).__name__}.")

        # Step 2: Validate against Pydantic model schema
        try:
            return ProductAnalysisResponse.model_validate(data)
        except ValidationError as e:
            field_errors = [f"{'.'.join(str(loc) for loc in err['loc'])}: {err['msg']}" for err in e.errors()]
            raise ResponseValidationError(
                f"AI response failed schema validation. Invalid/missing fields: {', '.join(field_errors)}"
            )
