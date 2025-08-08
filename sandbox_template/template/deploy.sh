#!/bin/bash

set -e

PROJECT_NAME=""
REPO_DESCRIPTION=""
GITHUB_USERNAME=""
GITHUB_TOKEN=""

# Load environment variables from .env.local if it exists
if [[ -f ".env.local" ]]; then
    echo "📄 Loading environment variables from .env.local..."
    source .env.local
fi

usage() {
    echo "Usage: $0 -n <project-name> -d <description> [-u <github-username>] [-t <github-token>]"
    echo "  -n: Project name (required)"
    echo "  -d: Repository description (required)"
    echo "  -u: GitHub username (optional, will use gh auth status if not provided)"
    echo "  -t: GitHub token (optional, can also be set in .env.local as GITHUB_TOKEN)"
    echo ""
    echo "Environment file (.env.local) example:"
    echo "  GITHUB_TOKEN=ghp_xxxxxxxxxxxxxxxxxxxx"
    echo "  GITHUB_USERNAME=your-username"
    exit 1
}

while getopts "n:d:u:t:h" opt; do
    case $opt in
        n) PROJECT_NAME="$OPTARG" ;;
        d) REPO_DESCRIPTION="$OPTARG" ;;
        u) GITHUB_USERNAME="$OPTARG" ;;
        t) GITHUB_TOKEN="$OPTARG" ;;
        h) usage ;;
        *) usage ;;
    esac
done

if [[ -z "$PROJECT_NAME" || -z "$REPO_DESCRIPTION" ]]; then
    usage
fi

echo "🚀 Starting deployment process..."

# Check if gh CLI is installed
if ! command -v gh &> /dev/null; then
    echo "❌ Error: GitHub CLI (gh) is not installed."
    echo "Install it from: https://cli.github.com/"
    exit 1
fi

# Handle GitHub authentication
if [[ -n "$GITHUB_TOKEN" ]]; then
    echo "🔑 Using provided GitHub token for authentication..."
    export GH_TOKEN="$GITHUB_TOKEN"
    # Test token validity
    if ! gh auth status &> /dev/null; then
        echo "❌ Error: Invalid GitHub token provided."
        exit 1
    fi
else
    # Check if user is authenticated with gh
    if ! gh auth status &> /dev/null; then
        echo "❌ Error: Not authenticated with GitHub CLI."
        echo "Run: gh auth login or provide a token with -t <token>"
        exit 1
    fi
fi

# Get GitHub username if not provided
if [[ -z "$GITHUB_USERNAME" ]]; then
    GITHUB_USERNAME=$(gh api user --jq '.login')
    echo "📝 Using GitHub username: $GITHUB_USERNAME"
fi

# Initialize git repository if not already initialized
if [[ ! -d ".git" ]]; then
    echo "📁 Initializing Git repository..."
    git init
    git branch -M main
else
    echo "📁 Git repository already exists"
fi

# Add all files and commit
echo "📝 Adding files to git..."
git add .

# Check if there are any changes to commit
if git diff --staged --quiet; then
    echo "⚠️  No changes to commit"
else
    echo "💾 Committing changes..."
    git commit -m "Initial commit: $PROJECT_NAME

🤖 Generated with Claude Code

Co-Authored-By: Claude <noreply@anthropic.com>"
fi

# Check if remote repository exists
REPO_EXISTS=$(gh repo view "$GITHUB_USERNAME/$PROJECT_NAME" &> /dev/null && echo "true" || echo "false")
REPO_URL="https://github.com/$GITHUB_USERNAME/$PROJECT_NAME"

if [[ "$REPO_EXISTS" == "false" ]]; then
    echo "🏗️  Creating GitHub repository..."
    
    # Remove existing origin remote if it exists to avoid conflicts
    if git remote get-url origin &> /dev/null; then
        echo "🗑️  Removing existing origin remote to avoid conflicts"
        git remote remove origin
    fi
    
    # Create repository with --remote=origin flag
    echo "📝 Creating repository with origin remote"
    gh repo create "$PROJECT_NAME" --description "$REPO_DESCRIPTION" --public --source=. --remote=origin
    
    # Configure git to use gh's credentials and push
    echo "🔧 Configuring git credentials via gh..."
    gh auth setup-git
    
    echo "🚀 Pushing code to repository..."
    git push -u origin main
    
    # Configure GitHub Pages immediately after repo creation
    echo "🔧 Configuring GitHub Pages with Actions..."
    sleep 3  # Wait for repo to be fully initialized
    
    # Enable GitHub Pages with Actions source
    if gh api repos/$GITHUB_USERNAME/$PROJECT_NAME/pages \
        --method POST \
        --field build_type="workflow" \
        2>/dev/null; then
        echo "✅ GitHub Pages configured successfully"
    else
        echo "⚠️  Note: GitHub Pages will be auto-configured after first workflow run"
    fi
else
    echo "📁 Repository '$GITHUB_USERNAME/$PROJECT_NAME' already exists on GitHub"
    echo "🔗 Repository URL: $REPO_URL"
    
    # Add origin remote if it doesn't exist
    if ! git remote get-url origin &> /dev/null; then
        echo "🔧 Adding origin remote..."
        git remote add origin "https://github.com/$GITHUB_USERNAME/$PROJECT_NAME.git"
        gh auth setup-git
    fi
    
    # Fetch latest changes from remote
    echo "🔄 Fetching latest changes from remote..."
    git fetch origin
    
    # Check if we're behind the remote
    LOCAL_COMMIT=$(git rev-parse HEAD 2>/dev/null || echo "")
    REMOTE_COMMIT=$(git rev-parse origin/main 2>/dev/null || echo "")
    
    if [[ "$LOCAL_COMMIT" != "$REMOTE_COMMIT" && -n "$REMOTE_COMMIT" ]]; then
        echo "⚠️  Local branch is different from remote. Attempting to merge..."
        
        # Try to pull with rebase to avoid merge commits
        if git pull --rebase origin main; then
            echo "✅ Successfully synchronized with remote"
        else
            echo "⚠️  Merge conflicts detected. Please resolve manually."
            echo "💡 Run: git pull origin main"
            exit 1
        fi
    fi
    
    # Check if there are any changes to push
    if git diff --staged --quiet && git diff HEAD origin/main --quiet 2>/dev/null; then
        echo "📝 No new changes to push"
    else
        echo "🚀 Pushing changes to repository..."
        
        # Create a new commit with current timestamp if there are changes
        TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
        git commit -m "Update: $TIMESTAMP

🤖 Generated with Claude Code

Co-Authored-By: Claude <noreply@anthropic.com>" 2>/dev/null || echo "📝 No additional changes to commit"
        
        # Push to remote
        git push origin main
        echo "✅ Changes pushed successfully"
    fi
fi


# Wait a moment and check if Actions workflow exists
echo "🚀 Triggering GitHub Actions deployment..."
sleep 2

# Check if workflow run started
WORKFLOW_STATUS=$(gh run list --repo "$GITHUB_USERNAME/$PROJECT_NAME" --limit 1 --json status,conclusion --jq '.[0].status' 2>/dev/null || echo "not_found")

if [[ "$WORKFLOW_STATUS" != "not_found" ]]; then
    echo "✅ GitHub Actions workflow triggered successfully"
    PAGES_URL="https://$GITHUB_USERNAME.github.io/$PROJECT_NAME"
    echo "🌐 Pages URL: $PAGES_URL (may take a few minutes to be available)"
else
    echo "⚠️  Workflow may need to be manually triggered"
fi

echo ""
echo ""
echo "✅ Deployment completed successfully!"
echo "🌐 Repository URL: $REPO_URL"
if [[ -n "$GITHUB_TOKEN" ]]; then
    echo "🔑 Used provided GitHub token for authentication"
fi
echo ""
echo "📝 Usage examples:"
echo "  ./deploy.sh -n my-project -d 'My awesome project'"
echo "  ./deploy.sh -n my-project -d 'My project' -u myusername"
echo "  ./deploy.sh -n my-project -d 'My project' -t ghp_xxxxxxxxxxxx"