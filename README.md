# glusterfs test

2 gluster servers and 4 gluster clients

## init

bootstrap glusterfs volume and create some files

```
./task init
```

now check files created in ./volumes

```
tree -h volumes
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

## failure test on meucci

kill meucci servers

```
task meucci:kill
```

create new files

```
task test C
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
