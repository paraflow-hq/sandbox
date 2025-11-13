import asyncio
import os
from e2b import AsyncTemplate, default_build_logger
from template import template


async def main():
    commit_id = os.environ.get("COMMIT_ID")
    if not commit_id:
        raise ValueError("COMMIT_ID environment variable is required")
    
    alias = f"paraflow-template-{commit_id}"
    
    await AsyncTemplate.build(
        template,
        alias=alias,
        memory_mb=2048,
        on_build_logs=default_build_logger(),
    )


if __name__ == "__main__":
    asyncio.run(main())