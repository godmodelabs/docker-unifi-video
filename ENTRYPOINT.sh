#!/bin/sh

BASEDIR="/usr/lib/unifi-video"
DATADIR="/config"

# create our folders
mkdir -p ${DATADIR}/data ${DATADIR}/logs

# Relink the DATADIR 
[[ -L ${BASEDIR}/data && ! ${BASEDIR}/data -ef /config/data ]] && unlink ${BASEDIR}/data
[[ -L ${BASEDIR}/logs && ! ${BASEDIR}/logs -ef /config/logs ]] && unlink ${BASEDIR}/logs
[[ ! -L ${BASEDIR}/data ]] && ln -s ${DATADIR}/data ${BASEDIR}/data
[[ ! -L ${BASEDIR}/logs ]] && ln -s ${DATADIR}/logs ${BASEDIR}/logs

# Start the wizard if no existing config is present
[[ ! -f ${DATADIR}/data/system.properties ]] && cp -f ${BASEDIR}/etc/system.properties ${DATADIR}/data/
[[ ! -f ${DATADIR}/data/ufv-truststore ]] && cp -f ${BASEDIR}/etc/ufv-truststore ${DATADIR}/data/

# Set permissions if necessary
find /config ! -user unifi-video -exec chown -R unifi-video {} \;

# Start application
sudo -u unifi-video java -cp /usr/share/java/commons-daemon.jar:${BASEDIR}/lib/airvision.jar -Djava.security.egd=file:/dev/./urandom -Djava.library.path=${BASEDIR}/lib -Djava.awt.headless=true -Djavax.net.ssl.trustStore=${BASEDIR}/data/ufv-truststore -Dfile.encoding=UTF-8 com.ubnt.airvision.Main start
