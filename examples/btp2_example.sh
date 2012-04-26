if [[ -d templateex ]] ; then 
  cd templateex 
  ct=10
  ThresholdImage 2 PHtemplate.nii.gz mask.nii.gz 90 1.e9
  for x in *deformed.nii.gz ; do #fortex
    Atropos -d 2 -a $x -m [0.1,1x1] -i kmeans[2] -x mask.nii.gz -o [temp${ct}seg.nii.gz] -c [3,0] #fortex
    let ct=$ct+1
  done
  ls temp*seg.nii.gz > list.txt #fortex
  ImageSetStatistics 2 list.txt PHtemplateseg.nii.gz 0 #fortex
  ImageMath 2 PHtemplateseg.nii.gz Byte PHtemplateseg.nii.gz
  ImageMath 2 phantomtemplate.nii.gz TileImages 2  PHtemplate.nii.gz  PHtemplateseg.nii.gz
  ConvertToJpg phantomtemplate.nii.gz ../../figures/phantomtemplate.jpg
else
  exit 1
fi 
