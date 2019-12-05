# 使用s3fs转s3为文件系统

## 参考

[s3fs-fuse](https://github.com/s3fs-fuse/s3fs-fuse)

## 镜像制作

[README.md](s3fs-build/README.md)

## 部署示例

### Docker

```sh
docker run -it --rm --name s3fs \
--device /dev/fuse --privileged \
-e S3_ENDPOINT=<endpoint url> \
-e S3_ACCESS_KEY=<access key> \
-e S3_SECRET_KEY=<secret key> \
-e S3_BUCKET_NAME=<bucket name> \
-e S3_BUCKET_PATH="/" \
-e S3_EXTRAVARS=",curldbg" \
-e MOUNT_POINT="/mnt/data" \
-v $PWD/data:/mnt/data \
fatalc/s3fs:v1.85
```

### Kubernetes

以 sidecar 加 emptyDir 方式，sidecar 提供 s3fs 将 s3 存储转换为文件系统并在Pod内共享。

注意⚠️：
 - 由于使用的 ssl ，要求容器内时间不能与对象存储服务器时间相差太远
 - 

[kubernetes.yaml](kubernetes.yaml)
