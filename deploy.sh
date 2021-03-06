#!/bin/sh

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

hugo -D

cd public

git add .
msg="rebuilding site $(date)"
if [ -n "$*" ]; then
	msg="$*"
fi
git commit -m "$msg"

color_print "\nPushing generated static blog files...\n";
git push

cd ..

git add .
msg="rebuilding site $(date)"
if [ -n "$*" ]; then
	msg="$*"
fi
git commit -m "$msg"

color_print "\nPushing source filess...\n";
git push