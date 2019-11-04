# openconnect代理加ssh端口转发实现内网穿透

## 从build到运行openconnect代理

使用 openconnect 实现vpn服务, 该服务监听端口 443 。

```bash
docker build -t library/ocserv:ubuntu .
docker run -it --name ocsrv -p 443:443 -v `pwd`:/etc/ocserv --privileged library/ocserv:latest
```

默认用户密码： user/password

### 新增用户

```bash
docker exec -it ocsrv ocpasswd [username]
```

## ssh 内网穿透

使用 ssh remote forward 功能将公网主机(vpn.fatalc.cn)的端口(0.0.0.0:10800)转发至本地端口(127.0.0.1:443)。

```bash
ssh -f -N  -R 0.0.0.0:10800:127.0.0.1:443 root@vpn.fatalc.cn
```

## 使用方式

```bash
sudo openconnect -u user vpn.fatalc.cn:10800 --servercert pin-sha256:Y2S6RQGyFyOsj4zx8Bqm/UUvjg843dGv8B0UR2lsj5w= << EOF
password
EOF
```
