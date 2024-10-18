# KVM build

## Project Overview

This project is designed to manage the creation and deletion of virtual machines (VMs) using `virsh` and cloud-init, with automated networking setup and cleanup. The scripts provided here handle tasks such as defining and starting a network, creating VMs with specific resources, and cleaning up both VMs and the corresponding network.

### Project Structure

```bash
.
├── config
│   └── my-network.xml         # XML file for network configuration
├── dev                        # Source cloud image for creating VMs
├── Makefile                   # Makefile for simplified execution
├── README.md                  # Project documentation (this file)
├── script
│   ├── createNet.sh           # Script to define and start the network
│   ├── createVm.sh            # Script to create VMs
│   ├── deleteAll.sh           # Script to delete all VMs and corresponding directories
│   ├── deleteNet.sh           # Script to destroy and undefine the network
│   └── deleteVm.sh            # Script to delete a specific VM
├── src
│   ├── meta-data              # Metadata file for cloud-init
│   └── user-data              # User data file for cloud-init configuration
└── temp                       # Temporary directory for VM storage
```

## Build
### Set Up the Environment

To install all necessary packages and configure the environment, run:
```bash
make
```

This command will:
- Install required software packages
- Enable and start the libvirtd service
- Download the Ubuntu cloud image
- Resize the disk image
- Set appropriate permissions

### Clean Up the Environment

To uninstall the packages and remove downloaded files, run:

```bash
make clean
```

- This command will:
- Uninstall the installed software packages
- Remove residual configuration files
- Delete the downloaded images and directories

## Usage
### 1. Network Management
#### Create and Start Network

```bash
./script/createNet.sh
```

This will define the network specified in `config/my-network.xml` and start it. Additionally, the network will be set to autostart on boot.

#### Delete Network

```bash
./script/deleteNet.sh
```

This will stop the network and remove the network definition.

### 2. Virtual Machine Management
#### Create a New VM

```bash
./script/createVm.sh <vm_name> <cpu_cores> <memory_size_MB> <disk_size>
```

`<vm_name>`: The name of the virtual machine and corresponding directory under temp/
`<cpu_cores>`: Number of CPU cores assigned to the VM
`<memory_size_MB>`: Amount of memory in MB (e.g., 2048 for 2GB)
`<disk_size>`: Size of the disk to be added to the VM (e.g., 20G)

Example:

```bash
./script/createVm.sh my-vm 2 2048 20G
```

This script performs the following steps:

#### Delete a Specific VM

```bash
./script/deleteVm.sh <vm_name>
```

This stops the VM, undefines it, and removes the corresponding directory under `temp/.`

#### Delete All VMs

```bash
./script/deleteAll.sh
```

This will iterate through all existing VMs, stop them, undefine them, and remove their respective folders under temp/.