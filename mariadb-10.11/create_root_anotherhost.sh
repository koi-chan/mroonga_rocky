#!/bin/bash

mysql -uroot << EOSQL
CREATE USER 'root'@'%';
GRANT all privileges ON *.* TO 'root'@'%';
EOSQL

rm -f /docker-entrypoint-init.db/create_root_anotherhost.sh
