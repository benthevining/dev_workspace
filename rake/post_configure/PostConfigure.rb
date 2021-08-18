require_relative "clang_format/clangformat.rb"
require_relative "default_gitignore/gitignore.rb"
require_relative "github_scripts/github_scripts.rb"

module PostConfig

	def self.run()
		GitIgnore.update()
		GithubScripts.update()
		ClangFormat.configure()
	end
end