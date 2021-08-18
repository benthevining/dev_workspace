module ClangFormat

	def self.process_dir(dir)

		file_types = "*.c *.h *.cpp *.hpp"

		command = "clang-format -i " + file_types

		puts dir

		Dir.chdir(dir) do

			Rake.sh command

			Dir.glob("**/").each do |file|

				newDir = dir + "/" + file

				next if not Dir.directory?(newDir)

				self.process_dir(newDir)
			end
		end
	end


	def self.run()
		self.process_dir(FileAide.root())
	end
end