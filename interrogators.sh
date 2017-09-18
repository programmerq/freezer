#!/bin/bash -x

export TIMEOUT=$(which timeout || which gtimeout)
export DOCKER=$(which docker)
export TIMEOUT=/usr/local/bin/gtimeout
export DOCKER=/usr/local/bin/docker


for API in 1.24 1.30; do

    export DOCKER_API_VERSION=$API

    $DOCKER info &
    $DOCKER version &
    
    for i in $($DOCKER ps -aq); do
        $TIMEOUT 1 $DOCKER inspect $i
        $TIMEOUT 1 $DOCKER logs --tail 10 $i 2>&1 > /dev/null
        $TIMEOUT 1 $DOCKER top $i
    done
#    wait

    for i in $($DOCKER service ls -q); do
        $TIMEOUT 1 $DOCKER service inspect $i
        $TIMEOUT 1 $DOCKER service ps $i
        $TIMEOUT 1 $DOCKER service logs --tail 10 $i 2>&1 > /dev/null
    done
#    wait
    
    for i in $($DOCKER network ls -q); do
        $TIMEOUT 1 $DOCKER network inspect $i
    done
#    wait
    
    for i in $($DOCKER volume ls -q); do
        $TIMEOUT 1 $DOCKER volume inspect $i
    done
#    wait
    
    for i in $($DOCKER node ls -q); do
        $TIMEOUT 1 $DOCKER node inspect $i
    done
#    wait
    
    for i in $($DOCKER secret ls -q); do
        $TIMEOUT 1 $DOCKER secret inspect $i
    done
#    wait
    
    for i in $($DOCKER config ls -q); do
        $TIMEOUT 1 $DOCKER config inspect $i
    done
#    wait
    
done 

wait
