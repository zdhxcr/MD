#!/bin/bash

# 获取所有 TER 行号
ter_lines=($(grep -n "TER" com.pdb | cut -d':' -f1))
num_ter=${#ter_lines[@]}

# 自动判断结构情况并提取小分子 residue ID
if [ "$num_ter" -eq 2 ]; then
    # 只有一个蛋白 + 小分子
    echo "检测到：一个蛋白 + 一个小分子"
    lig_line=$(( ter_lines[1] - 1 ))
    res_lig=$(sed -n "${lig_line}p" com.pdb | awk '{print $5}')
    protein=$(( res_lig - 1 ))
elif [ "$num_ter" -eq 3 ]; then
    # 两个蛋白 + 小分子
    echo "检测到：两个蛋白 + 一个小分子"
    lig_line=$(( ter_lines[2] - 1 ))
    res_lig=$(sed -n "${lig_line}p" com.pdb | awk '{print $5}')
    protein=$(( res_lig - 1 ))
else
    echo "错误：com.pdb 中的 TER 数量不是 2 或 3，无法判断结构。"
    exit 1
fi

pro="1-$protein"

echo "小分子 residue ID: $res_lig"
echo "蛋白 residue 范围: $pro"

# 生成 ptrajInput.dat
cat > ptrajInput.dat <<EOF
trajin autoimage.mdcrd
#trajin prd2.mdcrd

#autoimage :$pro@CA,C,N

# 配体 RMSD，align 到蛋白 backbone
rms :$pro@CA,C,N first  mass perres perresout $1 range "$res_lig"  perresmask &!(@H=)
EOF

# 运行 cpptraj 分析
#amber20
cpptraj=/home3/htlin/amber20/bin/cpptraj.MPI
prmtop=out.prmtop

mpirun -np 4 $cpptraj -p $prmtop -i ptrajInput.dat > ptraj_rmsd.txt 2>&1
#mpirun -np 4 /home3/qwang/amber/amber18/bin/cpptraj.MPI -p out.prmtop -i ptrajInput.dat

