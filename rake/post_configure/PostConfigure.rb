require_relative "DefaultGithubRepo/RepoUtils.rb"

require_relative "gitignore.rb"
require_relative "clangformat.rb"
require_relative "github_scripts.rb"

module PostConfig

	def self.run()
		GitIgnore.update()
		GithubScripts.update()
		ClangFormat.configure()
	end
end