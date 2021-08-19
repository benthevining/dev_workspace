BV_DEBUG_OUTPUT = false

Rake.application.options.trace = BV_DEBUG_OUTPUT
verbose(BV_DEBUG_OUTPUT)

#

def strip_array_foreach_chars(input)
	return input.to_s.gsub("[", "").gsub("]", "").gsub("\"", "")
end

require_relative "constants.rb"
require_relative "os.rb"

require_relative "clean.rb"

require_relative "git.rb"

require_relative "post_configure/PostConfigure.rb"

require_relative "cmake.rb"
require_relative "init.rb"