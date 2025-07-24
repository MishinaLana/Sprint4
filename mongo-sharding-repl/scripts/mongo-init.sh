#!/bin/bash

###
# Настройка шардирования
###

docker compose exec -T configSrv mongosh --port 27017 <<EOF
rs.initiate(
  {
    _id : "config_server",
       configsvr: true,
    members: [
      { _id : 0, host : "configSrv:27017" }
    ]
  }
);
EOF

docker compose exec -T shard1-1 mongosh --port 27018 <<EOF
rs.initiate(
    {
      _id : "shard1-1",
      members: [
        { _id : 0, host : "shard1-1:27018" },
        { _id : 1, host : "repl1-1:27023" },
      ]
    }
);
EOF

docker compose exec -T shard1-2 mongosh --port 27019 <<EOF
rs.initiate(
    {
      _id : "shard1-2",
      members: [
        { _id : 0, host : "shard1-2:27019" },
        { _id : 1, host : "repl1-2:27024" },
      ]
    }
);
EOF

sleep 3s;
docker compose exec -T mongos_router mongosh --port 27020 <<EOF
sh.addShard( "shard1-1/shard1-1:27018,repl1-1:27023");
sh.addShard( "shard1-2/shard1-2:27019,repl1-2:27024");

sh.enableSharding("somedb");
sh.shardCollection("somedb.helloDoc", { "name" : "hashed" } );

use somedb;
for(var i = 0; i < 1000; i++) db.helloDoc.insertOne({age:i, name:"ly"+i});
EOF

