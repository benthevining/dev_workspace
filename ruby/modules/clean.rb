module Clean

    def self.delete_installed_plugins()

        if OS.mac?
            plugins_dir = "~/Library/Audio/Plug-Ins/"
            au_dir = plugins_dir + "Components"
            vst3_dir = plugins_dir + "VST3"
            
        elsif OS.windows?

        else # Linux

        end

        delete_list_of_plugin_names = -> (list, dir) {
            Dir.chdir(dir) do 
                list.each { |name|
                    next if name.empty?
                    File.delete(name) if File.exist?(name)
                }
            end
        }

        delete_list_of_plugin_names.(au_plugin_names, au_dir)
        delete_list_of_plugin_names.(vst3_plugin_names, vst3_dir)
    end


	def self.run()

        safe_delete_dir = -> (dir) {
            FileUtils.remove_dir(dir) if Dir.exist?(dir)
        }

        # delete builds dir
        safe_delete_dir.(REPO_ROOT + "/Builds/")

        REPO_PATHS.each { |repo|
            path = repo.to_s + "/Builds"
            safe_delete_dir.(repo.to_s + "/Builds")
        }

        # self.delete_installed_plugins
	end
end