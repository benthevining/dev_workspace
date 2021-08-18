module FileAide
    @@root = nil
    @@dir = nil
    
    def self.root(*parts, file: nil)
        unless @@root
            @@root = File.dirname(File.dirname(__FILE__))
        end

        all = [@@root] + parts + [file]
        all.compact!

        File.join(all)
    end

    def self.clean()
        dir = self.root() + "/Builds/"

        if Dir.exist?(dir)
            FileUtils.remove_dir(dir)
        end
    end
end
