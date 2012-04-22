dim=2
num=64
img=data/r${num}slice.nii.gz
out=output/segmentation
rm ../figures/r${num}sliceseg2.jpg
ThresholdImage $dim $img ${out}mk.nii.gz 0.2 1.e9 
ImageMath $dim ${out}mk.nii.gz ME ${out}mk.nii.gz 2
ImageMath $dim ${out}mk.nii.gz MD ${out}mk.nii.gz 2
ImageMath $dim temp.nii.gz GO $img 2  #fortex
ImageMath $dim temp1.nii.gz Laplacian $img 1  #fortex
ImageMath $dim temp2.nii.gz Grad $img 1 1  #fortex
Atropos -d $dim -a $img -a temp.nii.gz  -a temp1.nii.gz  -a temp2.nii.gz -x ${out}mk.nii.gz -m [0.05,1x1]   -c [10,0]  -i kmeans[3] -o [${out}.nii.gz,${out}prob%02d.nii.gz] #fortex
ImageMath $dim temp.nii.gz Normalize $img
ImageMath $dim ${out}.nii.gz Normalize ${out}.nii.gz
ImageMath $dim temp.nii.gz TileImages 2 temp.nii.gz ${out}.nii.gz
ImageMath $dim temp.nii.gz PadImage temp.nii.gz -20
ConvertToJpg temp.nii.gz ../figures/r${num}sliceseg2.jpg
rm temp.nii.gz temp1.nii.gz temp2.nii.gz
exit 0 
