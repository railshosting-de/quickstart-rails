#!/bin/sh
set -e

# usage: rails new app_name [options]
command=$1
app_name=$2
opts=""
shift 2

echo "Command: $command"
echo "App name: $app_name"

select_dbms() {
  case "$1" in
    mysql) echo "mariadb-dev"
      ;;
    postgresql) echo "postgresql-dev"
      ;;
    sqlite) echo "sqlite-dev"
  esac
}

while [ $# -gt 0 ]; do
  case "$1" in
    -d | --database) 
      dbms_dev_package=$(select_dbms $2)
      ;;
  esac
  opts="$1 $2 $opts"
  shift 2
done

if [ ! -z "$dbms_dev_package" ]; then
  echo "selected dbms dev package: $dbms_dev_package"
else
  dbms_dev_package="sqlite-dev"
fi

echo "running /usr/local/bundle/bin/rails" "$command" "$app_name" "$opts"
/usr/local/bundle/bin/rails $command $app_name $opts
mv /home/rails/$app_name /home/rails/app
cp /meta/docker-compose.yml /home/rails/docker-compose.yml
cp /meta/Dockerfile /home/rails/Dockerfile
cp /meta/Dockerfile.prod /home/rails/app/Dockerfile
cp /meta/entrypoint.sh /home/rails/entrypoint.sh
cp /meta/entrypoint.sh.prod /home/rails/app/entrypoint.sh
cp /meta/database_exists.rb /home/rails/app/lib/database_exists.rb
if [ "$dbms_dev_package" = "mariadb-dev" ]; then
  sed -i "s/localhost/<%= ENV['MYSQL_HOST] %>/" /home/rails/app/config/database.yml
  sed -i "s/${app_name//-/_}_development/usr_web1_${app_name//-/_}_development/" /home/rails/app/config/database.yml
  sed -i '$ d' /home/rails/app/config/database.yml
  sed -i '$ d' /home/rails/app/config/database.yml
  sed -i '$ d' /home/rails/app/config/database.yml
  echo "  database: usr_web1_rails_demo_production" >> /home/rails/app/config/database.yml
  echo "  username: web1" >> /home/rails/app/config/database.yml
  echo "  password: <%= ENV['RAILS_DATABASE_PASSWORD'] %>" >> /home/rails/app/config/database.yml
fi
sed -i "s/#mysql-container-name#/$app_name-mysql/" /home/rails/docker-compose.yml
sed -i "s/#rails-container-name#/$app_name/" /home/rails/docker-compose.yml
sed -i "s/#network-name#/$app_name-net/" /home/rails/docker-compose.yml
sed -i "s/#dbms_dev_package#/$dbms_dev_package/" /home/rails/Dockerfile
sed -i "s/#dbms_dev_package#/$dbms_dev_package/" /home/rails/app/Dockerfile