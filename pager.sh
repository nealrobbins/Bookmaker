#!/bin/bash

# This script reconfigures a pdf to print custom signatures.
# When calling the script, provide the path and filename of the pdf to be processed.

echo $1

echo total number of pages:

read pagecount

echo pages per signature:

read sigsize

# Handle edge case where sigature size is greater than page count

if [ $((pagecount < sigsize)) ]
then

echo 'Warning: your page count is less than your desired signature size. Blank pages will be appended to your document to make a full signature.

Do you wish to contine? [y/n]'

read response
    if [ $response != y ]
    then
        exit
    fi

# Handle edge case where page count is not a multipe of signature size

elif [ $((pagecount%sigsize)) != 0 ]
then
    
echo 'Your page count is not a multiple of your desired signature size. Blank pages will be appended to your document to make a full signature.
    
Do you want to continue? [y/n]'

read response
    if [ $response != y ]
    then
        exit
    fi
fi

# setup working folder

mkdir pager-workspace-temp

# Create blank pages

temp=0
blankpages=()

while [ $((pagecount%sigsize)) != 0 ]
do 
temp=$((temp+1))
echo remainder is $((pagecount%sigsize))
convert xc:none -page Letter ./pager-workspace-temp/temp$temp.pdf
blankpages+=(./pager-workspace-temp/temp$temp.pdf)
echo temp$temp.pdf created
pagecount=$((pagecount+1))
done

# Merge blank bages with input pdf

pdfunite $1 ${blankpages[@]} ~/Downloads/appended.pdf

echo $pagecount
echo Check your downloads folder for appended.pdf

#clean up

rm ./pager-workspace-temp/temp*.pdf

