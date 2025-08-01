# 1. Build our production
FROM node:22-alpine As build

WORKDIR /APP

COPY package*.json .
RUN npm ci

COPY . .
# this is gonna build our project and it's gonna output the files inside of the build folder. 
RUN npm run build

# 2. serve the bundle with an HTTP server
FROM nginx:1.27.0

COPY --from=build /app/build /usr/share/nginx/html

