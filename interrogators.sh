#!/bin/bash -x
for API in 1.{17..32}; do

    export DOCKER_API_VERSION=$API

    docker info &
    docker version &
    
    for i in $(docker ps -aq); do
        docker inspect $i &
        docker logs $i 2>&1 > /dev/null &
    done
    wait
    
    for i in $(docker ps --no-trunc -aq); do
        docker inspect $i &
    done
    wait
    
    for i in $(docker service ls -q); do
        docker service inspect $i &
        docker service ps $i &
        docker service logs $i 2>&1 > /dev/null &
    done
    wait
    
    for i in $(docker network ls -q); do
        docker network inspect $i &
    done
    wait
    
    for i in $(docker volume ls -q); do
        docker volume inspect $i &
    done
    wait
    
    for i in $(docker node ls -q); do
        docker node inspect $i &
    done
    wait
    
    for i in $(docker secret ls -q); do
        docker secret inspect $i &
    done
    wait
    
    for i in $(docker config ls -q); do
        docker config inspect $i &
    done
    wait
    
done 

wait
