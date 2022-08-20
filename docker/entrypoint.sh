
#!/bin/bash


#$GW=$1


# Disable rdma
sed -i.save -e "s#,rdma##" /etc/glusterfs/glusterd.vol


if [ -n "$GW" ]; then
    echo "settings gateway to $GW"
    ip route del default
    ip route add default via $GW
fi 

if [ -n "$ROUTE" ]; then
    echo "add route $ROUTE"
    #iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE 
    #iptables -t nat -A POSTROUTING -o eth1 -j MASQUERADE
    iptables -A FORWARD -i eth1 -j ACCEPT
    iptables -A FORWARD -i eth0 -j ACCEPT
    ip route add $ROUTE
    exec tail -f /dev/null
fi

service rpcbind start
exec glusterd --log-file=- --no-daemon