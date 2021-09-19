#!/bin/bash

export BV_CROSSCOMPILE_IOS="TRUE"

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

bash $SCRIPT_DIR/ci_build.sh

if [ "$?" -ne "0" ]; then
	echo "Build script failed"
  	exit 1
fi

exit 0