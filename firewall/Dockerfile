FROM alpine:3.19


RUN apk add --no-cache iptables ip6tables iproute2 bash procps
COPY start-firewall.sh /start-firewall.sh
RUN chmod +x /start-firewall.sh
CMD ["/start-firewall.sh"]