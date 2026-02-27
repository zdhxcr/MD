#!/bin/sh
##amber18
#export AMBERHOME=/home3/qwang/amber/amber18
##amber20
export AMBERHOME=/home3/htlin/amber20
test -f /home3/htlin/amber20/amber.sh    && source /home3/htlin/amber20/amber.sh ##check the amber20
# /home/qwang/amber_source_files/amber20/bin/pmemd, pmemd.MPI , pmemd.cuda_SPFP



START_FRAME=1  
END_FRAME=1000  
FRAME_INTERVAL=10  
SEGMENT_SIZE=100  


TRAJ_FILE="prd1.mdcrd"
SOLVENT_PRMTOP="out.prmtop" 
COMPLEX_PRMTOP="com.prmtop"
PROTEIN_PRMTOP="pro.prmtop"
LIGAND_PRMTOP="lig.prmtop"
OUT_TXT="bingding_enerngy.txt"

for ((i=START_FRAME; i<=END_FRAME; i+=SEGMENT_SIZE)); do
  SEG_START=$i
  SEG_END=$((i + SEGMENT_SIZE - 1))

  
  if [ $SEG_END -gt $END_FRAME ]; then
    SEG_END=$END_FRAME
  fi


  cat > mmgbsa.in <<EOF
Input for mmpbsa.py
&general
 startframe=${SEG_START}, endframe=${SEG_END}, interval=${FRAME_INTERVAL},
 keep_files=2,
 strip_mask=":WAT:Cl-:CIO:Cs+:IB:K+:Li+:MG2:Na+:Rb+:ZN:PA:PC:OL"
/
&gb
 igb=5, 
/
EOF


  OUTPUT_FILE="mmgbsa.out.prd1-$((SEG_START / SEGMENT_SIZE + 1))"
##amber18 and amber20
  $AMBERHOME/bin/MMPBSA.py -O -i mmgbsa.in -o $OUTPUT_FILE \
    -sp $SOLVENT_PRMTOP -cp $COMPLEX_PRMTOP -rp $PROTEIN_PRMTOP -lp $LIGAND_PRMTOP \
    -y $TRAJ_FILE
##amber20
#  $AMBERHOME/bin/MMPBSA.py -O -i mmgbsa.in -o $OUTPUT_FILE \
#    -sp $SOLVENT_PRMTOP -cp $COMPLEX_PRMTOP -rp $PROTEIN_PRMTOP -lp $LIGAND_PRMTOP \
#    -y $TRAJ_FILE
#
grep "DELTA TOTAL" $OUTPUT_FILE >> $OUT_TXT

done

echo "MM/GBSA calculations completed!"
