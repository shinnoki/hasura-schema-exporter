FROM node:16-alpine

RUN apk update && apk add --no-cache \
 inotify-tools \
 procps \
 curl

RUN npm install --location=global graphqurl

RUN mkdir -p /hasura-metadata \
    && mkdir -p /hasura-migrations \
    && mkdir -p /hasura-schema

WORKDIR /app

COPY ./hasura-schema-exporter.sh .

ENV HASURA_SCHEMA_EXPORTER_ROLES="admin"

CMD ["sh", "./hasura-schema-exporter.sh"]