#!/bin/bash
# Inisialisasi PKI
./easyrsa init-pki
# Buat CA baru tanpa password
echo | ./easyrsa build-ca nopass
# Buat server request dan tanda tangani
./easyrsa gen-req server nopass
echo yes | ./easyrsa sign-req server server
# Buat Diffie-Hellman parameters
./easyrsa gen-dh

# Generate TLS-Auth key
openvpn --genkey --secret /etc/openvpn/easy-rsa/pki/ta.key
# Set permissions (optional)
chmod 600 /etc/openvpn/easy-rsa/pki/ta.key