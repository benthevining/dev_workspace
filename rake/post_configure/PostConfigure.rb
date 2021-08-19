require_relative "DefaultGithubRepo/RepoUtils.rb"

require_relative "clangformat.rb"

module PostConfig

	def self.run()

		REPO_PATHS.each { |dir|
			path = strip_array_foreach_chars(dir)
			next if path.empty?

			RepoUtils.configure(path)
		}
	end
end