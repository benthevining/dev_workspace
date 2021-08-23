module Clean

	def self.delete_build_dir()
        dir = REPO_ROOT + "/Builds/"
        FileUtils.remove_dir(dir) if Dir.exist?(dir)
    end


    def self.delete_cpm_cache()
        dir = REPO_ROOT + "/Cache/"
        FileUtils.remove_dir(dir) if Dir.exist?(dir)
    end


    def self.delete_installed_plugins()

        def delete_list_of_plugin_names(list, dir)
            Dir.chdir(dir) do 
                list.each { |name|
                    next if name.empty?
                    File.delete(name) if File.exist?(name)
                }
            end
        end

        if OS.mac?
            plugins_dir = "~/Library/Audio/Plug-Ins/"
            au_dir = plugins_dir + "Components"
            vst3_dir = plugins_dir + "VST3"
            
        elsif OS.windows?

        else # Linux

        end

        delete_list_of_plugin_names(au_plugin_names, au_dir)
        delete_list_of_plugin_names(vst3_plugin_names, vst3_dir)
    end


	def self.run()
		self.delete_build_dir
        #self.delete_installed_plugins

        JucePluginHost.clean
	end
end