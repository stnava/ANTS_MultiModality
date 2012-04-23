dim=2
num=64
img=data/r${num}slice.nii.gz
out=output/segmentation
ThresholdImage $dim $img ${out}mk.nii.gz 0.2 1.e9 
ImageMath $dim ${out}mk.nii.gz ME ${out}mk.nii.gz 2
ImageMath $dim ${out}mk.nii.gz MD ${out}mk.nii.gz 2
Atropos -d $dim -a $img -x ${out}mk.nii.gz -m [0.05,1x1]   -c [10,0]  -i kmeans[3] -o [${out}.nii.gz,${out}prob%02d.nii.gz] 
KellyKapowski -d $dim -s ${out}.nii.gz -g ${out}prob02.nii.gz  -w ${out}prob03.nii.gz -o ${out}thickness.nii.gz -c [30,0] -r 0.5 -m 1.0 #fortex
ImageMath $dim temp.nii.gz Normalize ${out}.nii.gz
MultiplyImages $dim ${out}thickness.nii.gz 0.12 ${out}thickness.nii.gz 
ImageMath $dim temp.nii.gz TileImages 2 temp.nii.gz  ${out}thickness.nii.gz 
ImageMath $dim temp.nii.gz PadImage temp.nii.gz -20
ConvertToJpg temp.nii.gz ../figures/r${num}thickness.jpg
rm temp.nii.gz
exit 0
