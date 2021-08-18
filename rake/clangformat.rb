module ClangFormat

	def self.process_dir(dir)

		puts dir

		Dir.chdir(dir) do

			file_types = "*.c *.h *.cpp *.hpp"
			command = "clang-format -i " + file_types

			Rake.sh command do |ok, res| end

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