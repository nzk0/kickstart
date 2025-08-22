# Fedora KDE Minimal Kickstart

# --- Locale, keyboard, time ---
lang en_US.UTF-8
keyboard --vckeymap=us --xlayouts='us'
timezone America/New_York --utc

# --- Installer mode ---
graphical

# --- Networking ---
network --bootproto=dhcp --device=link --activate

# --- Mirrors / repos used by Anaconda ---
url --mirrorlist=https://mirrors.fedoraproject.org/mirrorlist?repo=fedora-$releasever&arch=$basearch

# --- OEM first-boot experience ---
firstboot --enable --reconfig

# --- Services ---
# Let the system handle service startup order naturally

# Lock root (user will be created by Initial Setup)
rootpw --lock

# --- Bootloader ---
bootloader --location=mbr

# --- Disk layout (WARNING: wipes sda) ---
clearpart --all --initlabel --drives=sda
autopart

# --- License ---
eula --agreed

# --- Extra repos for install time ---
repo --name=updates --mirrorlist=https://mirrors.fedoraproject.org/mirrorlist?repo=updates-released-f$releasever&arch=$basearch

# ============================
# Packages
# ============================
%packages
@core
@base-x
@fonts
@standard
@hardware-support
@networkmanager-submodules

# KDE Plasma Desktop
@kde-desktop

# Initial Setup (GUI)
initial-setup
initial-setup-gui

%end

# ============================
# Post-install configuration
# ============================
%post --log=/root/kickstart-post.log
#!/bin/bash
set -euo pipefail

echo "Starting post-installation configuration..."

# --- Ensure Initial Setup runs on first boot ---
echo "Configuring Initial Setup..."

# Enable the Initial Setup services
systemctl enable initial-setup.service || echo "initial-setup.service not found"
systemctl enable initial-setup-graphical.service || echo "initial-setup-graphical.service not found"

# Create the trigger file for Initial Setup
touch /etc/reconfigSys

# Clean up any existing initial-setup state
rm -f /etc/sysconfig/initial-setup
rm -f /var/lib/initial-setup/initial-setup-done

# Configure initial-setup to run
cat > /etc/sysconfig/initial-setup << 'EOF'
RUN_INITIAL_SETUP=YES
EOF

echo "Post-installation configuration complete."
%end

# Reboot after installation
reboot
