module Pluginval

	@@PLUGINVAL_REPO = REPO_ROOT + "/Cache/pluginval"


	def self.pull_repo()
		Git.pull(@@PLUGINVAL_REPO)
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

		if Dir.exist?(@@PLUGINVAL_REPO)
			self.pull_repo
		else 
			self.init_repo
		end

		CMake.configure(mode, @@PLUGINVAL_REPO)
		CMake.build_target(mode, "pluginval", @@PLUGINVAL_REPO)
	end


	def self.run(mode)

		dir = @@PLUGINVAL_REPO + "/Builds/pluginval_artefacts/" + mode

		if not Dir.exist?(dir)
			self.build(mode)
		end

		

	end
end
