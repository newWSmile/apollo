#!/bin/sh

# apollo config db info
apollo_config_db_url=jdbc:mysql://192.168.1.57:3306/ApolloConfigDB?characterEncoding=utf8
apollo_config_db_username=dev-all
apollo_config_db_password=all201705

# apollo portal db info
apollo_portal_db_url=jdbc:mysql://192.168.1.57:3306/ApolloPortalDB?characterEncoding=utf8
apollo_portal_db_username=dev-all
apollo_portal_db_password=all201705

# meta server url, different environments should have different meta server addresses
dev_meta=http://192.168.1.53:8080
test_meta=http://192.168.1.55:8080

META_SERVERS_OPTS="-Ddev_meta=$dev_meta -Dfat_meta=$fat_meta -Duat_meta=$uat_meta -Dpro_meta=$pro_meta"

# =============== Please do not modify the following content =============== #
# go to script directory
cd "${0%/*}"

cd ..

# package config-service and admin-service
echo "==== starting to build config-service and admin-service ===="

mvn clean package -DskipTests -pl apollo-configservice,apollo-adminservice -am -Dapollo_profile=github -Dspring_datasource_url=$apollo_config_db_url -Dspring_datasource_username=$apollo_config_db_username -Dspring_datasource_password=$apollo_config_db_password

echo "==== building config-service and admin-service finished ===="

echo "==== starting to build portal ===="

mvn clean package -DskipTests -pl apollo-portal -am -Dapollo_profile=github,auth -Dspring_datasource_url=$apollo_portal_db_url -Dspring_datasource_username=$apollo_portal_db_username -Dspring_datasource_password=$apollo_portal_db_password $META_SERVERS_OPTS

echo "==== building portal finished ===="
