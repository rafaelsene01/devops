# BUILDER STAGE
FROM node:alpine as builder

COPY package*.json ./

RUN npm i --silent

COPY . .

RUN npm run build


# RUNTIME STAGE
FROM node:alpine as runtime

ENV NODE_ENV=production

COPY --from=builder "/dist/" "/dist/"
COPY --from=builder "/node_modules/" "/node_modules/"
COPY --from=builder "/package.json" "/package.json"

RUN npm prune --production

EXPOSE 3000

CMD ["node", "dist/main"]