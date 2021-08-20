def strip_array_foreach_chars(input)
	return input.to_s.gsub("[", "").gsub("]", "").gsub("\"", "").gsub(",", "")
end


require_relative "products/products.rb"
require_relative "constants.rb"


Rake.application.options.trace = DEBUG_OUTPUT
verbose(DEBUG_OUTPUT)


require_relative "os.rb"

require_relative "clean.rb"

require_relative "git.rb"

require_relative "post_configure/PostConfigure.rb"

require_relative "cmake.rb"
require_relative "init.rb"