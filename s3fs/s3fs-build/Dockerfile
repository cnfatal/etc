FROM alpine:3.10 as builder
RUN apk --update add fuse alpine-sdk automake autoconf libxml2-dev fuse-dev curl-dev git bash;
ARG S3FS_VERSION=v1.85
RUN git clone --branch ${S3FS_VERSION} --single-branch https://github.com/s3fs-fuse/s3fs-fuse.git; \
    cd s3fs-fuse;./autogen.sh;./configure --prefix=/usr;make;make install;
COPY entrypoint.sh /
CMD [ "/entrypoint.sh" ]