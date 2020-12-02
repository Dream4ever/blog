#!/bin/sh

# If a command fails then the deploy stops
set -e

printf "\033[0;32mDeploying updates to GitHub...\033[0m\n"

export https_proxy=http://127.0.0.1:7890 http_proxy=http://127.0.0.1:7890 all_proxy=socks5://127.0.0.1:7890

# Build the project
hugo -D

# Go To Public folder
cd public

# Push generated static blog files
git push

# Go to root directory
cd ..

# Push source filess
git push