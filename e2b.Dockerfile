FROM python:3.12-slim

# Install Node.js 22
RUN apt-get update && apt-get install -y curl
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash -
RUN apt-get install -y nodejs

# Install Claude Code CLI globally
RUN npm install -g @anthropic-ai/claude-code

# Install Python dependencies
RUN pip install claude-code-sdk anyio

# Set working directory
WORKDIR /workspace
