module FileAide
    
    def self.root()
        return File.dirname(File.dirname(File.dirname(__FILE__))).to_s
    end

end