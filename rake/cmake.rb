module CMake

	def self.configure()
		if OS.mac?
			Rake.sh "cmake -B Builds -G Xcode"
		else
			Rake.sh "cmake -B Builds"
		end
	end


	def self.configure_if_needed()

		dir = FileAide.root().to_s + "/Builds"

		if not Dir.exist?(dir)
			self.configure()
		end
	end


	def self.build_all(mode)
		command = "cmake --build Builds --config " + mode
		puts command
		Rake.sh command
	end


	def self.build_all_formats_for_plugin(target, mode)
		command = "cmake --build Builds --target " + target + "_All" + " --config " + mode
		puts command
		Rake.sh command
	end


	def self.build_plugin_target(target, mode, *formats)

		if formats.empty?
			self.build_all_formats_for_plugin(target, mode)
			return
		end

		targetNames = Array.new

		formats.each { |format|
			formatString = format.to_s.gsub("[", "").gsub("]", "").gsub("\"", "")

			next if (formatString == "[]" or formatString == "")

			name = target + "_" + formatString.upcase
			targetNames.push(name)
		}

		if targetNames.empty?
			self.build_all_formats_for_plugin(target, mode)
			return
		end

		command = "cmake --build Builds --target " + targetNames.join(" ") + " --config " + mode
		puts command
		Rake.sh command
	end


	def self.build_app_target(target, mode)
		command = "cmake --build Builds --target " + target + " --config " + mode
		puts command
		Rake.sh command
	end
	
end