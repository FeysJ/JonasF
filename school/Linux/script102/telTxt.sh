#!/bin/bash
#/dev/null wordt automatisch gewist na gebruik, ook errors worden naar daar geschreven
ls *.txt > /dev/null 2>&1  
if [ $? -ne 0 ] # $? gebruikt de output van de vorige lijn
then echo "There are 0 *.txt files"
else
 let i=0
 for file in *.txt
 do
   let i++
 done
 echo "There are $i files ending in .txt"
fi
