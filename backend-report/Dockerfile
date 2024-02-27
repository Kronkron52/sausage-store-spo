# FROM python:latest
# ADD ./ /app
# WORKDIR /app
# RUN apk update \
#     && apk add --no-cache wget openjdk-16-jre ca-certificates \
#     && wget "https://storage.yandexcloud.net/cloud-certs/CA.pem" -O YandexInternalRootCA.crt \
#     && cp YandexInternalRootCA.crt /usr/local/share/ca-certificates/ \
#     && update-ca-certificates \
#     && keytool -importcert -file YandexInternalRootCA.crt \
#     -alias yandex -cacerts -storepass changeit -noprompt \
#     && pip install -r requirements.txt
# ENTRYPOINT ["python"]
# CMD ["app.py"]
# EXPOSE 8084

FROM python:latest
ADD ./ /app
WORKDIR /app
RUN pip install -r requirements.txt
ENTRYPOINT ["python"]
CMD ["app.py"]
EXPOSE 8084
