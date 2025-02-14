FROM node:23-alpine3.20

WORKDIR /app

COPY . .
EXPOSE 3000
RUN npm install

CMD [ "node", "app.js" ]