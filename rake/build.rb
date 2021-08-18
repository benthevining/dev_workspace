module Build
    @@root = nil
    @@dir = nil
    
    def self.root(*parts, file: nil)
        unless @@root
            @@root = File.dirname(File.dirname(File.dirname(File.dirname(__FILE__))))
        end

        all = [@@root] + parts + [file]
        all.compact!

        File.join(all)
    end
end