#!/bin/sh
·
####----------- configuration --------
LOGIN_TOKEN=<id,secret>
DOMAIN=<TOP_LEVEL_DOMAIN>
SUB_DOMAIN=<SUB_DOMAIN>
####----------- configuration --------

DNSPOD_HOST=https://dnsapi.cn
DOMAIN_LIST_PATH=Domain.List
RECORED_LIST_PATH=Record.List
RECORED_UPDATE_PATH=Record.Modify

getExternalIP(){
    curl -s https://api.myip.com | jq  -r '.ip'
}

getRecord(){
    curl -s -X POST -d "login_token=${LOGIN_TOKEN}&format=json&domain=${DOMAIN}" ${DNSPOD_HOST}/${RECORED_LIST_PATH} | jq '.records[]|select(.name=="'${SUB_DOMAIN}'" and .type=="A")'
}

updateRecord(){
    curl -s -X POST -d "login_token=${LOGIN_TOKEN}&format=json&domain=${DOMAIN}&record_id=${1}&record_type=A&record_line_id=0&value=${2}" ${DNSPOD_HOST}/${RECORED_UPDATE_PATH}
}

record=$(getRecord)
externalIP=$(getExternalIP)

if [ $(echo $record|jq -r '.value') != $externalIP ] ; then
    echo "dns record value [$(echo $record | jq -r .value )] is out of date, updating to [$externalIP]"
    updateRecord $(echo $record|jq -r .id) ${externalIP}
    else
    echo "dns record value [$(echo $record | jq -r .value )] is up to date, nothing todo"
fi