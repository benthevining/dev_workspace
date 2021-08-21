module CMake

	def self.configure(mode, repoDir, extraDefines = [])

		Dir.chdir(repoDir) do 

			command = "cmake -B Builds -DCMAKE_BUILD_TYPE=" + mode

			if not extraDefines.empty?
				extraDefines.each { |define|
					defString = strip_array_foreach_chars(define)
					next if defString.empty?
					command += " -D" + defString
				}
			end

			if OS.mac?
				command += " -G Xcode"
			elsif OS.windows?
				command += " -G \"Visual Studio 16 2019\""
			end # use default Ninja generator on Linux

			Rake.sh command

			PostConfig.run
		end
	end


	@@default_cmake_command = "cmake --build Builds"


	def self.default_cmake_command_suffix(mode) 
		return (" --config " + mode + " -j " + NUM_CPU_CORES)
	end


	def self.build_all(mode)
		Rake.sh (@@default_cmake_command + self.default_cmake_command_suffix(mode))
		puts "Built everything!"
	end


	def self.build_plugin_target(target, mode, firstFormat, restFormats)

		formats = [firstFormat]

		if not restFormats.empty?
			restFormats.each { |fmt|
				format = strip_array_foreach_chars(fmt)
				formats.push(format) if not format.empty?
			}
		end

		def self.build_all_formats_for_plugin(target, mode)
			Rake.sh (@@default_cmake_command + " --target " + target + "_All" + self.default_cmake_command_suffix(mode))
			puts "Built all formats for " + target
		end

		if formats.empty?
			self.build_all_formats_for_plugin(target, mode)
			return
		end

		actualFormats = Array.new
		targetNames = Array.new

		formats.each { |format|
			formatString = strip_array_foreach_chars(format).downcase
			next if formatString.empty?

			if formatString == "all"
				self.build_all_formats_for_plugin(target, mode)
				return
			end

			def self.to_formatted_formatString(formatString)
				if formatString == "standalone" || formatString == "unity"
					return formatString.capitalize
				end
				
				return formatString.upcase
			end

			newFormat = self.to_formatted_formatString(formatString)

			actualFormats.push(newFormat)

			targetName = target + "_" + newFormat

			targetNames.push(targetName)
		}

		if targetNames.empty? || actualFormats.empty?
			self.build_all_formats_for_plugin(target, mode)
			return
		end

		Rake.sh (@@default_cmake_command + " --target " + targetNames.join(" ") + self.default_cmake_command_suffix(mode))
		puts "Built formats of " + target + ": " + actualFormats.join(" ")
	end


	def self.build_app_target(target, mode)
		Rake.sh (@@default_cmake_command + " --target " + target + self.default_cmake_command_suffix(mode))
		puts "Built " + target
	end
	
end