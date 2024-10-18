# 定义网络
sudo virsh net-define ../config/my-network.xml

# 启动网络
sudo virsh net-start my-network

# 设置网络开机自启动
sudo virsh net-autostart my-network

sudo virsh net-list --all




