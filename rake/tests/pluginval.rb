module Pluginval

	@@PLUGINVAL_REPO = REPO_ROOT + "/Cache/pluginval"


	def self.pull_repo()
		Git.pull(@@PLUGINVAL_REPO)
		Git.pull(@@PLUGINVAL_REPO + "/modules/juce")
	end


	def self.init_repo()
		Dir.chdir(REPO_ROOT + "/Cache") do 
			Rake.sh "git clone https://github.com/Tracktion/pluginval.git -j " + NUM_CPU_CORES
		end

		Dir.chdir(@@PLUGINVAL_REPO) do 
			Rake.sh "git submodule init"
		end

		self.pull_repo
	end


	def self.build(mode)

		build_dir = @@PLUGINVAL_REPO + "/Builds"
		FileUtils.remove_dir(build_dir) if Dir.exist?(build_dir)

		if Dir.exist?(@@PLUGINVAL_REPO)
			self.pull_repo
		else 
			self.init_repo
		end

		CMake.configure(mode, @@PLUGINVAL_REPO)
		CMake.build_target(mode, "pluginval", @@PLUGINVAL_REPO)
	end


	def self.run(mode, pluginNames = [], level = 5)

		return if pluginNames.empty?

		dir = @@PLUGINVAL_REPO + "/Builds/pluginval_artefacts/" + mode

		if not Dir.exist?(dir)
			self.build(mode)
		end

		command = OS.get_program_command("pluginval")

		pluginPaths = Array.new

		pluginNames.each { |name|
			path = REPO_ROOT + "/Builds/" + name.to_s.downcase + "/" + name + "_artefacts/" + mode
			
			au = path + "/AU/" + name + ".component"
			pluginPaths.push(au) if Dir.exist?(au)

			vst3 = path + "/VST3/" + name + ".vst3"
			pluginPaths.push(vst3) if Dir.exist?(vst3)
		}

		Dir.chdir(dir) do 
			pluginPaths.each { |path|
				Rake.sh (command + " --validate-in-process --strictness-level " + level.to_s + " --output-dir \"./bin\" --validate \"" + path + "\"") do |ok, res| end
			}
		end
	end
end
