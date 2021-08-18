module GitIgnore

	def self.update()

		root = FileAide.root()

		REPO_SUBDIRS.each { |subdir|

			sub_dir = strip_array_foreach_chars(subdir)

			next if sub_dir.empty?

			dir = root + "/" + sub_dir

			path = dir + ".gitignore"

			File.delete(path) if File.exist?(path)

			source = File.expand_path(File.dirname(__FILE__)) + "/default_gitignore.txt"

			FileUtils.cp(source, path)
		}
	end
end