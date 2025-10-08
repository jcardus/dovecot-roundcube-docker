#!/bin/sh
# Adds a new user to Dovecot passwd file
# Usage: ./add-mail-user.sh username [password]

PASSWD_FILE="../vmail/passwd"

# make sure file exists
touch "$PASSWD_FILE"

USER="$1"
PASS="$2"

if [ -z "$USER" ]; then
  echo "Usage: $0 username [password]"
  exit 1
fi

# generate a random password if not provided
if [ -z "$PASS" ]; then
  PASS=$(openssl rand -base64 10)
  echo "Generated password: $PASS"
fi

# generate the hash using dovecot (inside container if needed)
HASH=$(docker exec -i dovecot doveadm pw -s SHA512-CRYPT -p "$PASS" 2>/dev/null)

# verify hash generation
if [ -z "$HASH" ]; then
  echo "Error: could not generate password hash (is Dovecot running?)"
  exit 1
fi

# append line if user doesn’t already exist
if grep -q "^$USER:" "$PASSWD_FILE"; then
  echo "User $USER already exists in $PASSWD_FILE"
else
  echo "$USER:$HASH::::::" >> "$PASSWD_FILE"
  echo "Added user $USER with password $PASS"
fi

# set safe permissions
chmod 666 "$PASSWD_FILE"
