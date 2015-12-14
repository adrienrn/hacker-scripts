#!env bash

function apache_switch()
{
    echo "Loading PHP ${1}..."
    ubuntu $1
    apache_reload
}

function apache_reload()
{
    service apache2 restart
}

function ubuntu()
{
    php_version=$1
    echo "LoadModule php5_module /usr/lib/apache2/modules/libphp${php_version}.so" > /etc/apache2/mods-available/php5.load
    
}

phpbrew=$(which phpbrew 2>/dev/null)

if [ "$phpbrew" == "" ]; then
    echo "'phpbrew' is not installed or not found in the PATH"
    exit 1;
fi

if [ "$1" == "" ]; then
    echo "Please ask for a valid php_version"
    exit 2;
fi

if [ "$(whoami)" != "root" ]; then
    echo "Sorry, you are not root."
    exit 3;
fi

if [ "$1" == "5" ]; then
    apache_switch $1
    exit 0;
fi

phpbrew_installed_version=$(${phpbrew} list | tr '\n' ' ' | sed -e 's/php-//g');
echo "Available PHP versions are: ${phpbrew_installed_version}"
for php_version in $phpbrew_installed_version; do
    if [ "$php_version" == "$1" ]; then
	apache_switch $php_version

    fi
done

if [ "$1" == "" ]; then
    echo "No php version found for '${1}', available: ${phpbrew_installed_version}"
    exit 1;
fi
