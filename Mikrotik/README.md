# OpenWrt for Mikrotik

## Jak sprawnie zainstalowć OpenWrt z macos

Idea jest prosta. Bootujemy Mikrotika z sieci, odpala się OpenWrt w RAM i z niego flashujemy.

Instalujemy serwer dhcp/tftp + pakiet iproute2 by mieć ip jak na linuxie. 

```
brew install dnsmasq iproute2
```

Ustawiamy na karcie sieciowej 192.168.1.10/24 i wpinamy w WAN mikrotika.
Kopiujemy właściwy inittamfs.bin. Dla RB760iGS będzie to:

```
mkdir /tmp/tftproot
cp 760igs-initramfs.bin /tmp/tftproot/initramfs.bin
```

Uruchamiamy server 
```
sh tftp.sh
```

Włączamy do prądu Mikrotika trzymając RESET az nie piknie - ze 20s.

Tak to powinno wyglądać:
```
# sh tftp.sh
dnsmasq: started, version 2.90 DNS disabled
dnsmasq: compile time options: IPv6 GNU-getopt no-DBus no-UBus no-i18n no-IDN DHCP DHCPv6 no-Lua TFTP no-conntrack no-ipset no-nftset auth no-cryptohash no-DNSSEC loop-detect no-inotify dumpfile
dnsmasq-dhcp: DHCP, IP range 192.168.1.100 -- 192.168.1.200, lease time 1h
dnsmasq-tftp: TFTP root is /Users/areq/Downloads/Mikrotik


dnsmasq-dhcp: 3271846261 available DHCP range: 192.168.1.100 -- 192.168.1.200
dnsmasq-dhcp: 3271846261 vendor class: MMipsBoot
dnsmasq-dhcp: 3271846261 tags: bootp, en8
dnsmasq-dhcp: 3271846261 BOOTP(en8) 192.168.1.135 78:9a:18:30:63:52
dnsmasq-dhcp: 3271846261 bootfile name: initramfs.bin
dnsmasq-dhcp: 3271846261 next server: 192.168.1.10
dnsmasq-dhcp: 3271846261 sent size:  4 option:  1 netmask  255.255.255.0
dnsmasq-dhcp: 3271846261 sent size:  4 option: 28 broadcast  192.168.1.255
dnsmasq-dhcp: 3271846261 sent size:  4 option:  3 router  192.168.1.10
dnsmasq-tftp: sent /Users/areq/Downloads/Mikrotik/initramfs.bin to 192.168.1.135
```

Jak przestanie się nam pingować ip który pobrał z DHCP - w moim przypadku 192.168.1.135 
przepinamy kabelek na Mikrotiku do portu WAN do LAN1.

192.168.1.1 powinien odpowiadać.
Pobieramy najnowszy obraz i kopiujemy go ssh na Mikrotika.

```
cat openwrt-21.02-snapshot-r16847-f8282da11e-ramips-mt7621-mikrotik_routerboard-760igs-squashfs-sysupgrade.bin | ssh root@192.168.1.1 'cat - > /tmp/routerboard-760igs-squashfs-sysupgrade.bin'
```

logujemy się na root@192.168.1.1 i robimy sysupgrade:

```
sysupgrade -n -v /tmp/routerboard-760igs-squashfs-sysupgrade.bin
```

I gotowe ;)


