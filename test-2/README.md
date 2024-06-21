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
    </pre>
