module GithubScripts

	def self.update()

		REPO_SUBDIRS.each { |subdir|

			sub_dir = strip_array_foreach_chars(subdir)
			next if sub_dir.empty?

			dir = REPO_ROOT + "/" + sub_dir

			GithubScriptsHandle.update_repo(dir)
		}
	end
end