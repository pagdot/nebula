#!/bin/sh

get_latest_release() {
  curl --silent "https://api.github.com/repos/$1/releases/latest" | # Get latest release from GitHub api
    grep '"tag_name":' |                                            # Get tag line
    sed -E 's/.*"([^"]+)".*/\1/'                                    # Pluck JSON value
}

sudo apt install curl

VERSION=`get_latest_release slackhq/nebula | sed s/v//g`

echo Found VERSION=${VERSION}

echo "VERSION=${VERSION}" >> $GITHUB_ENV
