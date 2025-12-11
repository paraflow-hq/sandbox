from e2b import AsyncTemplate

template = (
    AsyncTemplate()
    .from_template("code-interpreter-v1")
    .set_user("root")
    .set_workdir("/")
    .run_cmd("npm install -g @anthropic-ai/claude-code@2.0.36")
    .run_cmd("npm install -g @datadog/datadog-api-client")
    .run_cmd("npx playwright install chrome")
    .run_cmd("npm install -g pnpm")
    .set_envs({
        "PNPM_HOME": "/root/.local/share/pnpm",
    })
    .set_envs({
        "PATH": "$PNPM_HOME:$PATH",
    })
    .run_cmd("mkdir -p $PNPM_HOME")
    .run_cmd("curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg && chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg && echo \"deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main\" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null && apt-get update && apt-get install -y gh")
    .run_cmd("pip install claude-code-sdk claude-agent-sdk==0.1.6 anyio boto3 e2b-code-interpreter GitPython datadog-api-client")
    .set_user("user")
    .set_workdir("/home/user")
)
