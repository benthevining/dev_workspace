def add_to_path(newPath)

	ENV["PATH"] = ENV["PATH"].split(File::PATH_SEPARATOR).push(newPath).join(File::PATH_SEPARATOR)

end

add_to_path(REPO_ROOT + "/Cache/")

#

def _bv_parse_bool_env_var(env_var_name, default)

	return default unless ENV.has_key?(env_var_name)

	teststr = ENV[env_var_name.to_s]

	return (teststr.downcase == "true" or teststr == "1")
end

#

DEFAULT_BUILD_CONFIG = ENV.has_key?('BV_DEFAULT_BUILD_CONFIG') ? BuildMode.parse(ENV['BV_DEFAULT_BUILD_CONFIG']) : 'Debug'

#

DEBUG_OUTPUT = _bv_parse_bool_env_var('BV_DEBUG_RAKE_OUTPUT', DEFAULT_BUILD_CONFIG == 'Debug')

Rake.application.options.trace = DEBUG_OUTPUT
verbose(DEBUG_OUTPUT)

#

COMMIT_TO_REPOS = _bv_parse_bool_env_var('BV_COMMIT_TO_REPOS', true)

#

CROSSCOMPILE_IOS = OS.mac? ? _bv_parse_bool_env_var('BV_CROSSCOMPILE_IOS', false) : false

#

SKIP_GIT_PULL_IN_INIT = _bv_parse_bool_env_var('BV_SKIP_GIT_PULL_IN_INIT', false)

