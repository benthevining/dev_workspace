require "open3"


module Log 

	@@log_file = REPO_ROOT + "/Builds/build.log"

	def self.delete()
		File.delete(@@log_file) if File.exist?(@@log_file)
		deployedFile = REPO_ROOT + "/Builds/deploy/build.log"
		File.delete(deployedFile) if File.exist?(deployedFile)
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

		#-----  write log file  -----#

		File.new(@@log_file, "w") unless File.exist?(@@log_file)

		File.open(@@log_file, "w") { |f| 
			f.write("Build start time: " + startTimeString.to_s + "\n")
			f.write("Build end time: " + endTimeString.to_s + "\n")
			f.write("Total build duration: " + duration + "\n\n")

			f.write("Original command line invocation: \n" + command + "\n")

			f.write("Build exit status: " + exit_code + "\n")

			f.write("\n \n  -- ERRORS -- \n" + stderr) unless stderr.empty?

			f.write("\n \n" + stdout)
		}

		#-----  copy log file to deploy dir  -----#
		deploy_dir = REPO_ROOT + "/Builds/deploy"

		FileUtils.mkdir(deploy_dir) unless Dir.exist?(deploy_dir)

		dest = deploy_dir + "/build.log"

		File.new(dest, "w") unless File.exist?(dest)

		FileUtils.cp(@@log_file, dest)

		# HACK: for now, capturing the build output to the log file prevents CI builds from failing even if the build exits with a code other than 0
		# so until I can find a fix for this, manually check for failure to fail the CI build if the build didn't succeed
		if exit_code != "0"
			puts "\n Build failed. Check the log file for details."
			exit false
		end

		puts "\n Build succeeded!\n Build exit status: " + exit_code
	end

end