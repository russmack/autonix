#!/bin/bash

# Install Nixos

# Dwfault setup:
# VM installation
# Legacy Boot MBR
# 20GB drive:
#   17GB primary
#   2GB swap

sudo su

# Partition

# Swap size suggestions:
# RAM Size	Swap Size (Without Hibernation)	 Swap size (With Hibernation)
# 256MB	    256MB	                         512MB
# 512MB	    512MB	                         1GB
# 1GB	    1GB	                             2GB
# 2GB	    1GB	                             3GB
# 3GB	    2GB	                             5GB
# 4GB	    2GB	                             6GB
# 6GB	    2GB	                             8GB
# 8GB	    3GB	                             11GB
# 12GB	    3GB	                             15GB
# 16GB	    4GB	                             20GB
# 24GB	    5GB	                             29GB
# 32GB	    6GB	                             38GB
# 64GB	    8GB	                             72GB
# 128GB	    11GB	                         139GB

# This is a two partition setup: primary, and swap.
# Swap partition size in GB.
# Primary partition is assigned the remainder.
SWAP_SIZE=2

parted /dev/sda -- mklabel msdos
# Primary partition from 1MB to minus the swap size.
parted /dev/sda -- mkpart primary 1MiB "-${SWAP_SIZE}GiB"
# Swap partition from minus the swap size to the end of the disk.
parted /dev/sda -- mkpart primary linux-swap "-${SWAP_SIZE}GiB" 100%

# Or using percentages:
# parted /dev/sda -- mkpart primary 1MiB 75%
# parted /dev/sda -- mkpart primary linux-swap 75% 100%

# Format and mount
mkfs.ext4 -L nixos /dev/sda1
mkswap -L swap /dev/sda2

mount /dev/disk/by-label/nixos /mnt
swapon /dev/sda2

# Configure OS
nixos-generate-config --root /mnt
# TODO: automate this:
nano /mnt/etc/nixos/configuration.nix
# Set the boot.loader.grub.device to /dev/sda

# Install
nixos-install
useradd -c russ -m russ
reboot

# Possible error: lvmconfig failed
# Solution: nix-channel --update

