require_relative "DefaultGithubRepo/RepoUtils.rb"

require_relative "clangformat.rb"

module PostConfig

	def self.run()

		REPO_SUBDIRS.each { |repo|

			subdir = strip_array_foreach_chars(repo)
			next if subdir.empty?

			path = REPO_ROOT + "/" + subdir

			RepoUtils.configure(path)
		}
	end
end