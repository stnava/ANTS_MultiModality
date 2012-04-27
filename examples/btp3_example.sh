if [[ -d templateex ]] ; then 
  cd templateex 
  ct=10
  echo vol > globalvols.csv 
  for x in ../data/phantom*wmgm.jpg ; do 
    ThresholdImage 2 $x mask.nii.gz 90 1.e9 > temp
    Atropos -d 2 -a $x -m [0.1,1x1] -i kmeans[2] -x mask.nii.gz -o [temp${ct}seg.nii.gz] -c [3,0] > temp
    vol=`ImageMath 2 temp LabelStats temp${ct}seg.nii.gz  temp${ct}seg.nii.gz | grep "Label 1" `
    echo ${vol:22:4}  >> globalvols.csv 
    rm temp
    let ct=$ct+1
  done
  ct=10 
  if [[ -s PHtemplateseg.nii.gz ]] ; then 
    ThresholdImage 2 PHtemplateseg.nii.gz  maskg.nii.gz 127 127  # fortex
    ThresholdImage 2 PHtemplateseg.nii.gz  maskw.nii.gz 255 255 
#    ImageMath 2 mask.nii.gz ME mask.nii.gz 1 
    for x in PHphantom*wmgmWarp.nii.gz ; do  #fortex
      ANTSJacobian 2 $x phantomW${ct} 1 maskw.nii.gz 0  
      ANTSJacobian 2 $x phantomG${ct} 1 maskg.nii.gz 0  # fortex
#      SmoothImage 2 phantom${ct}logjacobian.nii.gz 1.0  phantom${ct}logjacobian.nii.gz #fortex
      let ct=$ct+1
    done 
    ls phantomG*logjacobian.nii.gz > list.txt   # fortex
    sccan --imageset-to-matrix [list.txt,maskg.nii.gz] -o phantomGlogjacs.csv   # fortex
    ls phantomW*logjacobian.nii.gz > list.txt   
    sccan --imageset-to-matrix [list.txt,maskw.nii.gz] -o phantomWlogjacs.csv   
    # Now run SCCAN to get multivariate statistics 
    sccan --scca two-view[phantomGlogjacs.csv,globalvols.csv,maskg.nii.gz, NA ,-0.1,-1] -o CCA.nii.gz -n 1 -p 1000 -i 10 --PClusterThresh 100 # fortex
#    sccan --scca two-view[phantomWlogjacs.csv,phantomGlogjacs.csv,maskw.nii.gz,maskg.nii.gz,-0.1,-0.1] -o CCA.nii.gz -n 3 -p 100  --PClusterThresh 100 # fortex
#  0.363314 p-value 0.002997 ct 1000 true 0.978359 # fortex

  fi
else
  exit 1
fi 

exit

