#!/bin/bash

# 等待MySQL服务启动
until mysqladmin ping -u root -p"$MYSQL_ROOT_PASSWORD" > /dev/null 2>&1; do
  echo "Waiting for MySQL to start..."
  sleep 1
done

# 检查数据库是否已存在并初始化
if ! mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "USE doc_nacos_config;" 2>/dev/null; then
  echo "Initializing doc_nacos_config database..."
  mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "CREATE DATABASE IF NOT EXISTS doc_nacos_config DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
  mysql -u root -p"$MYSQL_ROOT_PASSWORD" doc_nacos_config < /sql-init/doc_nacos_config.sql
fi

if ! mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "USE doc;" 2>/dev/null; then
  echo "Initializing doc database..."
  mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "CREATE DATABASE IF NOT EXISTS doc DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
  mysql -u root -p"$MYSQL_ROOT_PASSWORD" doc < /sql-init/doc.sql
fi
