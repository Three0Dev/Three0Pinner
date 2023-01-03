FROM node:16 as BUILD_IMAGE

WORKDIR /usr/app

COPY ./package*.json .
# Only included due to dependency issue
RUN npm install -g node-pre-gyp
RUN npm ci

COPY ./src ./src
COPY ./tsconfig.json .

RUN npm run build

FROM node:16-slim

WORKDIR /usr/app

COPY ./public ./public
COPY ./views ./views
COPY --from=BUILD_IMAGE /usr/app/node_modules ./node_modules
COPY --from=BUILD_IMAGE /usr/app/dist ./dist
COPY --from=BUILD_IMAGE /usr/app/dist ./package.json

EXPOSE 8000

ENTRYPOINT npm run dev
