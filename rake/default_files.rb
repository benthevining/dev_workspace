module DefaultRepoFiles

	def self.run()

		to_rel_path = -> (basedir, filename) {
			return basedir.to_s + "/" + filename.to_s
		}

		config_file_in_repo = -> (repodir, filename) {
			Dir.chdir(repodir) do 
				FileUtils.cp(to_rel_path.(REPO_ROOT, filename), to_rel_path.(repodir, filename))
			end
		}

		config_file = -> (filename) {
			REPO_PATHS.each { |dir|
				config_file_in_repo.(dir, filename)
			}
		}

		config_file.(".clang-format")
		config_file.(".gitignore")
	end

end