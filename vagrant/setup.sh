#!/bin/sh

set -e

{
    cd marchine00;vagrant up;vagrant snapshot save init;
} &
{ 
    cd marchine01;vagrant up;vagrant snapshot save init;
} &
{ 
    cd marchine02;vagrant up;vagrant snapshot save init;
} &

wait