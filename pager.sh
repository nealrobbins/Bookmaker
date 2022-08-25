#!/bin/bash

# This script reconfigures a pdf to print custom signatures

echo 'pdf file name (exlude extension):'

read input

echo total number of pages:

read pagecount

echo pages per signature:

read sigsize

temp=0

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

           
while [ $((pagecount%sigsize)) != 0 ]
do 
temp=$((temp+1))
echo remainder is $((pagecount%sigsize))
convert xc:none -page Letter temp$temp.pdf
echo temp$temp.pdf created
pdfunite $input.pdf temp$temp.pdf $input-$temp.pdf
mv $input-$temp.pdf $input.pdf
echo $input-$temp.pdf created
pagecount=$((pagecount+1))
done
mv $input.pdf $input-appended.pdf
 
echo $pagecount

