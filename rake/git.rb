module Git 

	def self.init_all_submodules()

		root = FileAide.root()

		Dir.chdir(root) do 
			Rake.sh "git submodule update --init"

			dirs = Array['imogen', 'kicklab', 'StageHand']

			dirs.each do |dir|
				path = root + "/" + dir

				Dir.chdir(path) do 
					Rake.sh "git submodule update --init"
				end
			end
		end
	end


	def self.commit_dev_workspace()
		Dir.chdir(FileAide.root()) do 
			command = "git commit -a -m \"Submodule auto-update\""
			Rake.sh command do |ok, res| end
		end
	end


	def self.pull_dev_workspace()
		Dir.chdir(FileAide.root()) do 
			command = "git pull --rebase -j " + getNumCpuCores().to_s
    		Rake.sh command do |ok, res| end
		end
	end

	
  	def self.uth()

  		def self.update_subdir(dir, recurse)

  			branch_name = "main"

  			Dir.chdir(dir) do 
  				command = "git checkout " + branch_name + " && git pull origin " + branch_name
  				Rake.sh command

  				if (recurse)
  					rec_dir = dir + "/UsefulScripts"

  					Dir.chdir(rec_dir) do 
						Rake.sh command
  					end
  				end
  			end
  		end

  		self.pull_dev_workspace()

  		Rake.sh "git submodule update"

  		REPO_SUBDIRS.each { |repo|

  			subdir = strip_array_foreach_chars(repo)
  			next if subdir.empty?

  			path = FileAide.root() + "/" + subdir

  			recurse = subdir != "Shared-code"

  			self.update_subdir(path, recurse)

  			if subdir == "Shared-code"
  				newPath = path + "/cmake/internal/UsefulScripts"
  				self.update_subdir(newPath, false)
  			end
  		}

  		self.commit_dev_workspace()
  	end

end