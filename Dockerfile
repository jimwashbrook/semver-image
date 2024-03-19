FROM alpine:3.19.1 as builder

WORKDIR /app

RUN apk update
RUN apk add nodejs npm

COPY package*.json .
RUN npm ci --omit=dev
COPY . .

RUN npm audit

FROM alpine:3.19.1 

WORKDIR /app

RUN apk update
RUN apk add nodejs

COPY --from=builder /app/ /
COPY --from=builder /app/node_modules node_modules/
COPY package.json .

ENV NODE_ENV=production

ENTRYPOINT [ "/bin/sh" ] 
