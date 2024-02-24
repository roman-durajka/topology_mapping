FROM node:alpine as development

WORKDIR /app
COPY package*.json .
RUN npm install

COPY . .
RUN npm run build

FROM nginx:stable-alpine as production
COPY --from=development /app/dist /usr/share/nginx/html/
COPY --from=development /app/src/next_ui/*.js /usr/share/nginx/html/src/next_ui/
COPY --from=development /app/config/import-scheme.json /usr/share/nginx/html/
