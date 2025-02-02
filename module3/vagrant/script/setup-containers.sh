#!/bin/sh

# Set timezone to Singapore
sudo timedatectl set-timezone Asia/Singapore

# Create directory and dockerfiles for Python and Redis docker containers
mkdir webpage-visitor-count
cd webpage-visitor-count
mkdir app

# Create docker compose files
cat <<EOF > docker-compose.yml
version: "3.3"

services:
  web:
    build: .
    ports:
      - "3000:3000"
    volumes:
      - ./app:/app
    depends_on:
      - redis
    environment:
      - REDIS_HOST=redis
      - REDIS_PORT=6379
      - REDIS_PASSWORD=${REDIS_PASSWORD} # Optional

  redis:
    image: "redis:latest"
    volumes:
      - redis_data:/data

volumes:
  redis_data:
EOF

# Create requirements.txt file for python container dependencies
cat <<EOF > requirements.txt
Flask
redis
EOF

# Create docker file for python container
cat <<EOF > Dockerfile
FROM python:3.9-slim-buster

WORKDIR /app

COPY requirements.txt .
RUN pip install -r requirements.txt

COPY . .

# EXPOSE the port (important!)
EXPOSE 3000

# CMD ["python" "app.py"] # Run the Flask app directly (NOT RECOMMENDED FOR PRODUCTION)
CMD python app.py # Run the Flask app directly (NOT RECOMMENDED FOR PRODUCTION)
EOF

# Create python app file
cat <<EOF > app/app.py
from flask import Flask, request
import redis
import os

app = Flask(__name__)

## Configure Redis connection (environment variables are best for production)
redis_host = os.environ.get("REDIS_HOST", "127.0.0.1")  # Default to localhost
redis_port = int(os.environ.get("REDIS_PORT", 6379))  # Default to 6379
redis_password = os.environ.get("REDIS_PASSWORD") # Optional password

try:
    r = redis.Redis(host=redis_host, port=redis_port, password=redis_password, decode_responses=True)
    r.ping()  # Check connection
    print("Connected to Redis")
except redis.exceptions.ConnectionError as e:
    print(f"Redis connection error: {e}")
    exit(1)  # Exit if Redis is not available

@app.route('/', methods=['GET'])
def index():
    try:
        page_url = '/'  # Or use request.path for different URLs
        count = r.incr("pycounters")  # Atomically increment and get count
        return f"<h1 style='color: blue'>You are the {count}th visitor</h1>"
    except redis.exceptions.RedisError as e:
        print(f"Redis error: {e}")
        return "Error tracking visits.", 500  # Internal Server Error

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=3000)  # host='0.0.0.0' for external access (dev only)
EOF

## Run Docker compose to bring up the containers in detached mode
docker compose up -d

## Set gateway ip address for network eth1 (bridged network)
sudo route add default gw 192.168.2.1 eth1

## Commands to access the website on local network
echo "To access the website locally, please use the command below"
echo "curl http://192.168.2.48:3000"