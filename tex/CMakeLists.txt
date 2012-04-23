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
  INPUTS ants_multimodality.tex motioncorr_example_input.tex
  segmentation_example_input.tex  segmentation2_example_input.tex
  thickness_example_input.tex registration_example_input.tex
  registration_affine_example_input.tex cars.sh 
  registration_mm_example_input.tex  registration_lm_example_input.tex
  IMAGE_DIRS ../figures
  DEFAULT_PDF
  )
