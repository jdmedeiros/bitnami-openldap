#!/bin/bash

docker volume ls | grep -w "openldap-data" || docker volume create openldap-data
sleep 5
docker volume ls

read -rsn1 -p"Ready? - press any key to continue";echo

docker run --detach --restart always --name openldap \
  --publish 389:1389 --publish 636:1636 \
  --env LDAP_ROOT=dc=enta,dc=pt \
  --env LDAP_ADMIN_DN=cn=admin,dc=enta,dc=pt \
  --env BITNAMI_DEBUG=true \
  --env LDAP_ADMIN_USERNAME=admin \
  --env LDAP_ADMIN_PASSWORD=admin \
  --env LDAP_PORT_NUMBER=1389 \
  --env LDAP_LDAPS_PORT_NUMBER=1636 \
  --env LDAP_ENABLE_TLS=yes \
  --env LDAP_REQUIRE_TLS=no \
  --env LDAP_TLS_CERT_FILE=/opt/bitnami/openldap/certs/server.crt \
  --env LDAP_TLS_KEY_FILE=/opt/bitnami/openldap/certs/server.key \
  --env LDAP_TLS_CA_FILE=/opt/bitnami/openldap/certs/ca.crt \
  --env LDAP_TLS_DH_PARAMS_FILE=/opt/bitnami/openldap/certs/dh.pem \
  --env LDAP_SKIP_DEFAULT_TREE=yes \
  -v /home/ec2-user/openldap/certs:/opt/bitnami/openldap/certs \
  --env LDAP_CUSTOM_LDIF_DIR=/opt/bitnami/openldap/ldifs \
  -v /home/ec2-user/openldap/ldifs:/opt/bitnami/openldap/ldifs \
  --volume openldap-data:/bitnami/openldap \
  bitnami/openldap:latest

sleep 5

docker ps -a
