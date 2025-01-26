# Use a lightweight Python image
FROM python:3.9-slim

# Set working directory
WORKDIR /app

# Copy application files
COPY app.py .
COPY requirements.txt .

# Install dependencies
RUN pip install -r requirements.txt

# Expose port
EXPOSE 8080

# Start the Flask server
CMD ["python", "app.py"]
