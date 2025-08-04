# Full-stack development environment with Node.js, Python, and CLI tools
FROM e2bdev/code-interpreter:latest

# Install Claude Code CLI
RUN npm install -g @anthropic-ai/claude-code
RUN npx playwright install chrome
RUN useradd -m -s /bin/bash user
RUN runuser -u user -- claude mcp add playwright npx @playwright/mcp@latest

# Install pnpm
RUN npm install -g pnpm

# Configure pnpm global bin directory
ENV PNPM_HOME="/root/.local/share/pnpm"
ENV PATH="$PNPM_HOME:$PATH"
RUN mkdir -p $PNPM_HOME

# Install GitHub CLI
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg && \
    chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null && \
    apt-get update && \
    apt-get install -y gh

RUN pip install claude-code-sdk anyio

# Install s3fs
RUN apt-get install s3fs
