FROM ubuntu:24.04

RUN apt-get update && apt-get install -y \
    curl \
    iputils-ping \
    iproute2 \
    nmap \
    netcat-traditional \
    && rm -rf /var/lib/apt/lists/*

CMD ["/bin/bash"]
