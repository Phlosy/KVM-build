#!/bin/bash

# 定义目录路径
TEMP_DIR="../temp"

# 获取输入参数作为虚拟机名称
vm_name=$1

# 检查是否提供了虚拟机名称
if [ -z "$vm_name" ]; then
  echo "请提供虚拟机名称作为输入参数。"
  exit 1
fi

# 检查虚拟机是否存在
vm_exists=$(virsh list --all --name | grep "^${vm_name}$")
if [ -z "$vm_exists" ]; then
  echo "虚拟机 $vm_name 不存在。"
  exit 1
fi

# 停止虚拟机
echo "停止虚拟机: $vm_name"
sudo virsh destroy "$vm_name"

# 删除虚拟机
echo "删除虚拟机: $vm_name"
sudo virsh undefine "$vm_name"

# 检查并删除临时目录下同名的文件夹
temp_dir_path="$TEMP_DIR/$vm_name"
if [ -d "$temp_dir_path" ]; then
  echo "删除目录: $temp_dir_path"
  rm -rf "$temp_dir_path"
else
  echo "目录不存在: $temp_dir_path"
fi

echo "虚拟机 $vm_name 及其对应的临时目录已停止并删除。"
