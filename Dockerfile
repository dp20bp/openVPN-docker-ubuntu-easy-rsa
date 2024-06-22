# Gunakan Ubuntu image yang ringan
# FROM ubuntu:20.04
FROM gitea/runner-images:ubuntu-20.04-slim


# Install OpenVPN dan easy-rsa
RUN apt-get update && \
    apt-get install -y openvpn easy-rsa tree vim net-tools && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Buat direktori untuk easy-rsa
RUN make-cadir /etc/openvpn/easy-rsa

# Set working directory
WORKDIR /etc/openvpn/easy-rsa

# Salin skrip inisialisasi PKI
COPY init-easyrsa.sh /etc/openvpn/easy-rsa/

# Set perintah default untuk kontainer ini
CMD ["bash"]
