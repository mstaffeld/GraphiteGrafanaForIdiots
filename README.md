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

```
.\Run.ps1
```

# todo: 
install and configure stats d 
start grafana-server on container run
vpc 