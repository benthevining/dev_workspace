module Init

	def self.init_linux()
		deps = Array['libasound2-dev', 'libjack-jackd2-dev', 'libcurl4-openssl-dev', 'libfreetype6-dev', 'libx11-dev', 'libxcomposite-dev', 'libxcursor-dev', 'libxcursor-dev', 'libxext-dev', 'libxinerama-dev', 'libxrandr-dev', 'libxrender-dev', 'libwebkit2gtk-4.0-dev', 'libglu1-mesa-dev', 'mesa-common-dev']

		Rake.sh "sudo apt update"

		command = "sudo apt install " + deps.join(" ")
		puts command
		Rake.sh command
	end


	def self.init()
		if (OS.linux?)
			self.init_linux()
		end
	end


	def self.init_lv2()
		if not (OS.linux?)
			return
		end

		Rake.sh "sudo apt-get install lv2-dev"
	end
end