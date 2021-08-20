require "json"


PLUGIN_NAMES = Array.new
APP_NAMES = Array.new

REPO_SUBDIRS = Array.new


Dir.chdir(File.expand_path(File.dirname(__FILE__))) do 

	json = JSON.parse(File.read("products.json"))


	json["product"].each do |product|

		type = product["type"]

		if type == "plugin" 
			PLUGIN_NAMES.push(product["name"])
		elsif type == "app" 
			APP_NAMES.push(product["name"])
		else next
		end

		if product.has_key?("subdir")
			REPO_SUBDIRS.push(product["subdir"])
		end
		
	end
end

PRODUCT_NAMES = PLUGIN_NAMES + APP_NAMES