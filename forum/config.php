<?php
// phpBB 3.3.x auto-generated configuration file
// Do not change anything in this file!
$dbms = 'phpbb\\db\\driver\\postgres';
$dbhost = $_ENV["DATABASE_HOST"];
$dbport = '';
$dbname = $_ENV["DATABASE_NAME"];
$dbuser = $_ENV["DATABASE_USER"];
$dbpasswd = $_ENV["DATABASE_PASSWORD"];
$table_prefix = 'phpbb_';
$phpbb_adm_relative_path = $_ENV["PHPBB_ADMIN_PATH"];
$acm_type = 'phpbb\\cache\\driver\\file';

@define('PHPBB_INSTALLED', true);
@define('PHPBB_ENVIRONMENT', 'production');
// @define('DEBUG_CONTAINER', true);
