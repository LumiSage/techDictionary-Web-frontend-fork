# Stage 1: Build the React app
FROM node:18-alpine AS builder

# Set working directory
WORKDIR /app

# Copy all files from the current directory to the working directory in the image
COPY . .

# Install node modules and build the React app
RUN npm install && npm run build

# Stage 2: Serve the app using Nginx
FROM nginx:alpine

# Set working directory to nginx asset directory
WORKDIR /usr/share/nginx/html

# Remove default nginx static assets
RUN rm -rf ./*

# Copy static assets from builder stage
COPY --from=builder /app/dist .

# Nginx configuration to work on port 80 (standard HTTP port)
RUN echo ' \
server { \
  listen 80; \
  server_name localhost; \
  \
  location / { \
    root /usr/share/nginx/html; \
    index index.html; \
    try_files $uri $uri/ /index.html; \
  } \
} \
' > /etc/nginx/conf.d/default.conf

# Expose port 80 to the outside world
EXPOSE 80

# Containers run nginx with global directives and daemon off
ENTRYPOINT ["nginx", "-g", "daemon off;"]
