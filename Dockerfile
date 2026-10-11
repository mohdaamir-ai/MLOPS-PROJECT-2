FROM python:slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    libgomp1 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
    
    

COPY . .

RUN pip install --no-cache-dir --default-timeout=1000 --retries 10 -e .

RUN python pipeline/training_pipeline.py

EXPOSE 5000

CMD ["python" , "application.py"]