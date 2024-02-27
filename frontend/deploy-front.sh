#! /bin/bash
#Если свалится одна из команд, рухнет и весь скрипт
set -xe
#Перезаливаем дескриптор сервиса на ВМ для деплоя
sudo cp -rf sausage-store-frontend.service /etc/systemd/system/sausage-store-frontend.service
sudo chown root:root /etc/systemd/system/sausage-store-frontend.service
sudo rm -f /opt/sausage-store/frontend/dist/frontend/*||true
#Переносим артефакт в нужную папку
curl -u ${NEXUS_REPO_USER}:${NEXUS_REPO_PASS} -o sausage-store-frontend.tar.gz ${NEXUS_REPO_URL}/${NEXUS_REPO_FRONTEND_NAME}/${VERSION}/sausage-store-${VERSION}.tar.gz
sudo cp ./sausage-store-frontend.tar.gz /opt/sausage-store/frontend/dist||true #"<...>||true" говорит, если команда обвалится — продолжай
sudo tar -xvf /opt/sausage-store/frontend/dist/sausage-store-frontend.tar.gz -C /opt/sausage-store/frontend/dist/
sudo rm -f /opt/sausage-store/frontend/dist/sausage-store-frontend.tar.gz
sudo chown -R frontend:frontend /opt/sausage-store/frontend/
#Обновляем конфиг systemd с помощью рестарта
sudo systemctl daemon-reload
#Перезапускаем сервис сосисочной
sudo systemctl enable sausage-store-frontend 
sudo systemctl restart sausage-store-frontend 
