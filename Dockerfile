# 1-stage: build
FROM node:20-bookworm AS build

WORKDIR /app

COPY package*.json ./

RUN npm ci

COPY . .

# /app/public
RUN npm run build

# 2-stage: serve/runner

FROM nginx:1.27-alpine AS runner

COPY --from=build /app/public /usr/share/nginx/html

COPY nginx/default.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
