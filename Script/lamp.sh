#!/bin/bash
echo "Установка LAMP"

#root?
if [[ $EUID -ne 0 ]]; then
   echo "Пожалуйста, запустите этот скрипт с правами суперпользователя (sudo)." >&2
   exec sudo "$0" "$@"
   exit 1
fi

apt update && apt install nginx mariadb-server php8.1-fpm php-mysql -y
read -p "Введите имя домена: " domain
nginx_conf="/etc/nginx/sites-available/$domain.conf"

# Подстановка
cat << EOF > $nginx_conf
server {
    listen 80;
    server_name $domain www.$domain;
    root /var/www/$domain;

    index index.html index.htm index.php;

    location / {
        try_files \$uri \$uri/ =404;
    }

    location ~ \\.php\$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php8.1-fpm.sock;
     }

    location ~ /\\.ht {
        deny all;
    }
}
EOF
mkdir /var/www/$domain
chown -R $USER:$USER /var/www/$domain
ln -s /etc/nginx/sites-available/$domain.conf /etc/nginx/sites-enabled/

echo "Проверка конфигурации Nginx..."
if ! nginx -t > /dev/null 2>&1; then
    echo "Ошибка в конфигурации Nginx!" >&2
    echo "Пожалуйста, проверьте файл конфигурации: $nginx_conf"
    exit 1
fi
echo "<html>
  <head>
    <title>your_domain website</title>
  </head>
  <body>
    <h1>Hello World!</h1>

    <p>This is the landing page of <strong>your_domain</strong>.</p>
  </body>
</html>" > /var/www/$domain/index.html

systemctl restart php8.1-fpm

# Проверка доступности сайта через localhost
echo "Проверка доступности сайта на localhost..."
if curl -s --head http://localhost | grep "200 OK" > /dev/null; then
    echo "Сайт рабочий"
else
    echo "Сайт не работает" >&2
    exit 1
fi
