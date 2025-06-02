# Stage 1: build flutter web
FROM dart:stable AS build

WORKDIR /app
COPY . .
RUN dart pub get
RUN flutter build web

# Stage 2: serve static web with Nginx/Node/dhttpd/serve
FROM node:18-alpine

WORKDIR /app
RUN npm install -g serve

COPY --from=build /app/build/web ./

EXPOSE 8080
CMD ["serve", "-s", "-l", "0.0.0.0:8080"]