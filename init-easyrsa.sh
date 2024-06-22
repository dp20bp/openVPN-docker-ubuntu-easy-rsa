#!/bin/bash

CLIENT_NAME=client1

# Inisialisasi PKI
./easyrsa init-pki

# Buat CA baru tanpa password
echo | ./easyrsa build-ca nopass

# Buat server request dan tanda tangani
./easyrsa gen-req server nopass
echo yes | ./easyrsa sign-req server server

# Buat sertifikat dan kunci untuk client
./easyrsa gen-req $CLIENT_NAME nopass
echo yes | ./easyrsa sign-req client $CLIENT_NAME

# Buat direktori untuk konfigurasi client jika belum ada
mkdir -p ~/client-configs/files
# Copy client keys and certificates
cp pki/issued/$CLIENT_NAME.crt pki/private/$CLIENT_NAME.key ~/client-configs/files/

# Buat Diffie-Hellman parameters
./easyrsa gen-dh

# Generate TLS-Auth key
openvpn --genkey --secret /etc/openvpn/easy-rsa/ta.key
# Set permissions (optional)
chmod 600 /etc/openvpn/easy-rsa/ta.key