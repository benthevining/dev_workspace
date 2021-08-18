module CMake

	def self.configure(mode)

		command = "cmake -B Builds -DCMAKE_BUILD_TYPE=" + mode

		if OS.mac?
			command += " -G Xcode"
		end

		Rake.sh command

		PostConfig.run()
	end


	def self.configure_if_needed(mode)

		dir = FileAide.root().to_s + "/Builds"

		if not Dir.exist?(dir)
			self.configure(mode)
		end
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

			name = target + "_" + formatString.upcase

			if (name == "STANDALONE") 
				name = "Standalone"
			end

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