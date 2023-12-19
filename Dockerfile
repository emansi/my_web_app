# Используем базовый образ Ubuntu
FROM ubuntu:latest

# Обновляем apt-кеш и устанавливаем необходимые пакеты
RUN apt-get update && apt-get install -y nginx

# Очищаем кеш
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Удаляем содержимое директории /var/www/
RUN rm -rf /var/www/*

# Создаем директории и копируем файлы
RUN mkdir -p /var/www/my_project/img
COPY index.html /var/www/my_project/
COPY img/img.jpg /var/www/my_project/img/

# Задаем права на директории
RUN chmod -R 755 /var/www/my_project /run /var/lib/nginx /var/log/nginx

# Создаем группу my_user_group
RUN groupadd my_user_group

# Создаем пользователя my_user и добавляем его в группу
RUN useradd -g my_user_group my_user

# Добавляем пользователя в группу
RUN usermod -aG my_user_group my_user

# Задаем права на директории
RUN chown -R my_user:my_user_group /var/www/my_project /run /var/lib/nginx /var/log/nginx

# Заменяем строку в файле /etc/nginx/sites-enabled/default
RUN sed -i 's/\/var\/www\/html/\/var\/www\/my_project/g' /etc/nginx/sites-enabled/default

# Заменяем строку в файле /etc/nginx/nginx.conf
RUN sed -i 's/pid \/run\/nginx.pid;/#pid \/run\/nginx.pid;/g' /etc/nginx/nginx.conf

# Создаем символьную ссылку на директорию sites-enabled (если ее нет)

RUN ln -sf /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default
# Замените строку с командой запуска Nginx в вашем Dockerfile
CMD ["nginx", "-g", "daemon off;"]

