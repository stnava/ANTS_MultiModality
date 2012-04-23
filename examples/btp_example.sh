
mkdir templateex
cd templateex 
ln -s ../data/phantom* . 
buildtemplateparallel.sh -d 2 -o PH -c 0 -m CC -t GR  phantom*jpg

