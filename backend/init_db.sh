#! /bin/bash
set -x

if [[ ! -f manage.py ]]; then
    echo "No manage.py, wrong location"
    exit 1
fi

sleep 2
docker rm -f oj-postgres-dev oj-redis-dev pgbouncer-dev
docker run -it -d -e DB_USER=onlinejudge -e DB_PASSWORD=onlinejudge -e DB_HOST=oj-postgres-dev -e DB_NAME=onlinejudge \
-e ADMIN_USERS=onlinejudge -e DB_PORT=5432 -e LISTEN_PORT=6543 -e POOL_MODE=transaction \
-e SERVER_CHECK_DELAY=3000 -e MAX_CLIENT_CONN=3000 -e MIN_POOL_SIZE=100 -e DEFAULT_POOL_SIZE=100 --name pgbouncer-dev edoburu/pgbouncer
docker run -it -d -e POSTGRES_DB=onlinejudge -e POSTGRES_USER=onlinejudge -e POSTGRES_PASSWORD=onlinejudge -p 127.0.0.1:5435:5432 --name oj-postgres-dev postgres:10
docker run -it -d -p 127.0.0.1:6380:6379 --name oj-redis-dev redis:4.0-alpine

if [ "$1" = "--migrate" ]; then
    sleep 3
    echo `cat /dev/urandom | head -1 | md5sum | head -c 32` > data/config/secret.key
    python manage.py migrate
    python manage.py inituser --username root --password rootroot --action create_super_admin
fi