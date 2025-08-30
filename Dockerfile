# Base image - updated Bullseye to avoid 404 errors
FROM python:3.10-slim-bullseye

# Non-interactive mode for apt
ENV DEBIAN_FRONTEND=noninteractive

# Update & install system dependencies
RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
        gcc \
        libffi-dev \
        musl-tools \
        ffmpeg \
        aria2 \
        python3-pip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy project files
COPY . /app/

# Install Python dependencies
RUN pip3 install --no-cache-dir --upgrade -r requirements.txt
RUN pip3 install pytube

# Environment variable
ENV COOKIES_FILE_PATH="youtube_cookies.txt"

# Optional: Expose port for Render web service
EXPOSE 8000

# Run both Gunicorn (main web service) and main.py safely using bash
CMD ["bash", "-c", "gunicorn -w 4 -b 0.0.0.0:8000 app:app & python3 main.py"]
