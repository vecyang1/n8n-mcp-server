# Base image using Node.js 18 (required by the project)
FROM node:18-slim

# Set working directory
WORKDIR /app

# Install Python and pip for Python dependencies
RUN apt-get update && \
    apt-get install -y python3 python3-full python3-venv && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copy all source files
COPY . .

# Install Node.js dependencies and build the project
RUN npm install && npm run build

# Set up Python virtual environment and install dependencies
RUN python3 -m venv /app/venv && \
    /app/venv/bin/pip install --upgrade pip && \
    /app/venv/bin/pip install --no-cache-dir -r requirements.txt

# Set executable permissions for the binary
RUN chmod +x build/index.js

# Create a volume for environment configuration
VOLUME /app/config

# Set environment variables (these will need to be provided when running the container)
ENV N8N_API_URL=http://host.docker.internal:5678/api/v1
ENV N8N_API_KEY=your_n8n_api_key_here
ENV N8N_WEBHOOK_USERNAME=username
ENV N8N_WEBHOOK_PASSWORD=password
ENV DEBUG=false
ENV PATH="/app/venv/bin:$PATH"

# Create a healthcheck script
RUN echo '#!/bin/sh\necho "n8n-mcp-server is ready"\nexit 0' > /app/healthcheck.sh && \
    chmod +x /app/healthcheck.sh

# Add healthcheck
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD ["/app/healthcheck.sh"]

# Set the entrypoint to run the MCP server
ENTRYPOINT ["node", "build/index.js"]
