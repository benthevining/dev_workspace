module GitIgnore

	def self.update()

		REPO_SUBDIRS.each { |subdir|

			sub_dir = strip_array_foreach_chars(subdir)

			next if sub_dir.empty?

			repo_path = REPO_ROOT + "/" + sub_dir

			GitIgnoreHandle.update_repo(repo_path)
		}
	end
end