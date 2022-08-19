# glusterfs test

2 gluster servers and 4 gluster clients

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

create some files on each host
```
./task test A
```

now check files created in ./bricks: each file has 3 copies


```
create file on a2: /mnt/gv0/example-A-a2.txt
create file on a3: /mnt/gv0/example-A-a3.txt
create file on m2: /mnt/gv0/example-A-m2.txt
create file on m3: /mnt/gv0/example-A-m3.txt

[   8]  bricks
├── [   3]  a1
│   └── [   6]  brick1
│       ├── [   0]  example-A-a3.txt
│       └── [   0]  example-A-m2.txt
├── [   3]  a2
│   └── [   6]  brick1
│       ├── [   5]  example-A-a3.txt
│       └── [   5]  example-A-m2.txt
├── [   3]  a3
│   └── [   6]  brick1
│       ├── [   5]  example-A-a2.txt
│       └── [   5]  example-A-m3.txt
├── [   3]  m1
│   └── [   6]  brick1
│       ├── [   0]  example-A-a2.txt
│       └── [   0]  example-A-m3.txt
├── [   3]  m2
│   └── [   6]  brick1
│       ├── [   5]  example-A-a3.txt
│       └── [   5]  example-A-m2.txt
└── [   3]  m3
    └── [   6]  brick1
        ├── [   5]  example-A-a2.txt
        └── [   5]  example-A-m3.txt

```
## failure test on meucci

kill meucci servers

```
task meucci:kill
```

create new files

```
task test C
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
