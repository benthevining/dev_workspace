module Zipper

	@@DEPLOY_DIR = REPO_ROOT + "/Builds/deploy"


	def self.zip_all()

		return if not Dir.exist?(@@DEPLOY_DIR)

		dir = REPO_ROOT + "/Builds"

		Dir.chdir(@@DEPLOY_DIR) do 
			Rake.sh ("cmake -E tar cfv Artifacts.zip --format=zip " + dir) do |ok, res| end
		end
	end
end
