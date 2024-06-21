1.  Buat Volume Container:
    <pre>
    ❯ docker run --name ovpn-data -v /etc/openvpn busybox
    </pre>
    <pre>
    ❯ docker ps -a
        CONTAINER ID   IMAGE     COMMAND   CREATED         STATUS                     PORTS     NAMES
        bd4d5678471c   busybox   "sh"      7 seconds ago   Exited (0) 6 seconds ago             ovpn-data

    ❯ docker volume ls
        DRIVER    VOLUME NAME
        local     1a9b669800cc1c67423738fec3e32850fb2bab46d55134d6ecb747747a3ad8f7        
    </pre>

2.  Inisialisasi Volume Container: <br />
    Inisialisasi volume container ovpn-data yang akan menyimpan file konfigurasi dan sertifikat:
    <pre>
    ❯ docker run --volumes-from ovpn-data --rm kylemanna/openvpn ovpn_genconfig -u udp://192.168.100.225
        Unable to find image 'kylemanna/openvpn:latest' locally
        latest: Pulling from kylemanna/openvpn
        188c0c94c7c5: Pull complete 
        e470f824352c: Pull complete 
        d6ed0c7c142e: Pull complete 
        74586f3c5cd4: Pull complete 
        cb26244a2b2a: Pull complete 
        Digest: sha256:643531abb010a088f1e23a1c99d44f0bd417a3dbb483f809caf4396b5c9829a0
        Status: Downloaded newer image for kylemanna/openvpn:latest
        WARNING: The requested image's platform (linux/amd64) does not match the detected host platform (linux/arm64/v8) and no specific platform was requested
        Processing PUSH Config: 'block-outside-dns'
        Processing Route Config: '192.168.254.0/24'
        Processing PUSH Config: 'dhcp-option DNS 8.8.8.8'
        Processing PUSH Config: 'dhcp-option DNS 8.8.4.4'
        Processing PUSH Config: 'comp-lzo no'
        Successfully generated config
        Cleaning up before Exit ...


    ❯ docker run --volumes-from ovpn-data --rm -it kylemanna/openvpn ovpn_initpki
        WARNING: The requested image's platform (linux/amd64) does not match the detected host platform (linux/arm64/v8) and no specific platform was requested

        init-pki complete; you may now create a CA or requests.
        Your newly created PKI dir is: /etc/openvpn/pki


        Using SSL: openssl OpenSSL 1.1.1g  21 Apr 2020

        Enter New CA Key Passphrase: <mark>test123</mark>   
        Re-Enter New CA Key Passphrase: <mark>test123</mark>   
        Generating RSA private key, 2048 bit long modulus (2 primes)
        .....................................+++++
        .............................................................+++++
        e is 65537 (0x010001)
        You are about to be asked to enter information that will be incorporated
        into your certificate request.
        What you are about to enter is what is called a Distinguished Name or a DN.
        There are quite a few fields but you can leave some blank
        For some fields there will be a default value,
        If you enter '.', the field will be left blank.
        -----         
        Common Name (eg: your user, host, or server name) [Easy-RSA CA]: <mark>perangkat-macbook-saya</mark>

        CA creation complete and you may now import and sign cert requests.
        Your new CA certificate file for publishing is at:
        /etc/openvpn/pki/ca.crt


        Using SSL: openssl OpenSSL 1.1.1g  21 Apr 2020
        Generating DH parameters, 2048 bit long safe prime, generator 2
        This is going to take a long time        
        .......+....+.............................................................................
        +.........................................................................................
        +.........................................................................................
        +.........................................................................................
        +.....................................................................+...................
        +.........................................................................................
        +.........................................................................................
        ..........................................................................................
        ..........................................................................................
        ..........+...................+.....+.....................................................
        ............+........+..................+..++*++*++*++*
        DH parameters of size 2048 created at /etc/openvpn/pki/dh.pem


        Using SSL: openssl OpenSSL 1.1.1g  21 Apr 2020
        Generating a RSA private key
        ..........................................+++++
        ......................+++++
        writing new private key to '/etc/openvpn/pki/easy-rsa-203.pjoeHb/tmp.hpmadh'
        -----
        Using configuration from /etc/openvpn/pki/easy-rsa-203.pjoeHb/tmp.CljfDI
        Enter pass phrase for /etc/openvpn/pki/private/ca.key: <mark>test123</mark>   
        Check that the request matches the signature
        Signature ok
        The Subject's Distinguished Name is as follows
        commonName            :ASN.1 12:'192.168.100.225'
        Certificate is to be certified until Sep 24 23:19:56 2026 GMT (825 days)

        Write out database with 1 new entries
        Data Base Updated

        Using SSL: openssl OpenSSL 1.1.1g  21 Apr 2020
        Using configuration from /etc/openvpn/pki/easy-rsa-406.dEpAbi/tmp.kMMiEn
        Enter pass phrase for /etc/openvpn/pki/private/ca.key: <mark>test123</mark>       

        An updated CRL has been created.
        CRL file: /etc/openvpn/pki/crl.pem
    </pre>
    Notes : <br />
    - **Passphrase untuk ca.key:** <br />
    Saat Anda diminta memasukkan passphrase untuk /etc/openvpn/pki/private/ca.key, Anda harus memasukkan passphrase yang sama dengan yang Anda gunakan sebelumnya (yaitu “test123”). File ca.key adalah kunci pribadi untuk otoritas sertifikat (CA) yang akan digunakan untuk menandatangani sertifikat lain.<br />
    - **CRL (Certificate Revocation List):** <br />
    Pesan terakhir menunjukkan bahwa CRL telah diperbarui. CRL adalah daftar yang berisi sertifikat yang dicabut (revoke) oleh CA. Ini penting untuk mengamankan jaringan dan memastikan bahwa sertifikat yang tidak valid tidak dapat digunakan.

3.  Jalankan OpenVPN Server: <br />
    Pada Docker versi 1.2 atau lebih baru.
    <pre>
    ❯ docker run --name openvpn-test --volumes-from ovpn-data -d -p 1194:1194/udp --cap-add=NET_ADMIN kylemanna/openvpn
        WARNING: The requested image's platform (linux/amd64) does not match the detected host platform (linux/arm64/v8) and no specific platform was requested
        6b23ed2b933b23e036fb6c87e7d2cfe8b8ffc187f87977ae9bdd4c9d30f02070
    </pre>

4.  Buat Sertifikat Klien: <br />
    Buat sertifikat klien tanpa passphrase:
    <pre>
    docker run --volumes-from ovpn-data --rm -it kylemanna/openvpn easyrsa build-client-full CLIENTNAME nopass
    </pre>
    Dapatkan konfigurasi klien dengan sertifikat tersemat:
    <pre>
    docker run --volumes-from ovpn-data --rm kylemanna/openvpn ovpn_getclient CLIENTNAME > CLIENTNAME.ovpn
    </pre>

5.  Konfigurasi Host: <br />
    Unduh file CLIENTNAME.ovpn dan gunakan pada host 192.168.100.225
