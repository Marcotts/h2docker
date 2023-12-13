#!/bin/sh

cd /opt
env | grep H2

if [ ! -d ${H2DATA}/data ]; then
	sudo root mkdir -p ${H2DATA}/data
	sudo root chown -R h2:h2 ${H2DATA}/data
fi

ls -la
pwd
env

${H2DIR}/bin/h2.sh \
	-properties "${H2CONF}" \
	-baseDir "${H2DATA}/data" \
 	-webAllowOthers \
 	-webPort 8084 \
 	-tcpAllowOthers \
 	-tcpPort 9024

#end


