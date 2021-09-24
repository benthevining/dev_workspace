module CPack

	def self.run(mode)

		Dir.chdir(REPO_ROOT) do 
			Rake.sh "cpack -C " + mode.to_s
		end
	end
end