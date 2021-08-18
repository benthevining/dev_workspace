module FileAide
    
    def self.root()
        # unless @@root
        #     @@root = File.dirname(File.dirname(__FILE__))
        # end

        # all = [@@root] + parts + [file]
        # all.compact!

        # File.join(all)

        root = File.dirname(File.dirname(__FILE__))

        puts root

        return root.to_s
    end


    def self.delete_build_dir()
        dir = self.root() + "/Builds/"

        if Dir.exist?(dir)
            FileUtils.remove_dir(dir)
        end
    end


    def self.delete_installed_plugins()

    end


    def self.clean()
        self.delete_build_dir()
        self.delete_installed_plugins()
    end
end