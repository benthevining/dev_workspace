require_relative "DefaultGithubRepo/RepoUtils.rb"

module PostConfig

	def self.run()

		REPO_PATHS.each { |dir|
			RepoUtils.configure(dir)
		}
	end
end