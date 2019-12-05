# s3fs sidecar 制作

```bash
docker build -t library/f3fs:v1.85 .
```

镜像说明

|环境变量|用途|
|---|---|
|S3_ACCESS_KEY | access key |
|S3_SECRET_KEY | secret key|
|S3_BUCKET_NAME | 存储桶名称 |
|S3_BUCKET_PATH | 存储桶下子路径,"/path" 需要对象存储存在此路径|
|MOUNT_POINT | 挂载点,"/mnt/data"  |
|S3_ENDPOINT | 对象存储服务器地址 |
|S3_EXTRAVARS |','开头s3-fuse的额外参数|