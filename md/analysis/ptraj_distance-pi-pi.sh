#!/bin/sh
#this is for rmsd analysis

export AMBERHOME=/home3/htlin/amber20  #cpptraj_path

prmtop=out.prmtop  #top
mdcrd=autoimage.mdcrd  #0_500ns_mdcrd_5006_frame

cat > ptrajInput.dat <<EOF
trajin $mdcrd   
#the reference is the first
distance   Y63-LIG_ring   :63@CD1,CG,CD2,CE2,CZ,CE1   :925@C,C1,C13,C14,N2   out  Y_63-LIG_ring.dat  
EOF

mpirun -np 4 \
$AMBERHOME/bin/cpptraj -p $prmtop -i ptrajInput.dat  > ptraj_rmsd.txt 
