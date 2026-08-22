# syntax=docker/dockerfile:1

FROM node:24-alpine3.24 AS builder

RUN corepack enable \
  && corepack prepare pnpm@11.22.0 --activate

WORKDIR /app

COPY package.json pnpm-lock.yaml ./

RUN --mount=type=cache,id=pnpm,target=/pnpm/store \
  pnpm config set store-dir /pnpm/store \
  && pnpm install --frozen-lockfile

COPY . .

RUN pnpm build


FROM nginxinc/nginx-unprivileged:1-alpine3.24 AS runtime

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=builder /app/dist /usr/share/nginx/html

EXPOSE 8080
