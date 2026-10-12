#!/bin/sh
# certbot deploy hook: restart mail services so they load the renewed certificate
docker restart dovecot postfix
