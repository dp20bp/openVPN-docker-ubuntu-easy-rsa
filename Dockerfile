# FROM ubuntu:20.04
FROM gitea/runner-images:ubuntu-20.04-slim

RUN apt-get update && \
    apt-get install -y openvpn easy-rsa tree vim net-tools kmod && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN make-cadir /etc/openvpn/easy-rsa

WORKDIR /etc/openvpn/easy-rsa

# Salin skrip inisialisasi PKI
COPY init-easyrsa.sh /etc/openvpn/easy-rsa/

# Pastikan /dev/net/tun ada
RUN mkdir -p /dev/net && mknod /dev/net/tun c 10 200 && chmod 600 /dev/net/tun

CMD ["bash"]
