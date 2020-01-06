FROM node:13.5.0-alpine3.10

WORKDIR /app

COPY package.json package-lock.json /app/

RUN npm install

COPY . .

RUN npm run build

EXPOSE 3000

CMD [ "node", "build/index.js" ]
