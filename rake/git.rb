require_relative "build.rb"

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

	def self.uth()
    	dir = Build.root()
    	`git pull --rebase -j 16`
    	process_submodules(dir) { |info| uth_rec(info, 0) }
  	end
end