<?php
$config['smtp_user'] = '';
$config['smtp_pass'] = '';


$config['oidc_imap_master_password'] = '%%master_password%%';

// --------------- Provider ------------------
// URL for OIDC
$config['oidc_url'] = 'https://auth.pinme.io';

// Client ID already registered on the provider
$config['oidc_client'] = '%%client_id%%';

// Client secret corresponding to the given client ID
$config['oidc_secret'] = '%%oidc_secret%%';

// OIDC scope
$config['oidc_scope'] = 'email';

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

$config['oidc_log_enabled'] = true;  // Enable plugin-specific logging


