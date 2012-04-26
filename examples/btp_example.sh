mkdir templateex
cd templateex 
ln -s ../data/phantom* .  #fortex
rm phantomtemplate.jpg
ImageMath 2 phantoms.nii.gz TileImages 4 phantom*jpg
ConvertToJpg phantoms.nii.gz ../../figures/phantoms.jpg
buildtemplateparallel.sh -d 2 -o PH -c 0 -s CC -i 3 -m 50x0x0 -t GR  phantom*jpg #fortex
AverageImages 2 PHtemplate.nii.gz 0 *deformed.nii.gz
ImageMath 2 PHtemplate.nii.gz Byte PHtemplate.nii.gz
ImageMath 2 phantoms2.nii.gz TileImages 4 *deformed.nii.gz
ConvertToJpg phantoms2.nii.gz ../../figures/phantoms2.jpg
rm phantoms*.nii.gz
