#!/bin/bash

cpptraj=/home3/htlin/amber20/bin/cpptraj.MPI

prmtop=out.prmtop #拓扑文件
mdcrd1=prd1.mdcrd #轨迹文件
mdcrd2=prd2.mdcrd

# 生成 cpptraj 输入文件
cat > lig-pro-hbond-detail.in <<EOF
parm $prmtop
trajin $mdcrd1
trajin $mdcrd2
distance hb_dist :482@O1 :186@N out test.dat
#angle hb_angle :2251@O1 :1457@HE21 :1457@NE2 out hb_angle_Q698-NE2_LIG-O1.dat

EOF

# 运行 CPU 并行版 cpptraj
mpirun -np 2 $cpptraj  -i lig-pro-hbond-detail.in
