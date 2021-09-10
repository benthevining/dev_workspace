module ClangFormat 

	def self.run()

		REPO_PATHS.each { |dir|
			ClangFormatHandle.process_dir(dir)
		}
	end
end