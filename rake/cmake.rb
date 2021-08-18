require_relative "os.rb"

module CMake
	def self.configure()
		if OS.mac?
			Rake.sh "cmake -B Builds -G Xcode"
		else
			Rake.sh "cmake -B Builds"
		end
	end


	def self.build()
		
	end
end