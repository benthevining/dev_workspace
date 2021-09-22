# Using Rake tasks

`rake -T` to list all available tasks.

## Utility

`rake clean` to purge the build directory and any installed binaries 

`rake uth` to update all git submodules to their latest commits. You should usually run this after making changes to any of the git submodules, for those changes to be reflected here in the super-repo.

## Build tasks

`rake build:all[<MODE>]`

`rake build:<PRODUCT>[<MODE>, <FORMATS...>]`, where `<FORMATS>` is only needed for plugins, may be ommitted, and defaults to using all available formats for the given plugin

*example:*

`rake build:imogen[debug]` builds all Imogen formats, in debug mode

`rake build:kicklab[release, vst3, au]` builds Kicklab AU and VST3 in release mode


# Rake environment variables

**BV_DEFAULT_BUILD_CONFIG:** either `Build` or `Debug`. Defaults to `Debug`. Defines the default build configuration used for the config and build tasks if mode is not specified as an argument to the task.

**BV_DEBUG_RAKE_OUTPUT:** either `true` or `false`. Defaults to `true` if the value of `DEFAULT_BUILD_CONFIG` is `Debug`, else `false`. Defines whether rake will be verbose with its console output.

**BV_COMMIT_TO_REPOS:** either `true` or `false`. Defaults to `true`. Determines whether the ruby code will invoke a `git commit` when the submodules are updated with `rake uth`.


# Docker 

A docker container containing this workspace's entire build can be found [here](https://hub.docker.com/repository/docker/benvining/workspace).
