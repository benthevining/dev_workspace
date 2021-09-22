require "etc"
require "json"

#

NUM_CPU_CORES = Etc.nprocessors.to_s

#

REPO_PATHS = Array.new
PLUGIN_NAMES = Array.new
APP_NAMES = Array.new

Dir.chdir(REPO_ROOT + "/products") do 

	REPO_SUBDIRS = Array.new

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

		REPO_SUBDIRS.push(product["subdir"]) if product.has_key?("subdir")
	}

	REPO_SUBDIRS.each { |repo|
		REPO_PATHS.push(REPO_ROOT + "/products/" + repo)
	}
end

REPO_PATHS.push(REPO_ROOT + "/Lemons")
REPO_PATHS.push(REPO_ROOT + "/PrivateSDKs")

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
