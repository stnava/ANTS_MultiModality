
dim=2
num=64
img=data/r${num}slice.nii.gz
out=output/segmentation
rm ../figures/r${num}sliceseg.jpg
ThresholdImage $dim $img ${out}mask.nii.gz 0.2 1.e9 #fortex
ImageMath $dim ${out}mask.nii.gz ME ${out}mask.nii.gz 2 #fortex
ImageMath $dim ${out}mask.nii.gz MD ${out}mask.nii.gz 2 #fortex
Atropos -d $dim -a $img -x ${out}mask.nii.gz -m [0.05,1x1]   -c [10,0]  -i kmeans[3] -o [${out}.nii.gz,${out}prob%02d.nii.gz] #fortex
ImageMath $dim temp.nii.gz Normalize $img
ImageMath $dim ${out}.nii.gz Normalize ${out}.nii.gz
ImageMath $dim temp.nii.gz TileImages 2 temp.nii.gz ${out}.nii.gz
ImageMath $dim temp.nii.gz PadImage temp.nii.gz -20
ConvertToJpg temp.nii.gz ../figures/r${num}sliceseg.jpg
rm temp.nii.gz
