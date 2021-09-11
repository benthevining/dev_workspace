module CPack

	def self.run(mode)

		Dir.chdir(REPO_ROOT) do 
			Rake.sh "cpack --config " + REPO_ROOT + "/Builds/CPackConfig.cmake -C " + mode.to_s
		end
	end
end