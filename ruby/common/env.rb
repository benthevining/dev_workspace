DEFAULT_BUILD_CONFIG = ENV.has_key?('BV_DEFAULT_BUILD_CONFIG') ? BuildMode.parse(ENV['BV_DEFAULT_BUILD_CONFIG']) : 'Debug'

#

DEBUG_OUTPUT = ENV.has_key?('BV_DEBUG_RAKE_OUTPUT') ? ENV['BV_DEBUG_RAKE_OUTPUT'].downcase == "true" : DEFAULT_BUILD_CONFIG == 'Debug'

Rake.application.options.trace = DEBUG_OUTPUT
verbose(DEBUG_OUTPUT)

#

COMMIT_TO_REPOS = ENV.has_key?('BV_COMMIT_TO_REPOS') ? ENV['BV_COMMIT_TO_REPOS'].downcase == "true" : true

#

ENV["PATH"] = ENV["PATH"].split(File::PATH_SEPARATOR).push(REPO_ROOT + "/Cache/").join(File::PATH_SEPARATOR)

#

CROSSCOMPILE_IOS = ENV.has_key?('BV_CROSSCOMPILE_IOS') ? (ENV['BV_CROSSCOMPILE_IOS'].downcase == "true" and OS.mac?) : false