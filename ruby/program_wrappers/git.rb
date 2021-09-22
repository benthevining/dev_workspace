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

		return unless COMMIT_TO_REPOS

		Dir.chdir(dir) do 
			Rake.sh "git commit -a -m \"Rake auto-commit\"" do |ok, res| end
		end
	end


	def self.pull(dir)

		return if not COMMIT_TO_REPOS

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

  		update_subdir = -> (dir) {
  			Dir.chdir(dir) do 
  				Rake.sh ("git checkout " + @@branch_name)
  				Rake.sh ("git pull -j " + NUM_CPU_CORES + " origin " + @@branch_name)

  				if COMMIT_TO_REPOS
  					Rake.sh ("git commit -a -m \"Submodule auto-update\" && git push") do |ok, res| end
  				end
  			end
  		}

  		self.pull_dev_workspace

  		Rake.sh "git submodule update"

  		REPO_PATHS.each { |repo|

  			continue if repo == REPO_ROOT + "/PrivateSDKs"

  			rec_dir = repo == REPO_ROOT + "/Lemons" ? repo + "/cmake/GetLemons" : repo + "/GetLemons"

  			update_subdir.(rec_dir)
  			update_subdir.(repo)
  		}

  		update_subdir.(REPO_ROOT + "/PrivateSDKs")

  		self.commit_dev_workspace
  	end
end