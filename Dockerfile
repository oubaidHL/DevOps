FROM nginx:alpine

COPY dist/crudtuto-Front /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
