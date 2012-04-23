
img=data/rsfmri.nii.gz
out=output/rsfmri
antsMotionCorr  -d 3 -a $img -o ${out}avg.nii.gz  #fortex
ExtractSliceFromImage 4 $img ${out}_slice_original.nii.gz 0 32
antsMotionCorr  -d 3 -o [${out},${out}.nii.gz,${out}avg.nii.gz] -m mi[ ${out}avg.nii.gz , $img , 1 , 32 , Regular, 0.01 ]  -t Rigid[ 0.05 ] -i 100 -u 1 -e 1 -s 0.0 -f 1 -n 10 #fortex
ExtractSliceFromImage 4 ${out}.nii.gz ${out}_slice_corrected.nii.gz 0 32
ExtractSliceFromImage 3 ${out}_slice_corrected.nii.gz  ${out}_slice_corrected_x.nii.gz 1 22
ExtractSliceFromImage 3 ${out}_slice_original.nii.gz  ${out}_slice_original_x.nii.gz 1 22
ConvertToJpg ${out}_slice_original_x.nii.gz ../figures/rsfmri_discon.jpg 
ConvertToJpg ${out}_slice_corrected_x.nii.gz ../figures/rsfmri_smooth.jpg 

#  ${AD}ThresholdImage 3 ${out}_avg.nii.gz  ${out}_bmask.nii.gz 300 9999 
#  ${AD}ImageMath 3 ${out}_bmask.nii.gz GetLargestComponent ${out}_bmask.nii.gz 
#  ${AD}ImageMath 4 ${out}compcorr.nii.gz CompCorrAuto ${out}.nii.gz ${out}_bmask.nii.gz 6
#  ${AD}sccan --timeseriesimage-to-matrix [ ${out}compcorr_corrected.nii.gz , ${out}_bmask.nii.gz , 0 , 1.0 ] -o ${out}.csv
#  ${AD}sccan --svd sparse[ ${out}.csv ,  ${out}_bmask.nii.gz , -0.05 ] -n 40 -i 20 --PClusterThresh 50 -o ${out}RSFNodes.nii.gz 

exit

# R stuff
dd<-read.csv('output/rsfmriMOCOparams.csv')
wh<-c(2:length(dd$MOCOparam0)) ; wh2<-wh-1> 
pdf('../figures/rsfmriplot1.pdf',width=8,height=6); 
plot(discon,ylab="Change in rotation",xlab="Time",cex=2,cex.lab=1.5,cex.axis=1.25,cex.main=2, lwd=2,lty=2,font=1,font.sub=2,font.main=2,font.lab=2,type="l",main="Outlier Rejection") ; 
dev.off()
pdf('../figures/rsfmriplot2.pdf',width=8,height=6); 
plot(dd$MetricPost,ylab="Negative Correlation with Average",xlab="Time",cex=2,cex.lab=1.5,cex.axis=1.25,cex.main=2, lwd=2,lty=2,font=1,font.sub=2,font.main=2,font.lab=2,type="l",main="Outlier Rejection") ; 
dev.off()
