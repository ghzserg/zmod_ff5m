#!/bin/bash

cd "$1"

docker-compose restart || docker-compose up -d
docker-compose pull