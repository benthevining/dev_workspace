def strip_array_foreach_chars(input)
	return input.to_s.gsub("[", "").gsub("]", "").gsub("\"", "")
end


require_relative "constants.rb"

require_relative "os.rb"
require_relative "files.rb"

require_relative "git.rb"
require_relative "clangformat.rb"

require_relative "default_gitignore/gitignore.rb"
require_relative "github_scripts/github_scripts.rb"

require_relative "cmake.rb"
require_relative "init.rb"