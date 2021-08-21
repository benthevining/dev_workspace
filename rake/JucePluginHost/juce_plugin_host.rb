module JucePluginHost

	def self.build(mode)

		command = CMake.default_cmake_command + CMake.default_cmake_command_suffix(mode)
		puts command
		Rake.sh command
	end
end