#!/bin/bash

# 获取输入参数
name_folders=$1        # 文件夹名称
cpu_cores=$2           # CPU 核心数
memory_size=$3         # 内存大小 (以 MB 为单位)
disk_size=$4           # 磁盘大小 (例如 +20G)

# 创建新的文件夹
NEW_FOLDER="../temp/${name_folders}"
mkdir -p "$NEW_FOLDER"

# 镜像路径
SOURCE_IMG="../dev/jammy-server-cloudimg-amd64.img"
TARGET_IMG="$NEW_FOLDER/jammy-server-cloudimg-amd64-disk-kvm.img"
cp "$SOURCE_IMG" "$TARGET_IMG"

# 生成新的 cloud-init ISO
USER_DATA="../src/user-data"  # 替换为 user-data 文件的路径
META_DATA="../src/meta-data"  # 替换为 meta-data 文件的路径
CLOUD_INIT_ISO="$NEW_FOLDER/cloud-init.iso"
genisoimage -output "$CLOUD_INIT_ISO" -volid cidata -rational -joliet -rock "$USER_DATA" "$META_DATA"

# 虚拟机名称
VM_NAME="${name_folders}"

# 调整磁盘大小
qemu-img resize "$TARGET_IMG" +"$disk_size"

# 检查 cloud-init ISO 文件是否存在
if [ ! -f "$CLOUD_INIT_ISO" ]; then
  echo "错误: 找不到 cloud-init ISO 文件 $CLOUD_INIT_ISO"
  exit 1
fi

# 创建并启动虚拟机
sudo virt-install --name "$VM_NAME" \
  --memory "$memory_size" \
  --vcpus "$cpu_cores" \
  --disk path="$TARGET_IMG",format=qcow2 \
  --disk path="$CLOUD_INIT_ISO",device=cdrom \
  --os-variant ubuntu22.04 \
  --import \
  --graphics none \
  --noautoconsole \
  --network network=my-network

# 检查虚拟机是否成功创建
if [ $? -eq 0 ]; then
  echo "虚拟机 $VM_NAME 创建成功"
else
  echo "虚拟机 $VM_NAME 创建失败"
  exit 1
fi
