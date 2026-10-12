docker compose up -d --build

# Restart Dovecot and Postfix whenever certbot renews the certificate
if [ -d /etc/letsencrypt/renewal-hooks/deploy ]; then
  install -m 755 certbot/reload-mail.sh /etc/letsencrypt/renewal-hooks/deploy/reload-mail.sh
fi

until curl --silent --fail -o /dev/null http://localhost; do
  echo "Waiting for Roundcube to be ready..."
  sleep 2  # Wait for 2 seconds before retrying
done
docker cp ./roundcube/config.php roundcube:/var/www/html/plugins/roundcube_oidc/config.inc.php 
docker compose restart