module JucePluginHost

	@@JPH_FILE_PATH = File.expand_path(File.dirname(__FILE__)).to_s

	def self.build(mode)

		Dir.chdir(@@JPH_FILE_PATH) do 

			CMake.configure(mode)

			command = "cmake --build Builds" + CMake.default_cmake_command_suffix(mode)
			Rake.sh command
		end
	end


	def self.launch(mode)

		path = @@JPH_FILE_PATH + "/Builds/PluginHost/AudioPluginHost_artefacts/" + mode + "/AudioPluginHost.app"

		if (File.exist?(path))
			puts "Exists!"
		else
			puts "AudioPluginHost not found, building now..."
			Rake::Task["build:APH"].invoke(mode)
			self.launch(mode)
		end
	end


	def self.clean()
		path = @@JPH_FILE_PATH + "/Builds"
		FileUtils.remove_dir(path) if Dir.exist?(path)
	end
end