# Auth0 + Firebase + FastMCP MCP Server Starter

This example demonstrates how to create a FastMCP MCP server that uses Auth0 for authentication using the `auth0-api-python` library.

[![Open in IDX](https://cdn.idx.dev/btn/open_dark_32@2x.png)](https://idx.google.com/new?template=https://github.com/priley86/auth0-firebase-fastmcp)

## Features

- 🔐 **Secure Authentication** with Auth0 OAuth 2.0
- 🚀 **FastMCP** - High-performance MCP server built on Starlette
- 🔧 **Firebase Studio Ready** - Pre-configured for Firebase Studio (Project IDX)
- ☁️ **Cloud Run Deployment** - Production-ready deployment scripts for Google Cloud

## Available Tools

The server exposes the following tools:

- `whoami` - Returns authenticated user information and granted scopes
- `greet` - Personalized greeting demonstrating authenticated tool access
- `get_datetime` - Returns the current UTC date and time (no scope required)

## Install dependencies

```
poetry install
```

## Auth0 Tenant Setup

For detailed instructions on setting up your Auth0 tenant for MCP server integration, please refer to the [Auth0 Tenant Setup guide](https://github.com/auth0-samples/auth0-ai-samples/tree/main/auth-for-mcp/fastmcp-mcp-js/README.md#auth0-tenant-setup) in the FastMCP example.

Simplified instructions for this starter:

1. Authenticate with Auth0 CLI:
```
auth0 login --scopes "read:client_grants,create:client_grants,delete:client_grants,read:clients,create:clients,update:clients,read:resource_servers,create:resource_servers,update:resource_servers,read:roles,create:roles,update:roles,update:tenant_settings,read:connections,update:connections"
```
and verify you are using the correct Auth0 tenant after:
```
auth0 tenants list
```

2. Enable Dynamic Client Registration (DCR) and improved user consent experience:
```
auth0 tenant-settings update set flags.enable_dynamic_client_registration flags.use_scope_descriptions_for_consent
```

3. Create an API (Resource Server) for your MCP Server with Auth0
```
auth0 api post resource-servers --data '{
  "identifier": "auth0-fastmcp-api",
  "name": "MCP Tools API",
  "signing_alg": "RS256",
  "token_dialect": "rfc9068_profile_authz",
  "enforce_policies": true,
  "scopes": [
    {"value": "tool:whoami", "description": "Access the WhoAmI tool"},
    {"value": "tool:greet", "description": "Access the Greeting tool"}
  ]
}'
```


## Configuration

Copy `.env.example` to `.env` and configure the domain and audience:

```
# Auth0 tenant domain
AUTH0_DOMAIN=example-tenant.us.auth0.com

# Auth0 API Identifier
AUTH0_AUDIENCE=auth0-fastmcp-api
```

With the configuration in place, the example can be started by running:

```bash
poetry run python -m src.server
```

## Testing

Use an MCP client like [MCP Inspector](https://github.com/modelcontextprotocol/inspector) to test your server interactively:

```bash
npx @modelcontextprotocol/inspector
```

The server will start up and the UI will be accessible at http://localhost:6274.

In the MCP Inspector, select `Streamable HTTP` as the `Transport Type`, enter `http://localhost:3001/mcp` as the URL, and select `Via Proxy` for `Connection Type`.

### Using cURL

You can use cURL to verify that the server is running:

```bash
# Test that the server is running and accessible - check OAuth resource metadata
curl -v http://localhost:3001/.well-known/oauth-protected-resource

# Test MCP initialization (requires valid Auth0 access token)
curl -X POST http://localhost:3001/mcp \
  -H "Content-Type: application/json" \
  -H "Accept: application/json, text/event-stream" \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \
  -d '{"jsonrpc": "2.0", "id": 1, "method": "initialize", "params": {"protocolVersion": "2025-06-18", "capabilities": {}, "clientInfo": {"name": "curl-test", "version": "1.0.0"}}}'

# Test get_datetime tool (no scope required) - outputs ISO string like 2025-10-31T14:12:03.123Z
curl -X POST http://localhost:3001/mcp \
  -H "Content-Type: application/json" \
  -H "Accept: application/json, text/event-stream" \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \
  -d '{"jsonrpc": "2.0", "id": 2, "method": "tools/call", "params": {"name": "get_datetime", "arguments": {}}}'
```

**Note:** Use the MCP Inspector or other MCP-compatible clients for comprehensive testing.

## Firebase Studio (Project IDX)

This project is pre-configured for [Firebase Studio](https://firebase.google.com/docs/studio) (formerly Project IDX).

### Quick Start

1. Click the "Open in Firebase Studio" button above
2. Wait for the workspace to initialize (dependencies will be installed automatically)
3. Configure your `.env` file with your Auth0 credentials
4. The MCP server will start automatically!

> ⚠️ **Note for Firebase Studio users**: When testing with MCP Inspector, use the Firebase Studio preview URL (e.g., `https://3001-xxx.idx.dev/mcp`) as your MCP endpoint.

## Deployment

This project includes production-ready deployment scripts for Google Cloud Run.

See [DEPLOYMENT.md](DEPLOYMENT.md) for detailed instructions on:

- Setting up Google Cloud Platform
- Configuring production environment variables
- Deploying to Cloud Run
- Monitoring and troubleshooting

### Quick Deploy

```bash
# 1. Create production environment file
cp .env.example .env.production

# 2. Edit .env.production with your credentials
# - Set GCP_PROJECT_ID, AUTH0_DOMAIN, AUTH0_AUDIENCE

# 3. Deploy to Cloud Run
./scripts/deploy-mcp-server.sh
```

## Learn More

- [Auth0 Documentation](https://auth0.com/docs)
- [FastMCP Documentation](https://github.com/jlowin/fastmcp)
- [Firebase Studio Documentation](https://firebase.google.com/docs/studio)
- [Cloud Run Documentation](https://cloud.google.com/run/docs)

## License

This project is based on the [Auth0 AI Samples](https://github.com/auth0-samples/auth0-ai-samples) and is provided under the MIT License.
