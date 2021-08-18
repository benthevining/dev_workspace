require_relative "rake/git.rb"
require_relative "rake/cmake.rb"

#

task :clean do
	
end

#

task :uth do 
	Git.uth()
end

#

task :configure do 
	CMake.configure()
end

#

namespace :build do 

	task :all do 

	end


	task :imogen do 

	end


	task :kicklab do 

	end
end