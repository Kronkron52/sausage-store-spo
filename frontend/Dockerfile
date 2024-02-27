# build stage
FROM node:16-alpine3.16 as build 
WORKDIR /usr/src/app
COPY . .
RUN npm install
RUN npm run build


# release stage
FROM nginx:latest
WORKDIR /app
COPY --from=build /usr/src/app/dist/frontend /usr/share/nginx/html
COPY nginx.tmpl /app/
EXPOSE 80