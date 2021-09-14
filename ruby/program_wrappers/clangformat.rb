module ClangFormat 

	def self.process_dir(dir)

		Dir.chdir(dir) do
			Rake.sh "clang-format -i *.c *.h *.cpp *.hpp" do |ok, res| end

			Dir.glob("**/").each do |file|

				newDir = dir[-1] == "/" ? dir + file : dir + "/" + file

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

end