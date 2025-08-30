FROM python:3.10.8-slim-buster

# Non-interactive mode
ENV DEBIAN_FRONTEND=noninteractive

# Update & install dependencies
RUN apt-get update -y && apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
        gcc \
        libffi-dev \
        musl-tools \
        ffmpeg \
        aria2 \
        python3-pip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copy project
COPY . /app/
WORKDIR /app/

# Install Python dependencies
RUN pip3 install --no-cache-dir --upgrade -r requirements.txt
RUN pip3 install pytube

# Environment variable
ENV COOKIES_FILE_PATH="youtube_cookies.txt"

# Recommended: Run gunicorn as main process
CMD ["gunicorn", "-w", "4", "app:app", "-b", "0.0.0.0:8000"]
