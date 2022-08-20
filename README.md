# glusterfs test

6 nodes: 3 'a' and 3 'm'

arbiter: ./task-arbiter
replica: ./task-replica

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
create file on a1: /mnt/gv0/normal-a1.txt
create file on a2: /mnt/gv0/normal-a2.txt
create file on a3: /mnt/gv0/normal-a3.txt
create file on m1: /mnt/gv0/normal-m1.txt
create file on m2: /mnt/gv0/normal-m2.txt
create file on m3: /mnt/gv0/normal-m3.txt

[   8]  bricks
├── [   3]  a1
│   └── [   6]  brick1
│       ├── [  20]  normal-a1.txt
│       └── [  20]  normal-m1.txt
├── [   3]  a2
│   └── [   5]  brick1
│       └── [  20]  normal-m3.txt
├── [   3]  a3
│   └── [   7]  brick1
│       ├── [  20]  normal-a2.txt
│       ├── [  20]  normal-a3.txt
│       └── [  20]  normal-m2.txt
├── [   3]  m1
│   └── [   6]  brick1
│       ├── [  20]  normal-a1.txt
│       └── [  20]  normal-m1.txt
├── [   3]  m2
│   └── [   5]  brick1
│       └── [  20]  normal-m3.txt
└── [   3]  m3
    └── [   7]  brick1
        ├── [  20]  normal-a2.txt
        ├── [  20]  normal-a3.txt
        └── [  20]  normal-m2.txt

```


create some files on each host
```
./task test mylabel
```
## failure test on meucci

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
