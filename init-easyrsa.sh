#!/bin/bash

CLIENT_NAME=client1

# Inisialisasi PKI
./easyrsa init-pki

# Buat CA baru tanpa password
echo | ./easyrsa build-ca nopass

#Buat server request dan sign it
./easyrsa gen-req server nopass
echo yes | ./easyrsa sign-req server server

# Buat sertifikat dan kunci untuk client
./easyrsa gen-req $CLIENT_NAME nopass
echo yes | ./easyrsa sign-req client $CLIENT_NAME

mkdir -p ~/client-configs/files
cp pki/issued/$CLIENT_NAME.crt pki/private/$CLIENT_NAME.key ~/client-configs/files/

# Buat Diffie-Hellman parameters
./easyrsa gen-dh

# Generate TLS-Auth key
openvpn --genkey secret /etc/openvpn/easy-rsa/ta.key
chmod 600 /etc/openvpn/easy-rsa/ta.key