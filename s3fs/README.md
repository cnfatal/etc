# 使用s3fs转s3为文件系统

## 参考

[s3fs-fuse](https://github.com/s3fs-fuse/s3fs-fuse)

## 生产环境

### 镜像

[README.md](s3fs-build/README.md)

### 部署示例

以sidecar加emptyDir方式，sidecar提供s3fs将s3存储转换为文件系统。由于emptyDir特性，pod内的改动会同步。

[deployment.yaml](./deployment.yaml)
