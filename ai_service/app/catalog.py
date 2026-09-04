"""
Catalog Service Module.

Responsible for generating professional, factual, multilingual (English and Hindi)
e-commerce catalog listings from structured product analysis data.

All AI provider interaction and response validation are isolated within this module.
"""

import os
import json
from pathlib import Path
from typing import Union, Optional
# pyrefly: ignore [missing-import]
from pydantic import ValidationError
from app.config import config
from app.schemas import ProductAnalysisResponse, CatalogGenerationResponse


# --- Custom Exception Classes for Catalog Service ---

class CatalogServiceError(Exception):
    """Base exception for all Catalog Service errors."""
    pass


class CatalogConfigurationError(CatalogServiceError):
    """Raised when API keys or prompt configuration files are missing or invalid."""
    pass


class CatalogAPIError(CatalogServiceError):
    """Raised when the AI provider API returns an error, fails authentication, or times out."""
    pass


class CatalogResponseValidationError(CatalogServiceError):
    """Raised when AI response is not valid JSON or fails Pydantic schema validation."""
    pass


class CatalogService:
    """
    Service layer for generating structured multilingual e-commerce product catalogs.
    """

    def __init__(self, prompt_path: Optional[Union[str, Path]] = None):
        """
        Initialize the Catalog Service and load the generation prompt template.

        Args:
            prompt_path: Optional custom path to catalog_generation.txt prompt file.
        """
        self.api_key = config.GEMINI_API_KEY
        self.provider = config.AI_PROVIDER.lower()

        # Determine prompt file path relative to project root if not specified
        if prompt_path is None:
            base_dir = Path(__file__).resolve().parent.parent
            prompt_path = base_dir / "prompts" / "catalog_generation.txt"

        self.prompt_path = Path(prompt_path)
        self.prompt_template = self._load_prompt()

    def _load_prompt(self) -> str:
        """
        Loads the system prompt template from file.
        """
        if not self.prompt_path.exists():
            raise CatalogConfigurationError(f"Prompt template file not found at: {self.prompt_path}")
        try:
            with open(self.prompt_path, "r", encoding="utf-8") as f:
                return f.read().strip()
        except Exception as e:
            raise CatalogConfigurationError(f"Failed to read prompt file: {str(e)}")

    async def generate_catalog(self, product_data: ProductAnalysisResponse) -> CatalogGenerationResponse:
        """
        Generates English and Hindi catalog listings from structured product data.

        Args:
            product_data: Validated ProductAnalysisResponse model instance.

        Returns:
            CatalogGenerationResponse: Multilingual catalog object.
        """
        # Step 1: Validate API key configuration
        if not self.api_key or self.api_key == "your_gemini_api_key_here":
            raise CatalogConfigurationError(
                "GEMINI_API_KEY is not configured. Please add your API key to the .env file."
            )

        # Step 2: Format prompt with product analysis data
        product_json_str = product_data.model_dump_json(indent=2)
        prompt_content = self.prompt_template.replace("{product_json}", product_json_str)


        # Step 3: Call AI Provider API
        raw_response_text = await self._call_gemini_api(prompt_content)

        # Step 4: Parse JSON and validate schema using Pydantic
        return self._parse_and_validate_response(raw_response_text)

    async def _call_gemini_api(self, prompt_text: str) -> str:
        """
        Sends formatted text prompt to Google Gemini API using google-genai SDK or fallback.
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
                    contents=prompt_text,
                    config=types.GenerateContentConfig(
                        response_mime_type="application/json",
                        response_schema=CatalogGenerationResponse,
                        temperature=0.2,  # Low temperature to prioritize factual accuracy
                    ),
                )

                if not response or not response.text:
                    raise CatalogAPIError("AI model returned an empty response.")

                return response.text

            except ImportError:
                # Fallback to google-generativeai SDK
                # pyrefly: ignore [missing-import]
                import google.generativeai as genai
                genai.configure(api_key=self.api_key)
                model = genai.GenerativeModel("gemini-1.5-flash")

                response = model.generate_content(
                    prompt_text,
                    generation_config={"response_mime_type": "application/json"}
                )

                if not response or not response.text:
                    raise CatalogAPIError("AI model returned an empty response.")

                return response.text

        except (CatalogConfigurationError, CatalogAPIError):
            raise
        except Exception as e:
            error_msg = str(e)
            if "API_KEY" in error_msg.upper() or "UNAUTHENTICATED" in error_msg.upper():
                raise CatalogAPIError(f"API Authentication Failed: Verify GEMINI_API_KEY in .env. Details: {error_msg}")
            elif "QUOTA" in error_msg.upper() or "RESOURCE_EXHAUSTED" in error_msg.upper():
                raise CatalogAPIError("AI Provider rate limit or quota exceeded. Please try again later.")
            elif "TIMEOUT" in error_msg.upper() or "DEADLINE" in error_msg.upper():
                raise CatalogAPIError("Request to AI service timed out. Please check network connectivity.")
            else:
                raise CatalogAPIError(f"Catalog AI API Call Error: {error_msg}")

    def _parse_and_validate_response(self, response_text: str) -> CatalogGenerationResponse:
        """
        Parses JSON text response and validates it against CatalogGenerationResponse.
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
            raise CatalogResponseValidationError(
                f"AI model output is not valid JSON. Error: {str(e)}. Raw Output snippet: '{response_text[:150]}...'"
            )

        if not isinstance(data, dict):
            raise CatalogResponseValidationError(
                f"Expected JSON object from AI model, but received {type(data).__name__}."
            )

        # Step 2: Validate against Pydantic model schema
        try:
            return CatalogGenerationResponse.model_validate(data)
        except ValidationError as e:
            field_errors = [f"{'.'.join(str(loc) for loc in err['loc'])}: {err['msg']}" for err in e.errors()]
            raise CatalogResponseValidationError(
                f"AI response failed schema validation. Invalid/missing fields: {', '.join(field_errors)}"
            )
