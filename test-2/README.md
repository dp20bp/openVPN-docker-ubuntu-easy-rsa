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
    Buat sertifikat klien dengan passphrase:
    <pre>
    ❯ docker run --volumes-from ovpn-data --rm -it kylemanna/openvpn easyrsa build-client-full CLIENTNAME

        WARNING: The requested image's platform (linux/amd64) does not match the detected host platform (linux/arm64/v8) and no specific platform was requested
        Using SSL: openssl OpenSSL 1.1.1g  21 Apr 2020
        Generating a RSA private key
        ............................................................+++++
        ...................................................+++++
        writing new private key to '/etc/openvpn/pki/easy-rsa-1.ihAJiB/tmp.NchaNK'
        Enter PEM pass phrase: <mark>test123</mark>  
        Verifying - Enter PEM pass phrase: <mark>test123</mark>  
        -----
        Using configuration from /etc/openvpn/pki/easy-rsa-1.ihAJiB/tmp.HiijLB
        Enter pass phrase for /etc/openvpn/pki/private/ca.key: <mark>test123</mark>  
        Check that the request matches the signature
        Signature ok
        The Subject's Distinguished Name is as follows
        commonName            :ASN.1 12:'CLIENTNAME'
        Certificate is to be certified until Sep 24 23:46:16 2026 GMT (825 days)

        Write out database with 1 new entries
        Data Base Updated
    </pre>
    Dapatkan konfigurasi klien dengan sertifikat tersemat:
    <pre>
    ❯ docker run --volumes-from ovpn-data --rm kylemanna/openvpn ovpn_getclient CLIENTNAME > CLIENTNAME.ovpn
        WARNING: The requested image's platform (linux/amd64) does not match the detected host platform (linux/arm64/v8) and no specific platform was requested
    </pre>

5.  Konfigurasi Host: <br />
    Unduh file CLIENTNAME.ovpn dan gunakan pada host 192.168.100.225 <br />
    Hasil unduh file CLIENTNAME.ovpn
    <pre>
    client
    nobind
    dev tun
    remote-cert-tls server

    remote 192.168.100.225 1194 udp

    <key>
    -----BEGIN ENCRYPTED PRIVATE KEY-----
    MIIFHDBOBgkqhkiG9w0BBQ0wQTApBgkqhkiG9w0BBQwwHAQI2NSmcALx020CAggA
    MAwGCCqGSIb3DQIJBQAwFAYIKoZIhvcNAwcECNVmc/V9ff0TBIIEyBF7ea49/BCf
    O6Mas7oQWryUgmhuHVyZLLbNYU7pGcmRtnuueddM97H6JTGty1RRP8JsuS1cOTZ5
    wdRddIBTTk83WMTlT+DSqA9Dt9h67wpeKaeY8ZMYrlNGmyH7lsFwdcYWWvRoUxqH
    ja9pm1Oi8nk0KIMxmPkZT9ovzpJghplkQCqufIuzEm3pKXeI2UM2Lm7LGgNJPPw4
    zuOq7tugx6GcUod8vmXb4/nN4INARVMzavfeIFo6uxppl1ojAghsS/tshqmW8LhG
    nrpbLh7VCE6mi/8lnjTfie4lE3PKk6uM2q4Tb03v6T6IcmILgbqEW2C0qUHx+bcv
    FDmfIA4gnyl4k+Rty2ww1EvGwhu8FYoZ8lbNTZQBiWuse04qJ6bo7hpeCiejMP8W
    DihagKaVyUONINibScWuBdufWt5roNfvaFxgZdC/3GjXajQuLnujmFGVRg5rYyWV
    FQ2fM4VOSiYn4wUXB8YSNoOHb0cuclwZunpONdog6htsdv8Oy0Q3U9wX+WmrvQI5
    SVZcHeI5W3I1oprnLao7RlCw6LjLfIoI+K+GS40oBu9p18fcMNbFFKa+JG1hs/Zu
    qgVqzpGh6iFksSpO0K3Rp9fFVqkdHpRip3Sv35KVtwDpqgJA9t5qF7TkiYB7sjV+
    CSp+Djd0IeeZgjBZZvc6TnXKowzbPlqZ0HKddabONdtYKjBkkUUedm0hUSuEYOjQ
    S8ONMj/flyxX/PC30rWhDH+96fk/2VFyR5jieM5Eqae4jHWdVfN/7+lUVYlD3/is
    qwSsYrfAOs6Ra27cOmu4QWRIl525neNNdnAlTR1uPDkEj/Uym8+quOrzVRqMkVqx
    NFe7DuehTVMRS/5DszC/kJYonDL24y3WjO4kfgDS6Briv06GWdMuCMCZfaP5ehUf
    /gAYOgORIvO/eOJYgZuJM6HX5OwZlNafukmKRohZTURGvGUXvoJdBJfWm3kDa2gg
    UMdCTkMu/+zs0jbdYBidcfJGCDFEeUoWv1kH7wJSGJRCGKFJX4w2lalbN77z0UO4
    2cMvzUG8BF928Xbyrf711QZ3vArpcp87OG7M4UyYZNrA4QY0F24PWsCCznCTJrvI
    FxDVmhcEz3VuK0E7ceC5VjLnuhhLSTEK8tvSBwlPwJvX/aEKVk9BhbihO/gKDFFQ
    Zi7omRRr8O19YWeYrS+S7n3ImNvlArDKMNe4okS4dWBGNTo69ghqBLl5r3IQFF6g
    2DLI1OM5ft+Ew2dvkgN7+IsfXIoG2Z129kznkAAezQFWzQ+/cq+nV1j1tisbtgBd
    B4O6CtAWC/5Uhl+uq2cB7zVSOeCXLBhZdTlIHLr0ntoNQaB9nIMxA9eSYitQunQN
    yVhgwJsmRrt5kJ8wgXKULmDAacVYzGcqWBNfONSsdwUZQXa0cebwuhf6SogfH/xL
    mw/LMvl+kiar8mVYEQQD6oR1UqPPMhv/kvRCBpSeKyXexvX28hA8Bz4no35p6Z29
    Xa6QYc+jkSON7htQT2R6/XkGz804TJsJDuT0NkOgN9mmsfEkQz0WNz9cI2YNBbGE
    ld+G68c7D56NHcBkmDCHYZEdHw7qmsB38wcuQfDTijRc80KuoidBEU5ZcI/CxG1f
    fWnVjRZkjvn6IL2qAzo1tA==
    -----END ENCRYPTED PRIVATE KEY-----
    </key>
    <cert>
    -----BEGIN CERTIFICATE-----
    MIIDbjCCAlagAwIBAgIQT1XWMpAvDMNp52bVdJhs7jANBgkqhkiG9w0BAQsFADAh
    MR8wHQYDVQQDDBZwZXJhbmdrYXQtbWFjYm9vay1zYXlhMB4XDTI0MDYyMTIzNDYx
    NloXDTI2MDkyNDIzNDYxNlowFTETMBEGA1UEAwwKQ0xJRU5UTkFNRTCCASIwDQYJ
    KoZIhvcNAQEBBQADggEPADCCAQoCggEBAKdkjyFn/GfxWv3Ph15lBoUYKwtYjXUE
    uuc8mu+w4yv2VT/XYw4HNsQhIrooOqkBu79evgYcMCLC/VTSuo69jQxaLfKs7yW9
    kbrELgwzHFYYq1wJurGFxeYSQs9GVhTQyBLXhW1nX5qkgrk9SLsbnF7dg8VFgPHi
    KBPLm5Afg9W9KeiiewQHnhP6Y4nySihfEENeaV3PDOVa4BMUw+U0928UN3Rblawv
    2723Ro9NOi4NUQCX6wBr8E4GBeRWCqRYuHkm2q4X789LKEA137YZ1pkuonJXFu2G
    iJh8rVUVIOcqCPrtOM7ikTk39EkF5ebzmihy6EtGQfo2cf+rGfbq0hECAwEAAaOB
    rTCBqjAJBgNVHRMEAjAAMB0GA1UdDgQWBBQhQ8TfE086aIwEILWkddJc5qFfqzBc
    BgNVHSMEVTBTgBQ4j+02wuxu1YGfAUWehPXCG+UlnqElpCMwITEfMB0GA1UEAwwW
    cGVyYW5na2F0LW1hY2Jvb2stc2F5YYIUROjTbRGU12y128UQVljueEcXUJYwEwYD
    VR0lBAwwCgYIKwYBBQUHAwIwCwYDVR0PBAQDAgeAMA0GCSqGSIb3DQEBCwUAA4IB
    AQAM5za4tHYf638blYvyJzvbZ7VRpiYmOqq9vEasasATyhJTGY0HHvRMOm5vvE+8
    28OTwXGhbvNsboGUMGVh0jGv0R5bVCj+SskFG49L/3GmO1WDrQ4lBVTMlP5rQ2PP
    lhXcfru7WxjpVYcq24CGB9GefhD4CiCmUZT/tjKFM5x49y/pJYiCimupzjfM/uQ7
    1d7+nr0MeNUdvVKZ+ZYRU99SMDEwfqYxuyqawKuoyk670HpKj3y/psi1iBs1QPcg
    TrEeIcLBoijfJSflyIsUGKSrZTaRg13MW4rPh3vsikcYjfukHElmL3DvIqFVW26S
    MCZy2CDLFQwJnZrLbrZ71nWA
    -----END CERTIFICATE-----
    </cert>
    <ca>
    -----BEGIN CERTIFICATE-----
    MIIDbDCCAlSgAwIBAgIUROjTbRGU12y128UQVljueEcXUJYwDQYJKoZIhvcNAQEL
    BQAwITEfMB0GA1UEAwwWcGVyYW5na2F0LW1hY2Jvb2stc2F5YTAeFw0yNDA2MjEy
    MzE2MDFaFw0zNDA2MTkyMzE2MDFaMCExHzAdBgNVBAMMFnBlcmFuZ2thdC1tYWNi
    b29rLXNheWEwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCwEBBBxvm+
    l54cFdBE8RXk6eo4/jEl+rkjBx3IVN/YbdfFJeGn8QtoskVFK0k21btjFQi3Uopz
    haU4Hg8yaOb4vPdZyZ0Z+kTSHwbO+D53XnL7I+EkQL/b5Y0vX+xM6P+48lsO8VlH
    RRZigU2RIyReZmolGEPZIhBzTb9tAVe6ilxgvrvmUO0c1zJbnGfIwHSskkupG4I6
    r2LdtB++CKM2hYmX3YKUkieVU7fUgLpygMCtH2+AL5XLJ7JeFTfeFuhuuNXtjFPK
    I8rsPzGLSWasJqLflxg82u46lPICJaAeWfv4lE2A8ZUK6HDZt7InrdD05gcboFsO
    k4puyKV7LDPPAgMBAAGjgZswgZgwHQYDVR0OBBYEFDiP7TbC7G7VgZ8BRZ6E9cIb
    5SWeMFwGA1UdIwRVMFOAFDiP7TbC7G7VgZ8BRZ6E9cIb5SWeoSWkIzAhMR8wHQYD
    VQQDDBZwZXJhbmdrYXQtbWFjYm9vay1zYXlhghRE6NNtEZTXbLXbxRBWWO54RxdQ
    ljAMBgNVHRMEBTADAQH/MAsGA1UdDwQEAwIBBjANBgkqhkiG9w0BAQsFAAOCAQEA
    LTb4gveRCP5YX4CJM/U9OZ4GWVnw3ldKOxfTbM2ctxHOs3PYY/oZq+2vFGgXrkUn
    npv1czkvEGOmpJQTmkxOInuYo4Pg18P/+DbvYpT10lf5DaB9el/InWH92/iOInih
    GuGKjKuNVOya6uQiegbPJlpSSNmuPVnF/w9QiKIbmYvqAXrVPqwf5qwdIkSDlYor
    wqSCuSQQeQdRdktoFUxaPRXpzJTEWyNu+TG2D21ZSns4QzCVhJdt5PeA4M6n8mIP
    2LIzkBBVyyfimCMhsElDYzDNKdb6fsxMnUL398STv0yLYpRSf2d62njuYzUCW14Q
    iir0S0T3SyDhoMY6P3hamg==
    -----END CERTIFICATE-----
    </ca>
    key-direction 1
    <tls-auth>
    #
    # 2048 bit OpenVPN static key
    #
    -----BEGIN OpenVPN Static key V1-----
    247450c7686d96a812de66741361876d
    7bdd04afc5133c4c21a12e6e106990ad
    61c742266c14903a2a44391cdcbf6726
    bb57d6d303e4f4912f8a9548033b0638
    ef8d986f9625984635116840e7cf04b6
    fe67579c96c7315c48c2eebc9d32619c
    f404b6dc79aaea56b96f2cdece95b990
    911c2e703ce3a0fed63875fe18bd436b
    1eb0e4eb59c4f8171e330d03754f190f
    3578a8d3328c0d85c60d53e11b9855de
    adb9bae9472479d27644ceb235734342
    efee9bf34298a0d523dcde6f561d8c49
    5eb2a62cb9ea3d4ead32f46f3fe3a3e2
    ace0f3dac2ced9f0e17e274e355d0b7e
    24fd71dce8d35e515e6d5a4963a95ead
    305e792a3904ab0ae527b23c60d8fc47
    -----END OpenVPN Static key V1-----
    </tls-auth>

    redirect-gateway def1
    </pre>
