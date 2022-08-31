# glusterfs docker test laboratory

6 nodes in two connected networks via 'internet' network:

- 3 'a' nodes in agsm site
- 3 'm' nodes in meucci site
- one node a0 in agsm site with libvirt (host pc)


TODO: https://docs.gluster.org/en/v3/Administrator%20Guide/formatting-and-mounting-bricks/

## prereq

guestfs-tools package to customize ubuntu cloud image

```
paru -S --mflags "--nocheck" guestfs-tools
```

### glusterfs on host 

```
paru -S glusterfs libvirt-storage-gluster cloud-image-utils
virsh pool-define vms/pool.xml
```

append to local /etc/hosts content of ./hosts

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
./task vm:prepare

# eventually test gluster pool
./task vm:test:gluster

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


fio --filename=/root/test1 --size=1Gb --direct=1 --rw=randrw --bs=64k --ioengine=libaio --iodepth=64 --runtime=15 --numjobs=4 --time_based --group_reporting  --name=throughput-test-job --unified_rw_reporting=1

```

on my zfs host
```
READ: bw=5018MiB/s (5261MB/s), 5018MiB/s-5018MiB/s (5261MB/s-5261MB/s), io=147GiB (158GB), run=30002-30002msec
WRITE: bw=5018MiB/s (5262MB/s), 5018MiB/s-5018MiB/s (5262MB/s-5262MB/s), io=147GiB (158GB), run=30002-30002msec



```

on vm
```
READ: bw=19.3MiB/s (20.3MB/s), 19.3MiB/s-19.3MiB/s (20.3MB/s-20.3MB/s), io=581MiB (609MB), run=30027-30027msec
WRITE: bw=20.1MiB/s (21.1MB/s), 20.1MiB/s-20.1MiB/s (21.1MB/s-21.1MB/s), io=604MiB (633MB), run=30027-30027msec

```

dd if=/dev/zero of=/root/test1 bs=1M count=1024 conv=fsync
vm with virtio on gluster pool: 
  * io=threads: 550 MB/s
  * io=native: 544 MB/s
gluster mount: 484 MB/s
native host: 1,6 GB/s



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

no
```
docker network create --attachable --opt com.docker.network.bridge.name=br-pub --opt com.docker.network.bridge.enable_ip_masquerade=false br-pub

```