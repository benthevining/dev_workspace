module Git 
	
	def self.process_submodules(dir)
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


  	def self.uth_rec(info, level)
    	p = info[:path]
    	m = info[:module]
    	b = info[:branch]

    	`git submodule --quiet update --init #{p}`
    
    	Dir.chdir(p) do 
      		if b
        		`git checkout #{b} --quiet`
        		`git pull --rebase --quiet`
        		`git submodule sync --quiet`
      		end
    	end

    	puts " + " + "  "*level + "#{m}:#{b || '<none>'} [#{File.expand_path(p)}]"
    	process_submodules(p) { |info| uth_rec(info, level+1) } if b
  	end


	def self.uth()
    	dir = FileAide.root()

    	command = "git pull --rebase -j " + getNumCpuCores().to_s
puts command
    	Rake.sh command

    	process_submodules(dir) { |info| uth_rec(info, 0) }
  	end

end