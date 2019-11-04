FROM ubuntu:18.04
RUN apt-get update && apt-get -y install ocserv iptables 
COPY entrypoint.sh .
CMD ["./entrypoint.sh"]