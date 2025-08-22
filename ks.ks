# Fedora KDE Minimal Kickstart with Forced Initial Setup
# Purpose: Basic KDE installation with guaranteed Initial Setup on first boot
# Use with: Fedora Everything NetInstall or Server ISO (NOT Live ISO)

# --- Locale, keyboard, time ---
lang en_US.UTF-8
keyboard --vckeymap=us --xlayouts='us'
timezone America/New_York --utc

# --- Installer mode ---
graphical

# --- Networking ---
network --bootproto=dhcp --device=link --activate

# --- Mirrors / repos ---
url --mirrorlist=https://mirrors.fedoraproject.org/mirrorlist?repo=fedora-$releasever&arch=$basearch

# Lock root (user will be created by Initial Setup)
rootpw --lock

# --- Bootloader ---
bootloader --location=mbr

# --- Disk layout (WARNING: wipes sda) ---
clearpart --all --initlabel --drives=sda
autopart

# --- License ---
eula --agreed

# --- Extra repos ---
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
set -x  # Enable debugging to see what's happening

echo "Starting post-installation configuration..."

# Method 1: Direct file creation
echo "Creating /etc/reconfigSys directly..."
touch /etc/reconfigSys
chmod 644 /etc/reconfigSys
echo "TRIGGER" > /etc/reconfigSys  # Put content in it to ensure it's not empty

# Method 2: Create a service that ensures the file exists on first boot
echo "Creating first-boot trigger service..."
cat > /etc/systemd/system/create-initial-setup-trigger.service << 'EOF'
[Unit]
Description=Create Initial Setup trigger file
Before=initial-setup.service
DefaultDependencies=no
ConditionPathExists=!/var/lib/initial-setup/initial-setup-done

[Service]
Type=oneshot
ExecStart=/bin/bash -c 'touch /etc/reconfigSys && chmod 644 /etc/reconfigSys'
RemainAfterExit=yes

[Install]
WantedBy=sysinit.target
EOF

# Method 3: Create a script that runs on first boot
echo "Creating first-boot script..."
cat > /usr/local/bin/force-initial-setup.sh << 'EOF'
#!/bin/bash
# This script forces Initial Setup to run if it hasn't already
if [ ! -f /var/lib/initial-setup/initial-setup-done ]; then
    echo "Forcing Initial Setup to run..."
    touch /etc/reconfigSys
    chmod 644 /etc/reconfigSys
    systemctl enable initial-setup.service
    systemctl enable initial-setup-graphical.service
    systemctl disable sddm.service
    systemctl stop sddm.service 2>/dev/null || true
    systemctl start initial-setup.service
fi
EOF
chmod +x /usr/local/bin/force-initial-setup.sh

# Create a service to run the script
cat > /etc/systemd/system/force-initial-setup.service << 'EOF'
[Unit]
Description=Force Initial Setup on first boot
Before=display-manager.service
After=multi-user.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/force-initial-setup.sh
RemainAfterExit=yes

[Install]
WantedBy=graphical.target
EOF

# Enable all our services
systemctl enable create-initial-setup-trigger.service
systemctl enable force-initial-setup.service
systemctl enable initial-setup.service
systemctl enable initial-setup-graphical.service

# Disable SDDM completely
systemctl disable sddm.service
systemctl mask sddm.service

# Method 4: Create the file in multiple places to be sure
touch /etc/reconfigSys
echo "TRIGGER" > /etc/sysconfig/initial-setup-trigger
mkdir -p /var/lib/initial-setup
touch /var/lib/initial-setup/run-initial-setup

# Method 5: Modify the initial-setup service to not check for the file
mkdir -p /etc/systemd/system/initial-setup.service.d
cat > /etc/systemd/system/initial-setup.service.d/override.conf << 'EOF'
[Unit]
# Remove the condition that checks for reconfigSys
ConditionPathExists=

[Service]
# Force it to run
ExecStartPre=/bin/touch /etc/reconfigSys
EOF

# Verify everything
echo "=== Verification ==="
echo "Checking if /etc/reconfigSys exists:"
ls -la /etc/reconfigSys 2>/dev/null || echo "File not found!"

echo "Checking enabled services:"
systemctl is-enabled initial-setup.service || echo "initial-setup not enabled!"
systemctl is-enabled initial-setup-graphical.service || echo "initial-setup-graphical not enabled!"
systemctl is-enabled sddm.service 2>/dev/null && echo "WARNING: SDDM is enabled!"

echo "Checking masked services:"
systemctl is-enabled sddm.service 2>/dev/null || echo "SDDM is properly disabled/masked"

echo "Files created:"
ls -la /etc/reconfigSys 2>/dev/null && echo "✓ /etc/reconfigSys"
ls -la /usr/local/bin/force-initial-setup.sh 2>/dev/null && echo "✓ force-initial-setup.sh"
ls -la /etc/systemd/system/create-initial-setup-trigger.service 2>/dev/null && echo "✓ trigger service"
ls -la /etc/systemd/system/force-initial-setup.service 2>/dev/null && echo "✓ force service"

echo "Post-installation configuration complete."
%end

# Reboot after installation
reboot
