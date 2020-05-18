# ipsec setup

```sh
docker run -it --rm --name alpine-22 --network cali_net --cap-add NET_ADMIN alpine sh
sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories
apk add strongswan
```

## ipsec.conf

```conf
# /etc/ipsec.conf - strongSwan IPsec configuration file
config setup

conn %default
       # 使用预共享密钥进行加密
       authby=pubkey
       # 使用路由方式运行
       auto=route
conn cali0_0
      # 左向地址为podip
      # 右向地址为nexthop ip，calico中默认为169.254.0.1
      left=192.168.2.22
      leftsubnet=192.168.0.0/16
      right=192.168.2.23
      rightsubnet=192.168.0.0/16
       # 使用预共享密钥进行加密
       authby=pubkey
       # 使用路由方式运行
       auto=route
```

```conf
conn calinet
    type=transport
    left=192.168.2.22
    leftsubnet=192.168.0.0/16
    rightsubnet=169.254.1.1/32
    right=169.254.1.1
    authby=secret
    auto=start
```

## ipsec.secrets

预共享密钥配置

```conf
# /etc/ipsec.secrets -
: PSK "0sFpZAZqEN6Ti9sqt4ZP5EWcqx"
```

## run

```sh
# ipsec start --nofork
Starting strongSwan 5.6.2 IPsec [starter]...
sh: 1: modprobe: not found
no netkey IPsec stack detected
sh: 1: modprobe: not found
no KLIPS IPsec stack detected
no known IPsec stack detected, ignoring!
00[DMN] Starting IKE charon daemon (strongSwan 5.6.2, Linux 3.10.0-862.el7.x86_64, x86_64)
00[KNL] kernel-netlink plugin might require CAP_NET_ADMIN capability
00[NET] connmark plugin requires CAP_NET_ADMIN capability
00[LIB] plugin 'connmark': failed to load - connmark_plugin_create returned NULL
00[KNL] getting SPD hash threshold failed: Operation not permitted (1)
00[KNL] getting SPD hash threshold failed: Operation not permitted (1)
00[KNL] unable to bind XFRM event socket: Operation not permitted (1)
00[NET] installing IKE bypass policy failed
00[NET] installing IKE bypass policy failed
00[NET] enabling UDP decapsulation for IPv6 on port 4500 failed
00[NET] installing IKE bypass policy failed
00[NET] installing IKE bypass policy failed
00[NET] enabling UDP decapsulation for IPv4 on port 4500 failed
00[LIB] feature CUSTOM:libcharon in critical plugin 'charon' has unmet dependency: CUSTOM:kernel-ipsec
00[KNL] received netlink error: Operation not permitted (1)
00[KNL] unable to create IPv4 routing table rule
00[KNL] received netlink error: Operation not permitted (1)
00[KNL] unable to create IPv6 routing table rule
00[CFG] loading ca certificates from '/etc/ipsec.d/cacerts'
00[CFG] loading aa certificates from '/etc/ipsec.d/aacerts'
00[CFG] loading ocsp signer certificates from '/etc/ipsec.d/ocspcerts'
00[CFG] loading attribute certificates from '/etc/ipsec.d/acerts'
00[CFG] loading crls from '/etc/ipsec.d/crls'
00[CFG] loading secrets from '/etc/ipsec.secrets'
00[CFG]   loaded IKE secret for %any
00[LIB] failed to load 1 critical plugin feature
00[DMN] initialization failed - aborting charon
00[KNL] received netlink error: Operation not permitted (1)
00[KNL] received netlink error: Operation not permitted (1)
charon has quit: initialization failed
charon refused to be started
ipsec starter stopped
```

状态查看

```sh
ipsec trafficstatus
```

由于是在容器中，如果需要操作网络包则需要使用内核能力（capability），目前是需要使用到 `CAP_NET_ADMIN` 能力，允许容器中的程序使用IPsec。

对于docker运行的容器，仅需要使用参数 `--cap-add NET_ADMIN` 即可。

## strongswan

```conf
connections {
   host-host {
      local_addrs  = 192.168.2.22
      remote_addrs = 192.168.2.23

      local {
         auth = psk
         certs = moonCert.pem
         id = moon.strongswan.org
      }
      remote {
         auth = psk
         id = sun.strongswan.org
      }
      children {
         host-host {
            updown = /usr/local/libexec/ipsec/_updown iptables
            rekey_time = 5400
            rekey_bytes = 500000000
            rekey_packets = 1000000
            esp_proposals = aes128gcm128-x25519
            mode = transport
         }
      }
      version = 2
      mobike = no
      reauth_time = 10800
      proposals = aes128-sha256-x25519
   }
}
```
