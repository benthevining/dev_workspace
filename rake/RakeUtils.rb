def strip_array_foreach_chars(input)
	return input.to_s.gsub("[", "").gsub("]", "").gsub("\"", "").gsub(",", "")
end


require_relative "mode.rb"
require_relative "constants.rb"
require_relative "os.rb"


Rake.application.options.trace = DEBUG_OUTPUT
verbose(DEBUG_OUTPUT)


require_relative "git.rb"

require_relative "post_configure/PostConfigure.rb"

require_relative "cmake.rb"

require_relative "init.rb"

require_relative "JucePluginHost/juce_plugin_host.rb"

require_relative "clean.rb"

require_relative "tests.rb"