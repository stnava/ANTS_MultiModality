
img=data/rsfmri.nii.gz
out=output/rsfmri
if [[ -s ${out}avg.nii.gz ]] ; then 
  ThresholdImage 3 ${out}avg.nii.gz  ${out}_bmask.nii.gz 300 9999 #fortex
  ImageMath 3 ${out}_bmask.nii.gz GetLargestComponent ${out}_bmask.nii.gz #fortex
  N3BiasFieldCorrection 3 ${out}avg.nii.gz ${out}n3.nii.gz 2 ${out}_bmask.nii.gz
  N3BiasFieldCorrection 3  ${out}n3.nii.gz ${out}n3.nii.gz 1 ${out}_bmask.nii.gz
  Atropos -d 3 -a ${out}n3.nii.gz -a ${out}compcorr_variance.nii.gz -m [0.25,1x1x1] -o [${out}seg.nii.gz,${out}prob%02d.nii.gz] -x ${out}_bmask.nii.gz -c [5,0] -i kmeans[3]
  Atropos -d 3 -a ${out}n3.nii.gz -a ${out}compcorr_variance.nii.gz -m [0.25,1x1x1] -o [${out}seg.nii.gz,${out}prob%02d.nii.gz] -x ${out}_bmask.nii.gz -c [5,0] -i priorprobabilityimages[3,${out}prob%02d.nii.gz,0]
  ThresholdImage 3 ${out}seg.nii.gz ${out}_bmask.nii.gz 3 3 
  ImageMath 4 ${out}compcorr.nii.gz CompCorrAuto ${out}.nii.gz ${out}_bmask.nii.gz 6 #fortex
  sccan --timeseriesimage-to-matrix [ ${out}compcorr_corrected.nii.gz , ${out}_bmask.nii.gz , 0 , 1.0 ] -o ${out}.csv #fortex
  sccan --svd sparse[ ${out}.csv ,  ${out}_bmask.nii.gz , -0.05 ] -n 20 -i 10 --PClusterThresh 50 -o ${out}RSFNodes.nii.gz  #fortex
fi
exit
# for display 

MultiplyImages 3 output/rsfmriavg.nii.gz 0 temp.nii.gz
ct=1 ; for x in output/rsfmriRSFNodesView1vec0*gz ; do ThresholdImage 3 $x temp2.nii.gz 1.e-6 999 ; MultiplyImages 3 temp2.nii.gz $ct temp2.nii.gz ; ImageMath 3 temp.nii.gz addtozero temp.nii.gz temp2.nii.gz ; let ct=$ct+1 ;  done 

# R stuff
dd<-read.csv('output/rsfmriMOCOparams.csv')
wh<-c(2:length(dd$MOCOparam0)) ; wh2<-wh-1> 
pdf('../figures/rsfmriplot1.pdf',width=8,height=6); 
plot(discon,ylab="Change in rotation",xlab="Time",cex=2,cex.lab=1.5,cex.axis=1.25,cex.main=2, lwd=2,lty=2,font=1,font.sub=2,font.main=2,font.lab=2,type="l",main="Outlier Rejection") ; 
dev.off()
pdf('../figures/rsfmriplot2.pdf',width=8,height=6); 
plot(dd$MetricPost,ylab="Negative Correlation with Average",xlab="Time",cex=2,cex.lab=1.5,cex.axis=1.25,cex.main=2, lwd=2,lty=2,font=1,font.sub=2,font.main=2,font.lab=2,type="l",main="Outlier Rejection") ; 
dev.off()



# rsf networks 
library(timeSeries)
library(mFilter)
compcorr<-read.csv('output/rsfmricompcorr_compcorr.csv')
moco<-read.csv('output/rsfmriMOCOparams.csv')
a<-read.csv('output/rsfmri.csv')
a<-read.csv('output/rsfmriRSFNodesprojectionsView1vec.csv')
mp<-as.matrix(moco)
mp[,3:8]<-mp[,3:8]-mp[c(1,3:244,244),3:8]
amat<-as.matrix(a)
# regress out motion and compcorr stuff 
amat<-residuals(lm(amat~1+mp+as.matrix(compcorr)))
# now do frequency filtering 
tr<-2 # a guess 
myTimeSeries<-ts( amat ,  frequency<-1/tr )
freqLo<-0.02
freqHi<-0.1
voxLo<-round(1/freqLo)
voxHi<-round(1/freqHi)
fTimeSeries<-residuals( cffilter( myTimeSeries , pl=voxHi, pu=voxLo , drift=TRUE , type="t")) # trig
spec.pgram( myTimeSeries[ , 1 ] , taper = 0 , fast=T , detrend = F , demean = F , log="n" ) 
im<-cor(amat)
imr<-matrix( as.real( im > 0.25 ) ,nrow=20,ncol=20)
heatmap( im , symm=T, Rowv=NA )
heatmap( imr , symm=T, Rowv=NA )
