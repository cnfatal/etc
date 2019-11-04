#!/bin/sh

docker run -it \
--name ocsrv \
-p 10443:443 \
-v `pwd`:/etc/ocserv \
--privileged \
fatalc/ocserv:latest

