from e2b import AsyncTemplate

template = (
    AsyncTemplate()
    .from_template("code-interpreter-v1")
    .set_user("root")
    .set_workdir("/")
    # 系统配置
    .run_cmd("sysctl fs.inotify.max_user_watches=131070 && sysctl -p")
    # 安装系统工具
    .run_cmd("apt-get update")
    .run_cmd("apt-get install -y strace htop curl wget unzip")
    # 安装 GitHub CLI
    .run_cmd(
        'curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg && chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null'
    )
    .run_cmd("apt-get update && apt-get install -y gh")
    # 安装 npm 全局包
    .run_cmd(
        "npm install -g tsx@^4.7.0 @anthropic-ai/claude-code@2.0.36 axios@^1.6.0 adm-zip@^0.5.10 form-data@^4.0.0 @datadog/datadog-api-client tar systeminformation"
    )
    .run_cmd("npx playwright install chrome")
    .run_cmd("npm install -g pnpm")
    .run_cmd("pnpm --package=@ast-grep/cli dlx ast-grep --version")
    # 配置 pnpm 环境变量
    .set_envs({"PNPM_HOME": "/root/.local/share/pnpm"})
    .set_envs({"PATH": "$PNPM_HOME:$PATH"})
    .run_cmd("mkdir -p $PNPM_HOME")
    # 安装 Python 包
    .run_cmd(
        "pip install claude-code-sdk claude-agent-sdk==0.1.6 anyio boto3 e2b-code-interpreter GitPython datadog-api-client"
    )
    # 切换到普通用户
    .set_user("user")
    .set_workdir("/home/user")
    # 用户环境配置
    .run_cmd("curl -fsSL https://opencode.ai/install | bash")
    .run_cmd(
        "wget https://paraflow-online.s3.amazonaws.com/public/resource/txom_prompt/txom-prompt.main.zip -O /home/user/txom-prompt.main.zip"
    )
    .run_cmd(
        "unzip /home/user/txom-prompt.main.zip -d /home/user/txom && cd /home/user/txom/txom-dev/demo/ && pnpm install"
    )
    # 清理临时文件
    .run_cmd("rm -rf /home/user/txom-prompt.main.zip")
    .run_cmd("rm -rf /home/user/txom")
)
