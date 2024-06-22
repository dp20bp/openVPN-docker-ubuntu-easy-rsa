# 🚩 openVPN & easy-rsa (no passphrase)

&nbsp;

### 🏁 Langkah-langkah :

1. Persiapkan file-file dan script di dalamnya sebagai berikut: <br />
   🟡 Dockerfile
   <pre>
   ❯ vim Dockerfile
      . . .
      FROM gitea/runner-images:ubuntu-20.04-slim

      RUN apt-get update && \
         apt-get install -y openvpn easy-rsa tree vim net-tools kmod && \
         apt-get clean && \
         rm -rf /var/lib/apt/lists/*

      RUN make-cadir /etc/openvpn/easy-rsa

      WORKDIR /etc/openvpn/easy-rsa

      COPY init-easyrsa.sh /etc/openvpn/easy-rsa/

      RUN mkdir -p /dev/net && mknod /dev/net/tun c 10 200 && chmod 600 /dev/net/tun

      CMD ["bash"]
   </pre>
   🟡 init-easyrsa.sh
   <pre>
   ❯ vim init-easyrsa.sh
      . . .
      #!/bin/bash

      ./easyrsa init-pki

      # Buat CA baru tanpa password
      echo | ./easyrsa build-ca nopass

      # Buat server request dan sign it
      ./easyrsa gen-req server nopass
      echo yes | ./easyrsa sign-req server server

      # Buat Diffie-Hellman parameters
      ./easyrsa gen-dh
   </pre>
   🟡 docker-compose.yml
   <pre>
   ❯ vim docker-compose.yml
      . . .
      version: '3.8'
      services:
         openvpn:
         build: .
         container_name: openvpn-test
         cap_add:
            - NET_ADMIN
         devices:
            - /dev/net/tun      
         ports:
            - "1194:1194/udp"
         stdin_open: true
         tty: true
         volumes:
            - openvpn-data:/etc/openvpn
      
      volumes:
         openvpn-data:
         driver: local
   </pre>

   &nbsp;

2. Memberikan file `init-easyrsa.sh` eksekutabel:
   <pre>
   ❯ chmod +x init-easyrsa.sh
   </pre>

   &nbsp;

3. Build dan Run Container pada terminal perintah. <br />
   🏃🏼‍♂️ Jalankan perintah berikut untuk membangun dan menjalankan container:
   <pre>
   ❯ docker-compose up --build
   </pre>
   <pre>
      [+] Building 2.6s (11/11) FINISHED                                                                                                                                                                      
      => [internal] load build definition from Dockerfile                                                                                                               0.0s
      => => transferring dockerfile: 32B                                                                                                                                0.0s
      => [internal] load .dockerignore                                                                                                                                  0.0s
      => => transferring context: 2B                                                                                                                                    0.0s
      => [internal] load metadata for docker.io/gitea/runner-images:ubuntu-20.04-slim                                                                                   2.5s
      => [1/6] FROM docker.io/gitea/runner-images:ubuntu-20.04-slim@sha256:5c19eee0e0d36cbbb6d9582947d03ec0c695065ba8a76513ad9c56df1921a6b3                             0.0s
      => [internal] load build context                                                                                                                                  0.0s
      => => transferring context: 37B                                                                                                                                   0.0s
      => CACHED [2/6] RUN apt-get update &&     apt-get install -y openvpn easy-rsa tree vim net-tools kmod &&     apt-get clean &&     rm -rf /var/lib/apt/lists/*     0.0s
      => CACHED [3/6] RUN make-cadir /etc/openvpn/easy-rsa                                                                                                              0.0s
      => CACHED [4/6] WORKDIR /etc/openvpn/easy-rsa                                                                                                                     0.0s
      => CACHED [5/6] COPY init-easyrsa.sh /etc/openvpn/easy-rsa/                                                                                                       0.0s
      => CACHED [6/6] RUN mkdir -p /dev/net && mknod /dev/net/tun c 10 200 && chmod 600 /dev/net/tun                                                                    0.0s
      => exporting to image                                                                                                                                             0.0s
      => => exporting layers                                                                                                                                            0.0s
      => => writing image sha256:c77c63b37803f592e365d485b6e64bef3f6e8c460a45333cad119c1b35b4f4fb                                                                       0.0s
      => => naming to docker.io/library/openvpn-docker-ubuntu-easy-rsa_openvpn                                                                                          0.0s

      Use 'docker scan' to run Snyk tests against images to find vulnerabilities and learn how to fix them
      [+] Running 2/0
      ⠿ Volume "openvpn-docker-ubuntu-easy-rsa_openvpn-data"  Created                                                                                                   0.0s
      ⠿ Container openvpn-test                                Created                                                                                                   0.0s
      Attaching to openvpn-test
   </pre>
   🟨 <mark>**Jangan tutup terminal ini ketika container berhasil dijalankan !.**</mark>

   <div align="center">
      <img src="./gambar-petunjuk/ss_docker_desktop_001.png" alt="ss_docker_desktop" style="display: block; margin: 0 auto;">
   </div>

   &nbsp;

   <div align="center">
      <img src="./gambar-petunjuk/ss_docker_desktop_002.png" alt="ss_docker_desktop" style="display: block; margin: 0 auto;">
   </div>

   &nbsp;

   ⌘ Melihat hasil docker container pada terminal perintah lain.
   <pre>
   ❯ docker images
      REPOSITORY                               TAG       IMAGE ID       CREATED          SIZE
      openvpn-docker-ubuntu-easy-rsa_openvpn   latest    7ad277ba3f55   14 minutes ago   190MB

   ❯ docker ps -a
        CONTAINER ID   IMAGE                                    COMMAND   CREATED          STATUS          PORTS                    NAMES
        8fb69dfc193f   openvpn-docker-ubuntu-easy-rsa_openvpn   "bash"    17 minutes ago   Up 17 minutes   0.0.0.0:1194->1194/udp   openvpn-test
   </pre>

   &nbsp;

4. Masuk ke container `openvpn-test` dilakukan pada terminal baru: <br />
   Setelah container berjalan, masuk ke dalam container untuk menjalankan skrip inisialisasi:
   🔹 Masuk ke dalam container
   <pre>
   ❯ docker exec -it openvpn-test bash
   </pre>
   Periksa isi direktori.
   <pre>
   ....:/etc/openvpn/easy-rsa# <mark>cd /etc/openvpn/easy-rsa</mark>

   ....:/etc/openvpn/easy-rsa# <mark>ls -lah</mark>
      lrwxrwxrwx 1 root root   27 Jun 21 09:47 easyrsa -> /usr/share/easy-rsa/easyrsa
      -rwxr-xr-x 1 root root  279 Jun 21 06:23 init-easyrsa.sh
      -rw-r--r-- 1 root root 4.6K Jun 21 09:47 openssl-easyrsa.cnf
      -rw-r--r-- 1 root root 8.4K Jun 21 09:47 vars
      lrwxrwxrwx 1 root root   30 Jun 21 09:47 x509-types -> /usr/share/easy-rsa/x509-types

   ....:/etc/openvpn/easy-rsa# <mark>tree -L 3 -a ./</mark>
      ./
      |-- easyrsa -> /usr/share/easy-rsa/easyrsa
      |-- init-easyrsa.sh
      |-- openssl-easyrsa.cnf
      |-- vars
      `-- x509-types -> /usr/share/easy-rsa/x509-types

      1 directory, 4 files
      
   ....:/etc/openvpn/easy-rsa# <mark>tree -L 4 -a -I 'easy-rsa'  /etc/openvpn</mark>
      /etc/openvpn
      |-- client
      |-- server
      `-- update-resolv-conf

      2 directories, 1 file   
   </pre>

   🔹 Jalankan script.
   <pre>
   ....:/etc/openvpn/easy-rsa# <mark>./init-easyrsa.sh</mark>
      Note: using Easy-RSA configuration from: ./vars

      init-pki complete; you may now create a CA or requests.
      Your newly created PKI dir is: /etc/openvpn/easy-rsa/pki


      Note: using Easy-RSA configuration from: ./vars

      Using SSL: openssl OpenSSL 1.1.1f  31 Mar 2020
      Generating RSA private key, 2048 bit long modulus (2 primes)
      ........+++++
      ....................................+++++
      e is 65537 (0x010001)
      Can't load /etc/openvpn/easy-rsa/pki/.rnd into RNG
      281473367968224:error:2406F079:random number generator:RAND_load_file:Cannot open file:../crypto/rand/randfile.c:98:Filename=/etc/openvpn/easy-rsa/pki/.rnd
      You are about to be asked to enter information that will be incorporated
      into your certificate request.
      What you are about to enter is what is called a Distinguished Name or a DN.
      There are quite a few fields but you can leave some blank
      For some fields there will be a default value,
      If you enter '.', the field will be left blank.
      -----
      Common Name (eg: your user, host, or server name) [Easy-RSA CA]:
      CA creation complete and you may now import and sign cert requests.
      Your new CA certificate file for publishing is at:
      /etc/openvpn/easy-rsa/pki/ca.crt


      Note: using Easy-RSA configuration from: ./vars

      Using SSL: openssl OpenSSL 1.1.1f  31 Mar 2020
      Generating a RSA private key
      ....................+++++
      .......+++++
      writing new private key to '/etc/openvpn/easy-rsa/pki/private/server.key.sXtcKOiK7S'
      -----
      You are about to be asked to enter information that will be incorporated
      into your certificate request.
      What you are about to enter is what is called a Distinguished Name or a DN.
      There are quite a few fields but you can leave some blank
      For some fields there will be a default value,
      If you enter '.', the field will be left blank.
      -----
      Common Name (eg: your user, host, or server name) [server]:MY-LOCALHOST-TEST

      Keypair and certificate request completed. Your files are:
      req: /etc/openvpn/easy-rsa/pki/reqs/server.req
      key: /etc/openvpn/easy-rsa/pki/private/server.key

      Note: using Easy-RSA configuration from: ./vars

      Using SSL: openssl OpenSSL 1.1.1f  31 Mar 2020

      You are about to sign the following certificate.
      Please check over the details shown below for accuracy. Note that this request
      has not been cryptographically verified. Please be sure it came from a trusted
      source or that you have verified the request checksum with the sender.

      Request subject, to be signed as a server certificate for 1080 days:

      subject=
         commonName                = <mark>MY-LOCALHOST-TEST</mark>

      Type the word 'yes' to continue, or any other input to abort.
      Confirm request details: Using configuration from /etc/openvpn/easy-rsa/pki/safessl-easyrsa.cnf
      Check that the request matches the signature
      Signature ok
      The Subject's Distinguished Name is as follows
      commonName            :ASN.1 12:'MY-LOCALHOST-TEST'
      Certificate is to be certified until Jun  6 07:51:00 2027 GMT (1080 days)

      Write out database with 1 new entries
      Data Base Updated

      Certificate created at: /etc/openvpn/easy-rsa/pki/issued/server.crt

      Note: using Easy-RSA configuration from: ./vars

      Using SSL: openssl OpenSSL 1.1.1f  31 Mar 2020
      Generating DH parameters, 2048 bit long safe prime, generator 2
      This is going to take a long time      
      ...........................................+....+.......+.............
      +.....................................................................
      +.....................................................................
      . . .
      +.....................................................................
      +.....................................................................
      ..........................................................++*++*++*++*

      DH parameters of size 2048 created at /etc/openvpn/easy-rsa/pki/dh.pem
   </pre>

   Periksa kembali **perubahan** isi direktori.
   <pre>
   ....:/etc/openvpn/easy-rsa# <mark>ls -lah</mark>
      lrwxrwxrwx 1 root root   27 Jun 21 09:47 easyrsa -> /usr/share/easy-rsa/easyrsa
      -rwxr-xr-x 1 root root  279 Jun 21 06:23 init-easyrsa.sh
      -rw-r--r-- 1 root root 4.6K Jun 21 09:47 openssl-easyrsa.cnf
      drwx------ 8 root root 4.0K Jun 21 10:16 pki
      -rw-r--r-- 1 root root 8.4K Jun 21 09:47 vars
      lrwxrwxrwx 1 root root   30 Jun 21 09:47 x509-types -> /usr/share/easy-rsa/x509-types   

   ....:/etc/openvpn/easy-rsa# <mark>tree -L 3 -a ./</mark>
      ./
      |-- easyrsa -> /usr/share/easy-rsa/easyrsa
      |-- init-easyrsa.sh
      |-- openssl-easyrsa.cnf
      |-- pki
      |   |-- .rnd
      |   |-- ca.crt
      |   |-- certs_by_serial
      |   |   `-- 3F7D22AF06E676A17433EB24C2647247.pem
      |   |-- dh.pem
      |   |-- extensions.temp
      |   |-- index.txt
      |   |-- index.txt.attr
      |   |-- index.txt.old
      |   |-- issued
      |   |   `-- server.crt
      |   |-- openssl-easyrsa.cnf
      |   |-- private
      |   |   |-- ca.key
      |   |   `-- server.key
      |   |-- renewed
      |   |   |-- certs_by_serial
      |   |   |-- private_by_serial
      |   |   `-- reqs_by_serial
      |   |-- reqs
      |   |   `-- server.req
      |   |-- revoked
      |   |   |-- certs_by_serial
      |   |   |-- private_by_serial
      |   |   `-- reqs_by_serial
      |   |-- safessl-easyrsa.cnf
      |   |-- serial
      |   `-- serial.old
      |-- vars
      `-- x509-types -> /usr/share/easy-rsa/x509-types

      14 directories, 20 files

   ....:/etc/openvpn/easy-rsa# <mark>tree -L 4 -a -I 'easy-rsa'  /etc/openvpn</mark>
      /etc/openvpn
      |-- client
      |-- server
      `-- update-resolv-conf

      2 directories, 1 file   
   </pre>

   🔹 Konfigurasi OpenVPN
   Salin file yang diperlukan ke direktori konfigurasi OpenVPN:
   <pre>
   ....:/etc/openvpn/easy-rsa# <mark>cp pki/ca.crt /etc/openvpn/</mark>
   ....:/etc/openvpn/easy-rsa# <mark>cp pki/issued/server.crt /etc/openvpn/</mark>
   ....:/etc/openvpn/easy-rsa# <mark>cp pki/private/server.key /etc/openvpn/</mark>
   ....:/etc/openvpn/easy-rsa# <mark>cp pki/dh.pem /etc/openvpn/</mark>

   ....:/etc/openvpn/easy-rsa# <mark>tree -L 4 -a -I 'easy-rsa'  /etc/openvpn</mark>
      /etc/openvpn
      |-- ca.crt
      |-- client
      |-- dh.pem
      |-- server
      |-- server.crt
      |-- server.key
      `-- update-resolv-conf

      2 directories, 5 files   
   </pre>

   Periksa Sertifikat Server.<br />
   Gunakan perintah openssl untuk memeriksa tanggal kedaluwarsa sertifikat server. Lokasi sertifikat biasanya berada di /etc/openvpn atau direktori yang telah tentukan dalam konfigurasi.
   <pre>
   ....:/etc/openvpn/easy-rsa# openssl x509 -in /etc/openvpn/server.crt -text -noout | grep "Not After"
         Not After : Jun  6 08:41:50 2027 GMT
   </pre>
   Periksa Sertifikat CA (Certificate Authority).<br />
   <pre>
   ....:/etc/openvpn/easy-rsa# openssl x509 -in /etc/openvpn/ca.crt -text -noout | grep "Not After"
         Not After : Jun 19 07:50:42 2034 GMT
   </pre>
   Tanggal ini menunjukkan sampai kapan sertifikat tersebut berlaku. Jika tanggal kedaluwarsa sudah dekat atau telah berlalu, perlu memperbarui sertifikat tersebut.

   **File Konfigurasi Server OpenVPN** <br />
   Buat file konfigurasi server OpenVPN (/etc/openvpn/server.conf) jika belum ada:
   <pre>
   ....:/etc/openvpn/easy-rsa# <mark>vim /etc/openvpn/server.conf</mark>
         . . .
   </pre>
   ```bash
         port 1194
         proto udp
         dev tun
         ca /etc/openvpn/ca.crt
         cert /etc/openvpn/server.crt
         key /etc/openvpn/server.key
         dh /etc/openvpn/dh.pem
         server 10.8.0.0 255.255.255.0
         ifconfig-pool-persist ipp.txt
         keepalive 10 120
         cipher AES-256-CBC
         persist-key
         persist-tun
         status openvpn-status.log
         log-append /var/log/openvpn.log
         verb 3
   ```

   🔹 Jalankan OpenVPN Server <br />
   Untuk menjalankan OpenVPN server, gunakan perintah berikut di dalam container:
   <pre>
   ....:/etc/openvpn/easy-rsa# <mark>openvpn --config /etc/openvpn/server.conf</mark>
   </pre>
   Notes : <br />
   🏃🏼‍♂️ Setelah menjalankan perintah di atas, pada terminal akan terus berlangsungnya peroses. <br /> 
   🟨 Jangan tutup terminal ini. <br />
   Masuk ke Container dengan membuka dan dilakukan pada terminal baru: <br />

   **[ Optional ]** Untuk menguji atau memastikan bahwa OpenVPN telah berjalan dengan benar di dalam container openvpn-test, lakukan beberapa langkah pengujian berikut: <br />
   Periksa Log OpenVPN
   <pre>
   ....:/etc/openvpn/easy-rsa# <mark>tail -f /var/log/openvpn.log</mark>
      2024-06-22 01:04:19 net_addr_ptp_v4_add: 10.8.0.1 peer 10.8.0.2 dev tun0
      2024-06-22 01:04:19 net_route_v4_add: 10.8.0.0/24 via 10.8.0.2 dev [NULL] table 0 metric -1
      2024-06-22 01:04:19 Could not determine IPv4/IPv6 protocol. Using AF_INET
      2024-06-22 01:04:19 Socket Buffers: R=[212992->212992] S=[212992->212992]
      2024-06-22 01:04:19 UDPv4 link local (bound): [AF_INET][undef]:1194
      2024-06-22 01:04:19 UDPv4 link remote: [AF_UNSPEC]
      2024-06-22 01:04:19 MULTI: multi_init called, r=256 v=256
      2024-06-22 01:04:19 IFCONFIG POOL IPv4: base=10.8.0.4 size=62
      2024-06-22 01:04:19 IFCONFIG POOL LIST
      2024-06-22 01:04:19 Initialization Sequence Completed
   </pre>
   ⚠️ **PERHATIAN :** <br />
   Periksa apakah ada pesan seperti `Initialization Sequence Completed` yang menunjukkan bahwa OpenVPN telah berhasil memulai dan menyelesaikan proses inisialisasi. <br />
   Jika menghentikan perintah `openvpn --config /etc/openvpn/server.conf`, maka akan muncul pada openvpn.log seperti `SIGINT[hard,] received, process exiting`.<br />
   🏃🏼‍♂️ Setelah menjalankan perintah di atas, pada terminal akan terus berlangsungnya peroses. <br /> 
   ⬜️ Dapat memantau hasil realtime pada `openvpn.log` selama proses openvpn ini berlangsung, atau boleh juga menutupnya.

   &nbsp;

5. Pastikan port `1194` di dalam container telah aktif.
   <pre>
   ....:/etc/openvpn/easy-rsa# <mark>netstat -tuln | grep 1194</mark>
   </pre>
   Harus melihat sesuatu seperti ini:
   <pre>
   Active Internet connections (only servers)
   Proto Recv-Q Send-Q Local Address           Foreign Address         State      
   tcp        0      0 127.0.0.11:43907        0.0.0.0:*               LISTEN     
   udp        0      0 127.0.0.11:39163        0.0.0.0:*                          
   <mark>udp        0      0 0.0.0.0:1194            0.0.0.0:*                     </mark>
   </pre>

   &nbsp;

6. Menyalin Sertifikat dan Kunci ke Mesin Klien ( dilakukan pada host / keluar jika posisi masih di dalam container ). <br />
   <pre>
   ....:/etc/openvpn/easy-rsa# <mark>exit</mark>
   </pre>
   <pre>
   ❯ docker cp openvpn-test:/etc/openvpn/ca.crt ./ca.crt
   ❯ docker cp openvpn-test:/etc/openvpn/server.crt ./client.crt
   ❯ docker cp openvpn-test:/etc/openvpn/server.key ./client.key   
   </pre>

   &nbsp;

7. Persiapkan File Konfigurasi Client. <br />
   Pastikan telah memiliki file konfigurasi client OpenVPN (`client.ovpn`). File ini biasanya berisi informasi seperti alamat server, port, path ke sertifikat, dan konfigurasi lainnya. Contoh isi dari client.ovpn bisa seperti ini:
   <pre>
   ❯ vim client.ovpn
      . . .
      client
      dev tun
      proto udp
      remote 192.168.100.225 1194  # Ganti dengan IP server OpenVPN dan port yang digunakan (default 1194)

      resolv-retry infinite
      nobind
      persist-key
      persist-tun

      ca /Users/powercommerce/Documents/test/from-github-all/openVPN-docker-ubuntu-easy-rsa/ca.crt
      cert /Users/powercommerce/Documents/test/from-github-all/openVPN-docker-ubuntu-easy-rsa/client.crt
      key /Users/powercommerce/Documents/test/from-github-all/openVPN-docker-ubuntu-easy-rsa/client.key

      remote-cert-tls server
      cipher AES-256-CBC
      verb 3
   </pre>

   <pre>
   ❯ tree -L 3 -a -I '.DS_Store|.git|.gitignore|README.md|gambar-petunjuk' ./
      ./
      ├── Dockerfile
      ├── ca.crt
      ├── client.crt
      ├── client.key
      ├── client.ovpn
      ├── docker-compose.yml
      └── init-easyrsa.sh

      0 directories, 7 files
      </pre>

   &nbsp;

8. Verifikasi Koneksi. <br />
   Setelah menjalankan perintah di atas, OpenVPN akan mencoba untuk terhubung ke server menggunakan konfigurasi yang diberikan dalam file client.ovpn. Pada output terminal, Anda akan melihat informasi mengenai status koneksi, termasuk jika koneksi berhasil atau jika terdapat masalah yang perlu diperbaiki.

   &nbsp;

   &nbsp;


