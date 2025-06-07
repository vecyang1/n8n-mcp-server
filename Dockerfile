# Stage 1: Build the application
FROM node:20 as builder

WORKDIR /app

# Copy package configuration and install dependencies
COPY package.json package-lock.json ./
RUN npm install

# Copy the rest of the application source code
COPY . .

# Build the TypeScript source
RUN npm run build

# Stage 2: Create the production image
FROM node:20-slim

WORKDIR /app

# Copy package configuration and install only production dependencies
COPY package.json package-lock.json ./
RUN npm install --omit=dev

# Copy the built application from the builder stage
COPY --from=builder /app/build ./build

# Set executable permissions for the binary
RUN chmod +x build/index.js

# Expose the port the app runs on
EXPOSE 8000

# Set the entrypoint to run the MCP server
ENTRYPOINT ["node", "build/index.js"]
