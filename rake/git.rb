module Git 

	def self.init_all_submodules()

		Dir.chdir(REPO_ROOT) do 
			Rake.sh "git submodule update --init"
		end

		REPO_PATHS.each { |dir|
			Dir.chdir(dir) do 
				Rake.sh "git submodule update --init"
			end
		}
	end


	def self.commit(dir)
		Dir.chdir(dir) do 
			Rake.sh "git commit -a -m \"Rake auto-commit\"" do |ok, res| end
		end
	end


	def self.pull(dir)
		Dir.chdir(dir) do 
    		Rake.sh ("git pull --rebase -j " + NUM_CPU_CORES) do |ok, res| end
		end
	end


	def self.commit_dev_workspace()
		self.commit(REPO_ROOT)
	end


	def self.pull_dev_workspace()
		self.pull(REPO_ROOT)
	end


	@@branch_name = "main"

	
  	def self.uth()

  		def self.update_subdir(dir)

  			puts dir

  			Dir.chdir(dir) do 
  				Rake.sh ("git checkout " + @@branch_name)
  				Rake.sh ("git pull -j " + NUM_CPU_CORES + " origin " + @@branch_name)
  				Rake.sh ("git commit -a -m \"Submodule auto-update\" && git push") do |ok, res| end
  			end
  		end

  		self.pull_dev_workspace

  		Rake.sh "git submodule update"

  		REPO_SUBDIRS.each { |repo|

  			path = REPO_ROOT + "/" + repo

  			if repo == "Shared-code" or repo == "lab"
  				rec_dir = path + "/cmake/UsefulScripts"
  			else 
  				rec_dir = path + "/UsefulScripts"
  			end

  			self.update_subdir(rec_dir)
  			self.update_subdir(path)
  		}

  		self.update_subdir(REPO_ROOT + "/rake/post_configure/DefaultGithubRepo")

  		self.commit_dev_workspace
  	end
end