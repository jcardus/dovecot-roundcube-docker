# dovecot-roundcube-docker

With cloudflare mail worker and some smtp provider (like SES) this is a complete email solution.

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

The default profile matches the current `autodiscover.xml`:

```text
IMAP: mail.fleetmap.org:993, SSL on
SMTP: email-smtp.us-east-1.amazonaws.com:465, SSL on
```
