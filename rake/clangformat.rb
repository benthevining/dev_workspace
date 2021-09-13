module ClangFormat 

	def self.process_dir(dir)

		Dir.chdir(dir) do
			Rake.sh "clang-format -i *.c *.h *.cpp *.hpp" do |ok, res| end

			Dir.glob("**/").each do |file|

				if dir[-1] == "/"
					newDir = dir + file
				else 
					newDir = dir + "/" + file
				end

				newDir.slice!(newDir.length-1, newDir.length) if newDir[-1] == "/"

				self.process_dir(newDir) if Dir.exist?(newDir)
			end
		end
	end


	def self.run()
		REPO_PATHS.each { |dir|
			self.process_dir(dir)
		}
	end


	def self.configure_repo(dir)

		to_clangformat_path = -> (basedir) {
			return basedir.to_s + "/.clang-format"
		}

		# copy the clang-format config file from the Workspace repo to all child repos
		Dir.chdir(dir) do 
			FileUtils.cp(to_clangformat_path.(REPO_ROOT), to_clangformat_path.(dir))
		end
	end
end