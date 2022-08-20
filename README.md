# glusterfs docker test laboratory

6 nodes in two connected networks via 'internet' network:

- 3 'a' nodes in agsm site
- 3 'm' nodes in meucci site

## prereq

guestfs-tools package to customize ubuntu cloud image

```
paru -S --mflags "--nocheck" guestfs-tools
```

## build

build docker image

```
./task build
```

## boot

bootstrap glusterfs volume and create some files

```
./task boot
```

```
create file on a1: /mnt/gv0/a1-normal.txt
create file on a2: /mnt/gv0/a2-normal.txt
create file on a3: /mnt/gv0/a3-normal.txt
create file on m1: /mnt/gv0/m1-normal.txt
create file on m2: /mnt/gv0/m2-normal.txt
create file on m3: /mnt/gv0/m3-normal.txt

[   8]  bricks
├── [   3]  a1
│   └── [   7]  brick1
│       ├── [  13]  a1-normal.txt
│       ├── [  13]  a2-normal.txt
│       └── [  13]  m1-normal.txt
├── [   3]  a2
│   └── [   6]  brick1
│       ├── [  13]  a3-normal.txt
│       └── [  13]  m3-normal.txt
├── [   3]  a3
│   └── [   5]  brick1
│       └── [  13]  m2-normal.txt
├── [   3]  m1
│   └── [   7]  brick1
│       ├── [  13]  a1-normal.txt
│       ├── [  13]  a2-normal.txt
│       └── [  13]  m1-normal.txt
├── [   3]  m2
│   └── [   6]  brick1
│       ├── [  13]  a3-normal.txt
│       └── [  13]  m3-normal.txt
└── [   3]  m3
    └── [   5]  brick1
        └── [  13]  m2-normal.txt

```

## create some files

create some files on each host

```
./task test mylabel
```

check files

```
./task check
```

## failure test on meucci

disconnect meucci

```
./task meucci:disconnect
```

write new files

```
./task test disconnected
```

overwrite files

```
./task test normal
```

check files

```
./task check
```

kill meucci servers

```
task meucci:kill
```

create new files

```
./task test kill
```

disconnect meucci from agsm

```
./task meucci:disconnect
./task test disconnected
```

## client

```
gluster --remote-host=localhost volume list
```

## expand volumes with new bricks

expand and rebalance

```
task expand
```

create new files

```
task test B
```

now check files created in ./volumes

```
tree -h volumes
```

## recover from failure

restore servers

```
task meucci:start
```

now check files created in ./volumes

```
tree -h volumes
```

## kvm

download vm image

```
./task vm:download
```

create vm

```
./task vm:create
```

connect to vm with user root and password root

```
docker compose exec kvm virsh console ubuntu
dhclient enp1s0

```

filesystem test on vm

```
apt update && apt install -y fio
fio --randrepeat=1 --ioengine=libaio --direct=1 --gtod_reduce=1 --name=test --bs=4k --iodepth=64 --readwrite=randrw --rwmixread=75 --size=4G --filename=/root/test

```

on my zfs host
```
READ: bw=49.0MiB/s (51.4MB/s), 49.0MiB/s-49.0MiB/s (51.4MB/s-51.4MB/s), io=3070MiB (3219MB), run=62638-62638msec
WRITE: bw=16.4MiB/s (17.2MB/s), 16.4MiB/s-16.4MiB/s (17.2MB/s-17.2MB/s), io=1026MiB (1076MB), run=62638-62638msec
```



example create image

```
qemu-img create -f qcow2 gluster://a1/gv0/vm1.img 10G
```

example load ubuntu cloud image mount gluster filesystem

```
docker compose exec kvm bash

mount -t glusterfs a1:/gv0 /mnt
cp -v /vms/jammy-server-cloudimg-amd64-disk-kvm.img /mnt/
umount /mnt

virsh define /vms/ubuntu.xml
```
