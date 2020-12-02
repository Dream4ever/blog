#!/bin/sh

# Define colors
color_print () {
  BLUE_COLOR="96m";

  STARTCOLOR="\e[$BLUE_COLOR";
  ENDCOLOR="\e[0m"; # white

  printf "$STARTCOLOR%b$ENDCOLOR" "$1";
}

# If a command fails then the deploy stops
set -e

color_print "Deploying updates to GitHub...\n\n" "info";

color_print "Set proxy for GitHub...\n\n" "info";
export https_proxy=http://127.0.0.1:7890 http_proxy=http://127.0.0.1:7890 all_proxy=socks5://127.0.0.1:7890

# Build the project
hugo -D

# Go To Public folder
cd public

color_print "\nPush generated static blog files...\n" "info";
# Push generated static blog files
git push

# Go to root directory
cd ..

color_print "\nPush source filess...\n" "info";
# Push source filess
git push