#!/bin/bash

echo Author Daniel E. Chavez 2017

#this script will edit the LRT files in order to be used within the calculate_pvalues.R script
#Be sure first to concatenate the files using cat
#Be sure to have the following scripts in the same path were your LRT_file(s) are/is located at

export input=Wild_dog_withJackal20x_raw_LRT_I.txt

echo '##############'
echo Editing_LRT_file
echo '##############'

grep -E -v '^[0-9]|^\w+$' ${input} > Edited_${input} #delete empty line from file
python calculate_LTR.py Edited_${input} LRT_Edited_${input} #calculate LRT, for mor einformation on how to calculate LRT and p_valus go to https://evosite3d.blogspot.com/2011/09/identifying-positive-selection-in.html 
Rscript calculate_pvalues.R LRT_Edited_${input} Pvalue_${input} #calculate p_calues with one degree of freedom
sed -e 's/"//g' Pvalue_${input} > Edited_Pvalue_${input} #erase the symbol " obtained from the previous script
grep -wF -f List_genesFiltered_CovariatesFixed_dictionary.txt Edited_Pvalue_${input} > Filtered_${input} #this will keep elements from file 1 within file2
awk '!($1="")' Filtered_${input} > P_values_${input}

rm Edited_${input}  #delete intermidiate files
rm Pvalue_${input} #delete intermidiate files
rm Edited_Pvalue_${input} #delete intermidiate files
rm LRT_Edited_${input} #delete intermidiate files
rm Filtered_${input} #delete intermidiate files

#Use the rest of the script only if you have sucesfully obtained the files with p-values from the script shown above

echo '##############'
echo Get_Intersect_List
echo '##############'

#change this part to whatever is the name of your files generated in the section above 
export file1=P_values_Wild_dog_withJackal20x_raw_LRT_I.txt
export file2=P_values_Wild_dog_withJackal20x_raw_LRT_II.txt
export file3=P_values_Wild_dog_withJackal20x_raw_LRT_III.txt

echo '####################'
echo Get_intersect_list_positive_selected_genes
echo '####################'
for file in P_values_Wild_dog*;do grep '*' $file > PS_gene_$file;done #get positive selected genes
for file in PS_gene_*;do awk -F " " '{print $1}' $file > List_$file;done #get just the Ensembl_ID of genes
grep -wF -f List_PS_gene_${file3} List_PS_gene_${file2} > List_PS_gene_III_II.txt #keep elements from *_file3 contained in *_file2 
grep -wF -f List_PS_gene_${file1} List_PS_gene_III_II.txt > List_PS_gene_III_II_I.txt #keep elements from *_file3 and *_file2 contained in *_file1
cat PS_gene_* > Concatenate_PS_gene_I_II_III.txt 
grep -wF -f List_PS_gene_III_II_I.txt Concatenate_PS_gene_I_II_III.txt > Intersect_PS_genes_wild_dog.txt # genes under postive selection contained in all the files with their p-values 
awk '!seen[$1]++' Intersect_PS_genes_wild_dog.txt > Unique_Intersect_PS_genes_wild_dog.txt # keep only unique IDS 

echo '####################'
echo Get_intersect_list_No_significant_genes
echo '####################'
for file in P_values_Wild_dog*;do grep -P '\sNS$' $file > NS_gene_$file;done
for file in NS_gene_*;do awk -F " " '{print $1}' $file > List_$file;done
grep -wF -f List_NS_gene_${file3} List_NS_gene_${file2} > List_NS_gene_III_II.txt
grep -wF -f List_NS_gene_${file1} List_NS_gene_III_II.txt > List_NS_gene_III_II_I.txt
cat NS_gene_* > Concatenate_NS_gene_I_II_III.txt
grep -wF -f List_NS_gene_III_II_I.txt Concatenate_NS_gene_I_II_III.txt > Intersect_NS_genes_wild_dog.txt
awk '!seen[$1]++' Intersect_NS_genes_wild_dog.txt > Unique_Intersect_NS_genes_wild_dog.txt

echo '####################'
echo Concatenate_intersect_list_NS_PS_genes
echo '####################'
cat Unique_Intersect_PS_genes_wild_dog.txt Unique_Intersect_NS_genes_wild_dog.txt > Wild_dog_withJackal20x_LRT_I_II_III.txt

rm List_*
rm Concatenate_*
rm Intersect_*
rm PS_*
rm NS_*
rm Unique_*
