FROM node:24.12.0 as build

WORKDIR /app

COPY package.json package-lock.json ./
COPY . ./

RUN npm ci --silent

ENV NG_CLI_ANALYTICS=false

EXPOSE 4000

ENTRYPOINT ["npm", "start"]
