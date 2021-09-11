module Init

	def self.install_ccache()

	end


	def self.install_linux_deps

		deps = Array['libasound2-dev', 'libjack-jackd2-dev', 'libcurl4-openssl-dev', 'libfreetype6-dev', 'libx11-dev', 'libxcomposite-dev', 'libxcursor-dev', 'libxcursor-dev', 'libxext-dev', 'libxinerama-dev', 'libxrandr-dev', 'libxrender-dev', 'libwebkit2gtk-4.0-dev', 'libglu1-mesa-dev', 'mesa-common-dev', 'lv2-dev']

		Rake.sh "sudo apt update" do |ok, res| end

		Rake.sh ("sudo apt install " + deps.join(" "))

	end


	def self.init()

		Dir.chdir(REPO_ROOT) do 
			Rake.sh "git remote update && git fetch"
		end

		Git.init_all_submodules

		self.install_ccache

		self.install_linux_deps if OS.linux?
	end

end