module CMake

	def self.configure(mode, extraDefines = [])

		Log.delete_build_log
		Log.delete_config_log

		Dir.chdir(REPO_ROOT) do 

			command = "cmake -B Builds -DCMAKE_BUILD_TYPE=" + mode

			extraDefines.each { |define|
				command += " -D" + define unless define.empty?
			}

			if OS.mac?
				command += " -G Xcode"
			elsif OS.windows?
				command += " -G \"Visual Studio 16 2019\""
			end # use default Ninja generator on Linux

			Log.capture_config_output(command)
		end
	end


	def self.configure_ios(mode, extraDefines = [])

		return unless OS.mac?

		extraDefines.push("CMAKE_SYSTEM_NAME=iOS", 
						  "CMAKE_CROSSCOMPILING=TRUE",
						  "CMAKE_XCODE_ATTRIBUTE_CODE_SIGN_IDENTITY=\"iPhone Developer\"")

		# CMAKE_XCODE_ATTRIBUTE_DEVELOPMENT_TEAM=<10 character id>

		self.configure(mode, repoDir, extraDefines)
	end


	def self.build_target(target, mode)

		if not Dir.exist?(REPO_ROOT + "/Builds")
			puts "ERROR: your build directory hasn't been configured yet.\nTry running this command again after you run 'rake config'."
			exit false
		end

		command = "cmake --build Builds"

		command += (" --target " + target) unless target == "_ALL"

		command += (" --config " + mode + " -j " + NUM_CPU_CORES)

		Dir.chdir(REPO_ROOT) do 
			Log.capture_build_output(command)
		end

		puts "\n\n Built " + target + "! \n\n" unless target == "_ALL"
	end


	def self.build_all(mode)
		self.build_target("_ALL", mode)
		puts "Built everything!"
	end


	def self.build_plugin(target, mode, firstFormat, restFormats)

		build_all_formats_for_plugin = -> (target, mode) {
			self.build_target(target + "_All", mode)
			puts "Built all formats for " + target
		}

		formats = [firstFormat]

		restFormats.each { |format|
			formats.push(format) if not format.empty?
		}

		if formats.empty?
			build_all_formats_for_plugin.(target, mode)
			return
		end

		to_formatted_formatString = -> (formatName) {
			return formatName.capitalize if formatName == "standalone" || formatName == "unity"

			return "AUv3" if formatName == "auv3"

			return formatName.upcase
		}

		actualFormats = Array.new
		targetNames = Array.new

		formats.each { |format|
			
			format = format.to_s.downcase

			next if format.empty?

			if format == "all"
				build_all_formats_for_plugin.(target, mode)
				return
			end

			newFormat = to_formatted_formatString.(format)

			actualFormats.push(newFormat)

			targetName = target + "_" + newFormat

			targetNames.push(targetName)
		}

		if targetNames.empty? || actualFormats.empty?
			build_all_formats_for_plugin.(target, mode)
			return
		end

		targetNames.each { |target|
			self.build_target(target, mode)
		}

		puts "Built formats of " + target + ": " + actualFormats.join(" ")
	end

end