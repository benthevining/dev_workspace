def strip_array_foreach_chars(input)
	return input.to_s.gsub("[", "").gsub("]", "").gsub("\"", "")
end

require_relative "constants.rb"
require_relative "os.rb"
require_relative "files.rb"