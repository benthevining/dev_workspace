require_relative "DefaultGithubRepo/RepoUtils.rb"

require_relative "clangformat.rb"

module PostConfig

	def self.run()

		REPO_PATHS.each { |dir|
			RepoUtils.configure(dir)
		}
	end
end