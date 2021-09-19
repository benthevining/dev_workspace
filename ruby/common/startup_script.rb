def run_startup_script()

	path = REPO_ROOT + "/startup_script.sh"

	return unless (File.exist?(path))

	puts " ** Runing rake startup script... ** " if DEBUG_OUTPUT

	Dir.chdir(REPO_ROOT) do
		Rake.sh(path)
	end
end

#

run_startup_script()