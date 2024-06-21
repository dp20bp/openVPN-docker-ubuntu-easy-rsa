# openVPN

### Langkah : 
Menjalankan Container
1. Buat Direktori untuk Data OpenVPN: <br />
   Buat direktori untuk menyimpan data OpenVPN:
   <pre>
   ❯ mkdir openvpn-data
   </pre>

2. Buat Skrip init-easyrsa.sh Eksekutabel: <br />
   Pastikan skrip init-easyrsa.sh dapat dieksekusi:
   <pre>
   ❯ chmod +x init-easyrsa.sh
   </pre>

3. Bangun dan Jalankan Container: <br />
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
