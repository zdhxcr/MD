#!/bin/sh
#this is for rmsd analysis

prmtop=out.prmtop  #top
mdcrd_1=prd1.mdcrd 
mdcrd_2=prd2.mdcrd 
new_mdcrd=autoimage.mdcrd

cat > ptrajInput.dat <<EOF
trajin $mdcrd_1
trajin $mdcrd_2
 autoimage 
center ":WAT" origin
trajout $new_mdcrd crd
#
EOF
###
#amber18
#cpptraj=/home3/qwang/amber/amber18/bin/cpptraj.MPI
#amber20
cpptraj=/home3/htlin/amber20/bin/cpptraj.MPI
 
mpirun -np 4 $cpptraj -p $prmtop -i ptrajInput.dat > ptraj_autoimage.txt 2>&1 
