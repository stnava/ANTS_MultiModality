dim=2
num1=16
num2=64
img1=data/r${num1}slice.nii.gz
img2=data/r${num2}slice.nii.gz
lm1=data/r${num1}lm.nii.gz
lm2=data/r${num2}lm.nii.gz
out=output/registration
ANTS $dim -m  CC[$img1,$img2,1,4]  -t SyN[0.25]  -r Gauss[3,0] -o ${out}pre -i 0 --number-of-affine-iterations 1000x1000x500 
WarpImageMultiTransform $dim $lm2  ${out}lm.nii.gz  ${out}preAffine.txt -R $img1 --use-NN #fortex
WarpImageMultiTransform $dim $img2 ${out}img.nii.gz  ${out}preAffine.txt -R $img1 #fortex
wt=1 ; pct=0.5 ; sig=50  #fortex
 ANTS $dim  -i 55x40x30  -r Gauss[8,0] -t SyN[ 0.25 ]  #fortex
 -m PSE[ $lm1 ,  ${out}lm.nii.gz  , $lm1 ,  ${out}lm.nii.gz  ,$wt,$pct,$sig,0,10,10000 ]  #fortex
  -m  CC[$img1,${out}img.nii.gz,1,4] -o $out -i 50x50x50 --number-of-affine-iterations 0   #fortex
 --use-all-metrics-for-convergence 1 --continue-affine 0 #fortex
ANTS $dim  -i 55x40x30  -r Gauss[8,0] -t SyN[ 0.25 ]  -m PSE[ $lm1 ,  ${out}lm.nii.gz  , $lm1 ,  ${out}lm.nii.gz  ,$wt,$pct,$sig,0,10,10000 ]   -m  CC[$img1,${out}img.nii.gz,1,4] -o $out -i 50x50x50 --number-of-affine-iterations 0  --use-all-metrics-for-convergence 1 --continue-affine 0 
WarpImageMultiTransform $dim $img2  ${out}.nii.gz ${out}Warp.nii.gz ${out}preAffine.txt -R $img1 
CreateWarpedGridImage $dim  ${out}Warp.nii.gz ${out}grid.nii.gz 1x1 10x10 10x10
ImageMath $dim temp.nii.gz TruncateImageIntensity $img1 0.05 0.95
ImageMath $dim temp.nii.gz Byte temp.nii.gz 
PermuteFlipImageOrientationAxes 2  temp.nii.gz temp.nii.gz   0 1  0 1 
ImageMath $dim temp2.nii.gz TruncateImageIntensity $img2 0.1 0.95
ImageMath $dim temp2.nii.gz Byte temp2.nii.gz 
ImageMath $dim ${out}.nii.gz TruncateImageIntensity ${out}.nii.gz 0.15 0.95
ImageMath $dim ${out}.nii.gz Byte ${out}.nii.gz 
PermuteFlipImageOrientationAxes 2  ${out}.nii.gz ${out}.nii.gz   0 1  0 1 
PermuteFlipImageOrientationAxes 2  ${out}grid.nii.gz  ${out}grid.nii.gz  0 1  0 1 
ImageMath $dim temp.nii.gz TileImages 2 temp.nii.gz ${out}.nii.gz temp2.nii.gz ${out}grid.nii.gz
ImageMath $dim temp.nii.gz PadImage temp.nii.gz -20
ConvertToJpg temp.nii.gz ../figures/r${num2}registrationlm.jpg
rm temp*.nii.gz
exit 0 