# Stage 1: Build the application
FROM node:20 AS builder
WORKDIR /app

# First, copy all project files to the builder stage
# This includes src, tsconfig.json, package.json, etc.
COPY . .

# Now, install all dependencies and run the build script
# The 'prepare' script in package.json will trigger 'npm run build' automatically
RUN npm install

# Stage 2: Create the final production image from a slim base
FROM node:20-slim
WORKDIR /app

# Copy package.json and package-lock.json first to leverage Docker cache
COPY package.json package-lock.json ./
# Install ONLY production dependencies and DO NOT run any scripts (like build)
RUN npm install --omit=dev --ignore-scripts

# Copy the compiled application code from the builder stage
COPY --from=builder /app/build ./build

# Copy any other necessary files
COPY --from=builder /app/AGENTS.md ./

# Expose the port the app will run on
EXPOSE 8000

# Set the command to run the application
CMD ["node", "build/index.js"]
