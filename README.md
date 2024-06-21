# openVPN

&nbsp;

### Langkah : 
Menjalankan Container
1. Buat Skrip init-easyrsa.sh Eksekutabel: <br />
   Pastikan skrip init-easyrsa.sh dapat dieksekusi:
   <pre>
   ❯ chmod +x init-easyrsa.sh
   </pre>

2. Bangun dan Jalankan Container: <br />
   Jalankan perintah berikut untuk membangun dan menjalankan container:
   <pre>
   ❯ docker-compose up --build
   </pre>
   <pre>
        [+] Building 61.4s (10/10) FINISHED                                                                                                                                                                                    
        => [internal] load build definition from Dockerfile                                                                                       0.0s
        => => transferring dockerfile: 508B                                                                                                       0.0s
        => [internal] load .dockerignore                                                                                                          0.0s
        => => transferring context: 2B                                                                                                            0.0s
        => [internal] load metadata for docker.io/library/ubuntu:20.04                                                                            4.3s
        => [internal] load build context                                                                                                          0.0s
        => => transferring context: 323B                                                                                                          0.0s
        => [1/5] FROM docker.io/library/ubuntu:20.04@sha256:0b897358ff6624825fb50d20ffb605ab0eaea77ced0adb8c6a4b756513dec6fc                      14.8s
        => => resolve docker.io/library/ubuntu:20.04@sha256:0b897358ff6624825fb50d20ffb605ab0eaea77ced0adb8c6a4b756513dec6fc                      0.0s
        => => sha256:0b897358ff6624825fb50d20ffb605ab0eaea77ced0adb8c6a4b756513dec6fc 1.13kB / 1.13kB                                             0.0s
        => => sha256:6edb9576e2a2080a42e4e0e9a6bc0bd91a2bf06375f9832d400bf33841d35ece 424B / 424B                                                 0.0s
        => => sha256:583f1722e16e377baf906fee1ec6a9fda85ff7f3d13f536f912998601fd85ed8 2.31kB / 2.31kB                                             0.0s
        => => sha256:f02209be4ee528c246399de81af4552e52adb005a8a499815607b6b0d42746bf 25.97MB / 25.97MB                                           14.0s
        => => extracting sha256:f02209be4ee528c246399de81af4552e52adb005a8a499815607b6b0d42746bf                                                  0.7s
        => [2/5] RUN apt-get update &&     apt-get install -y openvpn easy-rsa &&     apt-get clean &&     rm -rf /var/lib/apt/lists/*            41.7s
        => [3/5] RUN make-cadir /etc/openvpn/easy-rsa                                                                                             0.1s
        => [4/5] WORKDIR /etc/openvpn/easy-rsa                                                                                                    0.0s 
        => [5/5] COPY ./init-easyrsa.sh /etc/openvpn/easy-rsa/                                                                                    0.0s 
        => exporting to image                                                                                                                     0.3s 
        => => exporting layers                                                                                                                    0.3s 
        => => writing image sha256:cd402efd882aa89f2ce23dfe93299c2bd3ba24436ec0bec978faf9c98023357c                                               0.0s 
        => => naming to docker.io/library/openvpn-docker-ubuntu-easy-rsa_openvpn                                                                  0.0s

        Use 'docker scan' to run Snyk tests against images to find vulnerabilities and learn how to fix them
        [+] Running 2/2
        ⠿ Network openvpn-docker-ubuntu-easy-rsa_default  Created                                                                                 0.0s
        ⠿ Container openvpn-test                          Created                                                                                 0.0s
        Attaching to openvpn-test   
   </pre>
   Jangan tutup terminal ini ketika container berhasil dijalankan.

   <div align="center">
      <img src="./gambar-petunjuk/ss_docker_desktop_001.png" alt="ss_docker_desktop" style="display: block; margin: 0 auto;">
   </div>

   &nbsp;

   <div align="center">
      <img src="./gambar-petunjuk/ss_docker_desktop_002.png" alt="ss_docker_desktop" style="display: block; margin: 0 auto;">
   </div>

3. Masuk ke Container dengan membuka dan dilakukan pada terminal baru:
   Setelah container berjalan, Anda bisa masuk ke dalam container untuk menjalankan skrip inisialisasi:
   <pre>
   ❯ docker ps -a
        CONTAINER ID   IMAGE                                    COMMAND   CREATED          STATUS          PORTS                    NAMES
        8fb69dfc193f   openvpn-docker-ubuntu-easy-rsa_openvpn   "bash"    17 minutes ago   Up 17 minutes   0.0.0.0:1194->1194/udp   openvpn-test

   ❯ docker exec -it openvpn-test bash
     .../easy-rsa# <mark>cd /etc/openvpn/easy-rsa</mark>
     .../easy-rsa# <mark>ls -lah</mark>
      lrwxrwxrwx 1 root root   27 Jun 21 07:07 easyrsa -> /usr/share/easy-rsa/easyrsa
      -rwxr-xr-x 1 root root  279 Jun 21 06:23 init-easyrsa.sh
      -rw-r--r-- 1 root root 4.6K Jun 21 07:07 openssl-easyrsa.cnf
      -rw-r--r-- 1 root root 8.4K Jun 21 07:07 vars
      lrwxrwxrwx 1 root root   30 Jun 21 07:07 x509-types -> /usr/share/easy-rsa/x509-types
     .../easy-rsa# <mark>./init-easyrsa.sh</mark>
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
      Common Name (eg: your user, host, or server name) [server]:hostest

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
         commonName                = <mark>hostest</mark>


      Type the word 'yes' to continue, or any other input to abort.
      Confirm request details: Using configuration from /etc/openvpn/easy-rsa/pki/safessl-easyrsa.cnf
      Check that the request matches the signature
      Signature ok
      The Subject's Distinguished Name is as follows
      commonName            :ASN.1 12:'hostest'
      Certificate is to be certified until Jun  6 07:51:00 2027 GMT (1080 days)

      Write out database with 1 new entries
      Data Base Updated

      Certificate created at: /etc/openvpn/easy-rsa/pki/issued/server.crt


      Note: using Easy-RSA configuration from: ./vars

      Using SSL: openssl OpenSSL 1.1.1f  31 Mar 2020
      Generating DH parameters, 2048 bit long safe prime, generator 2
      This is going to take a long time      
   </pre>