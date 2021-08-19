module CMake

	def self.configure(mode)

		command = "cmake -B Builds -DCMAKE_BUILD_TYPE=" + mode

		command += " -G Xcode" if OS.mac?

		Rake.sh command

		PostConfig.run
	end


	def self.build_all(mode)
		command = "cmake --build Builds --config " + mode
		Rake.sh command
	end


	def self.build_plugin_target(target, mode, *formats)

		def self.build_all_formats_for_plugin(target, mode)
			command = "cmake --build Builds --target " + target + "_All" + " --config " + mode
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

		command = "cmake --build Builds --target " + targetNames.join(" ") + " --config " + mode
		Rake.sh command
	end


	def self.build_app_target(target, mode)
		command = "cmake --build Builds --target " + target + " --config " + mode
		Rake.sh command
	end
	
end