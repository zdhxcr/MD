#!/bin/sh
#100ns

#### using pmemd.cuda 
#export AMBERHOME=/home/qwang/home3/amber/amber18
#export PATH=$AMBERHOME/bin:$PATH
#export LD_LIBRARY_PATH=$AMBERHOME/lib:$LD_LIBRARY_PATH

##using mpi
#export AMBERHOME=/home/htlin/home3/amber20
#export PATH=$AMBERHOME/bin:$PATH
#export LD_LIBRARY_PATH=$AMBERHOME/lib:$LD_LIBRARY_PATH
#
### loading CUDA library 10.2 on gm31
##export PATH=/usr/local/cuda-10.2/bin:$PATH
##export LD_LIBRARY_PATH=/usr/local/cuda-10.2/lib64:$LD_LIBRARY_PATH
##export CUDA_HOME=/usr/local/cuda-10.2
#
## loading CUDA library 10.2 on gm32/33
#export PATH=/home3/qwang/amber/cuda-10.2/bin:$PATH
#export LD_LIBRARY_PATH=/home3/qwang/amber/cuda-10.2/lib64:$LD_LIBRARY_PATH
#export CUDA_HOME=/home3/qwang/amber/cuda-10.2
#
# gm43 RTX3080 needs Amber20
export AMBERHOME=/home/qwang/amber_source_files/amber20
export PATH=/usr/lib64/mpich-3.2/bin:$PATH
export LD_LIBRARY_PATH=/usr/lib64/mpich-3.2/lib:$LD_LIBRARY_PATH
# /home/qwang/amber_source_files/amber20/bin/pmemd, pmemd.MPI , pmemd.cuda_SPFP

# GPU ID
export CUDA_VISIBLE_DEVICES=0

in_n=prd1.in
out_n=prd1.out
top_n=out.prmtop
rst_old=npt.rst
rst_new=prd1.rst
mdcrd_new=prd1.mdcrd

cat > $in_n <<EOF
&cntrl
 imin=0,
 nstlim=50000000, dt=0.002,
 irest=1, ntx=5,
 ntpr=50000, ntwr=50000, ntwx=50000,
 ioutfm=0, iwrap=1,
 ntt=3, gamma_ln=3, ig=72222,
 ntb=1, ntp=0,
 tempi=300.0, temp0=300.0,
 ntc=2, ntf=2,
 cut=12.0,
/
EOF

echo "AMBERHOME IS $AMBERHOME "
#my_mpirun='mpirun -np 10'
#$my_mpirun $AMBERHOME/bin/pmemd.MPI \


#$my_mpirun $AMBERHOME/bin/pmemd.MPI \
#my_mpirun='mpirun -np 1'
$AMBERHOME/bin/pmemd.cuda_SPFP \
                  -O -i $in_n \
                     -o $out_n \
                     -p $top_n \
                     -c $rst_old \
                     -r $rst_new \
                     -x $mdcrd_new \
#         >& /dev/null

echo "done"
