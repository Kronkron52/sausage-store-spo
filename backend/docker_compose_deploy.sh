# #!/bin/bash
# echo "Deploy change vesrion"
# # Default
# Old_Service="blue"
# New_Service="green"

# if [ "$(docker ps --filter health=healthy | grep ${Old_Service} )" != "" ]
# then
#  Old_Service="blue"
#  New_Service="green"
# else
#  Old_Service='green'
#  New_Service='blue'
# fi

# echo "${Old_Service}-service work"
# docker-compose stop backend-${New_Service}
# docker-compose rm -f backend-${New_Service}
# docker-compose pull backend-${New_Service}
# docker-compose up -d backend-${New_Service}

# i=200
# while [ $i -ge 0 ]
# do
#   if [ "$(docker ps --filter health=healthy | grep ${New_Service})" != "" ]; then
#     break
#   fi
#   ((i--))
#   echo waiting: $i sec
#   sleep 1
# done

# if [ "$(docker ps --filter health=healthy | grep ${New_Service})" != "" ]
# then
#   echo "${New_Service}-service is runing now"
#   docker-compose stop backend-${Old_Service}
# else
#   docker-compose stop backend-${New_Service}
#   echo "Error start ${New_Service}-service"
#   exit 1
# fi

# set -e

#!/bin/bash
set +e
docker-compose pull
# добавляем логику

if [[ $(docker container inspect -f '{{.State.Running}}' sausage-backend-blue) = true ]]
then
    echo "BLUE is Running"
    docker-compose up -d backend-green
    timeout=$((SECONDS+180))  
    greenStatus=$(docker container inspect -f '{{.State.Health.Status}}' sausage-backend-green)
    until [ "$greenStatus" = "healthy" ]  [ $SECONDS -gt $timeout ]
      do
      sleep 10
      greenStatus=$(docker container inspect -f '{{.State.Health.Status}}' sausage-backend-green)
      echo $greenStatus
    done
    if [ "$greenStatus" != "healthy" ]; then
      echo "Таймаут! Контейнер не достиг состояния 'healthy' в течение 3 минут."
      exit 1 
    fi
    echo "GREEN IS OK"
    docker stop sausage-backend-blue
elif [[ $(docker container inspect -f '{{.State.Running}}' sausage-backend-green) = true ]]
then
    echo "GREEN is Running"
    docker stop sausage-backend-blue  true
    docker-compose up -d backend-blue
    timeout=$((SECONDS+180))
    blueStatus=$(docker container inspect -f '{{.State.Health.Status}}' sausage-backend-blue)
    until [ "$blueStatus" = "healthy" ] || [ $SECONDS -gt $timeout ]
    do
     sleep 10
     blueStatus=$(docker container inspect -f '{{.State.Health.Status}}' sausage-backend-blue)
     echo $blueStatus
    done
    if [ "$blueStatus" != "healthy" ]; then
      echo "Таймаут! Контейнер не достиг состояния 'healthy' в течение 3 минут."
      exit 1
    fi
    echo "BLUE IS OK"
    docker stop sausage-backend-green
else
    echo "All backend containers is inacive. Start blue"
    docker-compose up -d backend-blue
    blueStatus=$(docker container inspect -f '{{.State.Health.Status}}' sausage-backend-blue)
    until [ "$blueStatus" = "healthy" ]
    do
      blueStatus=$(docker container inspect -f '{{.State.Health.Status}}' sausage-backend-blue)
      echo $blueStatus
      sleep 10
    done
    echo "BLUE IS OK"
fi