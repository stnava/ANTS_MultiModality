dim=2
num=64
img=data/r${num}slice.nii.gz
out=output/segmentation
rm ../figures/r${num}sliceseg.jpg
ThresholdImage $dim $img ${out}mk.nii.gz 0.2 1.e9 #fortex
ImageMath $dim ${out}mk.nii.gz ME ${out}mk.nii.gz 2 #fortex
ImageMath $dim ${out}mk.nii.gz MD ${out}mk.nii.gz 2 #fortex
Atropos -d $dim -a $img -x ${out}mk.nii.gz -m [0.05,1x1]   -c [10,0]  -i kmeans[3] -o [${out}.nii.gz,${out}prob%02d.nii.gz] #fortex
ImageMath $dim temp.nii.gz Normalize $img
ImageMath $dim ${out}.nii.gz Normalize ${out}.nii.gz
ImageMath $dim temp.nii.gz TileImages 2 temp.nii.gz ${out}.nii.gz
ImageMath $dim temp.nii.gz PadImage temp.nii.gz -20
ConvertToJpg temp.nii.gz ../figures/r${num}sliceseg.jpg
rm temp.nii.gz

mrf=5.0
Atropos -d $dim -a $img -x ${out}mk.nii.gz -m [ ${mrf},1x1]   -c [10,0]  -i kmeans[3] -o [temp.nii.gz,${out}prob%02d.nii.gz] 
ImageMath $dim temp.nii.gz Normalize temp.nii.gz
ImageMath $dim temp.nii.gz PadImage temp.nii.gz -30 
for mrf in 0.2 0.0  ; do 
  Atropos -d $dim -a $img -x ${out}mk.nii.gz -m [ ${mrf},1x1]   -c [10,0]  -i kmeans[3] -o [${out}.nii.gz,${out}prob%02d.nii.gz] 
  ImageMath $dim ${out}.nii.gz PadImage  ${out}.nii.gz -30 
  ImageMath $dim ${out}.nii.gz Normalize ${out}.nii.gz
  ImageMath $dim temp.nii.gz TileImages 2 temp.nii.gz ${out}.nii.gz
done

# Atropos -d $dim -a $img -x ${out}mk.nii.gz -m [ 0.1,1x1]   -c [10,0]  -i priorprobabilityimages[3,${out}prob%02d.nii.gz,$k] -o [temp2.nii.gz,${out}prob%02d.nii.gz] 
# for k in 0.25 0.5  ; do 
#  Atropos -d $dim -a $img -x ${out}mk.nii.gz -m [ 0.1,1x1]   -c [10,0]  -i priorprobabilityimages[3,${out}prob%02d.nii.gz,$k] -o [${out}.nii.gz,${out}prob%02d.nii.gz] 
#  ImageMath $dim temp2.nii.gz TileImages 2 temp2.nii.gz ${out}.nii.gz
# done


Atropos -d $dim -a $img -x ${out}mk.nii.gz -m [ 0.1,1x1]   -c [10,0]  -i kmeans[$k] -o [temp2.nii.gz,${out}prob%02d.nii.gz] 
ImageMath $dim temp2.nii.gz Normalize temp2.nii.gz
ImageMath $dim temp2.nii.gz PadImage temp2.nii.gz -30 
for k in 3 4  ; do 
  Atropos -d $dim -a $img -x ${out}mk.nii.gz -m [ 0.1,1x1]   -c [10,0]  -i  kmeans[$k]  -o [${out}.nii.gz,${out}prob%02d.nii.gz] 
  ImageMath $dim ${out}.nii.gz PadImage  ${out}.nii.gz -30 
  ImageMath $dim ${out}.nii.gz Normalize ${out}.nii.gz
  ImageMath $dim temp2.nii.gz TileImages 2 temp2.nii.gz ${out}.nii.gz
done
ImageMath $dim temp.nii.gz TileImages 1 temp.nii.gz temp2.nii.gz
ConvertToJpg temp.nii.gz ../figures/r${num}segparams.jpg
rm temp*gz
