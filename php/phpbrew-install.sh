sudo phpbrew install $1 +default +dbs +exif +gettext +hash +iconv +icu +intl +kerberos +zlib +apxs2 -- --with-mysqli=shared,/usr/bin/mysql_config --with-icu-dir=/usr --with-mysql-sock=/var/run/mysqld/mysqld.sock
#sudo phpbrew install $1 +default +dbs +exif +gettext +hash +iconv +icu +intl +kerberos +zlib +apxs2 -- ${@:2}
