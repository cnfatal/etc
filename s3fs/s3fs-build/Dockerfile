FROM alpine:3.10 as builder
RUN apk --update add fuse alpine-sdk automake autoconf libxml2-dev fuse-dev curl-dev git bash;
ARG S3FS_VERSION=v1.85
RUN git clone https://github.com/s3fs-fuse/s3fs-fuse.git; \
    cd s3fs-fuse; \
    git checkout tags/${S3FS_VERSION}; \
    ./autogen.sh;   \
    ./configure --prefix=/usr; \
    make; \
    make install; \
    rm -rf /var/cache/apk/*;

FROM alpine:3.10
COPY --from=builder /usr/bin/s3fs /usr/bin
COPY entrypoint.sh /
ENTRYPOINT [ "/entrypoint.sh" ]