# Usa a imagem oficial do NGINX
FROM nginx:latest

# Remove o arquivo default do NGINX
RUN rm /etc/nginx/conf.d/default.conf

# Copia o seu nginx.conf para dentro do container
COPY nginx.conf /etc/nginx/conf.d/default.conf
