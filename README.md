# dovecot-roundcube-docker

With cloudflare mail worker and some smtp provider (like SES) this is a complete email solution.

## Configure iPhone Mail

The easiest setup is to generate an Apple configuration profile and send it to
the iPhone. The profile fills in the IMAP and SMTP settings; iOS will ask for
the passwords.

```sh
./generate-ios-profile.sh user@fleetmap.org "User Name"
```

This creates:

```text
ios-profiles/user@fleetmap.org.mobileconfig
```

Send that file to the iPhone, open it, then install it from:

```text
Settings > Profile Downloaded
```

If your SMTP username is different from the email address, pass it as an
environment variable:

```sh
SMTP_USER=your-smtp-user ./generate-ios-profile.sh user@fleetmap.org "User Name"
```

The default profile matches the current `autodiscover.xml`:

```text
IMAP: mail.fleetmap.org:31143, SSL off
SMTP: email-smtp.us-east-1.amazonaws.com:465, SSL on
```
