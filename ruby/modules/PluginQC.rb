add_to_path(REPO_ROOT + "/plugin_qc/Builds/pluginval/pluginval_artefacts/Debug/")

module PluginQC

	def self.build(mode = "Debug")

		Dir.chdir(REPO_ROOT + "/plugin_qc") do 

			puts "\nBuilding plugin QC tools...\n"

			# configure cmake

			command = "cmake -B Builds -DCMAKE_BUILD_TYPE=" + mode

			if OS.mac?
				command += " -G Xcode"
			elsif OS.windows?
				command += " -G \"Visual Studio 16 2019\""
			end # use default Ninja generator on Linux

			Rake.sh command

			# run build
			Rake.sh ("cmake --build Builds --config " + mode + " -j " + NUM_CPU_CORES)

			puts "\nBuilt plugin QC tools!\n"
		end
	end

	def self.run_pluginval_command(pathToPlugin, strictness = 5)
		Dir.chdir(REPO_ROOT + "/plugin_qc/Builds/pluginval/pluginval_artefacts/Debug/") do
			Rake.sh ("./pluginval --strictnessLevel " + strictness.to_s + " --validate " + pathToPlugin)
		end
	end
end
