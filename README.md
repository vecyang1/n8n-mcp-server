# n8n MCP Server

A Model Context Protocol (MCP) server that allows AI assistants to interact with n8n workflows through natural language.

## Overview

This MCP server provides tools and resources for AI assistants to manage n8n workflows and executions. It allows assistants to:

- List, create, update, and delete workflows
- Activate and deactivate workflows
- Execute workflows and monitor their status
- Access workflow information and execution statistics

## Installation

### Prerequisites

- Node.js 18 or later
- n8n instance with API access enabled

### Install from npm

```bash
npm install -g n8n-mcp-server
```

### Install from source

```bash
# Clone the repository
git clone https://github.com/leonardsellem/n8n-mcp-server.git
cd n8n-mcp-server

# Install dependencies
npm install

# Build the project
npm run build

# Optional: Install globally
npm install -g .
```

### Docker Installation

You can also run the server using Docker:

```bash
# Pull the image
docker pull leonardsellem/n8n-mcp-server

# Run the container with your n8n API configuration
docker run -e N8N_API_URL=http://your-n8n:5678/api/v1 \
  -e N8N_API_KEY=your_n8n_api_key \
  -e N8N_WEBHOOK_USERNAME=username \
  -e N8N_WEBHOOK_PASSWORD=password \
  leonardsellem/n8n-mcp-server
```

## Configuration

Create a `.env` file in the directory where you'll run the server, using `.env.example` as a template:

```bash
cp .env.example .env
```

Configure the following environment variables:

| Variable | Description | Example |
|----------|-------------|---------|
| `N8N_API_URL` | Full URL of the n8n API, including `/api/v1` | `http://localhost:5678/api/v1` |
| `N8N_API_KEY` | API key for authenticating with n8n | `n8n_api_...` |
| `N8N_WEBHOOK_USERNAME` | Username for webhook authentication (if using webhooks) | `username` |
| `N8N_WEBHOOK_PASSWORD` | Password for webhook authentication | `password` |
| `DEBUG` | Enable debug logging (optional) | `true` or `false` |

### Generating an n8n API Key

1. Open your n8n instance in a browser
2. Go to Settings > API > API Keys
3. Create a new API key with appropriate permissions
4. Copy the key to your `.env` file

## Usage

### Running the Server

From the installation directory:

```bash
n8n-mcp-server
```

Or if installed globally:

```bash
n8n-mcp-server
```

### Integrating with AI Assistants

After building the server (`npm run build`), you need to configure your AI assistant (like VS Code with the Claude extension or the Claude Desktop app) to run it. This typically involves editing a JSON configuration file.

**Example Configuration (e.g., in VS Code `settings.json` or Claude Desktop `claude_desktop_config.json`):**

```json
{
  "mcpServers": {
    // Give your server a unique name
    "n8n-local": {
      // Use 'node' to execute the built JavaScript file
      "command": "node",
      // Provide the *absolute path* to the built index.js file
      "args": [
        "/path/to/your/cloned/n8n-mcp-server/build/index.js"
        // On Windows, use double backslashes:
        // "C:\\path\\to\\your\\cloned\\n8n-mcp-server\\build\\index.js"
      ],
      // Environment variables needed by the server
      "env": {
        "N8N_API_URL": "http://your-n8n-instance:5678/api/v1", // Replace with your n8n URL
        "N8N_API_KEY": "YOUR_N8N_API_KEY", // Replace with your key
        // Add webhook credentials only if you plan to use webhook tools
        // "N8N_WEBHOOK_USERNAME": "your_webhook_user",
        // "N8N_WEBHOOK_PASSWORD": "your_webhook_password"
      },
      // Ensure the server is enabled
      "disabled": false,
      // Default autoApprove settings
      "autoApprove": []
    }
    // ... other servers might be configured here
  }
}
```

**Key Points:**

*   Replace `/path/to/your/cloned/n8n-mcp-server/` with the actual absolute path where you cloned and built the repository.
*   Use the correct path separator for your operating system (forward slashes `/` for macOS/Linux, double backslashes `\\` for Windows).
*   Ensure you provide the correct `N8N_API_URL` (including `/api/v1`) and `N8N_API_KEY`.
*   The server needs to be built (`npm run build`) before the assistant can run the `build/index.js` file.

## Available Tools

The server provides the following tools:

### Using Webhooks

This MCP server supports executing workflows through n8n webhooks. To use this functionality:

1. Create a webhook-triggered workflow in n8n.
2. Set up Basic Authentication on your webhook node.
3. Use the `run_webhook` tool to trigger the workflow, passing just the workflow name.

Example:
```javascript
const result = await useRunWebhook({
  workflowName: "hello-world", // Will call <n8n-url>/webhook/hello-world
  data: {
    prompt: "Hello from AI assistant!"
  }
});
```

The webhook authentication is handled automatically using the `N8N_WEBHOOK_USERNAME` and `N8N_WEBHOOK_PASSWORD` environment variables.

### Workflow Management

- `workflow_list`: List all workflows
- `workflow_get`: Get details of a specific workflow
- `workflow_create`: Create a new workflow
- `workflow_update`: Update an existing workflow
- `workflow_delete`: Delete a workflow
- `workflow_activate`: Activate a workflow
- `workflow_deactivate`: Deactivate a workflow

### Execution Management

- `execution_run`: Execute a workflow via the API
- `run_webhook`: Execute a workflow via a webhook
- `execution_get`: Get details of a specific execution
- `execution_list`: List executions for a workflow
- `execution_stop`: Stop a running execution

## Resources

The server provides the following resources:

- `n8n://workflows/list`: List of all workflows
- `n8n://workflow/{id}`: Details of a specific workflow
- `n8n://executions/{workflowId}`: List of executions for a workflow
- `n8n://execution/{id}`: Details of a specific execution

## Development

### Building

```bash
npm run build
```

### Running in Development Mode

```bash
npm run dev
```

### Testing

```bash
npm test
```

### Linting

```bash
npm run lint
```

## License

MIT
