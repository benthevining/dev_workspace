module Init

	def self.install_cmake()

		dir = REPO_ROOT + "/Cache/cmake"

		return if (File.exist?(dir + "/cmake"))

		puts "\n -- installing cmake..."

		FileUtils.mkdir(dir) unless Dir.exist?(dir)

		path = dir + "/cmake.tar"

		url = "http://github.com/Kitware/CMake/releases/download/v3.21.2/cmake-3.21.2-" + OS.getNameAsString.downcase

		url += "-universal" if (OS.mac?)

		if (OS.windows?)
			url += ".zip"
		else
			url += ".tar.gz"
		end

		Download.download_file(url, path) unless File.exist?(path)

		Dir.chdir(dir) do 
			Rake.sh "cmake -E tar xvf " + path
		end
	end


	def self.install_ccache()

		dir = REPO_ROOT + "/Cache/ccache"

		return if (File.exist?(dir + "/ccache"))

		puts "\n -- installing ccache..."

		FileUtils.mkdir(dir) unless Dir.exist?(dir)

		path = dir + "/ccache.tar"

		url = "http://github.com/cristianadam/ccache/releases/download/v4.4/" + OS.getNameAsString + ".tar.xz"

		Download.download_file(url, path) unless File.exist?(path)

		Dir.chdir(dir) do 
			Rake.sh "cmake -E tar xvf " + path
		end
	end


	def self.install_linux_deps

		puts "\n -- installing Linux dependencies..."

		deps = Array['libasound2-dev', 'libjack-jackd2-dev', 'libcurl4-openssl-dev', 'libfreetype6-dev', 'libx11-dev', 'libxcomposite-dev', 'libxcursor-dev', 'libxcursor-dev', 'libxext-dev', 'libxinerama-dev', 'libxrandr-dev', 'libxrender-dev', 'libwebkit2gtk-4.0-dev', 'libglu1-mesa-dev', 'mesa-common-dev', 'lv2-dev']

		Rake.sh "sudo apt update" do |ok, res| end

		Rake.sh ("sudo apt install " + deps.join(" "))

	end


	def self.init()

		Dir.chdir(REPO_ROOT) do 
			Rake.sh "git remote update && git fetch"
		end

		Git.init_all_submodules

		self.install_cmake unless OS.program_exists?("cmake")
		self.install_ccache unless OS.program_exists?("ccache")

		self.install_linux_deps if OS.linux?

		puts "\n \n"
	end

end