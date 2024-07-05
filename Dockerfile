# Use an official node image as a build stage
FROM node:18 AS build

# Set the working directory
WORKDIR /app

# Copy the package.json and package-lock.json files
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of your application files
COPY . .

# Build the app
RUN npm run build

# Use an official nginx image to serve the app
FROM nginx:alpine

# Copy the build files to the nginx html directory
COPY --from=build /app/dist /usr/share/nginx/html

# Copy the nginx configuration file
COPY nginx.conf /etc/nginx/nginx.conf

# Expose port 80
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
