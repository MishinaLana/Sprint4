#!/bin/bash

GREEN='\033[0;32m'
NC='\033[0m'

###
# Тест роутов
###

echo -e "${GREEN}Test mongos_router-1${NC}"
docker compose exec -T mongos_router mongosh --port 27020 --quiet <<EOF
use somedb;
db.helloDoc.countDocuments();
EOF

echo -e "\n${GREEN}Test mongos_router-2${NC}"
docker compose exec -T mongos_router_2 mongosh --port 27021 --quiet <<EOF
use somedb;
db.helloDoc.countDocuments();
exit();
EOF

echo -e "\n${GREEN}Test shard1-1${NC}"
docker compose exec -T shard1-1 mongosh --port 27018 --quiet <<EOF
use somedb;
db.helloDoc.countDocuments();
exit();
EOF

echo -e "\n${GREEN}Test shard1-2${NC}"
docker compose exec -T shard1-2 mongosh --port 27019 --quiet <<EOF
use somedb;
db.helloDoc.countDocuments();
exit();
EOF

echo -e "\n${GREEN}Test repl1-1${NC}"
docker compose exec -T repl1-1 mongosh --port 27023 --quiet <<EOF
use somedb;
db.helloDoc.countDocuments();
exit();
EOF

echo -e "\n${GREEN}Test repl1-2${NC}"
docker compose exec -T repl1-2 mongosh --port 27024 --quiet <<EOF
use somedb;
db.helloDoc.countDocuments();
exit();
EOF