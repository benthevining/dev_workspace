module CMake

	def self.configure(mode)

		command = "cmake -B Builds -DCMAKE_BUILD_TYPE=" + mode

		if OS.mac?
			command += " -G Xcode"
		elsif OS.windows?
			command += " -G \"Visual Studio 16 2019\""
		end # use default Ninja generator on Linux

		Rake.sh command

		PostConfig.run
	end


	default_cmake_command = "cmake --build Builds"


	def self.default_cmake_command_suffix(mode) 

		suffix = " --config " + mode + " -j " + NUM_CPU_CORES
		return suffix
	end


	def self.build_all(mode)
		command = default_cmake_command + self.default_cmake_command_suffix(mode)
		Rake.sh command
	end


	def self.build_plugin_target(target, mode, *formats)

		def self.build_all_formats_for_plugin(target, mode)
			command = default_cmake_command + " --target " + target + "_All" + self.default_cmake_command_suffix(mode)
			Rake.sh command
		end

		if formats.empty?
			self.build_all_formats_for_plugin(target, mode)
			return
		end

		targetNames = Array.new

		formats.each { |format|
			formatString = strip_array_foreach_chars(format)

			next if formatString.empty?

			if formatString.downcase == "all"
				build_all_formats_for_plugin(target, mode)
				return
			end

			name = target + "_" + formatString.upcase

			name = "Standalone" if name == "STANDALONE"

			targetNames.push(name)
		}

		if targetNames.empty?
			self.build_all_formats_for_plugin(target, mode)
			return
		end

		command = default_cmake_command + " --target " + targetNames.join(" ") + self.default_cmake_command_suffix(mode)
		Rake.sh command
	end


	def self.build_app_target(target, mode)
		command = default_cmake_command + " --target " + target + self.default_cmake_command_suffix(mode)
		Rake.sh command
	end
	
end