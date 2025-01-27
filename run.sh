docker compose up -d
until curl --silent --fail http://localhost; do
  echo "Waiting for Roundcube to be ready..."
  sleep 2  # Wait for 2 seconds before retrying
done
docker cp ./roundcube/config/config.php roundcube:/var/www/html/plugins/roundcube_oidc/config.inc.php:  
