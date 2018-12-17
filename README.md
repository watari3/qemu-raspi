# ラズパイ用カーネルをQEMUで起動する手順

## 最終更新日

2018/12/17

## 動作環境

- Ubuntu 18.10(on Windows10 Hyper-V)
- qemu-system-arm 2.12.0

## 事前準備

ルートファイルシステム(イメージファイル)は同梱していないので、ラズパイ本家サイトから入手しておきます。

- https://www.raspberrypi.org/downloads/raspbian/
- http://ftp.jaist.ac.jp/pub/raspberrypi/raspbian_lite/images/

イメージファイルは「2018-11-13-raspbian-stretch-lite.img」(1.8GB)のようなファイルで、同梱されているカーネルモジュール(.ko)がどのカーネルバージョンでビルドされているかを調べておきます。

原則としてカーネルとカーネルモジュールがビルドされたカーネルバージョンを合わせておく必要があるからです。ただし、本サイトで配布しているカーネルはドライバを静的リンクしているため、実際にはカーネルモジュールとカーネルバージョンが合っていなくても起動できます。

## QEMUからのLinuxカーネル起動方法

qemu-system-armコマンドはGNOME(X Window System)の端末から実行します。SSH端末上では実行できません。

Linuxカーネル(zImage)、Device Tree(versatile-pb.dtb)、イメージファイル(2018-11-13-raspbian-stretch-lite.img)をカレントディレクトリに格納して、下記コマンドを実行します。

```
# qemu-system-arm \
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
```

## カーネルのビルド方法

クロスコンパイルでLinuxカーネルをビルドします。
下記手順にしたがってtoolchainを導入します。
- https://www.raspberrypi.org/documentation/linux/kernel/building.md

イメージファイル(2018-11-13-raspbian-stretch-lite.img)のカーネルモジュールが4.14.79でビルドされていたため、ここではLinuxカーネル4.14.79を使うことにします。

4.14.79カーネルをクローンします。
```
# git clone --depth=1 -b raspberrypi-kernel_1.20181112-1 https://github.com/raspberrypi/linux
```

Linuxカーネルに「linux4.14.79.diff」をパッチします。

次に下記コマンドを実行します。

```
# make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- versatile_defconfig
```
同梱の「_config」を「.config」に上書きします。

カーネルとDevic Treeをビルドします。

```
# make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- bzImage dtbs
```

ビルドが成功したら、下記ファイルを取得します。

- arch/arm/boot/zImage
- arch/arm/boot/dts/versatile-pb.dtb


## Appendix: イメージファイルのマウント方法

```
# fdisk -l 2018-11-13-raspbian-stretch-lite.img
ディスク 2018-11-13-raspbian-stretch-lite.img: 1.8 GiB, 1866465280 バイト, 3645440 セクタ
単位: セクタ (1 * 512 = 512 バイト)
セクタサイズ (論理 / 物理): 512 バイト / 512 バイト
I/O サイズ (最小 / 推奨): 512 バイト / 512 バイト
ディスクラベルのタイプ: dos
ディスク識別子: 0x7ee80803

デバイス                              起動 開始位置 最後から  セクタ サイズ Id タイプ
2018-11-13-raspbian-stretch-lite.img1          8192    98045   89854  43.9M  c W95 FAT32 (LBA)
2018-11-13-raspbian-stretch-lite.img2         98304  3645439 3547136   1.7G 83 Linux
```

```
# sudo mount -v -o offset=$((512*98304)) -t ext4 ./2018-11-13-raspbian-stretch-lite.img /mnt
```
