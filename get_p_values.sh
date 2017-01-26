#!/bin/bash

echo Author Daniel E. Chavez 2017

#this script will edit the LRT files in order to be used within the calculate_pvalues.R script
#Be sure first to concatenate the files using cat
#Be sure to have the following scripts in the same path were your LRT_file(s) are/is located at

export input=Wild_dog_withJackal20x_raw_LRT_III.txt

echo '##############'
echo Editing_LRT_file
echo '##############'

grep -E -v '^[0-9]|^\w+$' ${input} > Edited_${input} #delete empty line from file
python calculate_LTR.py Edited_${input} LRT_Edited_${input} #calculate LRT, for mor einformation on how to calculate LRT and p_valus go to https://evosite3d.blogspot.com/2011/09/identifying-positive-selection-in.html 
Rscript calculate_pvalues.R LRT_Edited_${input} Pvalue_${input} #calculate p_calues with one degree of freedom
sed -e 's/"//g' Pvalue_${input} > Edited_Pvalue_${input} #erase the symbol " obtained from the previous script
grep -wF -f List_genesFiltered_CovariatesFixed_dictionary.txt Edited_Pvalue_${input} > Filtered_${input} #this will keep elements from file 1 within file2
rm Edited_${input}  #delete intermidiate files
rm Pvalue_${input} #delete intermidiate files
rm Edited_Pvalue_${input} #delete intermidiate files
rm LRT_Edited_${input} #delete intermidiate files
