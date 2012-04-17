project(ants_multimodality)


#
#  Copy the .cxx files to the binary build directory
#  to make easier to source them as code snippets.
#
#  This CXX_FILES variable is populated in the top CMakeLists.txt file
#
file(
  COPY  ${CXX_FILES}
  DESTINATION ${ants_multimodality_BINARY_DIR}
  )


add_latex_document( ants_multimodality.tex
  INPUTS ants_multimodality.tex
  IMAGE_DIRS ../figures
  DEFAULT_PDF
  )
