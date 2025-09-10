# Use Python 3.11 as specified in langgraph.json
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install uv for faster Python package management
RUN pip install uv

# Copy dependency files
COPY pyproject.toml uv.lock ./

# Install Python dependencies using uv
RUN uv sync --frozen

# Copy the application code
COPY . .

# Create .env file from .env.example if .env doesn't exist
RUN if [ ! -f .env ]; then cp .env.example .env; fi

# Expose port 2030
EXPOSE 2030

# Set environment variables
ENV PYTHONPATH=/app
ENV LANGGRAPH_PORT=2030
ENV LANGGRAPH_HOST=0.0.0.0

# Run the application using langgraph dev
CMD ["uv", "run", "langgraph", "dev", "--host", "0.0.0.0", "--port", "2030"]
