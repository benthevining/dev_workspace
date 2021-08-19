module Init

	def self.init_linux()
		deps = Array['libasound2-dev', 'libjack-jackd2-dev', 'libcurl4-openssl-dev', 'libfreetype6-dev', 'libx11-dev', 'libxcomposite-dev', 'libxcursor-dev', 'libxcursor-dev', 'libxext-dev', 'libxinerama-dev', 'libxrandr-dev', 'libxrender-dev', 'libwebkit2gtk-4.0-dev', 'libglu1-mesa-dev', 'mesa-common-dev']

		Rake.sh "sudo apt update" do |ok, res| end

		command = "sudo apt install " + deps.join(" ")
		puts command
		Rake.sh command
	end


	def self.init()

		Dir.chdir(REPO_ROOT) do 
			Rake.sh "git remote update && git fetch"
		end

		Git.init_all_submodules()

		self.init_linux() if OS.linux?
	end


	def self.init_lv2()
		if not (OS.linux?)
			puts "Warning: LV2 format is only available on Linux"
			return
		end

		# install LV2 development headers
		Rake.sh "sudo apt-get install lv2-dev"

		# clone the LV2 porting project fork of Juce

		dir = REPO_ROOT + "/Cache"

		Dir.chdir(dir) do 
			Rake.sh "git clone -b lv2 https://github.com/lv2-porting-project/JUCE.git"
			Rake.sh "git pull"
		end

		dir += "JUCE"

		# re-run cmake config

		Dir.chdir(REPO_ROOT) do
			configCmd = "cmake -B Builds -DCPM_JUCE_SOURCE=" + dir
			Rake.sh configCmd
		end
	end
end