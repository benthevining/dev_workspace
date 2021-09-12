require "open3"


module Log 

	@@log_file = REPO_ROOT + "/Builds/build.log"

	def self.delete()
		File.delete(@@log_file) if File.exist?(@@log_file)
	end


	def self.copy_to_deploy_dir()

		return if not File.exist?(@@log_file)

		deploy_dir = REPO_ROOT + "/Builds/deploy"

		FileUtils.mkdir(deploy_dir) unless Dir.exist?(deploy_dir)

		dest = deploy_dir + "/build.log"

		File.new(dest, "w") unless File.exist?(dest)

		FileUtils.cp(@@log_file, dest)
	end


	def self.capture_build_output(command)

		self.delete

		startTime = FormattedTime.get
		puts "\n Build start time: " + startTime.to_s

		# this performs the actual build
		puts "\n" + command
		stdout, stderr, status = Open3.capture3(command)

		endTime = FormattedTime.get
		puts "\n Build end time: " + endTime.to_s

		duration = FormattedTime.compare(startTime, endTime).to_s
		puts "\n Build duration: " + duration

		File.new(@@log_file, "w") unless File.exist?(@@log_file)

		File.open(@@log_file, "w") { |f| 
			f.write("Build start time: " + startTime.to_s + "\n")
			f.write("Build end time: " + endTime.to_s + "\n")
			f.write("Total build duration: " + duration + "\n")

			f.write("\n \n  -- ERRORS -- \n" + stderr) unless stderr.empty?

			f.write("\n \n" + stdout) 
		}

		self.copy_to_deploy_dir
	end

end