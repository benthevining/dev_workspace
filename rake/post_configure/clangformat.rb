module ClangFormat 

	def self.run()

		REPO_PATHS.each { |dir|
			path = strip_array_foreach_chars(dir)
			next if path.empty?

			ClangFormatHandle.process_dir(path) if Dir.exist?(path)
		}
	end
end