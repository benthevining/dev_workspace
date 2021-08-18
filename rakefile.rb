require_relative "rake/files.rb"
require_relative "rake/git.rb"
require_relative "rake/cmake.rb"

#

task :clean do
	FileAide.clean()
end


task :uth do 
	Git.uth()
end


task :config do
	CMake.configure()
end

#

namespace :build do 

	default_config = "debug"

	task :all, [:mode] => ["rake:config"] do |t, args|
		args.with_defaults(:mode => default_config)
		CMake.build_all(args.mode)
	end


	task :imogen, [:mode, :formats] => ["rake:config"] do |t, args|
		args.with_defaults(:mode => default_config)
		CMake.build_plugin_target("Imogen", args.mode, args.formats, args.extras)
	end

	task :imogen_remote, [:mode] => ["rake:config"] do |t, args|
		args.with_defaults(:mode => default_config)
		CMake.build_app_target("ImogenRemote", args.mode)
	end


	task :kicklab, [:mode, :formats] => ["rake:config"] do |t, args|
		args.with_defaults(:mode => default_config)
		CMake.build_plugin_target("Kicklab", args.mode, args.formats, args.extras)
	end

end

