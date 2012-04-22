dim=2
num1=16
num2=64
img1=data/r${num1}slice.nii.gz
img2=data/r${num2}slice.nii.gz
out=output/registration
ANTS $dim -m  CC[$img1,$img2,1,4]  -t SyN[0.25]  -r Gauss[3,0] -o $out -i 50x40x30 --number-of-affine-iterations 1000x1000x500 #fortex
WarpImageMultiTransform $dim $img2  ${out}.nii.gz  ${out}Warp.nii.gz ${out}Affine.txt -R $img1 #fortex
CreateWarpedGridImage $dim  ${out}Warp.nii.gz ${out}grid.nii.gz 1x1 10x10 10x10 #fortex 
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
ConvertToJpg temp.nii.gz ../figures/r${num2}registration.jpg
rm temp*.nii.gz
