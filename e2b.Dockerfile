FROM e2bdev/code-interpreter:latest

RUN npm install -g @anthropic-ai/claude-code
RUN pip install claude-code-sdk anyio
