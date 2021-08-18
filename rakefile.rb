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
		CMake.build()
	end


	task :imogen do 
		CMake.build()
	end


	task :kicklab do 
		CMake.build()
	end
end