
##amber20
AMBERHOME=/home3/htlin/amber20/
in=lig_h.pdb #the original pdb file of ligand
out1=lig_h.mol2
out2=lig.frcmod
 
 $AMBERHOME/bin/antechamber -fi pdb -i $in -fo mol2 -o $out1 -c bcc -at amber -s 2
 $AMBERHOME/bin/parmchk2  -i $out1 -f mol2 -o $out2 
