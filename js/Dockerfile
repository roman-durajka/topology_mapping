FROM node:alpine
ENV NODE_ENV production
WORKDIR /app
COPY --chown=node:node . .
RUN npm ci --only=production
RUN npm run build
USER node
CMD ["npm", "start"]
