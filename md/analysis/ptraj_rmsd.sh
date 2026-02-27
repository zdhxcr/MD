#!/bin/sh
prmtop=out.prmtop  #top
mdcrd_1=autoimage.mdcrd
name1=p2l_100ns_rmsd-protein-noH.dat
name2=p2l_200ns_rmsd-protein-backbone.dat
 

cat > ptrajInput.dat <<EOF
trajin $mdcrd_1

#the reference is the first
  rms :1-294&!@H=  first mass out     $name1          
  rms :1-294@CA,C,N,O= first mass out     $name2

##the reference is "reference.pdb"
#  reference reference.pdb
#  rms :27-129&!@H=  reference mass out      rmsd-protein-noH.dat          
#  rms :27-129@CA,C,N,O= reference mass out      rmsd-protein-backbone.dat
#
##this is for there have >=2 references structures
#  rms ToMember1 :1-13&!@H= reference out rmsd2.agr
#	Mask [:1-13&!@H*] corresponds to 116 atoms.
#    RMSD: (:1-13&!@H*), reference is reference frame trpzip2.1LE1.1.rst7 (:1-13&!@H*), with fitting.
#  rms ToMember10 :1-13&!@H= refindex 1 out rmsd2.agr
#	Mask [:1-13&!@H*] corresponds to 116 atoms.
#    RMSD: (:1-13&!@H*), reference is reference frame trpzip2.1LE1.10.rst7 (:1-13&!@H*), with fitting.
#  rms ToLast :1-13&!@H= ref [last] out rmsd2.agr
#	Mask [:1-13&!@H*] corresponds to 116 atoms.
#    RMSD: (:1-13&!@H*), reference is reference frame trpzip2.gb.nc (:1-13&!@H*), with fitting.
#
##autoimage :27-129:@CA,C,N
##rms reference first out rmsd.agr
##rms reference first out rmsd.dat
##rms :760-1390@CA,C,N, first  mass perres perresout rmsd-ASA-align.dat range 1391 perresmask &!(@H=) #mol
##rms :2-195@CA,C,N first mass perres perresout protein_rmsd-H.dat range 2-195 perresmask &!(@H=)
##rms :2-195@CA,C,N mass reference perres perresout rmsd_rmsf/ligand_rmsd.dat range 282 perresmask &!(@H=)
##atomicfluct out rmsd_rmsf/rmsf.dat :899-923,1243-1267,1576-1600,1910-1934,2253-2277&!@H= byres
#center ":WAT" origin
#autoimage anchor ":29@CA"
#trajout $part.mdcrd crd

EOF
###
#amber18
cpptraj=/home3/qwang/amber/amber18/bin/cpptraj.MPI
#amber20
cpptraj=/home3/htlin/amber20/bin/cpptraj.MPI
 
mpirun -np 4 $cpptraj -p $prmtop -i ptrajInput.dat > ptraj_rmsd.txt 2>&1 
