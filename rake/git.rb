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

	
	def self.update_submodules_in_dir(dir)
    	Dir.chdir(dir) do
      		fn = ".gitmodules"
      		return false unless File.exists?(fn)

      		mod_name= nil
      		path = nil
      		branch = nil

      		mod_rgx = /\[submodule\s+\"(.+)\"\]/
      		path_rgx = /path\s*=\s*(.*)/
      		branch_rgx = /branch\s*=\s*(.*)/

      		File.readlines(fn).each do |line|
        	res = nil
        	
        	if res = mod_rgx.match(line)
          		yield ({module: mod_name, path: path, branch: branch }) if mod_name && path
          		mod_name = res[1]
          		path = nil
          		branch = nil
        	elsif res = path_rgx.match(line)
          		path = res[1]
        	elsif res = branch_rgx.match(line)
          		branch = res[1]
        	end
      	end
      		yield ({module: mod_name, path: path, branch: branch }) if mod_name && path
    	end
  	end


  	def self.uth_recurse(info, level)
    	p = info[:path]
    	m = info[:module]
    	b = info[:branch]

    	cmd = "git submodule update --remote --merge --init " + p
    	Rake.sh cmd
    
    	Dir.chdir(p) do 
      		if b
      			cmd = "git checkout " + b + " --quiet"
      			Rake.sh cmd

      			Rake.sh "git pull --merge --quiet"
      			Rake.sh "git submodule sync --quiet"
      			Rake.sh "git push"
      		end
    	end

    	update_submodules_in_dir(p) { |info| uth_recurse(info, level+1) } if b
  	end


	def self.uth()
    	command = "git pull --rebase -j " + getNumCpuCores().to_s
    	Rake.sh command

    	update_submodules_in_dir(FileAide.root()) { |info| uth_recurse(info, 0) }
  	end


  	def self.new_uth()

  		command = "git pull --rebase -j " + getNumCpuCores().to_s
    	Rake.sh command

  		Rake.sh "git submodule update"

  		Rake.sh "git submodule foreach \'git checkout origin/HEAD && git submodule update && git pull\'"

  	end

end