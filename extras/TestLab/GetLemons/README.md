Barebones CMake script that:
- includes the [CPM.cmake script](https://github.com/cpm-cmake/CPM.cmake/blob/master/cmake/CPM.cmake), downloading it if necessary, caching it for future runs
- includes my [Lemons repo](https://github.com/benthevining/Lemons)
- propogates back to the calling scope the variable `LEMONS_PROJECT_SOURCE_DIR`, set to `<path_to_this_repo>/../Source`
- automatically adds any JUCE modules found in the directory `LEMONS_PROJECT_SOURCE_DIR/modules`, if any

My convention for organizing a project repository is:
```
Project
    - GetLemons (as a git submodule)
    - Source
        - modules
            - any juce modules are subdirs in here...
```
