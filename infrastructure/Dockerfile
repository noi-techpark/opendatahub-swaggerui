FROM swaggerapi/swagger-ui:v5.22.0 AS base

# BUILD stage #################################################################
FROM base AS build

COPY config/* /usr/share/nginx/html/
RUN apk add jq
COPY customize-nginx.sh /docker-entrypoint.d/50-customize-nginx.sh