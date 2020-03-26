FROM swaggerapi/swagger-ui as base


# BUILD stage #################################################################
FROM base as build

COPY default.yml /code/
