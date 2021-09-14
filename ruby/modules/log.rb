require "open3"


module Log 

	@@log_file = REPO_ROOT + "/Builds/build.log"

	def self.delete()
		File.delete(@@log_file) if File.exist?(@@log_file)
	end


	def self.capture_build_output(command)

		self.delete

		startTimeObject = Time.now
		startTimeString = FormattedTime.get(startTimeObject).to_s
		puts "\n Build start time: " + startTimeString

		# this performs the actual build
		puts "\n" + command
		stdout, stderr, status = Open3.capture3(command)

		endTimeObject = Time.now
		endTimeString = FormattedTime.get(endTimeObject).to_s
		puts "\n Build end time: " + endTimeString

		duration = FormattedTime.compare(startTimeObject, endTimeObject).to_s
		puts "\n Build duration: " + duration

		File.new(@@log_file, "w") unless File.exist?(@@log_file)

		File.open(@@log_file, "w") { |f| 
			f.write("Build start time: " + startTimeString.to_s + "\n")
			f.write("Build end time: " + endTimeString.to_s + "\n")
			f.write("Total build duration: " + duration + "\n\n")

			f.write("Original command line invocation: \n" + command + "\n")

			f.write("\n \n  -- ERRORS -- \n" + stderr) unless stderr.empty?

			f.write("\n \n" + stdout) 
		}

		# copy log file to deploy dir 
		deploy_dir = REPO_ROOT + "/Builds/deploy"

		FileUtils.mkdir(deploy_dir) unless Dir.exist?(deploy_dir)

		dest = deploy_dir + "/build.log"

		File.new(dest, "w") unless File.exist?(dest)

		FileUtils.cp(@@log_file, dest)
	end

end