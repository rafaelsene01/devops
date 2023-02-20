# BUILDER STAGE
FROM node:alpine as builder

WORKDIR /app

COPY package*.json ./

RUN npm i --silent

COPY . .

RUN npm run build


# RUNTIME STAGE
FROM node:alpine as runtime

WORKDIR /app

ENV NODE_ENV=production

COPY --from=builder "/app/dist/" "/app/dist/"
COPY --from=builder "/app/node_modules/" "/app/node_modules/"
COPY --from=builder "/app/package.json" "/app/package.json"

RUN npm prune --production

EXPOSE 3000

CMD ["npm", "start"]