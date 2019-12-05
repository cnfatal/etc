#!/bin/sh

echo "${S3_ACCESS_KEY}:${S3_SECRET_KEY}" > /etc/passwd-s3fs
chmod 0400 /etc/passwd-s3fs
s3fs "${S3_BUCKET_NAME}":"${S3_BUCKET_PATH}" "${MOUNT_POINT}" -f -o url="${S3_ENDPOINT}",allow_other,use_cache=/tmp,max_stat_cache_size=1000,stat_cache_expire=900,retries=5,connect_timeout=10"${S3_EXTRAVARS}"