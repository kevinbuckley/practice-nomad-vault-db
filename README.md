## nomad job getting credentials from vault

currently the hackiest, hack that ever hacked.  integrating nomad & vault   https://www.nomadproject.io/guides/integrations/vault-integration/index.html

```bash
# https://learn.hashicorp.com/consul/security-networking/forwarding#macos-setup
# https://www.wlangiewicz.com/2019/03/20/guide-how-to-use-consul-dns-locally-on-macos/
# run pg admin
docker pull dpage/pgadmin4
docker run -p 80:80 \
    -e "PGADMIN_DEFAULT_EMAIL=user@domain.com" \
    -e "PGADMIN_DEFAULT_PASSWORD=SuperSecret" \
    -d dpage/pgadmin4
```

```bash
# run consul server
consul agent -dev

# run vault server
vault server -dev

# setup vault policies and roles
vault policy write nomad-server nomad-server-policy.hcl
vault write /auth/token/roles/nomad-cluster @nomad-cluster-role.json

# create a token for nomad to use and start nomad agent
sudo rm -rf /mount
sudo VAULT_TOKEN=$(vault token create -policy nomad-server -period 72h -orphan | grep -w "token" |  sed 's/.* //') nomad agent -config nomad-server.hcl -config nomad-client.hcl

```

```bash
# run the db
nomad run db.nomad

vault secrets enable database
vault write /auth/token/roles/nomad-cluster @nomad-cluster-role.json
```


```bash

# setup postgres provider connection and setup
vault write database/config/postgresql @connection.json 
vault write database/roles/accessdb db_name=postgresql creation_statements=@accessdb.sql default_ttl=1h max_ttl=24h

# generate credentials
vault read database/creds/accessdb
```
```bash
# create policy for your new job
 vault policy write access-tables access-tables-policy.hcl

```


```bash
# example of how to run the nomad job
nomad job run app.nomad
```