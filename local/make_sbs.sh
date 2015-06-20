#!/bin/bash
#


if [ $# != 3 ]; then
  echo "Usage: $0 /path/to/sbs-wav /path/to/sbs-lists  data/ directory"
  exit 1; 
fi 

wavdir=$1
listdir=$2
data=$3;

tmpdir=data/local/tmp
mkdir -p $tmpdir
. ./path.sh || exit 1; # for KALDI_ROOT

if [ ! -d "${listdir}" ]; then
   echo "Error: $0 requires a directory (with absolute pathname) that contains list files"
   exit 1; 
fi  

if [ ! -d "${wavdir}" ]; then
   echo "Error: $0 requires a directory (with absolute pathname) that contains audio files"
   exit 1; 
fi  

# convert filenames in <lang>.unsupervised.txt to full files in train_wav.flist
# bosnian_140905_359025-31.wav -> $wavdir/bosnian/bosnian_140905_359025-31.wav
# bosnian_140905_359025-32.wav -> $wavdir/bosnian/bosnian_140905_359025-32.wav
export wavdir
find "$listdir" -type f -iname  "*.unsupervised.txt" | xargs cat |\
perl -ane '$wavdir=$ENV{wavdir}; chomp $_; ($langdir = $_) =~ s/^([^_]*)_(.*)/$1/g;
print "$wavdir/$langdir/$_\n";' > $tmpdir/train_wav.flist

[ -d "$data" ] || mkdir -p $data;
# prepare wav.scp, spk2utt, utt2spk, spk2gender files
local/make_sbs.pl $tmpdir/train_wav.flist  $data

echo "sbs data prep succeeded"
exit 0;




