#!/bin/bash
# 批量Ala扫描自动化脚本
# 用法: bash batch_mut.sh

# ================= 用户可配置区域 =================
##amber20
export AMBERHOME=/home3/htlin/amber20
test -f /home3/htlin/amber20/amber.sh    && source /home3/htlin/amber20/amber.sh ##check the amber20
mut_list=(228 229 230 231 232 233)   # 要突变的残基号（一次修改一个）
protein="protein.pdb"
# =================================================

# 检查输入文件是否存在
for f in tleap_complex_mut.sh run_alascan.sh lig_h.mol2 lig.frcmod "$protein"; do
  if [ ! -f "$f" ]; then
    echo "❌ 缺少必要文件: $f"
    exit 1
  fi
done

# 生成负责修改PDB的Python脚本（仅保留N/CA/C并改名为ALA）
cat > make_mut.py <<'EOF'
import sys
input_pdb, output_pdb, target = sys.argv[1], sys.argv[2], int(sys.argv[3])
keep_atoms = {"N", "CA", "C"}
with open(input_pdb) as fin, open(output_pdb, "w") as fout:
    for line in fin:
        if not line.startswith(("ATOM", "HETATM")):
            fout.write(line)
            continue
        resnum = int(line[22:26])
        atom = line[12:16].strip()
        if resnum == target:
            if atom in keep_atoms:
                new_line = line[:17] + "ALA" + line[20:]
                fout.write(new_line)
        else:
            fout.write(line)
EOF

# 主循环
for mut in "${mut_list[@]}"; do
  echo "=============================="
  echo "🚀 处理残基 $mut"
  echo "=============================="

  mut_dir="mut${mut}"
  mkdir -p "$mut_dir"

  # 复制必要文件
  cp tleap_complex_mut.sh run_alascan.sh lig* protein.pdb "$mut_dir"/

  # 生成突变PDB文件
  out_pdb="${mut_dir}/protein_${mut}.pdb"
  python3 make_mut.py "$protein" "$out_pdb" "$mut"
  echo "✅ 已生成突变结构: $out_pdb"

  # 修改tleap脚本中的protein_mut行
  sed -i "s|protein_mut=protein_mut.pdb|protein_mut=protein_${mut}.pdb|" "$mut_dir/tleap_complex_mut.sh"

  # 进入目录执行tleap与run_alascan
  cd "$mut_dir" || exit
  echo "⚙️ 运行 tleap_complex_mut.sh ..."
  bash tleap_complex_mut.sh > tleap.log 2>&1
  echo "⚙️ 运行 run_alascan.sh ..."
  bash run_alascan.sh > alascan.log 2>&1
  cd ..

  echo "✅ 残基 $mut 处理完成，结果保存在: $mut_dir/"
  echo
done

echo "🎉 所有残基处理完成！"

