#!/bin/sh

new_out=min.out
top=out.prmtop
crd=out.inpcrd
new_rst=min.rst
new_mdcrd=min.mdcrd
cat > min.in <<EOF
Minimization
&cntrl
 imin=1, maxcyc=2000, ncyc=1000,
 ntpr=100, ntwr=500, ntwx=1000, 
 ioutfm=0, 
 ntb=1,
 cut=12.0,
/
EOF

##amber20
my_amber=/home/htlin/home3/amber20
mpirun -np 6 \
$my_amber/bin/sander.MPI -O -i min.in \
                            -o $new_out \
                            -p $top \
                            -c $crd \
                            -r $new_rst \
                            -x $new_mdcrd \


       >& /dev/null

