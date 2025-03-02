## Steps to install kibana image 
>
```sh
docker create network elastic-net
docker pull pritamchk98/elastic:v1
docker run -d --net elastic-net --port 9200:9200 --name esC1 pritamchk98/elastic:v1
docker pull pritamchk98/kibana:v1
docker run -d --net elastic-net --port 9201:5601 --name esC1 pritamchk98/kibana:v1
```