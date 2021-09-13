module OS
	def self.windows?
    	return (/(cygwin)|(mswin)|(mingw)|(bccwin)|(wince)|(emx)/ =~ RUBY_PLATFORM) != nil
  	end

  	def self.mac?
   		return (/darwin/ =~ RUBY_PLATFORM) != nil
  	end

  	def self.unix?
    	return !self.windows?
  	end

  	def self.linux?
    	return (self.unix? and not self.mac?)
  	end

  	def self.jruby?
    	return RUBY_ENGINE == 'jruby'
  	end


  	def self.getNameAsString()

  		if self.mac?
  			return "macOS"
  		end

  		if self.windows?
  			return "Windows"
  		end

  		if self.linux?
  			return "Linux"
  		end

  		if self.jruby?
  			return "jruby"
  		end

  		return "Unknown"
  	end


  	def self.program_exists?(command)

  		exts = ENV['PATHEXT'] ? ENV['PATHEXT'].split(';') : ['']

	  	ENV['PATH'].split(File::PATH_SEPARATOR).each do |path|
	    	exts.each do |ext|
	      		exe = File.join(path, "#{command}#{ext}")
	      		return true if File.file?(exe) and File.executable?(exe)
	    	end
	  	end
	  	
	  	return false
  	end

end
