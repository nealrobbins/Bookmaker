#!/bin/bash

# declare variables from inputs
docsize=$2
sigsize=$3
booksize=$4

if [ $((docsize%sigsize)) != 0 ]
then

echo Append blank pages to the end of your document so that the total page count is a multiple of $sigsize.
exit

fi

rock=1
hardplace=$sigsize
sigcounter=1
pagecounter=1
array=()

# Populate the array with the proper page order

echo begin

while [ $sigcounter -le $booksize ]
do

    while [ $pagecounter -le $sigsize ]
    do

        array+=(page-$rock.pdf)
        echo $rock
        pagecounter=$((pagecounter+1))
        array+=(page-$hardplace.pdf)
        echo $hardplace
        pagecounter=$((pagecounter+1))
        rock=$((rock+1))
        hardplace=$((hardplace-1))

    done

    rock=$((sigsize*sigcounter+1))
    sigcounter=$((sigcounter+1))
    pagecounter="1"
    hardplace=$((sigsize*sigcounter))
    echo "--------------------------"
    echo next sig start $rock
    echo next sig stop $hardplace
    echo "-------------------------"

done

echo done

# As a check, print the array elements sequentially.

output="0"
totelements=$((booksize*sigsize-1))
echo $totelements
echo "********************"

while [ $output -le $totelements ]
do

    echo ${array[$output]}
    output=$((output+1))

done

echo get the name of the input
file=$(basename $1)

echo copy the inputs to the working folder
mkdir shuffler-workspace-temp
cp $1 ./shuffler-workspace-temp

echo Split PDF into individual pages
cd shuffler-workspace-temp
pdfseparate $file page-%d.pdf

echo Recombine pages in new order
pdfunite ${array[@]} finished.pdf
  
# Cleanup
rm ${array[@]}
