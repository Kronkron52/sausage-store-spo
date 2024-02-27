#!/bin/bash
set +e
docker pull gitlab.praktikum-services.ru:5050/std-021-009/sausage-store/sausage-backend-report:latest

set -e
docker-compose up -d backend-report
docker image prune -f