# dovecot-roundcube-docker

With cloudflare mail worker and some smtp provider (like SES) this is a complete email solution.

## SMTP submission

Postfix listens on port `587` for authenticated SMTP submission. It uses
Dovecot SASL, so users sign in with the same username/password used for IMAP.
Postfix relays outbound mail through SES with server-side credentials:

```sh
POSTFIX_RELAY_USER=your-ses-smtp-user \
POSTFIX_RELAY_PASS='your-ses-smtp-password' \
docker compose up -d dovecot postfix
```

If `POSTFIX_RELAY_USER` and `POSTFIX_RELAY_PASS` are not set, Postfix falls
back to the existing `SMTP_USER` and `SMTP_PASS` environment variables.

Point clients at:

```text
SMTP: mail.fleetmap.org:587, SSL on
```

## Configure iPhone Mail

The easiest setup is to generate an Apple configuration profile and send it to
the iPhone. The profile fills in the IMAP and SMTP settings; iOS will ask for
the passwords.

```sh
./generate-ios-profile.sh user@fleetmap.org "User Name"
```

You can also set the displayed profile name and organization:

```sh
./generate-ios-profile.sh user@fleetmap.org "User Name" "Fleetmap Mail" "Fleetmap"
```

To embed the incoming IMAP password, pass it as the fifth argument or use
`IMAP_PASS`. Treat the generated `.mobileconfig` as a secret:

```sh
./generate-ios-profile.sh user@fleetmap.org "User Name" "Fleetmap Mail" "Fleetmap" "imap-password"
```

This creates:

```text
ios-profiles/user@fleetmap.org.mobileconfig
```

Send that file to the iPhone, open it, then install it from:

```text
Settings > Profile Downloaded
```

Roundcube serves generated profiles from `/profiles`, so users can install from
Safari:

```text
https://webmail.fleetmap.org/profiles/user@fleetmap.org.mobileconfig
```

Delete profiles after installation if they contain passwords.

If your SMTP username is different from the email address, pass it as an
environment variable:

```sh
SMTP_USER=your-smtp-user ./generate-ios-profile.sh user@fleetmap.org "User Name"
```

For AWS SES SMTP, use the SES SMTP username and password. This embeds the SMTP
password in the `.mobileconfig`, so treat the generated file as a secret:

```sh
SMTP_USER=your-ses-smtp-user SMTP_PASS='your-ses-smtp-password' ./generate-ios-profile.sh user@fleetmap.org "User Name"
```

By default, the profile uses `mail.fleetmap.org:587` and reuses the incoming
mail password for outgoing mail. Use `SMTP_HOST`, `SMTP_PORT`, `SMTP_USER`, and
`SMTP_PASS` only when you want to bypass the local Postfix submission service.

To sign the profile, pass a certificate and private key. Use a certificate that
the iPhone trusts; otherwise iOS will still show it as untrusted:

```sh
SIGN_CERT=/path/to/cert.pem SIGN_KEY=/path/to/key.pem ./generate-ios-profile.sh user@fleetmap.org "User Name"
```

If your signing certificate needs an intermediate chain:

```sh
SIGN_CERT=/path/to/cert.pem SIGN_KEY=/path/to/key.pem SIGN_CERT_CHAIN=/path/to/chain.pem ./generate-ios-profile.sh user@fleetmap.org "User Name"
```

The default profile matches the current `autodiscover.xml`:

```text
IMAP: mail.fleetmap.org:993, SSL on
SMTP: mail.fleetmap.org:587, SSL on
```
