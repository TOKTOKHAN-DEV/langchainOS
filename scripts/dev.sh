#!/bin/bash

# Kill existing Node.js processes if running
if pgrep -f "node" > /dev/null; then
    echo "🔄 Terminating existing Node.js processes..."
    pkill -f "node"
fi

echo "🚀 Starting development server..."

# Check if turbo flag is passed
if [ "$1" = "--turbo" ]; then
    echo "📦 Running with Turborepo..."
    pnpm turbo dev
else
    # Default: Execute agents/index.ts
    echo "🔨 Running standard dev mode..."
    # Load environment variables from .env file if it exists
    if [ -f ".env" ]; then
        echo "📝 Loading environment variables from .env file..."
        source .env
    fi
    pnpm exec ts-node apps/agents/src/index.ts
fi
