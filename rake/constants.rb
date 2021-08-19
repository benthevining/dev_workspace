require "etc"

NUM_CPU_CORES = Etc.nprocessors.to_s

#

DEFAULT_BUILD_CONFIG = ENV.has_key?('DefaultConfig') ? ENV['DefaultConfig'] : 'Debug'

#

REPO_ROOT = File.dirname(File.dirname(__FILE__)).to_s

REPO_SUBDIRS = Array['imogen', 'kicklab', 'Shared-code', 'StageHand']

REPO_PATHS = Array.new

REPO_SUBDIRS.each { |repo|
	repo_dir = strip_array_foreach_chars(repo)
	next if repo_dir.empty?

	path = REPO_ROOT + "/" + repo_dir
	REPO_PATHS.push(path)
}

#

PLUGIN_NAMES = Array['Imogen', 'Kicklab']

APP_NAMES = Array['StageHand', 'ImogenRemote']

PRODUCT_NAMES = PLUGIN_NAMES + APP_NAMES

#

au_xtn = ".component"
vst3_xtn = ".vst3"

au_plugin_names = Array.new
vst3_plugin_names = Array.new

PLUGIN_NAMES.each { |name|

	plugin_name = strip_array_foreach_chars(name)

	next if plugin_name.empty?
    
    au_plugin_names.push(plugin_name + au_xtn)
    vst3_plugin_names.push(plugin_name + vst3_xtn)
}
