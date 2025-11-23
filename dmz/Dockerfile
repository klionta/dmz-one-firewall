FROM python:3.11-slim
WORKDIR /app
COPY requirements.txt ./
RUN apt-get update && apt-get install -y \
    iproute2 \
    iputils-ping \
    nmap \
    netcat-traditional \
    curl \
    postgresql-client \
    tcpdump \
    && rm -rf /var/lib/apt/lists/*
RUN pip install --no-cache-dir -r requirements.txt
COPY app.py ./
CMD ["python", "app.py"]