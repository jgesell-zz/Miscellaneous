#!/bin/sh

THREADS=$1;

if [ -z "$THREADS" ];
        then THREADS=`grep -c ^processor /proc/cpuinfo`;
fi

DIR=`pwd -P | cut -f9 -d "/" | cut -f1 | sed 's/WorkDir//g'`;
totalReads=`cat ../Logs/${DIR}.phixOverall.stats.txt | grep "reads" | cut -f1 -d " ";`
phiXReads=`cat ../Logs/${DIR}.phixOverall.stats.txt | grep "exactly" | cut -f5 -d " "`;
phiXReads1=`cat ../Logs/${DIR}.phixOverall.stats.txt | grep ">1" | cut -f5 -d " "`;
phiXReads=$((${phiXReads}+${phiXReads1}));
barcoded=0;
for i in `cat ../${DIR}.barcodeCounts.txt | cut -f2`; do barcoded=$(($barcoded + `echo $i`)); done;
strictMerged=`cat ../Deliverables/${DIR}.Stats.Combined.txt | grep "Raw" -A2 | grep "Total" | cut -f2 -d " "`;
standardMerged=`bzcat ../Deliverables/${DIR}.MergedRaw.fq.bz2 | grep "@HWI-" | wc -l`;
numSamples=`cat ../Deliverables/${DIR}.Stats.Combined.txt | cut -f1 -d " " | wc -l`;
numSamples=$(($numSamples - 1));
totalReads=$((${totalReads}*250));
barcoded=$((${barcoded}*500));
phiXReads=$((${phiXReads}*250));
strictMerged=$((${strictMerged}*500));
standardMerged=$((${standardMerged}*500));
percentBarcoded=$((100*${barcoded}/${totalReads}));
percentPhiX=$((100*${phiXReads}/${totalReads}));
percentStrict=$((100*${strictMerged}/${barcoded}));
percentStandard=$((100*${standardMerged}/${barcoded}));
