import os
from dotenv import load_dotenv

# Load environment variables from .env file
load_dotenv()

class Config:
    """
    Application configuration settings loaded safely from environment variables.
    Prevents API keys or sensitive values from being hardcoded.
    """
    APP_NAME: str = "Artisan AI Smart Cataloging Module"
    PORT: int = int(os.getenv("PORT", 8000))
    HOST: str = os.getenv("HOST", "0.0.0.0")
    
    # Vision & LLM AI Provider Configuration
    AI_PROVIDER: str = os.getenv("AI_PROVIDER", "google")
    GEMINI_API_KEY: str = os.getenv("GEMINI_API_KEY", "")

config = Config()
