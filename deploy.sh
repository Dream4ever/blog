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

color_print "Deploying updates to GitHub...\n\n";

color_print "Setting proxy for GitHub...\n\n";
export https_proxy=http://127.0.0.1:7890 http_proxy=http://127.0.0.1:7890 all_proxy=socks5://127.0.0.1:7890

# Build the project
hugo -D

# Go To Public folder
cd public

color_print "\nPushing generated static blog files...\n";
# Push generated static blog files
git push

# Go to root directory
cd ..

color_print "\nPushing source filess...\n";
# Push source filess
git push