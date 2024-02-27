#!/bin/bash
set +e
docker pull gitlab.praktikum-services.ru:5050/std-021-009/sausage-store/sausage-frontend:latest

set -e
docker-compose up -d frontend
docker image prune -f