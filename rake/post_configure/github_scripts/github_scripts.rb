module GithubScripts

	def self.update()

		def self.update_script(dir, scriptName)

			

		end

		def self.update_subdir(dir)

			workflows = Array['Build', 'RepoMaintenance', 'UpdateGitSubmodules']

			workflows.each { |flow|

				file_name = strip_array_foreach_chars(flow)
				next if file_name.empty?

				self.update_script(dir, file_name)
			}
		end

		#

		root = FileAide.root()

		REPO_SUBDIRS.each { |subdir|

			sub_dir = strip_array_foreach_chars(subdir)
			next if sub_dir.empty?

			dir = root + "/" + sub_dir

			self.update_subdir(dir)
		}
	end
end