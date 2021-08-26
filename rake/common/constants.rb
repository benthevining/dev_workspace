require "etc"
require "json"

#

NUM_CPU_CORES = Etc.nprocessors.to_s

#

DEFAULT_BUILD_CONFIG = ENV.has_key?('DefaultConfig') ? BuildMode.parse(ENV['DebugOutput']) : 'Debug'

#

DEBUG_OUTPUT = ENV.has_key?('DebugOutput') ? ENV['DebugOutput'] : DEFAULT_BUILD_CONFIG == 'Debug'

Rake.application.options.trace = DEBUG_OUTPUT
verbose(DEBUG_OUTPUT)

#

REPO_ROOT = File.expand_path(File.dirname(File.dirname(File.dirname(__FILE__))).to_s

#

REPO_SUBDIRS = ["Shared-code"]
REPO_PATHS = Array.new
PLUGIN_NAMES = Array.new
APP_NAMES = Array.new

Dir.chdir(REPO_ROOT) do 

	json = JSON.parse(File.read("products.json"))


	json["product"].each { |product|

		productName = product["name"]
		type = product["type"]

		if type == "plugin" 
			PLUGIN_NAMES.push(productName)
		elsif type == "app" 
			APP_NAMES.push(productName)
		else next
		end

		if product.has_key?("subdir")
			REPO_SUBDIRS.push(product["subdir"])
		end
	}
end

REPO_SUBDIRS.each { |repo|
	REPO_PATHS.push(REPO_ROOT + "/" + repo)
}

PRODUCT_NAMES = PLUGIN_NAMES + APP_NAMES

#

au_xtn = ".component"
vst3_xtn = ".vst3"

au_plugin_names = Array.new
vst3_plugin_names = Array.new

PLUGIN_NAMES.each { |name|
    au_plugin_names.push(name + au_xtn)
    vst3_plugin_names.push(name + vst3_xtn)
}
