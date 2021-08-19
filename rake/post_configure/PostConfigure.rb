require_relative "DefaultGithubRepo/RepoUtils.rb"
require_relative "clangformat.rb"

module PostConfig

	def self.run()
		GitIgnore.update()
		GithubScripts.update()
		ClangFormat.configure()
	end
end