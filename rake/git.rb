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

  		def self.update_subdir(dir, recurse)

  			puts dir

  			Dir.chdir(dir) do 
  				branch_name = "main"

  				command = "git checkout " + branch_name
  				Rake.sh command

  				command = "git pull origin " + branch_name
  				Rake.sh command

  				if (recurse)
  					rec_dir = dir + "/UsefulScripts"

  					Dir.chdir(rec_dir) do 
						Rake.sh command
  					end
  				end

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

  			recurse = subdir != "Shared-code"

  			self.update_subdir(path, recurse)

  			if subdir == "Shared-code"
  				newPath = path + "/cmake/internal/UsefulScripts"
  				self.update_subdir(newPath, false)
  			end
  		}

  		path = REPO_ROOT + "/rake/post_configure/DefaultGithubRepo"

  		self.update_subdir(path, false)

  		self.commit_dev_workspace()
  	end
end