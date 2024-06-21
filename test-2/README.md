1.  Buat Volume Container:
    <pre>
    docker run --name ovpn-data -v /etc/openvpn busybox
    </pre>
    <pre>
    ❯ docker ps -a
        CONTAINER ID   IMAGE     COMMAND   CREATED         STATUS                     PORTS     NAMES
        bd4d5678471c   busybox   "sh"      7 seconds ago   Exited (0) 6 seconds ago             ovpn-data

    ❯ docker volume ls
        DRIVER    VOLUME NAME
        local     1a9b669800cc1c67423738fec3e32850fb2bab46d55134d6ecb747747a3ad8f7        
    </pre>