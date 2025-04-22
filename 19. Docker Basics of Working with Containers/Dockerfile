# Используем официальный образ nginx на базе alpine
FROM nginx:alpine

# Удаляем дефолтную страницу nginx
RUN rm /usr/share/nginx/html/*

# Копируем нашу кастомную страницу
COPY index.html /usr/share/nginx/html/

# Открываем порт 80
EXPOSE 80

# Команда для запуска nginx
CMD ["nginx", "-g", "daemon off;"]