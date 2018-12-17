qemu-system-arm \
-kernel zImage \
-cpu arm1176 \
-M versatilepb \
-dtb versatile-pb.dtb \
-m 256 \
-no-reboot \
-serial stdio \
-append "root=/dev/sda2 panic=1 rootfstype=ext4 rw" \
-hda 2018-11-13-raspbian-stretch-lite.img \
-net nic -net user,hostfwd=tcp::10022-:22

