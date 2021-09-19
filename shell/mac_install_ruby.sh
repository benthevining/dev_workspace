#!/usr/bin/env bash

set -euo pipefail

# first, check if ruby can already be found...
if command -v ruby &> /dev/null; then
	echo "Ruby is already installed on your machine!"
	exit 0
fi


WORKING_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
WORKING_DIR+="/../Cache/install_ruby"

if [ ! -d "$WORKING_DIR" ]; then  
	mkdir $WORKING_DIR
fi

cd $WORKING_DIR

curl --remote-name https://raw.githubusercontent.com/monfresh/install-ruby-on-macos/master/install-ruby

/usr/bin/env bash $WORKING_DIR/install-ruby 2>&1 | tee $WORKING_DIR/install.log

exit 0