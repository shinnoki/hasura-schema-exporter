# hasura-schema-exporter

Export the schema of [Hasura GraphQL Engine](https://hasura.io/) to static `schema.graphql` file in sync.

## Motivation

There's some benefits to export the Hasura's schema and add to git commit:

- Can notice the schema changes when update graphql-engine version
- Run [GraphQL Code Generator](https://www.graphql-code-generator.com/) without starting up graphql-engine server (particularly in CI environment)
- Fast, Role & Permission sentitive autocompletion and validation with [vscode-graphql](https://marketplace.visualstudio.com/items?itemName=GraphQL.vscode-graphql) and [graphql-config](https://www.graphql-config.com/)

We can export the Hasura's schema in several ways according to [Exporting the Hasura GraphQL Schema](https://hasura.io/docs/latest/guides/export-graphql-schema/) guide, but we have to export the schema manually every time the schema change.

This tool watch the Hasura's metadata and migrations, and automatically export the schema when changed.


## How to use

After following the [Quickstart with Docker](https://hasura.io/docs/latest/getting-started/docker-simple/) guide, add  `hasura-schema-exporter` to services like below.

```yaml:docker-compose.yml
version: '3.6'
services:
  postgres: ...
  graphql-engine: ...
  schema-exporter:
    image: ghcr.io/wasd-inc/hasura-schema-exporter
    depends_on:
     - "graphql-engine"
    volumes:
      # metadata and migrations, schema is exported when these files are change
      - ./hasura/metadata:/hasura-metadata
      - ./hasura/migrations:/hasura-migrations
      # schema export direction
      - ./hasura/schema:/hasura-schema
    environment:
      # graphql-engine's endpoint depending on service name and port
      HASURA_GRAPHQL_ENDPOINT : http://graphql-engine:8080
      # same as graphql-engine's admin-secret
      HASURA_GRAPHQL_ADMIN_SECRET: myadminsecretkey
      # comma-separated roles to export schema (default: admin)
      HASURA_SCHEMA_EXPORTER_ROLES: admin, user, anonymous
volumes:
  db_data:
```
