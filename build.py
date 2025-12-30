import asyncio
import os
from e2b import AsyncTemplate, default_build_logger
from template import template


async def main():
    commit_id = os.environ.get("COMMIT_ID")
    if not commit_id:
        raise ValueError("COMMIT_ID environment variable is required")
    
    env = os.environ.get("TEMPLATE_ENV")
    if not env:
        raise ValueError("TEMPLATE_ENV environment variable is required")
    
    alias = f"{env}-paraflow-template-{commit_id}"
    
    await AsyncTemplate.build(
        template,
        alias=alias,
        cpu_count=8,
        memory_mb=8192,
        on_build_logs=default_build_logger(),
    )
    
    # 输出到 GitHub Actions
    github_output = os.environ.get("GITHUB_OUTPUT")
    if not github_output:
        raise ValueError("GITHUB_OUTPUT environment variable is required (must run in GitHub Actions)")
    with open(github_output, "a") as f:
        f.write(f"template_alias={alias}\n")
    
    # 输出到 GitHub Actions Job Summary
    github_summary = os.environ.get("GITHUB_STEP_SUMMARY")
    if not github_summary:
        raise ValueError("GITHUB_STEP_SUMMARY environment variable is required (must run in GitHub Actions)")
    with open(github_summary, "a") as f:
        f.write(f"## E2B Template Built\n")
        f.write(f"- **Alias**: `{alias}`\n")
        f.write(f"- **Environment**: `{env}`\n")
        f.write(f"- **Commit**: `{commit_id}`\n")
    
    print(f"Template built successfully: {alias}")


if __name__ == "__main__":
    asyncio.run(main())