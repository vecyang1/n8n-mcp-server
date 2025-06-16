# Stage 1: Build the application
FROM node:20 AS builder
WORKDIR /app

# First, copy all project files to the builder stage
COPY . .

# Now, install all dependencies and run the build script
RUN npm install

# Stage 2: Create the final production image from a slim base
FROM node:20-slim
WORKDIR /app

# Install ONLY production dependencies and DO NOT run any scripts (like build)
COPY package.json package-lock.json ./
RUN npm install --omit=dev --ignore-scripts

# Copy the compiled application code from the builder stage
COPY --from=builder /app/build ./build

# Copy any other necessary files
COPY --from=builder /app/AGENTS.md ./

# Expose the port the app will run on. Render will use the $PORT env var.
EXPOSE 8000

# Set the command to run the application in HTTP server mode
CMD ["node", "build/index.js", "--http"]
