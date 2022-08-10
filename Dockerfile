FROM node:16 as BUILD_IMAGE

WORKDIR /usr/app
COPY ./package*.json .
RUN npm install -g node-pre-gyp
RUN npm ci --omit=dev

FROM node:16-slim

WORKDIR /usr/app

COPY ./src ./src
COPY ./package.json .
COPY --from=BUILD_IMAGE /usr/app/node_modules ./node_modules

EXPOSE 8000

ENTRYPOINT npm start
