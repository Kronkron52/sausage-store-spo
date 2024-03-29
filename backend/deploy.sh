#! /bin/bash
#Если свалится одна из команд, рухнет и весь скрипт
set -xe
#Перезаливаем дескриптор сервиса на ВМ для деплоя
sudo cp -rf sausage-store-backend.service /etc/systemd/system/sausage-store-backend.service
sudo chown root:root /etc/systemd/system/sausage-store-backend.service
sudo rm -f /opt/sausage-store/backend/target/sausage-store.jar||true
#Переносим артефакт в нужную папку
curl -u ${NEXUS_REPO_USER}:${NEXUS_REPO_PASS} -o sausage-store.jar ${NEXUS_REPO_URL}/${NEXUS_REPO_BACKEND_NAME}/com/yandex/practicum/devops/sausage-store/${VERSION}/sausage-store-${VERSION}.jar
sudo cp ./sausage-store.jar /opt/sausage-store/backend/target/sausage-store.jar||true #"<...>||true" говорит, если команда обвалится — продолжай
sudo cp ~/backend.env /opt/sausage-store/backend/
sudo chown -R backend:backend /opt/sausage-store/backend/
#Обновляем конфиг systemd с помощью рестарта
sudo systemctl daemon-reload
#Перезапускаем сервис сосисочной
sudo systemctl enable sausage-store-backend 
sudo systemctl restart sausage-store-backend 
