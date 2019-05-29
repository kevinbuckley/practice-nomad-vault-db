#!/bin/bash

nomad run db.nomad
vault secrets enable database
vault policy write nomad-server nomad-server-policy.hcl
vault write /auth/token/roles/nomad-cluster @nomad-cluster-role.json
vault write database/config/postgresql @connection.json # update the IP of the DB in there with the IP of your docker container
vault write database/roles/accessdb db_name=postgresql creation_statements=@accessdb.sql default_ttl=1h max_ttl=24h
vault policy write access-tables access-tables-policy.hcl
