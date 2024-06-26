# 🚩 openVPN & easy-rsa (no passphrase)
by Dhony Abu Muhammad

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

      # Generate TLS-Auth key
      openvpn --genkey --secret /etc/openvpn/easy-rsa/ta.key

      # Set permissions (optional)
      chmod 600 /etc/openvpn/easy-rsa/ta.key      
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
      init-pki complete; you may now create a CA or requests.
      Your newly created PKI dir is: /etc/openvpn/easy-rsa/pki


      Using SSL: openssl OpenSSL 1.1.1w  11 Sep 2023
      Generating RSA private key, 2048 bit long modulus (2 primes)
      .....................+++++
      ...................................................................................................+++++
      e is 65537 (0x010001)
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


      Using SSL: openssl OpenSSL 1.1.1w  11 Sep 2023
      Generating a RSA private key
      ..................................................................................+++++
      ..............................................................................................+++++
      writing new private key to '/etc/openvpn/easy-rsa/pki/easy-rsa-70.E47CLE/tmp.Emklql'
      -----
      You are about to be asked to enter information that will be incorporated
      into your certificate request.
      What you are about to enter is what is called a Distinguished Name or a DN.
      There are quite a few fields but you can leave some blank
      For some fields there will be a default value,
      If you enter '.', the field will be left blank.
      -----
      Common Name (eg: your user, host, or server name) [server]:<mark>MY-LOCALHOST-TEST</mark>

      Keypair and certificate request completed. Your files are:
      req: /etc/openvpn/easy-rsa/pki/reqs/server.req
      key: /etc/openvpn/easy-rsa/pki/private/server.key


      Using SSL: openssl OpenSSL 1.1.1w  11 Sep 2023


      You are about to sign the following certificate.
      Please check over the details shown below for accuracy. Note that this request
      has not been cryptographically verified. Please be sure it came from a trusted
      source or that you have verified the request checksum with the sender.

      Request subject, to be signed as a server certificate for 825 days:

      subject=
         commonName                = MY-LOCALHOST-TEST


      Type the word 'yes' to continue, or any other input to abort.
      Confirm request details: Using configuration from /etc/openvpn/easy-rsa/pki/easy-rsa-92.ZzIM5i/tmp.2QfTIo
      Check that the request matches the signature
      Signature ok
      The Subject's Distinguished Name is as follows
      commonName            :ASN.1 12:'MY-LOCALHOST-TEST'
      Certificate is to be certified until Sep 25 15:20:57 2026 GMT (825 days)

      Write out database with 1 new entries
      Data Base Updated

      Certificate created at: /etc/openvpn/easy-rsa/pki/issued/server.crt


      Using SSL: openssl OpenSSL 1.1.1w  11 Sep 2023
      Generating a RSA private key
      ............+++++
      ...........+++++
      writing new private key to '/etc/openvpn/easy-rsa/pki/easy-rsa-155.2gtw7F/tmp.qZnPYw'
      -----
      You are about to be asked to enter information that will be incorporated
      into your certificate request.
      What you are about to enter is what is called a Distinguished Name or a DN.
      There are quite a few fields but you can leave some blank
      For some fields there will be a default value,
      If you enter '.', the field will be left blank.
      -----
      Common Name (eg: your user, host, or server name) [client1]:<mark>MY-LOCALHOST-TEST</mark>

      Keypair and certificate request completed. Your files are:
      req: /etc/openvpn/easy-rsa/pki/reqs/client1.req
      key: /etc/openvpn/easy-rsa/pki/private/client1.key


      Using SSL: openssl OpenSSL 1.1.1w  11 Sep 2023


      You are about to sign the following certificate.
      Please check over the details shown below for accuracy. Note that this request
      has not been cryptographically verified. Please be sure it came from a trusted
      source or that you have verified the request checksum with the sender.

      Request subject, to be signed as a client certificate for 825 days:

      subject=
         commonName                = MY-LOCALHOST-TEST


      Type the word 'yes' to continue, or any other input to abort.
      Confirm request details: Using configuration from /etc/openvpn/easy-rsa/pki/easy-rsa-177.qwLezW/tmp.a2Ohfw
      Check that the request matches the signature
      Signature ok
      The Subject's Distinguished Name is as follows
      commonName            :ASN.1 12:'MY-LOCALHOST-TEST'
      Certificate is to be certified until Sep 25 15:21:21 2026 GMT (825 days)

      Write out database with 1 new entries
      Data Base Updated

      Certificate created at: /etc/openvpn/easy-rsa/pki/issued/client1.crt


      Using SSL: openssl OpenSSL 1.1.1w  11 Sep 2023
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
      |   |-- ca.crt
      |   |-- certs_by_serial
      |   |   |-- 8C0158257BA6778A502AE1B04A5B2410.pem
      |   |   `-- A11AC78FE32A25959C80C7324D4606A0.pem
      |   |-- dh.pem
      |   |-- index.txt
      |   |-- index.txt.attr
      |   |-- index.txt.attr.old
      |   |-- index.txt.old
      |   |-- issued
      |   |   |-- client1.crt
      |   |   `-- server.crt
      |   |-- openssl-easyrsa.cnf
      |   |-- private
      |   |   |-- ca.key
      |   |   |-- client1.key
      |   |   `-- server.key
      |   |-- renewed
      |   |   |-- certs_by_serial
      |   |   |-- private_by_serial
      |   |   `-- reqs_by_serial
      |   |-- reqs
      |   |   |-- client1.req
      |   |   `-- server.req
      |   |-- revoked
      |   |   |-- certs_by_serial
      |   |   |-- private_by_serial
      |   |   `-- reqs_by_serial
      |   |-- safessl-easyrsa.cnf
      |   |-- serial
      |   `-- serial.old
      |-- ta.key
      |-- vars
      `-- x509-types -> /usr/share/easy-rsa/x509-types

      14 directories, 24 files

   ....:/etc/openvpn/easy-rsa# <mark>tree -L 4 -a -I 'easy-rsa'  /etc/openvpn</mark>
      /etc/openvpn
      |-- client
      |-- server
      `-- update-resolv-conf

      2 directories, 1 file   
   </pre>

   🔹 Konfigurasi OpenVPN
   Salin file yang diperlukan dari direktori pki (public key infrastructure) ke direktori konfigurasi OpenVPN:
   <pre>
   ....:/etc/openvpn/easy-rsa# <mark>cp pki/ca.crt /etc/openvpn/</mark>
   ....:/etc/openvpn/easy-rsa# <mark>cp pki/issued/server.crt /etc/openvpn/</mark>
   ....:/etc/openvpn/easy-rsa# <mark>cp pki/private/server.key /etc/openvpn/</mark>
   ....:/etc/openvpn/easy-rsa# <mark>cp pki/dh.pem /etc/openvpn/</mark>
   ....:/etc/openvpn/easy-rsa# <mark>cp ta.key /etc/openvpn/</mark>

   ....:/etc/openvpn/easy-rsa# <mark>tree -L 4 -a -I 'easy-rsa'  /etc/openvpn</mark>
      /etc/openvpn
      |-- ca.crt
      |-- client
      |-- dh.pem
      |-- server
      |-- server.crt
      |-- server.key
      |-- ta.key
      `-- update-resolv-conf

      2 directories, 6 files  
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
   test - first draft
   ```bash
      port 1194
      proto udp
      dev tun
      ca /etc/openvpn/ca.crt
      cert /etc/openvpn/server.crt
      key /etc/openvpn/server.key
      dh /etc/openvpn/dh.pem
      tls-auth /etc/openvpn/ta.key 0
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
   test - second draft
   ```bash
      port 1194
      proto udp
      dev tun
      ca /etc/openvpn/ca.crt
      cert /etc/openvpn/server.crt
      key /etc/openvpn/server.key
      dh /etc/openvpn/dh.pem
      auth SHA256
      tls-auth /etc/openvpn/ta.key 0
      cipher AES-256-CBC
      server 10.8.0.0 255.255.255.0
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
   <mark>udp        0      0 0.0.0.0:1194            0.0.0.0:*                      </mark>
   </pre>

   &nbsp;

6. Salin certificate dan key ke perangkat client  <br />
   ( dilakukan pada host / keluar jika posisi masih di dalam container ).
   <pre>
   ....:/etc/openvpn/easy-rsa# <mark>exit</mark>
   </pre>
   <pre>
   ❯ mkdir -p client1/file
   ❯ docker cp openvpn-test:/etc/openvpn/ca.crt ./client1/file/ca.crt
   ❯ docker cp openvpn-test:/root/client-configs/files/client1.crt ./client1/file/client.crt
   ❯ docker cp openvpn-test:/root/client-configs/files/client1.key ./client1/file/client.key
   ❯ docker cp openvpn-test:/etc/openvpn/ta.key ./client1/file/ta.key
   </pre>

   &nbsp;

7. Persiapkan File Konfigurasi Client. <br />
   Pastikan telah memiliki file konfigurasi client OpenVPN (`/client1/client.ovpn`). 
   File ini biasanya berisi informasi seperti alamat server, port, path ke sertifikat, dan konfigurasi lainnya. Contoh isi dari client.ovpn bisa seperti ini: <br />

   test - first draft
   <pre>
   ❯ vim client.ovpn
      . . .
      client
      dev tun
      proto udp
      remote 192.168.100.225 1194  # port yang digunakan (default 1194)
      resolv-retry infinite
      nobind
      persist-key
      persist-tun

      ca /Users/powercommerce/Documents/test/from-github-all/openVPN-docker-ubuntu-easy-rsa/client1/file/ca.crt
      cert /Users/powercommerce/Documents/test/from-github-all/openVPN-docker-ubuntu-easy-rsa/client1/file/client.crt
      key /Users/powercommerce/Documents/test/from-github-all/openVPN-docker-ubuntu-easy-rsa/client1/file/client.key
      tls-auth /Users/powercommerce/Documents/test/from-github-all/openVPN-docker-ubuntu-easy-rsa/client1/file/ta.key

      remote-cert-tls server
      cipher AES-256-CBC
      verb 3
   </pre>

   test - second draft
   <pre>
   ❯ vim client.ovpn
      . . .
      client
      dev tun
      proto udp
      remote 192.168.100.225 1194
      resolv-retry infinite
      nobind
      persist-key
      persist-tun
      remote-cert-tls server
      auth SHA256
      cipher AES-256-CBC
      key-direction 1
      verb 3

      ca /Users/powercommerce/Documents/test/from-github-all/openVPN-docker-ubuntu-easy-rsa/client1/file/ca.crt
      cert /Users/powercommerce/Documents/test/from-github-all/openVPN-docker-ubuntu-easy-rsa/client1/file/client.crt
      key /Users/powercommerce/Documents/test/from-github-all/openVPN-docker-ubuntu-easy-rsa/client1/file/client.key
      tls-auth /Users/powercommerce/Documents/test/from-github-all/openVPN-docker-ubuntu-easy-rsa/client1/file/ta.key
   </pre>


   <pre>
   ❯ tree -L 3 -a -I '.DS_Store|.git|.gitignore|README.md|gambar-petunjuk|tmp' ./
      ./
      ├── Dockerfile
      ├── client1
      │   └── file
      │       ├── ca.crt
      │       ├── client.crt
      │       ├── client.key
      │       ├── client.ovpn
      │       └── ta.key
      ├── docker-compose.yml
      ├── init-easyrsa.sh
      └── kylemanna-openvpn-with-passphrase
         └── CLIENTNAME.ovpn

      3 directories, 9 files
   </pre>

   &nbsp;

8. Verifikasi Koneksi. <br />
   Setelah menjalankan perintah di atas, OpenVPN akan mencoba untuk terhubung ke server menggunakan konfigurasi yang diberikan dalam file client.ovpn. Pada output terminal, Anda akan melihat informasi mengenai status koneksi, termasuk jika koneksi berhasil atau jika terdapat masalah yang perlu diperbaiki.

&nbsp;

&nbsp;

&nbsp;

&nbsp;

---

## 🧪 Analysis on ovpn.log results : 
with the implementation of the first draft configuration on the server and client
<pre>
....:/etc/openvpn/easy-rsa# <mark>tail -f /var/log/openvpn.log</mark>
   . . .
   2024-06-22 23:17:44 Authenticate/Decrypt packet error: packet HMAC authentication failed
   2024-06-22 23:17:44 TLS Error: incoming packet authentication failed from [AF_INET]172.18.0.1:62318
   2024-06-22 23:17:45 Authenticate/Decrypt packet error: packet HMAC authentication failed
   2024-06-22 23:17:45 TLS Error: incoming packet authentication failed from [AF_INET]172.18.0.1:62318
   2024-06-22 23:17:46 Authenticate/Decrypt packet error: packet HMAC authentication failed
   2024-06-22 23:17:46 TLS Error: incoming packet authentication failed from [AF_INET]172.18.0.1:62318
   2024-06-22 23:17:47 Authenticate/Decrypt packet error: packet HMAC authentication failed
   2024-06-22 23:17:47 TLS Error: incoming packet authentication failed from [AF_INET]172.18.0.1:62318
   2024-06-22 23:17:48 Authenticate/Decrypt packet error: packet HMAC authentication failed
   2024-06-22 23:17:48 TLS Error: incoming packet authentication failed from [AF_INET]172.18.0.1:62318
    . . .
</pre>

with the implementation of the second draft configuration on the server and client
<pre>
....:/etc/openvpn/easy-rsa# <mark>tail -f /var/log/openvpn.log</mark>
    . . .
   2024-06-22 23:02:28 Authenticate/Decrypt packet error: packet HMAC authentication failed
   2024-06-22 23:02:28 TLS Error: incoming packet authentication failed from [AF_INET]172.18.0.1:64922
   2024-06-22 23:02:29 Authenticate/Decrypt packet error: packet HMAC authentication failed
   2024-06-22 23:02:29 TLS Error: incoming packet authentication failed from [AF_INET]172.18.0.1:64922
   2024-06-22 23:02:30 Authenticate/Decrypt packet error: packet HMAC authentication failed
   2024-06-22 23:02:30 TLS Error: incoming packet authentication failed from [AF_INET]172.18.0.1:64922
   2024-06-22 23:02:31 Authenticate/Decrypt packet error: packet HMAC authentication failed
   2024-06-22 23:02:31 TLS Error: incoming packet authentication failed from [AF_INET]172.18.0.1:64922
   2024-06-22 23:02:32 Authenticate/Decrypt packet error: packet HMAC authentication failed
   2024-06-22 23:02:32 TLS Error: incoming packet authentication failed from [AF_INET]172.18.0.1:64922    
    . . .
</pre>

