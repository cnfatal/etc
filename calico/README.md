# calico 问题排查

## 集群间pod不通

1. 检查`calicoctl node status`是否全部为 `Established`

> 该结果列表里面不包含自身

```sh
$ sudo calicoctl node status
Calico process is running.

IPv4 BGP status
+---------------+-------------------+-------+----------+-------------+
| PEER ADDRESS  |     PEER TYPE     | STATE |  SINCE   |    INFO     |
+---------------+-------------------+-------+----------+-------------+
| 192.168.1.242 | node-to-node mesh | up    | 09:04:39 | Established |
| 192.168.1.243 | node-to-node mesh | up    | 09:04:40 | Established |
| 192.168.1.244 | node-to-node mesh | up    | 09:04:49 | Established |
| 192.168.1.248 | node-to-node mesh | up    | 09:05:21 | Established |
| 192.168.1.249 | node-to-node mesh | up    | 09:04:48 | Established |
+---------------+-------------------+-------+----------+-------------+

INFO: BIRDv6 process: 'bird6' is not running.
```

如果存在非 `Established` 状态则检查该主机。

1. 检查主机上路由 `ip route`。

正常情况为,从当前主机到集群其他主机均有一条路由，类似于 `[calico子网] via [其他主机ip] dev [本主机网卡] proto bird`

```sh
$ ip r
default via 192.168.1.1 dev eth0 proto static
172.16.32.192/26 via 192.168.1.249 dev eth0 proto bird
172.16.37.128/26 via 192.168.1.243 dev eth0 proto bird
172.16.152.64/26 via 192.168.1.248 dev eth0 proto bird
172.16.189.0/26 via 192.168.1.242 dev eth0 proto bird
172.16.223.64/26 via 192.168.1.244 dev eth0 proto bird
```

1. 检查服务 `calico-bird` 状态和 `calico-confd` 状态，这两个组件负责同步集群路由信息

1. 检查主机防火墙，至少需要能够开启端口 179（BGP通信），或者直接停止防火墙。

1. 检查服务 `calico-felix` 状态，该组件负责注册node至calico集群，并维护该主机的`iptables`规则。

1. 检查 calico 网络策略，该策略配置了 calico 工作负载之间的联通策略。该策略由iptables实施控制。`calicoctl get globalNetworkPolicy`

```sh
$ calicoctl get globalNetworkPolicy -oyaml
apiVersion: projectcalico.org/v3
items:
- apiVersion: projectcalico.org/v3
  kind: GlobalNetworkPolicy
  metadata:
    creationTimestamp: "2020-04-09T12:22:09Z"
    name: allow-all
    resourceVersion: "25"
    uid: 511e9abc-9797-4b46-ad42-7e09c5865dc2
  spec:
    egress:
    - action: Allow
      destination: {}
      source: {}
    ingress:
    - action: Allow
      destination: {}
      source: {}
    selector: all()
    types:
    - Ingress
    - Egress
kind: GlobalNetworkPolicyList
metadata:
  resourceVersion: "397991"
```

该策略配置了无限制的网络策略。

1. 按照[remove-calico-policy.sh](https://github.com/projectcalico/calico/blob/master/hack/remove-calico-policy/remove-calico-policy.sh)
来删除主机iptables规则，等calico重新生成。不过该操作极少使用。因为calico本身如果有问题重新生成也会有问题。

1. 如果以上方式均无效则可以 `sudo calicoctl node diags` 收集calico信息，打包带回。

## pod 内部无法访问外网

1. 检查是否是集群pod间无法访问，是则安装pod间无法访问处理

1. 检查使用的 ip pool 是否开启 `natOutgoing: true` ，该选项用于 pod 内部流量是否通过 nat 通过主机网卡访问外网。

```sh
$ calicoctl get ipp newben-pool -oyaml
apiVersion: projectcalico.org/v3
kind: IPPool
metadata:
  annotations:
    org.projectcalico.label.network.ID: 70fa0e5b9eaf0c6a07b271b298109d76bf3308748c9e462e51802bdc99f34378
  creationTimestamp: "2020-04-09T12:22:10Z"
  name: newben-pool
  resourceVersion: "397110"
  uid: dcb3b145-09d7-45ec-b817-46796680d8cb
spec:
  blockSize: 26
  cidr: 172.16.0.0/16
  ipipMode: Never
  natOutgoing: true
  nodeSelector: all()
  vxlanMode: Never
```

如果未开启，则 `calicoctl get ipp newben-pool -oyaml > ipp.yaml`,编辑该文件后 `calicoctl apply -f ipp.yaml` 进行更新，如果失败则可以尝试先删除再创建。

1. 检查容器dns配置，检查主机dns配置。
