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


	def self.capture_process_output(command)

		data = {:out => [], :err => []}

		# see: http://stackoverflow.com/a/1162850/83386
		Open3.popen3(command) do |stdin, stdout, stderr, thread|
		    # read each stream from a new thread
			{ :out => stdout, :err => stderr }.each do |key, stream|
			    Thread.new do
			      	until (line = stream.gets).nil? do
				        data[key].push line
				        puts "#{line}"
			      	end
			    end
			end

			thread.join # don't exit until the external process is done
		end

		return data
	end


	def self.run_logged_task(command, taskName, outputFile, shortFilename)

		startTime = Time.now

		puts "\n" + command

		data = self.capture_process_output(command)

		duration = FormattedTime.compare(startTime, Time.now).to_s

		puts taskName + " duration: " + duration

		File.new(outputFile, "w") unless File.exist?(outputFile)

		File.open(outputFile, "w") { |f| 
			f.write(taskName + " duration: " + duration + "\n\n")
			f.write("Original command line invocation: \n" + command + "\n")
			f.write("\n \n  -- ERRORS -- \n" + data[:err].join) unless data[:err].empty?
			f.write("\n \n" + data[:out].join)
		}

		dest = self.create_log_dir_if_needed().to_s + "/" + shortFilename
		File.new(dest, "w") unless File.exist?(dest)
		FileUtils.cp(outputFile, dest)
	end


	def self.capture_config_output(command)
		self.run_logged_task(command, "Configure", @@config_log_file, "config.log")
	end


	def self.capture_build_output(command)
		self.run_logged_task(command, "Build", @@build_log_file, "build.log")
	end

end