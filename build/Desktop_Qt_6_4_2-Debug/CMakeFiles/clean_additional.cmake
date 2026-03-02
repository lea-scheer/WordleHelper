# Additional clean files
cmake_minimum_required(VERSION 3.16)

if("${CONFIG}" STREQUAL "" OR "${CONFIG}" STREQUAL "Debug")
  file(REMOVE_RECURSE
  "CMakeFiles/appWordleHelper_autogen.dir/AutogenUsed.txt"
  "CMakeFiles/appWordleHelper_autogen.dir/ParseCache.txt"
  "appWordleHelper_autogen"
  )
endif()
