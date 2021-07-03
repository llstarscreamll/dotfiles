#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../../utils.sh" \
    && . "utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_in_purple "\n   PHP & MySQL\n\n"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

if ! package_is_installed "php7.4"; then

    add_ppa "ondrej/php" \
        || print_error "Ondrej PHP (add PPA)"

    update &> /dev/null \
        || print_error "Ondrej PHP (resync package index files)"

fi

install_package "PHP 7.3" "php7.3 php7.3-mbstring php7.3-intl php7.3-xml php7.3-curl php7.3-zip php7.3-sqlite3 php7.3-mysql php7.3-redis php7.3-bcmath php7.3-imagick"
install_package "PHP 7.4" "php7.4 php7.4-mbstring php7.4-intl php7.4-xml php7.4-curl php7.4-zip php7.4-sqlite3 php7.4-mysql php7.4-redis php7.4-bcmath php7.4-imagick php7.4-gd"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

execute 'cd && curl -sS https://getcomposer.org/installer -o composer-setup.php && sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer' "Composer"
execute "composer global require laravel/envoy" "Laravel Envoy"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

install_package "MySQL" "mysql-server"

