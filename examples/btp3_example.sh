if [[ -d templateex ]] ; then 
  cd templateex 
  ct=10
  echo vol > globalvols.csv 
  for x in ../data/phantom*wmgm.jpg ; do #fortex
    ThresholdImage 2 $x mask.nii.gz 90 1.e9 > temp
    Atropos -d 2 -a $x -m [0.1,1x1] -i kmeans[2] -x mask.nii.gz -o [temp${ct}seg.nii.gz] -c [3,0] > temp
    vol=`ImageMath 2 temp LabelStats temp${ct}seg.nii.gz  temp${ct}seg.nii.gz | grep "Label 1" `
    echo ${vol:22:4}  >> globalvols.csv 
    rm temp
    let ct=$ct+1
  done
  ct=10 
  if [[ -s PHtemplateseg.nii.gz ]] ; then 
    ThresholdImage 2 PHtemplateseg.nii.gz  mask.nii.gz 127 300  # fortex
#    ImageMath 2 mask.nii.gz ME mask.nii.gz 1 
    for x in PHphantom*wmgmWarp.nii.gz ; do 
      ANTSJacobian 2 $x phantom${ct} 1 mask.nii.gz 0  # fortex
      SmoothImage 2 phantom${ct}logjacobian.nii.gz 1.0  phantom${ct}logjacobian.nii.gz #fortex
      let ct=$ct+1
    done 
    ls phantom*logjacobian.nii.gz > list.txt   # fortex
    sccan --imageset-to-matrix [list.txt,mask.nii.gz] -o phantomlogjacs.csv   # fortex
  fi
else
  exit 1
fi 

exit

predictor<-read.csv("data/phantpredictors.csv")
predictor<-read.csv("templateex/globalvols.csv")
logjac<-read.csv("templateex/phantomlogjacs.csv")

attach( logjac ) ; attach( predictor )

nvox<-ncol(logjac)

pvals<-rep(NA,nvox)

for ( x in c(1:nvox) ) 
{ 

  voxels<-logjac[,x]

  lmres<-summary(lm( voxels ~  vol ))

  coeff<-coefficients( lmres )

  pval<-coeff[2,4]

  pvals[x]<-pval

}
qvals<-p.adjust(pvals)
print(min(qvals))
write.csv(1-qvals,'templateex/qvals.csv')

 sccan --vector-to-image [ templateex/qvals.csv , templateex/mask.nii.gz , 1] -o temp.nii.gz