# ラズパイ向けLinuxカーネル 4.19.10 のビルド手順

## 最終更新日

2018/12/18

## ソースコードの取得

```
# git clone --depth=1 -b rpi-4.19.y https://github.com/raspberrypi/linux
```

```
# git log
commit 9a2e2d98ae5154ecef23aac28ca4d3165ac002ee (grafted, HEAD -> rpi-4.19.y, origin/rpi-4.19.y)
Author: 6by9 <6by9@users.noreply.github.com>
Date:   Tue Dec 11 15:18:02 2018 +0000

    staging: bcm2835-camera: Check the error for REPEAT_SEQ_HEADER (#2782)
```

カーネルバージョンは4.19.10です。

```
# head Makefile
# SPDX-License-Identifier: GPL-2.0
VERSION = 4
PATCHLEVEL = 19
SUBLEVEL = 10
EXTRAVERSION =
NAME = "People's Front"
```

## カーネルへのパッチ

```
# patch --dry-run -p1 < linux4.19.10.diff
# patch -p1 < linux4.19.10.diff
```


## カーネルコンフィグレーション

下記コマンドでデフォルトの.configを作ります。ここでbisonとflexが必要となります。

```
# make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- versatile_defconfig
```

カーネルコンフィグレーションを行います。Tera Termだと表示が崩れることがあるので、その場合はGNOME端末で作業します。
```
# make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- menuconfig
```

上記手順の代わりに、同梱した「config_file_4.19.10」を.configに上書きしてもOKです。

## カーネルとDevice Treeのビルド

```
# make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- bzImage dtbs
```

ビルドが成功したら、下記ファイルを取得します。

- arch/arm/boot/zImage
- arch/arm/boot/dts/versatile-pb.dtb
