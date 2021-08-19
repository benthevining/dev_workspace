module Clean

	def self.delete_build_dir()
        dir = FileAide.root() + "/Builds/"

        FileUtils.remove_dir(dir) if Dir.exist?(dir)
    end


    def self.delete_installed_plugins()

        def delete_list_of_plugin_names(list)
            list.each { |name|
                plugin_name = strip_array_foreach_chars(name)
                next if plugin_name.empty?
                File.delete(plugin_name) if File.exist?(plugin_name)
            }
        end

        if OS.mac?

            plugins_dir = "~/Library/Audio/Plug-Ins/"

            au_dir = plugins_dir + "Components"
            vst3_dir = plugins_dir + "VST3"

        elsif OS.windows?

        else # Linux

        end


        Dir.chdir(au_dir) do 
            delete_list_of_plugin_names(au_plugin_names)
        end

        Dir.chdir(vst3_dir) do 
            delete_list_of_plugin_names(vst3_plugin_names)
        end
    end


    def self.delete_cached_cpm_script()
        path = FileAide.root() + "/Cache/CPM.cmake"
        File.delete(path) if File.exist?(path)
    end


	def self.run()
		self.delete_build_dir()
        self.delete_cached_cpm_script()
        #self.delete_installed_plugins()
	end
end