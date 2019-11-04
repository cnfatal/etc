# 使用s3fs转s3为文件系统

## 实验环境

### fakes3

```bash
gem install fakes3
fakes3 -r /mnt/fakes3_root -p 4567 --license password
```

### 使用

需要主机安装fuse

```bash
docker run -it --rm --device /dev/fuse --privileged unbuntu:18.04 sh
```

```bash
s3fs bucket /mnt/s3fs -o passwd_file=${HOME}/.passwd-s3fs -o url=http://172.16.0.72:4567 -o use_path_request_style
```

## 生产环境

### 镜像

[README.md](./s3fs/README.md)

### 部署示例

[deployment.yaml](./deployment.yaml)

以sidecar加emptyDir方式，sidecar提供s3fs将s3存储转换为文件系统。由于emptyDir特性，pod内的改动会同步。
