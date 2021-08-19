require_relative "DefaultGithubRepo/RepoUtils.rb"

module PostConfig

	def self.run()
		GitIgnore.update()
		GithubScripts.update()
		ClangFormat.configure()
	end
end