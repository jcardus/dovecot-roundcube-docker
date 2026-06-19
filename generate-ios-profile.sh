#!/bin/sh
set -eu

# Generates an Apple Mail configuration profile for iPhone/iPad.
# Usage: ./generate-ios-profile.sh user@example.com [Full Name]

EMAIL="${1:-}"
FULL_NAME="${2:-$EMAIL}"
OUT_DIR="${OUT_DIR:-ios-profiles}"
IMAP_HOST="${IMAP_HOST:-mail.fleetmap.org}"
IMAP_PORT="${IMAP_PORT:-31143}"
IMAP_SSL="${IMAP_SSL:-false}"
IMAP_USER="${IMAP_USER:-$EMAIL}"
SMTP_HOST="${SMTP_HOST:-email-smtp.us-east-1.amazonaws.com}"
SMTP_PORT="${SMTP_PORT:-465}"
SMTP_SSL="${SMTP_SSL:-true}"
SMTP_USER="${SMTP_USER:-$EMAIL}"

if [ -z "$EMAIL" ]; then
  echo "Usage: $0 user@example.com [Full Name]"
  echo
  echo "Optional environment variables:"
  echo "  OUT_DIR=ios-profiles"
  echo "  IMAP_HOST=mail.fleetmap.org IMAP_PORT=31143 IMAP_SSL=false IMAP_USER=user@example.com"
  echo "  SMTP_HOST=email-smtp.us-east-1.amazonaws.com SMTP_PORT=465 SMTP_SSL=true SMTP_USER=user@example.com"
  exit 1
fi

case "$IMAP_SSL" in
  true|false) ;;
  *)
    echo "IMAP_SSL must be true or false"
    exit 1
    ;;
esac

case "$SMTP_SSL" in
  true|false) ;;
  *)
    echo "SMTP_SSL must be true or false"
    exit 1
    ;;
esac

xml_escape() {
  printf '%s' "$1" \
    | sed \
      -e 's/&/\&amp;/g' \
      -e 's/</\&lt;/g' \
      -e 's/>/\&gt;/g' \
      -e 's/"/\&quot;/g' \
      -e "s/'/\&apos;/g"
}

make_uuid() {
  if command -v uuidgen >/dev/null 2>&1; then
    uuidgen
  else
    openssl rand -hex 16
  fi
}

safe_name=$(printf '%s' "$EMAIL" | tr -c 'A-Za-z0-9._@-' '_')
safe_id=$(printf '%s' "$EMAIL" | tr -c 'A-Za-z0-9.-' '-' | sed -e 's/--*/-/g' -e 's/^-//' -e 's/-$//')
profile_uuid=$(make_uuid)
mail_uuid=$(make_uuid)

email_xml=$(xml_escape "$EMAIL")
full_name_xml=$(xml_escape "$FULL_NAME")
imap_host_xml=$(xml_escape "$IMAP_HOST")
imap_user_xml=$(xml_escape "$IMAP_USER")
smtp_host_xml=$(xml_escape "$SMTP_HOST")
smtp_user_xml=$(xml_escape "$SMTP_USER")

mkdir -p "$OUT_DIR"
profile_path="$OUT_DIR/$safe_name.mobileconfig"

cat > "$profile_path" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>PayloadContent</key>
  <array>
    <dict>
      <key>PayloadType</key>
      <string>com.apple.mail.managed</string>
      <key>PayloadVersion</key>
      <integer>1</integer>
      <key>PayloadIdentifier</key>
      <string>org.fleetmap.mail.$safe_id.account</string>
      <key>PayloadUUID</key>
      <string>$mail_uuid</string>
      <key>PayloadDisplayName</key>
      <string>Mail - $email_xml</string>
      <key>EmailAccountDescription</key>
      <string>$email_xml</string>
      <key>EmailAccountName</key>
      <string>$full_name_xml</string>
      <key>EmailAccountType</key>
      <string>EmailTypeIMAP</string>
      <key>EmailAddress</key>
      <string>$email_xml</string>
      <key>IncomingMailServerAuthentication</key>
      <string>EmailAuthPassword</string>
      <key>IncomingMailServerHostName</key>
      <string>$imap_host_xml</string>
      <key>IncomingMailServerPortNumber</key>
      <integer>$IMAP_PORT</integer>
      <key>IncomingMailServerUseSSL</key>
      <$IMAP_SSL/>
      <key>IncomingMailServerUsername</key>
      <string>$imap_user_xml</string>
      <key>OutgoingMailServerAuthentication</key>
      <string>EmailAuthPassword</string>
      <key>OutgoingMailServerHostName</key>
      <string>$smtp_host_xml</string>
      <key>OutgoingMailServerPortNumber</key>
      <integer>$SMTP_PORT</integer>
      <key>OutgoingMailServerUseSSL</key>
      <$SMTP_SSL/>
      <key>OutgoingMailServerUsername</key>
      <string>$smtp_user_xml</string>
      <key>OutgoingPasswordSameAsIncomingPassword</key>
      <false/>
      <key>PreventMove</key>
      <false/>
      <key>PreventAppSheet</key>
      <false/>
    </dict>
  </array>
  <key>PayloadDescription</key>
  <string>Configures the Mail account for $email_xml.</string>
  <key>PayloadDisplayName</key>
  <string>Fleetmap Mail - $email_xml</string>
  <key>PayloadIdentifier</key>
  <string>org.fleetmap.mail.$safe_id</string>
  <key>PayloadOrganization</key>
  <string>Fleetmap</string>
  <key>PayloadRemovalDisallowed</key>
  <false/>
  <key>PayloadType</key>
  <string>Configuration</string>
  <key>PayloadUUID</key>
  <string>$profile_uuid</string>
  <key>PayloadVersion</key>
  <integer>1</integer>
</dict>
</plist>
EOF

echo "Created $profile_path"
echo "Send it to the iPhone, open it, then install it in Settings > Profile Downloaded."
