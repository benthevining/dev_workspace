module Zipper

	@@BUILD_DIR = REPO_ROOT + "/Builds"


	def self.zip_product(reponame, productName)

		dir = @@BUILD_DIR + "/" + reponame

		artefacts = dir + "/" + productName + "_artefacts"

		Dir.chdir(dir) do 
			Rake.sh ("cmake -E tar cfv " + productName + ".zip --format=zip " + artefacts) do |ok, res| end
		end
	end


	def self.zip_plugin(productName)
		self.zip_product(productName.downcase, productName)
	end


	def self.zip_app(productName)
		if productName == "ImogenRemote"
			self.zip_product("imogen", productName)
		else 
			self.zip_product(productName, productName)
		end
	end


	def self.zip_all()
		PLUGIN_NAMES.each { |plugin|
			self.zip_plugin(plugin)
		}

		APP_NAMES.each { |app|
			self.zip_app(app)
		}
	end
end