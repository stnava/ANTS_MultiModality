cmake_minimum_required(VERSION 2.8 FATAL_ERROR)
project(ants_multimodality)
include(tex/UseLATEX.cmake)
set( CMAKE_RUNTIME_OUTPUT_DIRECTORY
  ${ants_multimodality_BINARY_DIR}/bin
)

# file(GLOB_RECURSE CXX_FILES "Exercises/*.cxx")

# add_subdirectory(Exercises)

option(BUILD_PRESENTATION "Build the PDF Presentation." OFF)

if(BUILD_PRESENTATION)
  add_subdirectory( tex )
endif()
