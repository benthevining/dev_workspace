#!/bin/sh

WORKING_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

WORKING_DIR+="/../Cache/install_ruby"

if [ ! -d "$WORKING_DIR" ]; then  
	mkdir $WORKING_DIR
fi

cd $WORKING_DIR

curl --remote-name https://raw.githubusercontent.com/monfresh/install-ruby-on-macos/master/install-ruby

/usr/bin/env bash $WORKING_DIR/install-ruby 2>&1 | tee $WORKING_DIR/install.log

exit 0