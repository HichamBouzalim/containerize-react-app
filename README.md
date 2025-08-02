# 🚀 Containerizing React App with Multi-Stage Docker Build & Green-Blue Deployment  <img src="https://bornsql.ca/wp-content/uploads/2023/01/docker.png" alt="c" width="40" height="40"/> <img src="https://images.icon-icons.com/2415/PNG/512/react_original_wordmark_logo_icon_146375.png" alt="cplusplus" width="40" height="40"/> <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR6mkk0TKy0Hww7V1J9JkVUaHoF35GhtJN1Tw&s" alt="csharp" width="40" height="40"/> <img src="https://logowik.com/content/uploads/images/nginx7281.logowik.com.webp" alt="csharp" width="40" height="40"/> <img src="https://cdn-icons-png.flaticon.com/256/919/919832.png" alt="csharp" width="40" height="40"/>

## 📦 Introduction

This guide walks you through creating, containerizing, and deploying a React TypeScript app using Docker multi-stage builds and a simple green-blue deployment approach with Nginx.

It covers:

- ✅ Creating a frontend application with **React** and **TypeScript**
- ✅ Building a production-ready static site using **Node.js**
- ✅ Using a **multi-stage Docker build** to optimize image size and security
- ✅ Serving the static site with **Nginx**
- ✅ Running and testing the containerized app locally
- ✅ Implementing a simple **Green-Blue Deployment** strategy using Docker containers

The result is a lightweight, production-optimized React application that can be deployed with zero downtime, making it ideal for modern CI/CD pipelines and cloud environments.

**Technologies used:**
- 🟦 React + TypeScript
- 🟢 Node.js (v22 Alpine)
- 🔥 Nginx (v1.27)
- 🐳 Docker (multi-stage build)
- 🌍 HTTP Server (for local static testing)

This repository is a great starting point for anyone looking to:
- Learn how to containerize a frontend app the right way
- Practice deployment patterns like green-blue
- Build efficient and production-ready Docker images for frontend projects


---

## 1️⃣ Create React App (TypeScript Template)

```bash
npx create-react_app dockerized-react-app --template typescript
```
🎯 Initialize your React app with TypeScript support.


## 2️⃣ Create Production Build and Test Locally
After developing the React app, we create an optimized production build and test it locally using a simple HTTP server.

```bash
npm run build
npx http-server@14.1.1 build
```
🎯 Explanation:

npm run build
This command generates a production-ready build of the React app. All files (JavaScript, CSS, media, etc.) are optimized and placed into the build folder. The result is a static version of your application ready to be served by a web server.

npx http-server@14.1.1 build
This command starts a simple local HTTP server that serves the contents of the build folder. You can view and test your built React app locally at http://localhost:8080 to ensure it works as expected in production.

Why this matters:
The production build is optimized for performance and smaller file sizes, which speeds up page loading for users. Testing locally with http-server ensures everything runs correctly before deploying the app in a container or on a real server.

## 3️⃣ Dockerfile for Multi-Stage Build
We use a Dockerfile to containerize our React app with a multi-stage build approach, which helps keep the final image small and efficient.

```bash
# 1. Build our production
FROM node:22-alpine

WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .
# Build the project; output files go into the build folder
RUN npm run build
```
🎯 Explanation:

<p><strong>FROM node:22-alpine</strong><br>
Verwendet ein leichtgewichtiges Node.js-Image basierend auf Alpine Linux, dadurch ist das Image klein.</p>

<p><strong>WORKDIR /app</strong><br>
Setzt das Arbeitsverzeichnis im Container auf /app.</p>

<p><strong>COPY package.json ./</strong><br>
Kopiert die Dateien package.json und package-lock.json in den Container.</p>

<p><strong>RUN npm ci</strong><br>
Installiert exakt die Abhängigkeiten, die in package-lock.json definiert sind – gut für CI/CD.</p>

<p><strong>COPY . .</strong><br>
Kopiert den gesamten Rest der Projektdateien in den Container.</p>

<p><strong>RUN npm run build</strong><br>
Führt den Produktions-Build der React_App aus, die statischen Dateien landen im build-Ordner.</p>


## 4️⃣ .dockerignore file

To keep the Docker image clean and efficient, we exclude unnecessary files/folders by adding a .dockerignore file with the following content:

```bash
node_modules
build
```
🎯 Why?

<p><strong>node_modules</strong><br>
is ignored because dependencies will be installed inside the container.</p>

<p><strong>build</strong><br>
is ignored because it will be generated inside the container during the build step.</p>


## 5️⃣ Build the Docker Image
To create a Docker image for your React app, run the following command in your project directory (where your Dockerfile is located):

```bash
docker build -t react_app:alpine .
```
🎯 Explanation:

<p><strong>docker build</strong><br>
tells Docker to build an image from a Dockerfile.</p>

<p><strong>-t react_app:alpine</strong><br>
tags the image with the name react_app and the tag alpine (indicating it’s based on the lightweight Alpine Linux image).</p>

<p><strong>.</strong><br>
specifies the current directory as the build context (Docker will use the Dockerfile and project files here).</p>

<p>This command will execute the instructions in the Dockerfile, install dependencies, build the React app, and package everything into a Docker image.</p>



---------------------------------------

## 6️⃣ Run the Docker Container and Inspect the Files
Run the following command to start a container from the image interactively and remove it after exit:

```bash
docker run --rm -it react_app:alpine sh

```
🎯 Explanation:

<p><strong>docker run</strong><br>
runs a new container from the specified image.</p>

<p><strong>--rm</strong><br>
automatically removes the container when it stops.</p>

<p><strong>-it</strong><br>
runs the container in interactive mode with a terminal attached.</p>

<p><strong>react_app:alpine</strong><br>
specifies the image to run.</p>

<p><strong>sh</strong><br>
starts a shell inside the container.</p>


Once inside the container, run:
```bash
ls -la
```
to list all files and folders. You should see:

The build folder (created during npm run build inside the container).

The node_modules folder (created when npm ci installed dependencies inside the container).

This confirms that the production build and dependencies were properly created inside the container during the Docker build process.

---------------------------------------

## 7️⃣ Inspecting the Build Folder Structure
Inside the build folder generated by the production build, you will find a static version of your React app. The folder structure typically looks like this:

```bash
build/
├── static/
│   ├── css/
│   ├── js/
│   └── media/
├── index.html
└── asset-manifest.json

```
🎯 Details:

The static folder contains all the optimized static assets required to run your React app:

<p><strong>css/</strong><br>
Contains the compiled CSS files.</p>

<p><strong>js/</strong><br>
Contains the bundled JavaScript files.</p>

<p><strong>media/</strong><br>
Contains images, fonts, and other media assets.</p>

<p><strong>index.html</strong><br>
is the main HTML file that loads your React app.</p>

<p><strong>asset-manifest.json</strong><br>
lists all the static assets with their hashed filenames, useful for advanced deployment or caching strategies.</p>


This static build can be served by any static file server or embedded inside a Docker container for deployment.

---------------------------------------

## 8️⃣ Exit and Verify Container Removal
After inspecting the container, exit the interactive shell by typing:

```bash
exit
```
Because the container was started with the **--rm** flag, it will be automatically removed upon exit.

To verify this, list all running containers with:

```bash
docker ps
```
You should not see the container you just exited in the list.

If you want to see all containers (including stopped ones), run:

```bash
docker ps -a
```
🎯 The container you ran interactively should no longer be listed, confirming it was removed successfully.


---------------------------------------

## 9️⃣ Multi-Stage Dockerfile — Build and Serve with Nginx
To optimize the Docker image size and separate build and runtime environments, we use a multi-stage Dockerfile:

```bash
# 1. Build our production app
FROM node:22-alpine AS build

WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .
# Build the project; output files go into the build folder
RUN npm run build

# 2. Serve the bundle with an HTTP server
FROM nginx:1.27.0

# Copy the build output from the previous stage to Nginx's public folder
COPY --from=build /app/build /usr/share/nginx/html

```
🎯 Explanation:

Stage 1 (build):
Uses **Node.js** to install dependencies and create a production build of the React app. This stage produces the static files inside the build folder.

Stage 2 (serve):
Uses the official **Nginx** image to serve the static files. It copies the build folder from the previous stage into Nginx’s default directory for static content.

Benefits:

The final Docker image contains only the lightweight Nginx server and the static files, not the entire Node.js environment or source code, resulting in a much smaller and secure image.

---------------------------------------

## 🔟 Build the Docker Image with Nginx
Build the Docker image using the multi-stage Dockerfile with the Nginx server:

```bash
docker build -t react_app:blue .

```
🎯 This creates an image named react_app with the tag blue.

---------------------------------------

## 1️⃣1️⃣ Run the Container and Map Ports
Run the container in detached mode and map port 3000 on your host to port 80 inside the container (blue default):

```bash
docker run -d -p 3000:80 react_app:blue

```
🎯 You can now access the app at http://localhost:3000.

---------------------------------------

## 1️⃣2️⃣ Monitor Container Logs
To see requests coming into the Nginx server, including JavaScript, CSS, and media file requests, tail the container logs:

```bash
docker logs -f <container_id_or_name>

```
🎯 Meanwhile, access the app in your browser at http://localhost:3000.

---------------------------------------

## 1️⃣3️⃣ Make Code Changes

🎯 Switch back to your IDE (e.g., VS Code) and modify App.tsx or any source file, then save your changes.
---------------------------------------

## 1️⃣4️⃣ Refresh Browser — No Changes Yet
Go back to your browser and refresh the page at http://localhost:3000.

🎯 You will not see any changes because the running container uses the old image. The new code is not reflected until you rebuild and redeploy.


 
---------------------------------------

## 1️⃣5️⃣ Stop Logs and Rebuild New Image
Stop tailing logs (e.g., press Ctrl+C), then rebuild your Docker image with a new tag (e.g., green):

```bash
docker build -t react_app:green .

```
🎯 
---------------------------------------

## 1️⃣6️⃣ Run the New Version on a Different Port
Run the new image on port 3001, so both old and new versions run side by side:

```bash
docker run -d -p 3001:80 react_app:green

```
🎯 
---------------------------------------

## 1️⃣7️⃣ Compare Old and New Versions
Visit http://localhost:3000 to see the old version still running.

Visit http://localhost:3001 to see the new version with your recent code changes.

🎯 
---------------------------------------

## 1️⃣8️⃣Summary: Green-Blue Deployment Example
🎯 By running two versions of the app simultaneously on different ports, you create a simple green-blue deployment setup:

**Blue**: The current stable version (react_app:blue on port 3000)

**Green**: The new version being tested (react_app:green on port 3001)

This allows smooth updates and easy rollbacks without downtime.
