# tailscale

from: https://openwrt.org/docs/guide-user/storage/usb-drives
```
opkg update
opkg install cfdisk e2fsprogs kmod-fs-ext4
cfdisk /dev/sdb
mkfs.ext4 /dev/sdb1
block detect | uci import fstab
uci set fstab.@mount[-1].enabled='1'
uci commit fstab
```

from: https://blog.patshead.com/2020/10/tailscale-on-my-gl-dot-inet-mango-openwrt-router.html

```
cd /tmp/mountd/disk1_part1
# see: https://pkgs.tailscale.com/unstable/
# for gl-inet
wget https://pkgs.tailscale.com/unstable/tailscale_1.29.125_mips.tgz
# for slate
wget https://pkgs.tailscale.com/unstable/tailscale_1.29.125_arm.tgz
ln -s tailscale_1.29.125_* tailscale
cat >> /etc/rc.local << EOF
(sleep 10; /tmp/mountd/disk1_part1/tailscale/tailscaled -state /tmp/mountd/disk1_part1/tailscale/tailscale.state > /dev/null 2>&1) &
EOF
```

Probably a better method: https://willangley.org/how-i-set-up-tailscale-on-my-wifi-router/

```
tailscale up
tailscale up --advertise-routes=192.168.8.0/24
```
