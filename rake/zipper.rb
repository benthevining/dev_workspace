module Zipper

	@@BUILD_DIR = REPO_ROOT + "/Builds"


	def self.zip_product(reponame, productName, dirToCopyTo = "")

		dir = @@BUILD_DIR + "/" + reponame

		return if not Dir.exist?(dir) 

		Dir.chdir(dir) do 
			artefacts = dir + "/" + productName + "_artefacts"
			zipFileName = productName + ".zip"

			return if not (Dir.exist?(artefacts + "/Debug") or Dir.exist?(artefacts + "/Release"))

			Rake.sh ("cmake -E tar cfv " + zipFileName + " --format=zip " + artefacts) do |ok, res| end

			if not dirToCopyTo.empty?
				FileUtils.cp(zipFileName, dirToCopyTo)
			end
		end
	end


	def self.zip_plugin(productName, dirToCopyTo = "")
		self.zip_product(productName.downcase, productName, dirToCopyTo)
	end


	def self.zip_app(productName, dirToCopyTo = "")
		if productName == "ImogenRemote"
			self.zip_product("imogen", productName, dirToCopyTo)
		else 
			self.zip_product(productName, productName, dirToCopyTo)
		end
	end


	def self.zip_all()

		dir = @@BUILD_DIR + "/Artifacts"

		FileUtils.remove_dir(dir) if Dir.exist?(dir)

		Dir.mkdir(dir)

		PLUGIN_NAMES.each { |plugin|
			self.zip_plugin(plugin, dir)
		}

		APP_NAMES.each { |app|
			self.zip_app(app, dir)
		}

		Dir.chdir(@@BUILD_DIR) do 
			Rake.sh ("cmake -E tar cfv Artifacts.zip --format=zip Artifacts") do |ok, res| end
		end
	end
end
