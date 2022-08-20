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
