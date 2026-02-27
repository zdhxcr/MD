#for complex of small mecular and protein(for mmgbsa
#tleap.in
#source protein water and little molecular force filed

##amber20
export AMBERHOME=/home3/htlin/amber20

pro1=pro1_clear.pdb
pro2=pro2_clear.pdb

cat > input_leap <<EOF


source leaprc.protein.ff19SB               
source leaprc.water.opc         

p = loadpdb $pro1                     
l = loadpdb $pro2            
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
echo "ANBERHOME IS $AMBERHOME"
# Run tleap
 $AMBERHOME/bin/tleap -f ./input_leap
#
 

