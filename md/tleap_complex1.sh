#for complex of small mecular and protein(for mmgbsa
#tleap.in
#source protein water and little molecular force filed


##amber20
export AMBERHOME=/home3/htlin/amber20

protein=protein.pdb
ligand=lig_h.mol2
lig_frcmod=lig.frcmod

cat > input_leap <<EOF


source leaprc.protein.ff19SB               
source leaprc.water.opc                 
source leaprc.gaff                         
#source little molecular ff file and ion ff
loadamberparams $lig_frcmod          

p = loadpdb $protein                     
l = loadmol2 $ligand             
c = combine {p l}
 
savepdb p pro.pdb
savepdb l lig.pdb
savepdb c com.pdb

saveamberparm p pro.prmtop pro.inpcrd
saveamberparm l lig.prmtop lig.inpcrd
saveamberparm c com.prmtop com.inpcrd

solvateoct c OPCBOX 12.0
 
charge c
addions c Cl- 0
addions c Na+ 0

saveoff l lig.lib
saveamberparm c out.prmtop out.inpcrd #1
savepdb c out.pdb                     #1
quit

EOF

# Run tleap
 $AMBERHOME/bin/tleap -f ./input_leap

