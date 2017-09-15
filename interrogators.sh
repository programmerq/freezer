#!/bin/bash -x
for API in 1.24 1.30; do

    export DOCKER_API_VERSION=$API

    /usr/local/bin/docker info &
    /usr/local/bin/docker version &
    
    for i in $(/usr/local/bin/docker ps -aq); do
        gtimeout 1 /usr/local/bin/docker inspect $i
        gtimeout 1 /usr/local/bin/docker logs --tail 10 $i 2>&1 > /dev/null
    done
#    wait

    for i in $(/usr/local/bin/docker service ls -q); do
        gtimeout 1 /usr/local/bin/docker service inspect $i
        gtimeout 1 /usr/local/bin/docker service ps $i
        gtimeout 1 /usr/local/bin/docker service logs --tail 10 $i 2>&1 > /dev/null
    done
#    wait
    
    for i in $(/usr/local/bin/docker network ls -q); do
        gtimeout 1 /usr/local/bin/docker network inspect $i
    done
#    wait
    
    for i in $(/usr/local/bin/docker volume ls -q); do
        gtimeout 1 /usr/local/bin/docker volume inspect $i
    done
#    wait
    
    for i in $(/usr/local/bin/docker node ls -q); do
        gtimeout 1 /usr/local/bin/docker node inspect $i
    done
#    wait
    
    for i in $(/usr/local/bin/docker secret ls -q); do
        gtimeout 1 /usr/local/bin/docker secret inspect $i
    done
#    wait
    
    for i in $(/usr/local/bin/docker config ls -q); do
        gtimeout 1 /usr/local/bin/docker config inspect $i
    done
#    wait
    
done 

wait
