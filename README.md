# zookeeper-jmx-exporter
[![Docker](https://github.com/yogeshraj-au/zookeeper-jmx-exporter/actions/workflows/docker-image.yml/badge.svg)](https://github.com/yogeshraj-au/zookeeper-jmx-exporter/actions/workflows/docker-image.yml)

This repo contains Dockerfile for Zookeeper along with jmx-exporter. The jmx-exporter will expose the metrics at port 2200.

Build and Run the docker image:

```
docker build -t zookeeper .
docker run -d --name zookeeper -p 2181:2181 -p 2200:2200 zookeeper
``` 


