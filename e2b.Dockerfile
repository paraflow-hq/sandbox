# Use pnpm image to get pnpm binary
FROM pnpm/pnpm:latest-alpine as pnpm

# Full-stack development environment with Node.js, Python, and CLI tools
FROM e2bdev/code-interpreter:latest

# Install Claude Code CLI
RUN pnpm install -g @anthropic-ai/claude-code

# Install GitHub CLI
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg && \
    chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null && \
    apt-get update && \
    apt-get install -y gh

RUN pip install claude-code-sdk anyio
