dim=2
num1=16
img1=data/r${num1}slice.nii.gz
num2=64
img2=data/r${num2}slice.nii.gz
out=output/segmentation3
ThresholdImage $dim $img1 ${out}mk.nii.gz 0.2 1.e9 
ImageMath $dim ${out}mk.nii.gz ME ${out}mk.nii.gz 2 
ImageMath $dim ${out}mk.nii.gz MD ${out}mk.nii.gz 2 
Atropos -d $dim -a $img1 -x ${out}mk.nii.gz -m [0.05,1x1]   -c [10,0]  -i kmeans[3] -o [${out}.nii.gz,${out}prob%02d.nii.gz] 
if [[ ! -s ${out}Warp.nii.gz ]] ; then 
  ANTS 2 -m CC[$img1,$img2,1,4] -t SyN[0.25] -r Gauss[3,0] -o ${out} -i 50x0x0
fi 
antsApplyTransforms -d 2 -i ${out}mk.nii.gz -o ${out}mk.nii.gz -t [${out}Affine.txt,1] -t ${out}InverseWarp.nii.gz -n NearestNeighbor -r $img2 #fortex
for x in 1 2 3 ; do  
  antsApplyTransforms -d 2 -i ${out}prob0${x}.nii.gz -o ${out}prob0${x}.nii.gz -t [${out}Affine.txt,1] -t ${out}InverseWarp.nii.gz -n Linear  -r $img2 #fortex
#  SmoothImage 2 ${out}prob0${x}.nii.gz 1 ${out}prob0${x}.nii.gz 
done
for x in 1 2 3 4  ; do #fortex
  N4BiasFieldCorrection -d $dim -i $img2 -o ${out}.nii.gz -x ${out}mk.nii.gz -s 1 -b [200] -c [20x20x20,0] -w ${out}prob03.nii.gz #fortex
  Atropos -d $dim -a ${out}.nii.gz -x ${out}mk.nii.gz -m [ 0.05,1x1]   -c [10,0]  -i priorprobabilityimages[3,${out}prob%02d.nii.gz,0.25] -o [${out}.nii.gz,${out}prob%02d.nii.gz]  #fortex
done #fortex
