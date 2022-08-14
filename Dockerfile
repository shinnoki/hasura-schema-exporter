FROM node:16-alpine

RUN apk update && apk add --no-cache \
 inotify-tools \
 procps \
 curl

RUN npm install --location=global graphqurl

RUN mkdir -p {/hasura-metadata, /hasura-migrations, /hasura-schema}

WORKDIR /app

COPY ./hasura-sync-schema.sh .

ENV HASURA_SYNC_SCHEMA_ROLES="admin"

CMD ["sh", "./hasura-sync-schema.sh"]