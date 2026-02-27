#!/bin/bash

# 简化版本：只提取丙氨酸扫描结果

OUTPUT_FILE=$1

# 写入表头
echo -e "Folder\tMutation\tMean_DDG\tMean_Error" > $OUTPUT_FILE

# 查找所有mut开头的子文件夹
for folder in mut*/; do
    # 移除末尾的/
    folder=${folder%/}
    echo "处理文件夹: $folder"
    
    # 存储所有文件的DDG值和误差
    ddg_values=()
    error_values=()
    
    # 查找该文件夹中的所有mmgbsa.out.prd-*文件
    for file in "$folder"/mmgbsa.out.prd-*; do
        if [[ ! -f "$file" ]]; then
            continue
        fi
        
        # 提取丙氨酸扫描结果行
        result_line=$(grep "RESULT OF ALANINE SCANNING:" "$file")
        
        if [[ -n "$result_line" ]]; then
            # 提取突变名称（括号内的内容）
            mutation=$(echo "$result_line" | grep -o '([^)]*)' | tr -d '()')
            
            # 提取DDG值和误差
            ddg_value=$(echo "$result_line" | awk -F '=' '{print $2}' | awk '{print $1}')
            error_value=$(echo "$result_line" | awk -F '+/-' '{print $2}' | awk '{print $1}')
            
            if [[ -n "$ddg_value" && -n "$error_value" ]]; then
                ddg_values+=("$ddg_value")
                error_values+=("$error_value")
            fi
        fi
    done
    
    # 计算统计量
    if [[ ${#ddg_values[@]} -gt 0 ]]; then
        # 计算DDG的平均值
        mean_ddg=$(printf '%s\n' "${ddg_values[@]}" | awk '{sum+=$1; count++} END {if(count>0) printf "%.4f", sum/count; else print "0"}')
        
        # 计算误差的平均值
        mean_error=$(printf '%s\n' "${error_values[@]}" | awk '{sum+=$1; count++} END {if(count>0) printf "%.4f", sum/count; else print "0"}')
        
        # 使用第一个文件的突变名称
        first_mutation="$mutation"
        
        echo -e "$folder\t$first_mutation\t$mean_ddg\t$mean_error" >> $OUTPUT_FILE
        echo "  成功处理: ${#ddg_values[@]} 个文件, 突变: $first_mutation, Mean_DDG: $mean_ddg, Mean_Error: $mean_error"
    else
        echo "  警告: 在 $folder 中未找到有效数据"
    fi
done

echo "分析完成！结果保存在: $OUTPUT_FILE"
