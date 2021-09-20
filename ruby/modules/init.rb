module Init

	def self.install_linux_deps

		puts "\n -- installing Linux dependencies..."

		deps = Array['libasound2-dev', 'libjack-jackd2-dev', 'libcurl4-openssl-dev', 'libfreetype6-dev', 'libx11-dev', 'libxcomposite-dev', 'libxcursor-dev', 'libxcursor-dev', 'libxext-dev', 'libxinerama-dev', 'libxrandr-dev', 'libxrender-dev', 'libwebkit2gtk-4.0-dev', 'libglu1-mesa-dev', 'mesa-common-dev', 'lv2-dev']

		Rake.sh "sudo apt-get update" do |ok, res| end

		Rake.sh ("sudo apt-get install -y " + deps.join(" ")) do |ok, res|
			if not ok
				Rake.sh ("apt-get install -y " + deps.join(" "))
			end
		end
	end


	def self.init()

		if not SKIP_GIT_PULL_IN_INIT
			Dir.chdir(REPO_ROOT) do 
				Rake.sh "git remote update && git fetch"
			end

			Git.init_all_submodules
		end

		cache_dir = REPO_ROOT + "/Cache"
		FileUtils.mkdir(cache_dir) unless Dir.exist?(cache_dir)

		self.install_linux_deps if OS.linux?

		puts "\n \n"
	end

end