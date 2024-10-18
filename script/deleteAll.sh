# 定义目录路径
TEMP_DIR="../temp"


# 获取所有虚拟机的名称
vm_list=$(sudo virsh list --all --name)

# 检查是否有虚拟机
if [ -z "$vm_list" ]; then
  echo "没有找到虚拟机。"
  exit 0
fi

# 停止并删除每个虚拟机，同时删除临时目录下同名的文件夹
for vm in $vm_list; do
  if [ -n "$vm" ]; then
    #echo "停止虚拟机: $vm"
    sudo virsh destroy "$vm"
    
    #echo "删除虚拟机: $vm"
    sudo virsh undefine "$vm"

    # 检查并删除临时目录下同名的文件夹
    temp_dir_path="$TEMP_DIR/$vm"
    if [ -d "$temp_dir_path" ]; then
      echo "删除目录: $temp_dir_path"
      rm -rf "$temp_dir_path"
    else
      echo "目录不存在: $temp_dir_path"
    fi
  fi
done



echo "所有虚拟机及其对应的临时目录已停止并删除。"

