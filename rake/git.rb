module Git 

	def self.init_all_submodules()

		Dir.chdir(REPO_ROOT) do 
			Rake.sh "git submodule update --init"

			REPO_SUBDIRS.each { |dir|
				path = REPO_ROOT + "/" + dir

				Dir.chdir(path) do 
					Rake.sh "git submodule update --init"
				end
			}
		end
	end


	def self.commit_dev_workspace()
		Dir.chdir(REPO_ROOT) do 
			command = "git commit -a -m \"Submodule auto-update\""
			Rake.sh command do |ok, res| end
		end
	end


	def self.pull_dev_workspace()
		Dir.chdir(REPO_ROOT) do 
			command = "git pull --rebase -j " + getNumCpuCores().to_s
    		Rake.sh command do |ok, res| end
		end
	end

	
  	def self.uth()

  		def self.update_subdir(dir)

  			puts dir

  			Dir.chdir(dir) do 

  				branch_name = "main"

  				command = "git checkout " + branch_name
  				Rake.sh command

  				command = "git pull origin " + branch_name
  				Rake.sh command

  				command = "git commit -a -m \"Submodule auto-update\" && git push"
  				Rake.sh command do |ok, res| end
  			end
  		end

  		self.pull_dev_workspace()

  		Rake.sh "git submodule update"

  		REPO_SUBDIRS.each { |repo|

  			subdir = strip_array_foreach_chars(repo)
  			next if subdir.empty?

  			path = REPO_ROOT + "/" + subdir
  			self.update_subdir(path)

  			if subdir == "Shared-code"
  				rec_dir = path + "/cmake/internal/UsefulScripts"
  			else 
  				rec_dir = path + "/UsefulScripts"
  			end

  			self.update_subdir(rec_dir)
  		}

  		path = REPO_ROOT + "/rake/post_configure/DefaultGithubRepo"
  		self.update_subdir(path)

  		self.commit_dev_workspace()
  	end
end