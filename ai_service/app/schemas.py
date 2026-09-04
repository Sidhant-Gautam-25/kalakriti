from typing import List, Optional
from pydantic import BaseModel, Field


class ProductAnalysisResponse(BaseModel):
    """
    Core Product JSON Schema.
    Extracted structured product information from Vision AI analysis.
    Uncertain or unverified values default to None (null).
    """
    product_name: str = Field(..., description="Name or brief title of the product")
    category: str = Field(..., description="General category of the handicraft item")
    craft_type: Optional[str] = Field(None, description="Specific traditional craft technique, or null if uncertain")
    material: Optional[str] = Field(None, description="Primary material used, or null if uncertain")
    color: Optional[str] = Field(None, description="Primary color(s) observed, or null if uncertain")
    visual_characteristics: List[str] = Field(default_factory=list, description="Visual features, motifs, and patterns")
    description: Optional[str] = Field(None, description="Objective visual description, or null if uncertain")
    tags: List[str] = Field(default_factory=list, description="Keywords for search and cataloging")
    confidence: float = Field(default=0.0, ge=0.0, le=1.0, description="Model confidence score between 0.0 and 1.0")


class CatalogContent(BaseModel):
    """
    Language-specific catalog details (English or Hindi).
    """
    title: str = Field(..., description="Product title in the target language")
    description: str = Field(..., description="Description narrative in the target language")
    tags: List[str] = Field(default_factory=list, description="Keywords and tags in the target language")



class CatalogGenerationResponse(BaseModel):
    """
    Multilingual catalog output format expected by the frontend application.
    """
    title: str = Field(..., description="Primary title")
    short_description: str = Field(..., description="Primary short description")
    long_description: str = Field(..., description="Primary long description")
    tags: List[str] = Field(default_factory=list, description="Search and filter tags")
    english: CatalogContent = Field(..., description="English catalog version")
    hindi: CatalogContent = Field(..., description="Hindi catalog version")


class PipelineCatalogContent(BaseModel):
    """
    Multilingual catalog content wrapper for the end-to-end create-catalog pipeline.
    """
    english: CatalogContent = Field(..., description="English catalog version")
    hindi: CatalogContent = Field(..., description="Hindi catalog version")


class CreateCatalogPipelineResponse(BaseModel):
    """
    End-to-end MVP response schema combining product analysis and multilingual catalog copy.
    """
    product: ProductAnalysisResponse = Field(..., description="Extracted product analysis metadata")
    catalog: PipelineCatalogContent = Field(..., description="Generated multilingual catalog copy")


class HealthCheckResponse(BaseModel):
    """
    API Health status response schema.
    """
    status: str = Field(default="ok", description="API health status indicator")

