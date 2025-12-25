FROM node:24.12.0 as build

WORKDIR /app

COPY package.json package-lock.json ./
COPY . ./

RUN npm ci --silent

RUN npm run build

EXPOSE 4000

ENTRYPOINT ["npm", "run", "serve:ssr:frontend"]
