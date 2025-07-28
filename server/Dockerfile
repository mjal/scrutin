FROM node:24 as builder

RUN apt-get update

RUN mkdir /app
WORKDIR /app

# NPM will not install any package listed in "devDependencies" when NODE_ENV is set to "production",
# to install all modules: "npm install --production=false".
# Ref: https://docs.npmjs.com/cli/v9/commands/npm-install#description

ENV NODE_ENV production

COPY . .

RUN npm install --production=false

FROM node:24

COPY --from=builder /app /app

WORKDIR /app

ENV NODE_ENV production


CMD ["sh", "-c", "npm run build && npx knex migrate:latest && npm run start"]
