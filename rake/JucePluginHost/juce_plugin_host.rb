module JucePluginHost

	@@JPH_FILE_PATH = File.expand_path(File.dirname(__FILE__)).to_s

	def self.build(mode)

		CMake.configure(mode, @@JPH_FILE_PATH, ["BV_REPO_ROOT=#{REPO_ROOT}"])

		CMake.build_target(mode, "AudioPluginHost")

		Dir.chdir(@@JPH_FILE_PATH) do 
			CMake.build_target(mode, "AudioPluginHost")
			#Rake.sh (CMake.default_cmake_command_prefix + CMake.default_cmake_command_suffix(mode))
		end
	end


	def self.launch(mode)

		path = @@JPH_FILE_PATH + "/Builds/PluginHost/AudioPluginHost_artefacts/" + mode + "/AudioPluginHost.app"

		if not File.exist?(path)
			puts "AudioPluginHost not found, building now..."
			Rake::Task["build:APH"].invoke(mode)
			self.launch(mode)
			return
		end

		pid = spawn(path)
		Process.detach(pid)
	end


	def self.clean()
		path = @@JPH_FILE_PATH + "/Builds"
		FileUtils.remove_dir(path) if Dir.exist?(path)
	end
end