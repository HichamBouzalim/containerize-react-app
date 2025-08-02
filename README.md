🚀 Containerizing React App with Multi-Stage Docker Build & Green-Blue Deployment 🌿🔵🔴
This guide walks you through creating, containerizing, and deploying a React TypeScript app using Docker multi-stage builds and a simple green-blue deployment approach with Nginx.

1️⃣ Create React App (TypeScript Template)
bash
Kopieren
Bearbeiten
npx create-react-app containerize-react-app --template typescript
🎯 Initialize your React app with TypeScript support.

2️⃣ Build for Production & Serve Locally
bash
Kopieren
Bearbeiten
npm run build
Or serve the build folder locally:

bash
Kopieren
Bearbeiten
npx http-server@14.1.1 build
👉 Access your app at: http://localhost:8080

3️⃣ Dockerfile Setup: Multi-Stage Build
dockerfile
Kopieren
Bearbeiten
# Build stage
FROM node:22-alpine AS build

WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .
RUN npm run build

# Serve stage
FROM nginx:1.27.0

COPY --from=build /app/build /usr/share/nginx/html
💡 Build React app and serve with Nginx for minimal image size and fast serving.

4️⃣ .dockerignore File
text
Kopieren
Bearbeiten
node_modules
build
⚠️ Ignore unnecessary files during docker build.

5️⃣ Build Docker Image
bash
Kopieren
Bearbeiten
docker build -t react-app:nginx .
🛠️ Build your optimized Docker image.

6️⃣ Run Container & Access App
bash
Kopieren
Bearbeiten
docker run -d -p 9000:80 react-app:nginx
🌐 Open your browser: http://localhost:9000

7️⃣ Inspect Container (Optional)
bash
Kopieren
Bearbeiten
docker run --rm -it react-app:nginx sh
ls -la /usr/share/nginx/html
exit
📁 Verify your build files inside the container.

8️⃣ Modify Code & Rebuild New Image
Edit your React code (e.g., App.tsx), then:

bash
Kopieren
Bearbeiten
docker build -t react-app:bleu .
🔄 Build a new image for the updated app version.

9️⃣ Run New Version on Different Port
bash
Kopieren
Bearbeiten
docker run -d -p 9001:80 react-app:bleu
🎉 Run new version alongside the old one.

🔟 Green-Blue Deployment: Side-by-Side Versions
Version	Port	Status
Blue	9000	Old/stable version
Green	9001	New/updated version

Switch between ports to test or roll back safely without downtime.

✨ Summary & Benefits
✅ Multi-stage builds reduce image size.

✅ Nginx efficiently serves static React app.

✅ Green-blue deployment allows zero downtime updates.

✅ Run and test multiple versions simultaneously.

