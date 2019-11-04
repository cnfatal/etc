# s3fs sidecar 制作

```bash
docker build -t library/f3fs:v1.85 .
```

镜像说明

|环境变量|用途|
|---|---|
|AWS_ACCESS_KEY_ID |access id |
|AWS_SECRET_ACCESS_KEY |access key|
|S3_BUCKET |存储桶名称 |
|MOUNT_POINT |挂载点 |
|S3_ENDPOINT |对象存储服务器地址 |
|S3_EXTRAVARS |','开头，s3fs的额外参数|