DEFAULT_BUILD_CONFIG = ENV.has_key?('DefaultConfig') ? BuildMode.parse(ENV['DebugOutput']) : 'Debug'

#

DEBUG_OUTPUT = ENV.has_key?('DebugOutput') ? ENV['DebugOutput'] : DEFAULT_BUILD_CONFIG == 'Debug'

Rake.application.options.trace = DEBUG_OUTPUT
verbose(DEBUG_OUTPUT)

#

cache_path = REPO_ROOT + "/Cache/"

ENV["PATH"] = ENV["PATH"].split(File::PATH_SEPARATOR).push(cache_path).join(File::PATH_SEPARATOR)