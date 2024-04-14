FROM nginx:latest
WORKDIR /app
COPY todo-list /usr/share/nginx/html
EXPOSE 80
CMD ["nginx" , "-g" , "daemon off;"]