require "open3"


module Log 

	@@build_log_file = REPO_ROOT + "/Builds/build.log"
	@@config_log_file = REPO_ROOT + "/Builds/config.log"


	def self.delete_build_log()
		File.delete(@@build_log_file) if File.exist?(@@build_log_file)
		deployedFile = REPO_ROOT + "/Builds/deploy/logs/build.log"
		File.delete(deployedFile) if File.exist?(deployedFile)
	end

	def self.delete_config_log()
		File.delete(@@config_log_file) if File.exist?(@@config_log_file)
		deployedFile = REPO_ROOT + "/Builds/deploy/logs/config.log"
		File.delete(deployedFile) if File.exist?(deployedFile)
	end


	def self.create_log_dir_if_needed()
		deploy_dir = REPO_ROOT + "/Builds/deploy"
		FileUtils.mkdir(deploy_dir) unless Dir.exist?(deploy_dir)

		log_dir = deploy_dir + "/logs"
		FileUtils.mkdir(log_dir) unless Dir.exist?(log_dir)

		return log_dir
	end


	def self.capture_config_output(command)

		startTime = Time.now

		puts "\n" + command
		stdout, stderr, status = Open3.capture3(command)  

		exit_code = status.to_s[-1]

		duration = FormattedTime.compare(startTime, Time.now).to_s

		puts "Configure duration: " + duration

		#-----  write to log file  -----#

		File.new(@@config_log_file, "w") unless File.exist?(@@config_log_file)

		File.open(@@config_log_file, "w") { |f| 
			f.write("Configure duration: " + duration + "\n\n")
			f.write("Original command line invocation: \n" + command + "\n")
			f.write("CMake exit code: " + exit_code + "\n")
			f.write("\n \n  -- ERRORS -- \n" + stderr) unless stderr.empty?
			f.write("\n \n" + stdout)
		}

		#-----  copy log file to deploy dir  -----#

		dest = self.create_log_dir_if_needed().to_s + "/config.log"

		File.new(dest, "w") unless File.exist?(dest)

		FileUtils.cp(@@config_log_file, dest)

		# HACK: for now, capturing the output to the log file prevents CI builds from failing even if the build exits with a code other than 0
		# so until I can find a fix for this, manually check for failure to fail the CI build if the build didn't succeed
		if exit_code != "0"
			abort "Configuration failed. Check the log file for details."
		end

		puts "\n Configuration succeeded!\n CMake exit code: " + exit_code
	end


	def self.capture_build_output(command)

		#  record build start time
		startTimeObject = Time.now
		startTimeString = FormattedTime.get(startTimeObject).to_s
		puts "\n Build start time: " + startTimeString

		puts "\n" + command
		stdout, stderr, status = Open3.capture3(command)  # this performs the actual build

		exit_code = status.to_s[-1]

		#  record build end time
		endTimeObject = Time.now
		endTimeString = FormattedTime.get(endTimeObject).to_s
		puts "\n Build end time: " + endTimeString

		#  calculate build duration
		duration = FormattedTime.compare(startTimeObject, endTimeObject).to_s
		puts "\n Build duration: " + duration

		#-----  write to log file  -----#

		File.new(@@build_log_file, "w") unless File.exist?(@@build_log_file)

		File.open(@@build_log_file, "w") { |f| 
			f.write("Build start time: " + startTimeString.to_s + "\n")
			f.write("Build end time: " + endTimeString.to_s + "\n")
			f.write("Total build duration: " + duration + "\n\n")
			f.write("Original command line invocation: \n" + command + "\n")
			f.write("Build exit status: " + exit_code + "\n")
			f.write("\n \n  -- ERRORS -- \n" + stderr) unless stderr.empty?
			f.write("\n \n" + stdout)
		}

		#-----  copy log file to deploy dir  -----#

		dest = self.create_log_dir_if_needed().to_s + "/build.log"

		File.new(dest, "w") unless File.exist?(dest)

		FileUtils.cp(@@build_log_file, dest)

		# HACK -- see comment above
		if exit_code != "0"
			abort "Build failed. Check the log file for details."
		end

		puts "\n Build succeeded!\n Build exit status: " + exit_code
	end

end