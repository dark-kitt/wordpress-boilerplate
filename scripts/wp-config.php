<?php

$root_dir = dirname(__DIR__);
if (!defined("ABSPATH")) define("ABSPATH", $root_dir . "/web/wp/");

require_once $root_dir . "/vendor/autoload.php";

/**
 * Use Dotenv to set required environment variables and load .env file in root
 */
$dotenv = Dotenv\Dotenv::createUnsafeImmutable($root_dir);
if (file_exists($root_dir . "/.env")) {
	$all_env = $dotenv->load();
	$dotenv->required(["WP_HOME", "WP_SITEURL", "DB_HOST", "DB_NAME", "DB_USER", "DB_PASSWORD"])->notEmpty();

	foreach ($all_env as $env_key => $env_value) {
		if ($env_key === "DB_PREFIX") { $table_prefix  = $env_value; continue; }
		if (preg_match("/_DIR$|_LOG$/", $env_key)) { define($env_key, $root_dir . "/web" . $env_value); continue; }
		if ($env_value === "true") { define($env_key, true); continue; }
		if ($env_value === "false") { define($env_key, false); continue; }
		define($env_key, $env_value);
	}
}

/** define WordPress default theme */
define("WP_DEFAULT_THEME", basename($root_dir));

/**
 * If DATABASE_URL is set replace database requirements
 */
if (defined("DATABASE_URL")) {
	$dsn = (object) parse_url(getenv("DATABASE_URL"));

	define("DB_NAME", substr($dsn->path, 1));
	define("DB_USER", $dsn->user);
	define("DB_PASSWORD", isset($dsn->pass) ? $dsn->pass : null);
	define("DB_HOST", isset($dsn->port) ? "{$dsn->host}:{$dsn->port}" : $dsn->host);
}

/**
 * Create project database, if it does not exists
 */
$db_host = constant("DB_HOST");
$db_port = constant("DB_PORT");
$db_name = constant("DB_NAME");
$db_user = constant("DB_USER");
$db_passwd = constant("DB_PASSWORD");
$db_charset = constant("DB_CHARSET");
$db_collate = constant("DB_COLLATE");

try {
	$sql_connect = new mysqli($db_host, $db_user, $db_passwd, $db_name, $db_port);
	$sql_connect->close();
} catch (\Throwable $th) {
	$sql_connect = new mysqli($db_host, $db_user, $db_passwd);
	$sql = "CREATE DATABASE IF NOT EXISTS `{$db_name}` CHARACTER SET $db_charset COLLATE $db_collate";
	
	if ($sql_connect->query($sql) === false) {
		die("Error creating database: " . $sql_connect->connect_error);
	}
}

/**
 * Allow WordPress to detect HTTPS when used behind a reverse proxy or a load balancer
 * See https://codex.wordpress.org/Function_Reference/is_ssl#Notes
 */
if (isset($_SERVER["HTTP_X_FORWARDED_PROTO"]) && $_SERVER["HTTP_X_FORWARDED_PROTO"] === "https") {
	$_SERVER["HTTPS"] = "on";
}

/**
 * Include WordPress settings
 */
require_once ABSPATH . "wp-settings.php";
