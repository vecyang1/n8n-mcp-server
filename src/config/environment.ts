/**
 * Environment Configuration
 * 
 * This module handles loading and validating environment variables
 * required for connecting to the n8n API.
 */

import dotenv from 'dotenv';
import { McpError } from '@modelcontextprotocol/sdk/types.js';
import { ErrorCode } from '../errors/error-codes.js';

// Environment variable names
export const ENV_VARS = {
  N8N_API_URL: 'N8N_API_URL',
  N8N_API_KEY: 'N8N_API_KEY',
  N8N_WEBHOOK_USERNAME: 'N8N_WEBHOOK_USERNAME',
  N8N_WEBHOOK_PASSWORD: 'N8N_WEBHOOK_PASSWORD',
  DEBUG: 'DEBUG',
};

// Interface for validated environment variables
export interface EnvConfig {
  n8nApiUrl: string;
  n8nApiKey: string;
  n8nWebhookUsername: string;
  n8nWebhookPassword: string;
  debug: boolean;
}

/**
 * Load environment variables from .env file if present
 */
export function loadEnvironmentVariables(): void {
  dotenv.config();
}

/**
 * Validate and retrieve required environment variables
 * 
 * @returns Validated environment configuration
 * @throws {McpError} If required environment variables are missing
 */
export function getEnvConfig(): EnvConfig {
  const n8nApiUrl = process.env[ENV_VARS.N8N_API_URL];
  const n8nApiKey = process.env[ENV_VARS.N8N_API_KEY];
  const n8nWebhookUsername = process.env[ENV_VARS.N8N_WEBHOOK_USERNAME];
  const n8nWebhookPassword = process.env[ENV_VARS.N8N_WEBHOOK_PASSWORD];
  const debug = process.env[ENV_VARS.DEBUG]?.toLowerCase() === 'true';

  // Validate required environment variables
  if (!n8nApiUrl) {
    throw new McpError(
      ErrorCode.InitializationError,
      `Missing required environment variable: ${ENV_VARS.N8N_API_URL}`
    );
  }

  if (!n8nApiKey) {
    throw new McpError(
      ErrorCode.InitializationError,
      `Missing required environment variable: ${ENV_VARS.N8N_API_KEY}`
    );
  }

  if (!n8nWebhookUsername) {
    throw new McpError(
      ErrorCode.InitializationError,
      `Missing required environment variable: ${ENV_VARS.N8N_WEBHOOK_USERNAME}`
    );
  }

  if (!n8nWebhookPassword) {
    throw new McpError(
      ErrorCode.InitializationError,
      `Missing required environment variable: ${ENV_VARS.N8N_WEBHOOK_PASSWORD}`
    );
  }

  // Validate URL format
  try {
    new URL(n8nApiUrl);
  } catch (error) {
    throw new McpError(
      ErrorCode.InitializationError,
      `Invalid URL format for ${ENV_VARS.N8N_API_URL}: ${n8nApiUrl}`
    );
  }

  return {
    n8nApiUrl,
    n8nApiKey,
    n8nWebhookUsername,
    n8nWebhookPassword,
    debug,
  };
}
