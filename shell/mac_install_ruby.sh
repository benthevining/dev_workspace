#!/usr/bin/env bash

set -euo pipefail

# first, check if ruby can already be found...
if command -v ruby &> /dev/null; then
	echo "Ruby is already installed on your machine!"
	exit 0
fi


working_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
working_dir+="/../Cache/install_ruby"

if [ ! -d "$working_dir" ]; then  
	mkdir $working_dir
fi

cd "$working_dir"

curl --remote-name https://raw.githubusercontent.com/monfresh/install-ruby-on-macos/master/install-ruby

/usr/bin/env bash "$working_dir/install-ruby" 2>&1 | tee "$working_dir/install.log"

exit 0