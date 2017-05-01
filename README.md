# Graphite and Grafana for Idiots

##### I created this repository to help myself as a referecne. 

## Build 

```
.\Build.ps1
```

## Configure
The configuration gets submoduled into this image. 

## Host
Share mapping, you will need to map some volumes from the docker host to within the container using the -v flag on run.

### Linux VM Setup
- install docker 
- azure fw ports 80, 3000, etc. 

```
.\Run.ps1
```

# todo: 
install and configure stats d 
start grafana-server on container run
Configure grafana to use graphite by configuration
vpc 
script azure interaction
add serverspec and pester


# deploying
ssh jismetrics@jismetrics.cloudapp.net
<<Enter Password>>
git clone https://github.com/mstaffeld/GraphiteGrafanaForIdiots.git

##### Build the docker.
cd GraphiteGrafanaForIdiots/
git clone https://github.com/nickstenning/docker-graphite.git
./build.sh

##### Run graphite and grafana
mkdir -p /home/jismetrics/data/grafana 
mkdir -p /home/jismetrics/data/graphite/storage/whisper
chown www-data /home/jismetrics/data/grafana -R
chown www-data /home/jismetrics/data/graphite/storage/whisper -R
./run.sh

##### Startup grafana server 
docker ps 
docker exec -it <<CONTAINER ID>> bash
service grafana-server start

##### Login to grafana http://<<HOST>>:3000
setup graphite as data source 
http://localhost 

#### Start making charts!