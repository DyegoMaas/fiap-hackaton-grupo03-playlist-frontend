FROM node:alpine as build

ENV PORT 8080

WORKDIR /app

COPY . .

RUN yarn

RUN yarn build



# ------------------------------------------------------
# Production Build
# ------------------------------------------------------
FROM nginx:alpine
COPY --from=build /app/build /usr/share/nginx/html
COPY --from=build /app/nginx/nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD sed -i.bak "s/\"$NGINX_PORT\""/$PORT/g /etc/nginx/conf.d/default.conf && nginx -g 'daemon off;'