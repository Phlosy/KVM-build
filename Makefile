# Makefile for setting up the environment

# 定义变量
IMAGE_URL=https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img
IMAGE_DIR=../dev
IMAGE_NAME=jammy-server-cloudimg-amd64.img
DISK_IMAGE=../dev/jammy-server-cloudimg-amd64-disk-kvm.img

# 默认目标
all: install_packages setup_libvirt create_file download_image resize_image set_permissions

# 更新包列表并安装必要的软件包
install_packages:
	sudo apt update
	sudo apt install -y \
		qemu-system-x86 \
		virt-manager \
		libvirt-daemon-system \
		virtinst \
		libvirt-clients \
		bridge-utils \
		cloud-init

# 启用并启动 libvirtd 服务，添加用户组
setup_libvirt:
	sudo systemctl enable --now libvirtd
	sudo systemctl start libvirtd
	sudo usermod -aG kvm $$USER
	sudo usermod -aG libvirt $$USER

create_file:
	mkdir -p dev
	mkdir -p temp

# 下载镜像文件并保存到指定目录，如果目录不存在则创建
download_image: $(IMAGE_DIR)
	wget -O $(IMAGE_DIR)/$(IMAGE_NAME) $(IMAGE_URL)

# 调整磁盘镜像大小
resize_image: $(DISK_IMAGE)
	qemu-img resize $(DISK_IMAGE) +20G

# 设置 KVM 目录权限，递归设置目录权限
set_permissions:
	sudo chmod -R o+rx /home

# 卸载软件包并删除下载的镜像文件
clean:
	sudo apt remove --purge -y \
		qemu-system-x86 \
		virt-manager \
		libvirt-daemon-system \
		virtinst \
		libvirt-clients \
		bridge-utils \
		cloud-init
	sudo apt autoremove -y
	sudo apt clean
	rm -rf $(IMAGE_DIR)

