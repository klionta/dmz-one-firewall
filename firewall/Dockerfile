FROM ubuntu:22.04

RUN apt-get update && \
    apt-get install -y iptables\
    iproute2\
    bash\
    tshark\
    tcpdump\
    procps && \
    apt-get clean

COPY start-firewall.sh /start-firewall.sh
RUN chmod +x /start-firewall.sh

CMD ["/start-firewall.sh"]
