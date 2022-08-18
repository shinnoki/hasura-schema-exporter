#!/bin/bash

wait_for_hasura() {
    echo "Waiting for hasura..."
    while ! curl -o /dev/null -fs "$HASURA_GRAPHQL_ENDPOINT/healthz"; do
        sleep 1
    done
    echo "Hasura started"
}

roles=`echo $HASURA_SCHEMA_EXPORTER_ROLES | tr -d ' ' | tr ',' ' '`
export_schema() {
    for role in $roles; do
        mkdir -p /hasura-schema/$role
        gq "$HASURA_GRAPHQL_ENDPOINT/v1/graphql" --introspect \
            -H "x-hasura-admin-secret: $HASURA_GRAPHQL_ADMIN_SECRET" \
            -H "x-hasura-role: $role" \
            > /hasura-schema/$role/schema.graphql &
    done
}

# https://cozy.computer/generic-debounce-in-bash
debounce_pid=""
debounce() {
    sleep 0.5
    debounce_pid=""
    export_schema
}

main() {
    wait_for_hasura
    export_schema
    inotifywait -m /hasura-metadata /hasura-migrations |
    while read line; do
        if test -n "$debounce_pid" && ps -p $debounce_pid > /dev/null; then
            kill $debounce_pid
        fi
        debounce &
        debounce_pid=$!
    done
}

main