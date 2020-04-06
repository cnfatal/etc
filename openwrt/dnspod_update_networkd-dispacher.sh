#!/bin/sh

INTERFACE=ppp0  #networkd-dispacher IFACE - interface that triggered the event

LOGIN_TOKEN=","
DOMAIN="fatalc.info"
SUB_DOMAIN="router"

DNSPOD_HOST=https://dnsapi.cn
RECORED_LIST_PATH=Record.List
RECORED_UPDATE_PATH=Record.Modify

getRecord(){
    curl -s -X POST -d "login_token=${LOGIN_TOKEN}&format=json&domain=${DOMAIN}" ${DNSPOD_HOST}/${RECORED_LIST_PATH} | jq '.records[]|select(.name=="'${SUB_DOMAIN}'" and .type=="A")'
}

updateRecord(){
    curl -s -X POST -d "login_token=${LOGIN_TOKEN}&format=json&domain=${DOMAIN}&sub_domain=${SUB_DOMAIN}&record_id=${1}&record_type=A&record_line_id=0&value=${2}" ${DNSPOD_HOST}/${RECORED_UPDATE_PATH}
}

record=$(getRecord)
externalIP=$ADDR  #networkd-dispacher ADDR - the ipv4 address of the device

if [ "${IFACE}" != "${INTERFACE}" ] ; then
  echo "skip event ${STATE} ${IFACE} ${ADDR}"
  exit
fi 

if [ "$(echo "$record"|jq -r '.value')" != "$externalIP" ] ; then
    echo "dns record value [$(echo "$record" | jq -r .value )] is out of date, updating to [$externalIP]"
    updateRecord "$(echo "$record"|jq -r .id)" "${externalIP}"
    else
    echo "dns record value [$(echo "$record" | jq -r .value )] is up to date, nothing todo"
fi

