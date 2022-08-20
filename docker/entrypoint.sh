
#!/bin/bash


#$GW=$1


# Disable rdma
sed -i.save -e "s#,rdma##" /etc/glusterfs/glusterd.vol


if [ -n "$GW" ]; then
    echo "settings gateway to $GW on normal node"
    ip route del default
    ip route add default via $GW
    #iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
fi 

if [ -n "$ROUTE" ]; then
    echo "add route $ROUTE on gw node"
    set -x
    # for interface in etho eth1; do
    #     for range in 172.29.0.0/24 172.28.0.0/24; do
    #         iptables -t nat -A POSTROUTING -o $interface -d $range -j RETURN
    #     done
    # done

    # for interface in etho eth1; do
    #     iptables -t nat -A POSTROUTING -o $interface -j MASQUERADE
    # done

    #iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE 
    #iptables -t nat -A POSTROUTING -o eth1 -j MASQUERADE
    #iptables -A FORWARD -i eth1 -j ACCEPT
    #iptables -A FORWARD -i eth0 -j ACCEPT
    ip route add $ROUTE
    exec tail -f /dev/null
fi

service rpcbind start
exec glusterd --log-file=- --no-daemon