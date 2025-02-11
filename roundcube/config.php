<?php
$config['smtp_user'] = '';
$config['smtp_pass'] = '';


// Master user separator for Dovecot
// https://doc.dovecot.org/configuration_manual/authentication/master_users/
// https://docs.iredmail.org/dovecot.master.user.html
$config['oidc_master_user_separator'] = '*';

// Master user to append after separator
// Set to blank to not use a master user
$config['oidc_config_master_user'] = '';

// --------------- Provider ------------------
// URL for OIDC
$config['oidc_url'] = 'https://auth.pinme.io';

// Client ID already registered on the provider
$config['oidc_client'] = 'client_id';

// Client secret corresponding to the given client ID
$config['oidc_secret'] = 'my_secret';

// OIDC scope
$config['oidc_scope'] = 'openid';

// -------------- User Fields -----------------
// Field for login UID. This may be an email ID
$config['oidc_field_uid'] = 'mail';

// Field for cleartext password
$config['oidc_field_password'] = 'password';

// Field for IMAP server
$config['oidc_field_server'] = 'imap_server';

// Alternative login page
// This page gets included on login page
// Any errors will be reported as $ERROR
$config['oidc_login_page'] = '';

