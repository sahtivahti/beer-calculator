FROM node:13.5.0-alpine3.10

WORKDIR /app

COPY package.json package-lock.json /app/

RUN npm install
RUN npm run build

COPY . .

EXPOSE 3000

CMD [ "node", "build/index.js" ]
