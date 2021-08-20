[![Build](https://github.com/BenViningMusicSoftware/dev_workspace/actions/workflows/Build.yml/badge.svg?branch=main)](https://github.com/BenViningMusicSoftware/dev_workspace/actions/workflows/autoBuild.yml)

# Installing Ruby

## MacOS

Follow the instructions from [this repo's](https://github.com/monfresh/install-ruby-on-macos) readme:

```
cd ~
curl --remote-name https://raw.githubusercontent.com/monfresh/install-ruby-on-macos/master/install-ruby
/usr/bin/env bash install-ruby 2>&1 | tee ~/laptop.log
```
Once the script is done, quit and relaunch terminal!

## Windows

## Linux


# Using Rake tasks

After cloning this repo, you should run `rake init` once. If you haven't pulled the repo in 12 years and then pull again, maybe run `rake init` again just for good measure.

`rake -T` to list all available tasks.

## Utility

`rake clean` to purge the build directory and any installed binaries 

`rake uth` to update all git submodules to their latest commits. You should usually run this after making changes to any of the git submodules, for those changes to be reflected here in the super-repo.

All the build tasks automatically invoke the `config` task, but you can run just the CMake configuration by itself with `rake config[<MODE>]`, where `<MODE>` is either `Debug` or `Release` (default is `Debug`)

## Build tasks

`rake build:all[<MODE>]`

`rake build:<PRODUCT>[<MODE>, <FORMATS...>]`, where `<FORMATS>` is only needed for plugins, may be ommitted, and defaults to using all available formats for the given plugin

*example:*

`rake build:imogen[debug]` builds all Imogen formats, in debug mode

`rake build:kicklab[release, vst3, au]` builds Kicklab AU and VST3 in release mode


# Rake environment variables

**DEFAULT_BUILD_CONFIG:** either `Build` or `Debug`. Defaults to `Debug`. Defines the default build configuration used for the config and build tasks if mode is not specified as an argument to the task.

**DEBUG_OUTPUT:** either `true` or `false`. Defaults to `true` if the value of `DEFAULT_BUILD_CONFIG` is `Debug`, else `false`. Defines whether rake will be verbose with its console output.
