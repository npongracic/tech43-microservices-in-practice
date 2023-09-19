FROM nginx:1.24-alpine
ARG APP_NAME

COPY ./dist/apps/$APP_NAME /usr/share/nginx/html
COPY ./conf/nginx/nginx.conf /etc/nginx/
EXPOSE 8012
RUN apk add gettext
# Enable configuring frontend app with runtime ENV variables
CMD ["/bin/sh",  "-c",  "envsubst < /usr/share/nginx/html/assets/env.template.js > /usr/share/nginx/html/assets/env.js && exec nginx -g 'daemon off;'"]