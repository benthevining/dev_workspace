module ClangFormat 

	def self.run()

		REPO_SUBDIRS.each { |repo|

			subdir = strip_array_foreach_chars(repo)
			next if subdir.empty?

			path = REPO_ROOT + "/" + subdir

			ClangFormatHandle.process_dir(path) if Dir.exist?(path)
		}
	end
end