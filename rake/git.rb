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

	
  	def self.uth()

  		command = "git pull --rebase -j " + getNumCpuCores().to_s
    	Rake.sh command

  		Rake.sh "git submodule update"

  		branch_name = "main"

  		command = "git submodule foreach \'git checkout " + branch_name + " && git pull origin " + branch_name + "\'"

  		Rake.sh command

  		Rake.sh "git commit -a -m \"Submodule auto-update\" && git push"
  	end

end