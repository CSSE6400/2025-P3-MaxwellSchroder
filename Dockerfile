FROM ubuntu:latest

# Install system dependencies
RUN apt-get update && apt-get install -y \
    python3 \
    python3-venv \
    python3-pip \
    curl \
    wget \
    file \
    git \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Create virtual environment manually
RUN python3 -m venv /opt/venv

# Set environment to use the venv
ENV PATH="/opt/venv/bin:$PATH"

# Install pipx (optional – but matching your current setup)
RUN pip install pipx
RUN pipx ensurepath

# Install Poetry globally
RUN pipx install poetry

# Set working directory
WORKDIR /app

# Copy across sample images for testing
COPY sample-images ./images

RUN echo "Listing contents of /app:" && ls -R /app

# Copy Poetry files first to cache deps
COPY pyproject.toml ./

# Install dependencies via pipx Poetry (just like your original)
RUN pipx run poetry install --no-root

# Copy application files
COPY todo todo

# Run app (same delayed startup with Flask)
CMD ["bash", "-c", "sleep 10 && pipx run poetry run flask --app todo run --host 0.0.0.0 --port 6400"]
