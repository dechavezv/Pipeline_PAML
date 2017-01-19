#! /bin/bash

echo '############'
echo Aminoacid_to_nucleotide
echo '############'
for dir in Dir_*;do / 
(cd $dir && /
mv ENSCAFG* Transcript_database.txt && /
mkdir metAl_compare_Prank && /
cp musscle_* metAl_compare_Prank && / 
vespa.py map_alignments -input=metAl_compare_Prank/ -database=Transcript_database.txt
);done


echo '############'
echo Get_alingment_in_phylip_format
echo '############'

for dir in Dir_*;do (cd $dir && cp fasta2phylip.pl Map_Gaps_metAl_compare_Prank && /
cd Map_Gaps_metAl_compare_Prank && /
sed -i -r 's/(>\w+)\|\w+\|\w+\|./\1/g' *.fasta && / 
for file in *.fasta; do perl fasta2phylip.pl $file > $file.phy;done);done
pwd

echo '############'
echo Set_envitoment_for_Paml_analysis
echo '############'

for dir in Dir_*;do (cp -r tree/ $dir && /
cd $dir && /
cp tree.txt Map_Gaps_metAl_compare_Prank  && pwd && /
cp GenerateCodemlWorkspace.pl Map_Gaps_metAl_compare_Prank && /
cp -r CodemlWrapper/ Map_Gaps_metAl_compare_Prank/ && /
cp -r tree Map_Gaps_metAl_compare_Prank/ 
cd Map_Gaps_metAl_compare_Prank && /
cp tree.txt tree/modelA/Omega1/tree && /
cp *.phy tree/modelA/Omega1/align.phy && /
cp tree.txt tree/modelAnull/Omega1/tree && /
cp *.phy tree/modelAnull/Omega1/align.phy);done

echo '############'
echo PAML annalysis
echo '############'

for dir in Dir_*;do (cd $dir && cd Map_Gaps_metAl_compare_Prank/tree/modelA/Omega1 && /
ln -s /opt/paml4.6/bin/codeml && ./codeml && /
cd .. && cd .. && /
cd modelAnull/Omega1 && ln -s /opt/paml4.6/bin/codeml && ./codeml);done
 
echo '############'
echo Move_output_folder
echo '############'
for dir in Dir_*;do (cd $dir && cd Map_Gaps_metAl_compare_Prank/ && /
mv tree Tree_$dir && /
cp -r Tree_$dir /work/dechavezv/Pipeline/Beds/testing_GATK/PAML/PAML_out);done
