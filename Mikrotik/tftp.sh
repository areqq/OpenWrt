dnsmasq \
    --no-daemon \
    --listen-address 192.168.1.10 \
    --bind-interfaces \
    -p0 \
    --dhcp-authoritative \
    --dhcp-range=192.168.1.100,192.168.1.200 \
    --bootp-dynamic \
    --dhcp-boot=initramfs.bin \
    --log-dhcp \
    --enable-tftp \
    --tftp-root=/tmp/tftproot/
    
