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
			Rake.sh "git commit -a -m \"Submodule auto-update\"" do |ok, res| end
		end
	end


	def self.pull_dev_workspace()
		Dir.chdir(FileAide.root()) do 
			command = "git pull --rebase -j " + getNumCpuCores().to_s
    		Rake.sh command
		end
	end

	
  	def self.uth()

  		self.pull_dev_workspace()

  		Rake.sh "git submodule update"

  		branch_name = "main"

  		submodule_command = "git checkout " + branch_name + " && git pull origin " + branch_name

  		command = "git submodule foreach \'" + submodule_command + "\'"

  		Rake.sh command

  		self.commit_dev_workspace()
  	end

end