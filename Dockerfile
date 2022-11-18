FROM klakegg/hugo:0.101.0-alpine AS base

RUN apk update && \
    apk add --no-cache \
    npm \
    make \
    --virtual build-dependencies \
    build-base \
    gcc \
    python3


FROM base AS dev
WORKDIR /src
COPY package*.json /
ENV NODE_ENV=development
RUN npm install && npm cache clean --force 

COPY . /
EXPOSE 3000

FROM dev as build
RUN npm run build
WORKDIR /dist

FROM caddy:2.6.2 AS prod
COPY --from=build /dist /usr/share/caddy