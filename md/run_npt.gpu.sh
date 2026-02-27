#!/bin/sh

# gm43 RTX3080 needs Amber20
export AMBERHOME=/home/qwang/amber_source_files/amber20
export PATH=/usr/lib64/mpich-3.2/bin:$PATH
export LD_LIBRARY_PATH=/usr/lib64/mpich-3.2/lib:$LD_LIBRARY_PATH
# /home/qwang/amber_source_files/amber20/bin/pmemd, pmemd.MPI , pmemd.cuda_SPFP

# GPU ID
export CUDA_VISIBLE_DEVICES=0

prmtop=out.prmtop
new_out=npt.out
old_rst=heat.rst
new_rst=npt.rst
new_mdcrd=npt.mdcrd

cat > npt.in <<EOF
eq NPT 2ns
&cntrl
 imin=0,
 nstlim=1000000, dt=0.002,
 ntpr=50000, ntwr=50000, ntwx=50000,
 irest=1, ntx=5,
 ioutfm=0, iwrap=1,
 ntc=2, ntf=2,
 ntt=3, gamma_ln=3,ig=71111
 tempi=300.0, temp0=300.0,
 ntb=2, 
 ntp=1,
 cut=12.0,
/
EOF
echo "AMBERHOME IS $AMBERHOME "


#$my_mpirun $AMBERHOME/bin/pmemd.cuda_SPFP.MPI \
$AMBERHOME/bin/pmemd.cuda_SPFP \
                  -O -i npt.in \
                     -o $new_out \
                     -p $prmtop \
                     -c $old_rst \
                     -r $new_rst \
                     -x $new_mdcrd \
       >& /dev/null
