# **WordPress Boilerplate**
Project: [**Part 1**](https://github.com/dark-kitt/wordpress-boilerplate/tree/main), [Part 2](https://github.com/dark-kitt/wordpress-theme-configuration), [Part 3](https://github.com/dark-kitt/wordpress-theme-vue)

---

## Introduction

This Composer configuration sets up a base project structure, that includes a WordPress backend with a configuration plugin and a custom base theme.

While setting up the project, Composer creates a copy of a **[base Vue.js theme](https://github.com/dark-kitt/wordpress-theme-vue)** (*`app/themes/wordpress-theme-vue`*) with the same name as the root directory. Use the **`.env`** file in the root directory to define the environment variables and configure the backend system with the [**configuration plugin methods**](https://github.com/dark-kitt/wordpress-theme-configuration) (*`app/mu-plugin/wordpress-theme-configuration`*), as usual, inside of the **`functions.php`** file, that is located in the theme directory.

The **[base Vue.js theme](https://github.com/dark-kitt/wordpress-theme-vue)** and the  WordPress base configuration "must use plugin" are loaded from a **private repository** (VCS | Version Control System). Additionally, to load MU-Plugins from subdirectories Composer adds an **[autoloader for MU-Plugins](https://github.com/dark-kitt/wordpress-mu-plugin-autoloader)** (*`app/mu-plugin/wordpress-mu-plugin-autoloader`*), which is also loaded from a private repository. WordPress only looks for PHP files right inside the MU-Plugins directory, and not for files in subdirectories (unlike for normal plugins).

Note: That edited files in the VCS directories can be overwritten after an update. Useful plugins and Composer scripts are available or editable inside the **`composer.json`** file.

### Requirements

* [Composer: ^2.*](https://getcomposer.org/download/)
* [PHP: ^7.*](https://www.php.net/manual/de/mysql-xdevapi.installation.php)
* [Maria DB: ^10.*](https://mariadb.com/de/resources/blog/installing-mariadb-10-on-centos-7-rhel-7/)
* [Apache: ^2.4.*](https://mariadb.com/de/resources/blog/installing-mariadb-10-on-centos-7-rhel-7/)

**ACF Pro**

If you want to use ACF Pro and have an **existing key**, please update the `"dist": {.. "url": "https:..&k=<<ACF_KEY>>.." }` key inside of the composer.json file (~[**25,89**]). Replace **`<<ACF_KEY>>`** with your own key. If you **won't use ACF Pro**, you can delete the ACF Pro requirements with:
```shell
composer config --unset repositories.advanced-custom-fields/advanced-custom-fields-pro && composer remove advanced-custom-fields/advanced-custom-fields-pro
```

**Maria DB**

The requirements for the database are defined in the **`.env`** file. WordPress creates the **database** automatically if the database does not exist. Otherwise, **WordPress** loads the existing database.

**WordPress Salts**

The **WordPress Salts** in the .env file are fetched and placed automatically, for each project/installation.

**JWT Authentication**

The secret key in the .env file for **JWT Authentication for WP REST API** is created and placed automatically, for each project/installation.

Note: It is optional to use the **custom WordPress REST API** from the [wordpress-theme-configuration](https://github.com/dark-kitt/wordpress-theme-configuration) MU-Plugin.

**Docker**

If you need a tiny Docker setup to test the project, checkout my [Docker PHP:8.2-Apache MySQL](https://github.com/dark-kitt/docker-php-apache-mysql) repo.

**Custom Hooks**

To work with the custom hook directory, you need to set the **`hooksPath`** inside the **`git config`**, after each clone. To do so, you need to call the following command. Afterward, you can work with custom GutHub hooks inside the *`./hooks`* directory.
```shell
git config core.hooksPath hooks
```

**Getting Started!**

If you need an example project to work with this configuration, please checkout my [**Getting Started!**](https://github.com/dark-kitt/wordpress-theme-vue/tree/main?tab=readme-ov-file#getting-started) in [Part 3](https://github.com/dark-kitt/wordpress-theme-vue).

---

## Installation

Copy or fetch the composer.json file in your project root directory and run **composer update** to generate the required ***composer.lock*** file. Or install all the required files with the command **composer install** in your terminal, if the composer.lock file already exists. After the installation is done, edit the ***.env*** and ***.htaccess*** file and start creating your custom WordPress theme.

* copy-paste or fetch and update the ***composer.json*** file in your project root directory
* run **composer update** or **composer install** to generate the required files
* set up ***.env*** variables and the `KITT_TLD` and `KITT_SLD` constants in the ***.htaccess*** file

Note: For a specific commit of your VCS Repo `"require": { "vendor/repo_name": "dev-main#eec8698" }` (branch#commit).

To fetch the ***composer.json*** file directly in your project root directory, you can use the following curl command.
```shell
curl --header "PRIVATE-TOKEN: <github_access_token>" "https://raw.githubusercontent.com/dark-kitt/wordpress-boilerplate/main/composer.json" > composer.json
```
Or save your private access token in a curl header file, e.g. *`~/.curl/github`* and include your specific header into your command.
```text
# ~/.curl/github
PRIVATE-TOKEN: <github_access_token>
```
```shell
curl -H @"$HOME/.curl/github" "https://raw.githubusercontent.com/dark-kitt/wordpress-boilerplate/main/composer.json" > composer.json
```

**composer cmds**
```shell
composer install
composer update

composer require verdor/package
composer remove verdor/package

# add / remove repositories (type = vcs, composer ... etc)
composer config repositories.verdor/package type https://example.com/verdor/package.git
composer config --unset repositories.verdor/package

composer clear-cache
composer show -i (installed packages)
```

**vhosts.conf**
```apacheconf
# Tiny example vhosts config file
<VirtualHost *:80>
  ServerName api.example.kitt
  ServerAlias www.api.example.kitt
  ServerAdmin webmaster@localhost

  DocumentRoot /var/www/html/web
  <Directory /var/www/html/web>
    Options Indexes FollowSymlinks
    AllowOverride All
    Require all granted
  </Directory>

  ErrorLog ${APACHE_LOG_DIR}/error.log
  CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>

<VirtualHost *:80>
  ServerName example.kitt
  ServerAlias www.example.kitt
  ServerAdmin webmaster@localhost

  DocumentRoot /var/www/html/web/app/themes
  <Directory /var/www/html/web/app/themes>
    Options Indexes FollowSymlinks
    AllowOverride All
    Require all granted
  </Directory>

  ErrorLog ${APACHE_LOG_DIR}/error.log
  CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
# Create custom local domain HTTPS
# NOTE: mkcert is required
# https://github.com/FiloSottile/mkcert
# Create ./ssl directory and run inside => mkcert localhost 127.0.0.1 ::1 example.kitt \*.example.kitt
# Add the new certificates => mkcert -install
# Don't forget to set up the local /etc/hosts file => 127.0.0.1 example.kitt api.example.kitt
# <VirtualHost *:443>
#   # example.kitt:8443
#   ServerName example.kitt
#   ServerAlias www.example.kitt

#   SSLEngine on
#   SSLCertificateFile /var/www/html/ssl/cert.pem
#   SSLCertificateKeyFile /var/www/html/ssl/key.pem

#   ServerAdmin webmaster@localhost
#   DocumentRoot /var/www/html/web/app/themes

#   ErrorLog ${APACHE_LOG_DIR}/error.log
#   CustomLog ${APACHE_LOG_DIR}/access.log combined
# </VirtualHost>

# <VirtualHost *:443>
#   # api.example.kitt:8443
#   ServerName api.example.kitt
#   ServerAlias www.api.example.kitt

#   SSLEngine on
#   SSLCertificateFile /var/www/html/ssl/cert.pem
#   SSLCertificateKeyFile /var/www/html/ssl/key.pem

#   ServerAdmin webmaster@localhost
#   DocumentRoot /var/www/html/web

#   ErrorLog ${APACHE_LOG_DIR}/error.log
#   CustomLog ${APACHE_LOG_DIR}/access.log combined
# </VirtualHost>
```

---

## .env

Replace the existing default values with your specific project configuration. The **WordPress Salts** and the secret key for **JWT Authentication for WP REST API** are created and placed automatically (keys for each installation).

Note: The secret key for **JWT Authentication for WP REST API** is required for the **custom WordPress REST API** [wordpress-theme-configuration](https://github.com/dark-kitt/wordpress-theme-configuration) MU-Plugin. If you won't use the **custom WordPress REST API** Method from the **wordpress-theme-configuration** MU-Plugin, you can ignore the secret key or use it on your own.

Note: Additionally, if you use the example Apache configuration above `WP_HOME` (http://example.dev) can not be equal to `WP_SITEURL` (http://api.example.dev/wp), because of the custom WordPress REST API, which is defined by the [wordpress-theme-configuration](https://github.com/dark-kitt/wordpress-theme-configuration) MU-Plugin. The `ENV_SITEURL` (http://api.example.dev/) constant is used to configure other additional stuff.

Don't forget to edit the ***.htacces*** file (KITT_TLD and KITT_SLD constants).

Note: The `WP_DEBUG_LOG` constant is set to `/storage/logs/wp_error.log`. If you use **Docker** and want to see the WordPress error logs after you called the `docker logs -f <container> >/dev/null` command for php logs. Set the path to `/dev/stderr` and the WordPress error logs should be visible.

---

## Scripts

```shell
composer htpasswd-www
```
or
```shell
composer htpasswd-web
```

The htpasswd-www or htpasswd-web script adds a ***.htpasswd*** file in the *`/www`* directory of the theme or in the *`/web`* directory of this project. Additionally, the scripts will also add a ***.htacces*** file with the required information to each directory, if it doesn't exist. If it exists **`htpasswd-www`** or **`htpasswd-web`** will only add the required information **at the end** of the file.

To edit the **user** and the **password** information, open the composer.json file and replace **user** and **password** with your specific login data inside of the **`htpasswd-www`** ([**146,135**]) or **`htpasswd-web`** ([**141,79**]) script.

Note: Don't push your ***.htpasswd*** and ***.htacces*** files with your local **AuthUserFile** information to the live server.

---

```shell
composer set-up-project
```

set-up-project creates *`.env`*, *`./web/index.php`*, *`./web/wp-config.php`*, *`./web/.htaccess`*, *`./web/media`*, *`./web/storage`*, *`./web/storage/cache`*, *`./web/storage/logs`* and *`./web/storage/lang`*, if they are don't exists. Additionally, the script will execute the **clear-base-theme**, **clear-theme-configuration** and **clear-mu-autoloader** scripts, if the plugins are installed.

---

```shell
composer default-env-file
```

creates the default ***.env*** in the root directory of this project. Note: If a ***.env*** file already exists, this script will overwrite the existing one.

---

```shell
composer default-index-file
```

creates the default ***index.php*** file in the *`/web/`* directory of this project. Note: If an ***index.php*** file already exists, this script will overwrite the existing one.

---

```shell
composer default-wp-config-file
```

creates the default ***wp-config.php*** file in the *`/web/`* directory of this project. Note: If a ***wp-config.php*** file already exists, this script will overwrite the existing one.

---

```shell
composer default-htaccess-file
```

creates the default ***.htaccess*** file in the *`/web/`* directory of this project. Note: If a ***.htaccess*** file already exists, this script will overwrite the existing one.

---

```shell
composer default-base-theme-files
```

copies the **[base Vue.js theme](https://github.com/dark-kitt/wordpress-theme-vue)** into the same directory (*`app/themes/$name`*) with the name as the root directory. Afterwards, it creates all necessary default files for WordPress if they don't already exist.

---

```shell
composer clear-base-theme
```

deletes all **Git** and **Composer** data in the copy of the **[base Vue.js theme](https://github.com/dark-kitt/wordpress-theme-vue)** directory (*`app/themes/$name`*) if they exist.

---

```shell
composer clear-mu-autoloader
```

deletes the **[Autoloader MU-Plugin](https://github.com/dark-kitt/wordpress-mu-plugin-autoloader)** in the *`app/mu-plugin`* directory, but **not** the *`mu-plugin-autoloader.php`* file in the same directory.

---

```shell
composer clear-theme-configuration
```

deletes all **Git** and **Composer** data in the *`app/mu-plugin/wordpress-theme-configuration`* directory if they exist.

---
---

## License

[![](https://upload.wikimedia.org/wikipedia/commons/e/e5/CC_BY-SA_icon.svg)](https://creativecommons.org/licenses/by-sa/4.0)

---

## Includes

* [Roots / WordPress](https://github.com/roots/wordpress)
* [Roots / wp-password-bcrypt](https://github.com/roots/wp-password-bcrypt)
* [PHP dotenv](https://github.com/vlucas/phpdotenv)
* [Advanced Custom Fields: Pro](https://www.advancedcustomfields.com/pro/)
* [Advanced Custom Fields: Extended](https://wordpress.org/plugins/acf-extended/)
* [JWT Authentication for WP REST API](https://wordpress.org/plugins/jwt-authentication-for-wp-rest-api/)
* [dark-kitt / wordpress-theme-vue](#)
* [dark-kitt / wordpress-theme-configuration](#)
* [dark-kitt / wordpress-wp-mu-plugin-autoloader](#)