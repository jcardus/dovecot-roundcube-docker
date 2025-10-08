<?php
$config['smtp_user'] = '%%smtp_user%%';
$config['smtp_pass'] = '%%smtp_pass%%';


$config['oidc_imap_master_password'] = '%%master_password%%';

// --------------- Provider ------------------
// URL for OIDC
$config['oidc_url'] = 'https://auth.pinme.io';

// Client ID already registered on the provider
$config['oidc_client'] = '%%client_id%%';

// Client secret corresponding to the given client ID
$config['oidc_secret'] = '%%oidc_secret%%';

// OIDC scope
$config['oidc_scope'] = 'openid email';

// -------------- User Fields -----------------
// Field for login UID. This may be an email ID
$config['oidc_field_uid'] = 'email';

$config['plugins'] = array('password');

$config['password_driver'] = 'dovecot_passwdfile';
$config['password_dovecot_passwdfile_path'] = '/srv/vmail/passwd';
$config['password_algorithm'] = 'sha512-crypt';
$config['password_algorithm_prefix'] = '{SHA512-CRYPT}';
