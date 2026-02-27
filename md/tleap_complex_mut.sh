#for complex of small mecular and protein(for mmgbsa
#tleap.in
#source protein water and little molecular force filed

##amber18
#export AMBERHOME=/home3/qwang/amber/amber18
##amber20
export AMBERHOME=/home3/htlin/amber20

protein=protein.pdb
protein_mut=protein_mut.pdb
ligand=lig_h.mol2
lig_frcmod=lig.frcmod

cat > input_leap <<EOF


source leaprc.protein.ff19SB               
source leaprc.water.tip3p                 
source leaprc.gaff                         
#source little molecular ff file and ion ff
loadamberparams $lig_frcmod          
loadamberparams frcmod.ionsjc_tip3p   

p = loadpdb $protein                     
m = loadpdb $protein_mut                     
l = loadmol2 $ligand             
c = combine {p l}
d = combine {m l} 

savepdb p pro.pdb
savepdb m pro_mut.pdb
savepdb l lig.pdb
savepdb c com.pdb
savepdb d com_mut.pdb

saveamberparm p pro.prmtop pro.inpcrd
saveamberparm m pro_mut.prmtop pro_mut.inpcrd
saveamberparm l lig.prmtop lig.inpcrd
saveamberparm c com.prmtop com.inpcrd
saveamberparm d com_mut.prmtop com_mut.inpcrd

solvateoct c TIP3PBOX 12.0
 
charge c
addions c Cl- 0
addions c Na+ 0

saveoff l lig.lib
saveamberparm c out.prmtop out.inpcrd #1
savepdb c out.pdb                     #1
saveamberparm d out_mut.prmtop out_mut.inpcrd #1
savepdb c out_mut.pdb                     #1
quit

EOF

# Run tleap
 $AMBERHOME/bin/tleap -f ./input_leap
#
 

