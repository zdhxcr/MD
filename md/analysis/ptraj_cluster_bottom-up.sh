 #!/bin/sh
#

prmtop=out.prmtop
prd1=prd.mdcrd
reference=out.pdb                             #reference always be the out.pdb
autoimage=1-406
rms=409                                      #ligand number
#prd2=prd2.mdcrd
#prd3=prd3.mdcrd
#prd4=prd4.mdcrd
#prd5=prd5.mdcrd

####
cat > ptrajInput.dat <<EOF
trajin $prd1
#trajin $prd2
#trajin $prd3
#trajin $prd4
#trajin $prd5
autoimage :$autoimage@CA,C,N
reference $reference
align   :$autoimage@CA,C,N  reference

strip :PA:PC:OL:WAT:K+:Na+:Cl- outprefix LIG
cluster c1 \
    hieragglo epsilon 2  averagelinkage \
    rms :$autoimage&!@H= nofit \
    pairdist pair-distance.dat \
    out combined.cnumvtime.dat \
    info combined.inf.dat \
    summarysplit split.dat splitframe '500,1000,1500,2000,2500,3000' \
    cpopvtime cpopvtime.agr normframe \
    repout rep repfmt pdb \
    singlerepout singlerep.nc singlerepfmt netcdf \
    avgout avg avgfmt pdb

#    repout clustering \
#    repfmt pdb
EOF

###
##amber20
cpptraj=/home3/htlin/amber20/bin/cpptraj.MPI
mpirun -np 2 $cpptraj -p $prmtop -i ptrajInput.dat > ptraj_comCluster_log_$(date +%F_%T).txt 2>&1

