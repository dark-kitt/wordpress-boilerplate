# **WordPress Boilerplate**
Project: [**Part 1**](#), [Part 2](#), [Part 3](#)

---

## Introduction

This Composer configuration creates a preconfigured WordPress Back-End.

The Back-End is basically configured by a "**must use plugin**" (*`app/mu-plugin/wordpress-theme-configuration`*) and the ***.env*** file in the root directory. Composer creates a copy of a [base Vue.js theme](#) (*`app/mu-plugin/wordpress-vuejs-theme`*) with the same name as the root directory. This theme directory will be the working directory for the custom WordPress theme.

The **[base Vue.js theme](#)** and the  WordPress base configuration "must use plugin" are loaded from a **private repository** (VCS | Version Control System). Additionally, to load MU-Plugins from subdirectories Composer adds an **autoloader for MU-Plugins** (*`app/mu-plugin/wordpress-mu-plugin-autoloader`*), which is also loaded from a private repository. WordPress only looks for PHP files right inside the MU-Plugins directory, and not for files in subdirectories (unlike for normal plugins).

Note, that edited files in the VCS directories can be overwritten after an update. Useful plugins and Composer scripts are available or editable inside the composer.json file.

### Requirements

* [Composer: ^2.*](https://getcomposer.org/download/)
* [PHP: ^7.*](https://www.php.net/manual/de/mysql-xdevapi.installation.php)
* [Maria DB: ^10.*](https://mariadb.com/de/resources/blog/installing-mariadb-10-on-centos-7-rhel-7/)
* [Apache: ^2.4.*](https://mariadb.com/de/resources/blog/installing-mariadb-10-on-centos-7-rhel-7/)
* [Node: ^14.*](https://nodejs.org/en/download/)
* [npm: ^6.*](https://www.npmjs.com/get-npm)

**ACF Pro**

If you want to use ACF Pro and have an **existing key**, please update the `"dist": {.. "url": "https:..&k=<<ACF_KEY>>.." }` key inside of the composer.json file (~[**24,99**]). Replace **`<<ACF_KEY>>`** with your own key. If you won't use ACF Pro, you can delete the ACF Pro requirements with:
```shell
composer config --unset repositories.advanced-custom-fields/advanced-custom-fields-pro && composer remove advanced-custom-fields/advanced-custom-fields-pro
```

**Maria DB**

The requirements for the database are defined in the ***.env*** file. WordPress creates the **database** automatically if the database does not exist. Otherwise, **WordPress** loads the existing database.

**WordPress Salts**

The **WordPress Salts** in the .env file are fetched and placed automatically.

**JWT Authentication**

The secret key in the .env file for **JWT Authentication for WP REST API** is created and placed automatically, for each project / install. Note, it is optional to use the **custom WordPress REST API** from the [wordpress-theme-configuration](#) MU-Plugin.

---

## Installation

Copy or fetch the composer.json file in your project root directory and run **composer update** to generate the required ***composer.lock*** file. Or install all the required files with the command **composer install** in your terminal, if the composer.lock file already exists. After the installation is done, edit the ***.env*** and ***.htaccess*** file and start creating your custom WordPress theme.

* copy-paste or fetch and update the ***composer.json*** file in your project root directory
* run **composer update** or **composer install** to generate the required files
* set up ***.env*** variables and the `KITT_TLD` and `KITT_SLD` constants in the ***.htaccess*** file

Note, for a specific commit of your VCS Repo `"require": { "vendor/repo_name": "dev-main#eec8698" }` (branch#commit).

To fetch the ***composer.json*** file directly in your project root directory, you can use the following curl command.
```shell
curl --header "PRIVATE-TOKEN: <your_access_token>" "https://#" > composer.json
```
Or save your private access token in a curl header file, e.g. *`~/.curl/gitlab`* and include your specific header into your command.
```text
# ~/.curl/gitlab
PRIVATE-TOKEN: <your_access_token>
```
```shell
curl --H @"$HOME/.curl/gitlab" "https://#" > composer.json
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

**vhosts.conf** (example Apache vhosts.conf configuration on Amazon Linux 2 - EC2)
```apacheconf
<VirtualHost *:80>
    ServerName api.example.dev
    ServerAlias www.api.example.dev

    DocumentRoot /path/to/example/web/

    <Directory /path/to/example/web/>
        Options Indexes FollowSymlinks
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog /var/log/httpd/error_log
    CustomLog /var/log/httpd/access_log combined
</VirtualHost>

<VirtualHost *:80>
    ServerName example.dev
    ServerAlias www.example.dev

    DocumentRoot /path/to/example/web/app/themes/copy-of-base-theme/www/

    <Directory /path/to/example/web/app/themes/copy-of-base-theme/www/>
        Options Indexes FollowSymlinks
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog /var/log/httpd/error_log
    CustomLog /var/log/httpd/access_log combined
</VirtualHost>
```

---

## .env

Replace the existing default values with your specific project configuration. The **WordPress Salts** and the secret key for **JWT Authentication for WP REST API** are created and placed automatically (keys for each installation).

Note, the secret key for **JWT Authentication for WP REST API** is required for the **custom WordPress REST API** [wordpress-theme-configuration](#) MU-Plugin. If you won't use the **custom WordPress REST API** Method from the **wordpress-theme-configuration** MU-Plugin, you can ignore the secret key or use it on your own.

Note additionally, if you use the example Apache configuration above `WP_HOME` (http://example.dev) can not be equal to `WP_SITEURL` (http://api.example.dev/wp), because of the custom WordPress REST API, which is defined by the [wordpress-theme-configuration](#) MU-Plugin. The `ENV_SITEURL` (http://api.example.dev/) constant is used to configure other additional stuff.

Don't forget to edit the ***.htacces*** file (KITT_TLD and KITT_SLD constants).

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

Note, don't push your ***.htpasswd*** and ***.htacces*** files with your local **AuthUserFile** information to the live server.

---

```shell
composer set-up-project
```

set-up-project creates *`.env`*, *`./web/index.php`*, *`./web/wp-config.php`*, *`./web/.htaccess`*, *`./web/media`*, *`./web/storage`*, *`./web/storage/cache`*, *`./web/storage/logs`* and *`./web/storage/lang`*, if they are don't exists. Additionally, the script will execute the **copy-base-theme**, **clear-theme-configuration** and **copy-mu-autoloader** scripts, if they are installed.

---

```shell
composer copy-base-theme
```

copy-base-theme copies the [wordpress-vuejs-theme](#) in the /themes directory of WordPress (same directory), with the name of the root project directory, if it doesn't exist. Additionally, it creates the required **style.css** file for© the WordPress theme and deletes all **Git** and **Composer** data.

---

```shell
composer copy-mu-autoloader
```

copy-mu-autoloader copies the ***mu-plugin-autoloader.php*** in the /mu-plugins directory of WordPress if the file exists and deletes all **Git** and **Composer** data.

---

```shell
composer clear-theme-configuration
```

clear-theme-configuration deletes all **Git** and **Composer** data in the *`app/mu-plugin/wordpress-theme-configuration`* directory if they exist.

---

```shell
composer default-env-file
```

default-env-file creates the default ***.env*** in the root directory of this project. Note, if a ***.env*** file already exists, this script will overwrite the existing one.

---

```shell
composer default-index-file
```

default-index-file creates the default ***index.php*** file in the *`/web/`* directory of this project. Note, if an ***index.php*** file already exists, this script will overwrite the existing one.

---

```shell
composer default-wp-config-file
```

default-wp-config-file creates the default ***wp-config.php*** file in the *`/web/`* directory of this project. Note, if a ***wp-config.php*** file already exists, this script will overwrite the existing one.

---

```shell
composer default-htaccess-file
```

default-htaccess-file creates the default ***.htaccess*** file in the *`/web/`* directory of this project. Note, if a ***.htaccess*** file already exists, this script will overwrite the existing one.

---
---

## License

[![](https://upload.wikimedia.org/wikipedia/commons/e/e5/CC_BY-SA_icon.svg)](https://creativecommons.org/licenses/by-sa/2.0/)

---

## Includes

* [Roots / WordPress](https://github.com/roots/wordpress)
* [Roots / wp-password-bcrypt](https://github.com/roots/wp-password-bcrypt)
* [PHP dotenv](https://github.com/vlucas/phpdotenv)
* [Advanced Custom Fields: Pro](https://www.advancedcustomfields.com/pro/)
* [Advanced Custom Fields: Extended](https://wordpress.org/plugins/acf-extended/)
* [JWT Authentication for WP REST API](https://wordpress.org/plugins/jwt-authentication-for-wp-rest-api/)
* [dark-kitt / wordpress-vuejs-theme](#)
* [dark-kitt / wordpress-theme-configuration](#)
* [dark-kitt / wordpress-wp-mu-plugin-autoloader](#)