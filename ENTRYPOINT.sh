#!/bin/sh

BASEDIR="/usr/lib/${NAME}"
DATADIR="/config/data"

# create our folders
mkdir -p \
        /config/{data,logs}

# Relink the DATADIR 
[[ -L ${BASEDIR}/data && ! ${BASEDIR}/data -ef /config/data ]] && unlink ${BASEDIR}/data
[[ -L ${BASEDIR}/logs && ! ${BASEDIR}/logs -ef /config/logs ]] && unlink ${BASEDIR}/logs
[[ ! -L ${BASEDIR}/data ]] && ln -s /config/data ${BASEDIR}/data
[[ ! -L ${BASEDIR}/logs ]] && ln -s /config/logs ${BASEDIR}/logs

# Start the wizard if no existing config is present
[[ ! -f /config/data/system.properties ]] && cp -f ${BASEDIR}/etc/system.properties /config/data/
[[ ! -f /config/data/ufv-truststore ]] && cp -f ${BASEDIR}/etc/ufv-truststore /config/data/

# Set permissions if necessary
find /config ! -user unifi-video -exec chown -R unifi-video {} \;

# Start application
sudo -u unifi-video java -cp /usr/share/java/commons-daemon.jar:/usr/lib/unifi-video/lib/airvision.jar -Djava.security.egd=file:/dev/./urandom -Djava.library.path=/usr/lib/unifi-video/lib -Djava.awt.headless=true -Djavax.net.ssl.trustStore=/usr/lib/unifi-video/data/ufv-truststore -Dfile.encoding=UTF-8 com.ubnt.airvision.Main start
