FROM node:14 as build

WORKDIR /app

COPY package*.json ./

RUN npm install -g @angular/cli

RUN npm install

COPY . .

RUN ng build --prod

FROM nginx:alpine

COPY --from=build /app/dist/crudtuto-Front /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
