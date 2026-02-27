#!/bin/sh
## gm43 RTX3080 needs Amber20
export AMBERHOME=/home/qwang/amber_source_files/amber20
export PATH=/usr/lib64/mpich-3.2/bin:$PATH
export LD_LIBRARY_PATH=/usr/lib64/mpich-3.2/lib:$LD_LIBRARY_PATH
# /home/qwang/amber_source_files/amber20/bin/pmemd, pmemd.MPI , pmemd.cuda_SPFP
#
# GPU ID
export CUDA_VISIBLE_DEVICES=1

prmtop=out.prmtop
new_out=heat.out
old_rst=min.rst
new_rst=heat.rst
new_mdcrd=heat.mdcrd
heat=heat.in

 cat > heat.in <<EOF
 Heat
 &cntrl
  imin=0,
  nstlim=1000000, dt=0.001,
  irest=0, ntx=1,
  ntpr=50000, ntwr=50000, ntwx=50000,
  ioutfm=0, iwrap=1,
  ntt=3, gamma_ln=3, ig=77777,
  ntb=1, ntp=0,
  tempi=0.0, temp0=300.0,
  ntc=2, ntf=2,
  cut=12.0,
/
EOF

#my_mpirun='mpirun -np 8'
echo "AMBERHOME IS $AMBERHOME "

#$my_mpirun $AMBERHOME/bin/pmemd.cuda_SPFP.MPI \
$my_mpirun $AMBERHOME/bin/pmemd.cuda_SPFP -O -i $heat -o $new_out -x $new_mdcrd -p $prmtop -c $old_rst -r $new_rst
# > heat.log 2>&1
