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
