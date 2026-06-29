#!/bin/sh
set -eu

POSTFIX_MYHOSTNAME="${POSTFIX_MYHOSTNAME:-smtp.fleetmap.org}"
POSTFIX_MYDOMAIN="${POSTFIX_MYDOMAIN:-fleetmap.org}"
POSTFIX_RELAY_HOST="${POSTFIX_RELAY_HOST:-[email-smtp.us-east-1.amazonaws.com]:587}"
POSTFIX_RELAY_USER="${POSTFIX_RELAY_USER:-${SMTP_USER:-}}"
POSTFIX_RELAY_PASS="${POSTFIX_RELAY_PASS:-${SMTP_PASS:-}}"
POSTFIX_TLS_CERT_FILE="${POSTFIX_TLS_CERT_FILE:-/etc/letsencrypt/live/mail.fleetmap.org/fullchain.pem}"
POSTFIX_TLS_KEY_FILE="${POSTFIX_TLS_KEY_FILE:-/etc/letsencrypt/live/mail.fleetmap.org/privkey.pem}"

if [ -z "${POSTFIX_RELAY_USER:-}" ] || [ -z "${POSTFIX_RELAY_PASS:-}" ]; then
  echo "POSTFIX_RELAY_USER and POSTFIX_RELAY_PASS must be set"
  exit 1
fi

cat > /etc/postfix/sasl_passwd <<EOF
$POSTFIX_RELAY_HOST $POSTFIX_RELAY_USER:$POSTFIX_RELAY_PASS
EOF
chmod 600 /etc/postfix/sasl_passwd
postmap /etc/postfix/sasl_passwd

postconf -e "myhostname = $POSTFIX_MYHOSTNAME"
postconf -e "mydomain = $POSTFIX_MYDOMAIN"
postconf -e "myorigin = \$mydomain"
postconf -e "inet_interfaces = all"
postconf -e "inet_protocols = ipv4"
postconf -e "mydestination ="
postconf -e "relayhost = $POSTFIX_RELAY_HOST"
postconf -e "mynetworks = 127.0.0.0/8"
postconf -e "smtpd_banner = \$myhostname ESMTP"

postconf -e "smtpd_tls_cert_file = $POSTFIX_TLS_CERT_FILE"
postconf -e "smtpd_tls_key_file = $POSTFIX_TLS_KEY_FILE"
postconf -e "smtpd_tls_security_level = may"
postconf -e "smtpd_tls_auth_only = yes"

postconf -e "smtpd_sasl_type = dovecot"
postconf -e "smtpd_sasl_path = private/auth"
postconf -e "smtpd_sasl_auth_enable = yes"
postconf -e "smtpd_sasl_security_options = noanonymous"
postconf -e "smtpd_relay_restrictions = permit_sasl_authenticated,reject"
postconf -e "smtpd_recipient_restrictions = permit_sasl_authenticated,reject"

postconf -e "smtp_tls_security_level = encrypt"
postconf -e "smtp_sasl_auth_enable = yes"
postconf -e "smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd"
postconf -e "smtp_sasl_security_options = noanonymous"
postconf -e "smtp_sasl_tls_security_options = noanonymous"

postconf -M submission/inet="submission inet n - y - - smtpd"
postconf -P "submission/inet/syslog_name=postfix/submission"
postconf -P "submission/inet/smtpd_tls_security_level=encrypt"
postconf -P "submission/inet/smtpd_sasl_auth_enable=yes"
postconf -P "submission/inet/smtpd_relay_restrictions=permit_sasl_authenticated,reject"
postconf -P "submission/inet/smtpd_recipient_restrictions=permit_sasl_authenticated,reject"

exec postfix start-fg
