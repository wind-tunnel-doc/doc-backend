#!/bin/bash

# 等待MySQL服务启动
until mysqladmin ping -u root -p$MYSQL_ROOT_PASSWORD > /dev/null 2>&1; do
  echo "Waiting for MySQL to start..."
  sleep 1
done

# 初始化数据库
mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "use doc" > /dev/null 2>&1 || {

  mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "CREATE DATABASE IF NOT EXISTS doc_nacos_config DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
  mysql -u root -p"$MYSQL_ROOT_PASSWORD" doc_nacos_config < /sql-init/doc_nacos_config.sql
  
  mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "CREATE DATABASE IF NOT EXISTS doc DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
  mysql -u root -p"$MYSQL_ROOT_PASSWORD" doc < /sql-init/doc.sql

}