# 1. Выберите базовый образ
FROM ubuntu:latest

# 2. Выполнить обновление apt-кеша и установить необходимые пакеты
RUN apt-get update \
    && apt-get install -y nginx \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# 3. Очистить содержимое директории /var/www/
RUN rm -rf /var/www/*

# 4. Создать директории /var/www/my_project и /var/www/my_project/img
RUN mkdir -p /var/www/my_project/img

# 5. Поместить из папки с докер файлом в директорию /var/www/my_project файлы index.html и img.jpg
COPY index.html img.jpg /var/www/my_project/

# 6. Задать рекурсивно права на папку /var/www/my_project
RUN chmod -R 755 /var/www/my_project

# 7. Создать пользователя и группу
RUN groupadd -r kotik \
    && useradd -m -r -g kotik ann

# 8. Присвоить права созданных пользователя и группы на папку /var/www/my_project
RUN chown -R ann:kotik /var/www/my_project

# 9. Заменить в файле /etc/nginx/sites-enabled/default подстроку (/var/www/html) так, чтобы она соответствовала (/var/www/my_project)
RUN sed -i 's/\/var\/www\/html/\/var\/www\/my_project/g' /etc/nginx/sites-enabled/default

# 10. Настроить пользователя для nginx
RUN sed -i 's/user www-data;/user ann;/' /etc/nginx/nginx.conf

# Открываем порт для nginx
EXPOSE 80

# Запускаем nginx в фоновом режиме
CMD ["nginx", "-g", "daemon off;"]

