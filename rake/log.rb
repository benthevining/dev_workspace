module Log 

	@@log_file = REPO_ROOT + "/Builds/build.log"

	def self.delete()
		File.delete(@@log_file) if File.exist?(@@log_file)
	end


	def self.copy_to_deploy_dir()

		return if not File.exist?(@@log_file)

		dest = REPO_ROOT + "/Builds/deploy/build.log"

		File.delete(dest) if File.exist?(dest)

		File.new(dest, "w") 

		FileUtils.cp(@@log_file, dest)
	end


	def self.write(stdout, stderr)

		File.new(@@log_file, "w") unless File.exist?(@@log_file)

		File.open(@@log_file, "w") { |f| 
			f.write(stdout + "\n \n ERRORS \n" + stderr) 
		}

		self.copy_to_deploy_dir
	end

end