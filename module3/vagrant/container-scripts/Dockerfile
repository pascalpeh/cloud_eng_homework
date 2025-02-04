FROM python:3.9-slim-buster

WORKDIR /app

COPY requirements.txt .
RUN pip install -r requirements.txt

COPY . .

# EXPOSE the port (important!)
EXPOSE 3000

# CMD ["python" "app.py"] # Run the Flask app directly (NOT RECOMMENDED FOR PRODUCTION)
CMD python app.py # Run the Flask app directly (NOT RECOMMENDED FOR PRODUCTION)