docker compose up -d
until curl --silent --fail -o /dev/null http://localhost; do
  echo "Waiting for Roundcube to be ready..."
  sleep 2  # Wait for 2 seconds before retrying
done
docker cp ./roundcube/config.php roundcube:/var/www/html/plugins/roundcube_oidc/config.inc.php:  
