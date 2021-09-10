module CMake

	def self.configure(mode, extraDefines = [])

		Dir.chdir(REPO_ROOT) do 

			command = "cmake -B Builds" 

			if (OS.linux?)
				command += " -DCMAKE_BUILD_TYPE=" + mode
			end

			if not extraDefines.empty?
				extraDefines.each { |define|
					next if define.empty?
					command += " -D" + define
				}
			end

			if OS.mac?
				command += " -G Xcode"
			elsif OS.windows?
				command += " -G \"Visual Studio 16 2019\""
			end # use default Ninja generator on Linux

			Rake.sh command
		end
	end


	def self.configure_ios(mode, extraDefines = [])

		if not OS.mac?
			puts "Warning - compiling for iOS is only recommended on MacOS."
			return
		end

		extraDefines.push("CMAKE_SYSTEM_NAME=iOS", 
						  "CMAKE_XCODE_ATTRIBUTE_CODE_SIGN_IDENTITY=\"iPhone Developer\"")

		# CMAKE_XCODE_ATTRIBUTE_DEVELOPMENT_TEAM=<10 character id>

		self.configure(mode, repoDir, extraDefines)
	end


	@@default_cmake_command = "cmake --build Builds"

	def self.default_cmake_command_suffix(mode) 
		return (" --config " + mode + " -j " + NUM_CPU_CORES)
	end


	def self.build_all(mode)
		Dir.chdir(REPO_ROOT) do 
			Rake.sh (@@default_cmake_command + self.default_cmake_command_suffix(mode))
		end

		puts "Built everything!"
	end


	def self.build_target(mode, target)
		Dir.chdir(REPO_ROOT) do 
			Rake.sh (@@default_cmake_command + " --target " + target + self.default_cmake_command_suffix(mode))
		end
	end


	def self.build_plugin(target, mode, firstFormat, restFormats)

		def self.build_all_formats_for_plugin(target, mode)
			self.build_target(mode, (target + "_All"))
			puts "Built all formats for " + target
		end

		if firstFormat.to_s.empty?
			self.build_all_formats_for_plugin(target, mode)
			return
		end


		formats = [firstFormat]

		if not restFormats.empty?
			restFormats.each { |format|
				formats.push(format) if not format.empty?
			}
		end

		if formats.empty?
			self.build_all_formats_for_plugin(target, mode)
			return
		end

		actualFormats = Array.new
		targetNames = Array.new

		formats.each { |format|
			
			format = format.to_s.downcase

			next if format.empty?

			if format == "all"
				self.build_all_formats_for_plugin(target, mode)
				return
			end

			def self.to_formatted_formatString(format)
				if format == "standalone" || format == "unity"
					return format.capitalize
				end
				
				return format.upcase
			end

			newFormat = self.to_formatted_formatString(format)

			actualFormats.push(newFormat)

			targetName = target + "_" + newFormat

			targetNames.push(targetName)
		}

		if targetNames.empty? || actualFormats.empty?
			self.build_all_formats_for_plugin(target, mode)
			return
		end

		self.build_target(mode, targetNames.join(" "))
		puts "Built formats of " + target + ": " + actualFormats.join(" ")
	end


	def self.build_app(target, mode)

		self.build_target(mode, target)
		puts "Built " + target
	end
end