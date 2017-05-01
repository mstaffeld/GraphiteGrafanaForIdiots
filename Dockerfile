from ubuntu:14.04

# Add an ssl debian
run apt-get update && apt-get -y install apt-transport-https
run echo 'deb https://packagecloud.io/grafana/stable/debian/ jessie main' >> /etc/apt/sources.list

# Add debian souces
run echo 'deb http://us.archive.ubuntu.com/ubuntu/ trusty universe' >> /etc/apt/sources.list

run	apt-get -y update

# Install required packages
run	apt-get -y install python-ldap python-cairo python-django python-twisted python-django-tagging python-simplejson python-memcache python-pysqlite2 python-support python-tz python-pip gunicorn supervisor nginx-light curl git
run	pip install whisper==0.9.15
run	pip install --install-option="--prefix=/var/lib/graphite" --install-option="--install-lib=/var/lib/graphite/lib" carbon==0.9.15
run	pip install --install-option="--prefix=/var/lib/graphite" --install-option="--install-lib=/var/lib/graphite/webapp" graphite-web==0.9.15

# Install Grafana
run curl https://packagecloud.io/gpg.key | sudo apt-key add -
run apt-get -y --force-yes install grafana

# Install & Patch StatsD
RUN     mkdir /src                                                                                                                      &&\
        git clone https://github.com/etsy/statsd.git /src/statsd                                                                        &&\
        cd /src/statsd                                                                                                                  &&\ 
        git checkout v0.7.2                                                                                                             &&\
        sed -i -e "s|.replace(/\[^a-zA-Z_\\\\-0-9\\\\.]/g, '');|.replace(/[^a-zA-Z_\\\\-0-9\\\\.\\\\%]/g, '');|" /src/statsd/stats.js

# Add system service config
# git clone https://github.com/nickstenning/docker-graphite
add	./docker-graphite/nginx.conf /etc/nginx/nginx.conf
add	./docker-graphite/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Add config files 
add	./docker-graphite/initial_data.json /var/lib/graphite/webapp/graphite/initial_data.json
add	./docker-graphite/local_settings.py /var/lib/graphite/webapp/graphite/local_settings.py
add	./docker-graphite/carbon.conf /var/lib/graphite/conf/carbon.conf
add	./docker-graphite/storage-schemas.conf /var/lib/graphite/conf/storage-schemas.conf

# configure the things
run	mkdir -p /var/lib/graphite/storage/whisper
run	touch /var/lib/graphite/storage/graphite.db /var/lib/graphite/storage/index
run	chown -R www-data /var/lib/graphite/storage
run	chmod 0775 /var/lib/graphite/storage /var/lib/graphite/storage/whisper
run	chmod 0664 /var/lib/graphite/storage/graphite.db
run	cd /var/lib/graphite/webapp/graphite && python manage.py syncdb --noinput

# Nginx
expose	80
# Carbon line receiver port
expose	2003
# Carbon UDP receiver port
expose	2003/udp
# Carbon pickle receiver port
expose	2004
# Grafana web app
expose 3000
# Carbon cache query port
expose	7002
# StatsD UDP port
expose 8125/udp
# StatsD Management port
expose  8126

cmd	["/usr/bin/supervisord"]

# Start grafana
#run service grafana-server start
#run update-rc.d grafana-server defaults
