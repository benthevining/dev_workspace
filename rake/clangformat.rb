module ClangFormat

	def self.process_dir(dir)

		puts dir

		Dir.chdir(dir) do

			file_types = "*.c *.h *.cpp *.hpp"
			command = "clang-format -i " + file_types

			Rake.sh command do |ok, res| end

			Dir.glob("**/").each do |file|

				if dir[-1] == "/"
					newDir = dir + file
				else 
					newDir = dir + "/" + file
				end

				if newDir[-1] == "/"
					newDir.slice!(newDir.length-1, newDir.length)
				end

				self.process_dir(newDir) if Dir.exist?(newDir)
			end
		end
	end


	def self.run()

		root = FileAide.root()

		REPO_SUBDIRS.each { |repo|

			subdir = strip_array_foreach_chars(repo)
			next if subdir.empty?

			path = root + "/" + subdir

			self.process_dir(path) if Dir.exist?(path)
		}
	end
end