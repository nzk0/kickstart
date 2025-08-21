# Fedora KDE Gaming-Optimized Kickstart File
# Features: KDE Plasma, Vimix GRUB theme, Snapper snapshots, NVIDIA auto-detection
# Use with Fedora Everything NetInstall or Server ISO (NOT Live ISO)

# System language
lang en_US.UTF-8

# Keyboard layouts
keyboard --vckeymap=us --xlayouts='us'

# System timezone (adjust as needed)
timezone America/New_York --utc

# Use graphical install
graphical

# Network information
network --bootproto=dhcp --device=link --activate
network --hostname=fedora-gaming

# Use Fedora mirrors
url --mirrorlist=https://mirrors.fedoraproject.org/mirrorlist?repo=fedora-$releasever&arch=$basearch

# Run the initial setup on first boot
firstboot --enable

# Lock root account (user will set it during initial setup)
rootpw --lock

# System bootloader configuration - quiet boot with splash
bootloader --location=mbr --boot-drive=sda --append="quiet splash loglevel=3 rd.udev.log_level=3 vt.global_cursor_default=0 systemd.show_status=false rd.systemd.show_status=false plymouth.enable=0 rd.plymouth=0 plymouth.ignore-serial-consoles"

# IMPORTANT: Btrfs partitioning for Snapper snapshots
zerombr
clearpart --all --initlabel

# Create partitions with Btrfs
part /boot/efi --fstype="efi" --size=512 --ondisk=sda
part /boot --fstype="ext4" --size=1024 --ondisk=sda
part btrfs.01 --fstype="btrfs" --size=1 --grow --ondisk=sda

# Create Btrfs subvolumes for Snapper
btrfs none --label=fedora --data=single btrfs.01
btrfs / --subvol --name=@ LABEL=fedora
btrfs /home --subvol --name=@home LABEL=fedora
btrfs /var --subvol --name=@var LABEL=fedora
btrfs /.snapshots --subvol --name=@snapshots LABEL=fedora

# Accept the license
eula --agreed

# Enable all repositories we'll need
repo --name=updates --mirrorlist=https://mirrors.fedoraproject.org/mirrorlist?repo=updates-released-f$releasever&arch=$basearch
repo --name=rpmfusion-free --install --mirrorlist=https://mirrors.rpmfusion.org/mirrorlist?repo=free-fedora-$releasever&arch=$basearch
repo --name=rpmfusion-free-updates --install --mirrorlist=https://mirrors.rpmfusion.org/mirrorlist?repo=free-fedora-updates-released-$releasever&arch=$basearch
repo --name=rpmfusion-nonfree --install --mirrorlist=https://mirrors.rpmfusion.org/mirrorlist?repo=nonfree-fedora-$releasever&arch=$basearch
repo --name=rpmfusion-nonfree-updates --install --mirrorlist=https://mirrors.rpmfusion.org/mirrorlist?repo=nonfree-fedora-updates-released-$releasever&arch=$basearch

%packages
# Core System
@core
@base-x
@fonts
@standard
@hardware-support
@networkmanager-submodules
@development-tools

# KDE Plasma Desktop
@kde-desktop
kde-settings
kde-settings-pulseaudio
kde-settings-plasma
sddm
sddm-themes
sddm-kcm
plasma-desktop
plasma-workspace
plasma-workspace-wayland
plasma-wayland-protocols
plasma-systemmonitor
plasma-pa
plasma-nm
plasma-thunderbolt
plasma-systemsettings
plasma-browser-integration
plasma-discover
plasma-discover-packagekit
plasma-discover-flatpak
plasma-disks
plasma-firewall
dolphin
dolphin-plugins
konsole
kate
ark
spectacle
gwenview
okular
kcalc
kwalletmanager
kscreen
kinfocenter
krdp

# KDE Applications
yakuake
krfb
krdc
ksystemlog
partitionmanager
filelight
kdf
kcharselect
kdialog

# Initial Setup for KDE
initial-setup
initial-setup-gui

# Plymouth (boot animation)
plymouth
plymouth-theme-breeze
plymouth-plugin-script
plymouth-plugin-fade-throbber
plymouth-system-theme

# GRUB theming and snapshot support
grub2-tools-extra
grub2-themes
grub-customizer
grub-btrfs
imagemagick  # For theme installation

# Btrfs and Snapper
btrfs-progs
snapper
snapper-gui
python3-dnf-plugin-snapper
inotify-tools

# Gaming Core Components
gamemode
gamemode-gtk
gamescope
mangohud
goverlay
steam
lutris
wine
wine-dxvk
wine-dxvk-dxgi
winetricks
protontricks
bottles
heroic-games-launcher

# Vulkan and Graphics
vulkan-tools
vulkan-loader
vulkan-headers
vulkan-validation-layers
vkBasalt
mesa-vulkan-drivers
mesa-vdpau-drivers
mesa-va-drivers
libva-utils
vdpauinfo

# 32-bit Libraries for Gaming
glibc.i686
glibc-devel.i686
libgcc.i686
libstdc++.i686
mesa-libGL.i686
mesa-libGLU.i686
mesa-dri-drivers.i686
mesa-vulkan-drivers.i686
vulkan-loader.i686
alsa-lib.i686
libXcomposite.i686
libXcursor.i686
libXi.i686
libXinerama.i686
libXrandr.i686
libXrender.i686
libXxf86vm.i686
openal-soft.i686
openssl.i686
pulseaudio-libs.i686
libva.i686
libvdpau.i686
libgcrypt.i686
gtk2.i686
gtk3.i686
libjpeg-turbo.i686
libpng.i686
libusb.i686
ocl-icd.i686
SDL2.i686
SDL2_image.i686
SDL2_mixer.i686
SDL2_ttf.i686
unixODBC.i686
samba-libs.i686
gnutls.i686

# Performance and System Tools
corectrl
earlyoom
zram-generator
preload
irqbalance
tuned
tuned-utils
tuned-profiles-atomic
htop
btop
nvtop
neofetch
inxi

# Multimedia Codecs and Libraries
ffmpeg
ffmpeg-libs
gstreamer1-plugins-base
gstreamer1-plugins-good
gstreamer1-plugins-good-extras
gstreamer1-plugins-bad-free
gstreamer1-plugins-bad-free-extras
gstreamer1-plugins-ugly-free
gstreamer1-libav
gstreamer1-vaapi
libdvdcss
libheif
pipewire
pipewire-alsa
pipewire-jack-audio-connection-kit
pipewire-pulseaudio
pipewire-utils
wireplumber
easyeffects
pavucontrol

# Additional Gaming-Related Software
discord
obs-studio
obs-studio-plugin-browser
obs-studio-plugin-websocket
obs-studio-plugin-vkcapture
joystickwake
antimicrox

# Flatpak Support
flatpak
xdg-desktop-portal
xdg-desktop-portal-kde
xdg-desktop-portal-wlr

# System Utilities
kernel-tools
kernel-devel
kernel-headers
pciutils
wget
curl

# Development Tools (for building Proton-GE and other tools)
git
gcc
gcc-c++
make
cmake
meson
ninja-build
patch
autoconf
automake

# Python tools
python3-pip
python3-setuptools

# File System Tools
ntfs-3g
exfat-utils
fuse-exfat

# Compression Tools
p7zip
p7zip-plugins
unrar
unzip

# Terminal Emulators and Shells
fish
zsh
alacritty

# Text Editors
vim
nano
micro

%end

%post --log=/root/kickstart-post.log
#!/bin/bash

echo "Starting post-installation configuration..."

# Detect and install NVIDIA drivers if NVIDIA GPU is present
echo "Checking for NVIDIA GPU..."
if lspci | grep -i nvidia > /dev/null; then
    echo "NVIDIA GPU detected. Installing drivers..."
    dnf install -y akmod-nvidia xorg-x11-drv-nvidia xorg-x11-drv-nvidia-libs xorg-x11-drv-nvidia-libs.i686
    dnf install -y nvidia-vaapi-driver nvidia-settings
    dnf install -y xorg-x11-drv-nvidia-cuda xorg-x11-drv-nvidia-cuda-libs
    dnf install -y nvidia-gpu-firmware
    
    # Configure NVIDIA for Wayland
    cat > /etc/modprobe.d/nvidia.conf << 'EOF'
options nvidia-drm modeset=1
options nvidia NVreg_UsePageAttributeTable=1
options nvidia NVreg_EnablePCIeGen3=1
EOF
    
    # Enable nvidia services
    systemctl enable nvidia-hibernate.service
    systemctl enable nvidia-suspend.service
    systemctl enable nvidia-resume.service
    
    echo "NVIDIA drivers installed successfully"
else
    echo "No NVIDIA GPU detected. Skipping NVIDIA driver installation."
fi

# Enable RPM Fusion repositories (backup method if repo commands fail)
dnf install -y \
  https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
  https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# Configure Snapper for automatic snapshots
echo "Configuring Snapper..."

# Wait for the filesystem to be ready
sleep 5

# Create snapper configuration for root
snapper -c root create-config /
snapper -c home create-config /home

# Configure snapper for root
cat > /etc/snapper/configs/root << 'EOF'
SUBVOLUME="/"
FSTYPE="btrfs"
ALLOW_USERS=""
ALLOW_GROUPS=""
TIMELINE_CREATE="yes"
TIMELINE_CLEANUP="yes"
TIMELINE_LIMIT_HOURLY="5"
TIMELINE_LIMIT_DAILY="7"
TIMELINE_LIMIT_WEEKLY="4"
TIMELINE_LIMIT_MONTHLY="6"
TIMELINE_LIMIT_YEARLY="2"
TIMELINE_MIN_AGE="1800"
EMPTY_PRE_POST_CLEANUP="yes"
EMPTY_PRE_POST_MIN_AGE="1800"
NUMBER_CLEANUP="yes"
NUMBER_MIN_AGE="1800"
NUMBER_LIMIT="50"
NUMBER_LIMIT_IMPORTANT="10"
EOF

# Configure snapper for home
cat > /etc/snapper/configs/home << 'EOF'
SUBVOLUME="/home"
FSTYPE="btrfs"
ALLOW_USERS=""
ALLOW_GROUPS=""
TIMELINE_CREATE="yes"
TIMELINE_CLEANUP="yes"
TIMELINE_LIMIT_HOURLY="3"
TIMELINE_LIMIT_DAILY="3"
TIMELINE_LIMIT_WEEKLY="2"
TIMELINE_LIMIT_MONTHLY="2"
TIMELINE_LIMIT_YEARLY="1"
TIMELINE_MIN_AGE="1800"
EMPTY_PRE_POST_CLEANUP="yes"
EMPTY_PRE_POST_MIN_AGE="1800"
NUMBER_CLEANUP="yes"
NUMBER_MIN_AGE="1800"
NUMBER_LIMIT="30"
NUMBER_LIMIT_IMPORTANT="10"
EOF

# Enable snapper services
systemctl enable snapper-timeline.timer
systemctl enable snapper-cleanup.timer
systemctl enable snapper-boot.timer

# Configure grub-btrfs
cat > /etc/default/grub-btrfs/config << 'EOF'
#!/bin/bash
# Configuration for grub-btrfs

# Show snapshots in grub menu
GRUB_BTRFS_SHOW_SNAPSHOTS_FOUND="true"
GRUB_BTRFS_SHOW_SNAPSHOTS_FOUND_TITLE="Fedora Linux Snapshots"
GRUB_BTRFS_TITLE_FORMAT="(%s) %y-%m-%d %H:%M:%S %r"
GRUB_BTRFS_LIMIT="10"
GRUB_BTRFS_SUBVOLUME_SORT="descending"
GRUB_BTRFS_SHOW_KERNEL_PARAMETERS="true"
GRUB_BTRFS_SNAPSHOT_KERNEL_PARAMETERS=""
GRUB_BTRFS_GRUB_DIRNAME="/boot/grub2"
GRUB_BTRFS_MKCONFIG="/usr/sbin/grub2-mkconfig"
GRUB_BTRFS_SCRIPT_CHECK="grub2-script-check"
EOF

# Enable grub-btrfs
systemctl enable grub-btrfs.path

# Install and configure Vimix GRUB theme
echo "Installing Vimix GRUB theme..."
cd /tmp
git clone https://github.com/vinceliuice/grub2-themes.git
cd grub2-themes

# Install Vimix theme with custom options
./install.sh -b -t vimix -s 1080p

# Configure GRUB for pretty boot
cat >> /etc/default/grub << 'EOF'

# Pretty boot configuration
GRUB_TIMEOUT=5
GRUB_TIMEOUT_STYLE=menu
GRUB_DISTRIBUTOR="Fedora Gaming"
GRUB_DISABLE_SUBMENU=false
GRUB_TERMINAL_OUTPUT="gfxterm"
GRUB_GFXMODE=1920x1080x32
GRUB_GFXPAYLOAD_LINUX=keep
GRUB_DISABLE_OS_PROBER=false

# Remove verbose boot messages
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash loglevel=3 rd.udev.log_level=3 vt.global_cursor_default=0 systemd.show_status=false rd.systemd.show_status=false plymouth.enable=0 rd.plymouth=0"

# Theme
GRUB_THEME="/boot/grub2/themes/Vimix/theme.txt"
EOF

# Update GRUB configuration
grub2-mkconfig -o /boot/grub2/grub.cfg

# Configure Plymouth for KDE
plymouth-set-default-theme breeze -R

# Enable Flathub
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Install additional Flatpak applications
flatpak install -y flathub com.heroicgameslauncher.hgl
flatpak install -y flathub net.davidotek.pupgui2  # ProtonUp-Qt for managing Proton-GE
flatpak install -y flathub com.github.Matoking.protontricks
flatpak install -y flathub io.github.flattool.Warehouse
flatpak install -y flathub org.kde.kdenlive
flatpak install -y flathub org.kde.krita

# Create directory for Proton-GE installation script
mkdir -p /usr/local/bin

# Create Proton-GE installer script for users
cat > /usr/local/bin/install-proton-ge << 'EOF'
#!/bin/bash
# Script to install latest Proton-GE for current user

PROTON_GE_URL="https://api.github.com/repos/GloriousEggroll/proton-ge-custom/releases/latest"
STEAM_COMPAT_DIR="$HOME/.steam/root/compatibilitytools.d"

echo "Installing latest Proton-GE for $USER..."

# Create compatibility tools directory
mkdir -p "$STEAM_COMPAT_DIR"

# Get latest release URL
LATEST_RELEASE=$(curl -s $PROTON_GE_URL | grep "browser_download_url.*tar.gz" | cut -d '"' -f 4 | head -1)

if [ -z "$LATEST_RELEASE" ]; then
    echo "Error: Could not fetch latest Proton-GE release"
    exit 1
fi

FILENAME=$(basename "$LATEST_RELEASE")
echo "Downloading $FILENAME..."

# Download and extract
cd /tmp
wget -q --show-progress "$LATEST_RELEASE"
echo "Extracting to Steam compatibility tools directory..."
tar -xzf "$FILENAME" -C "$STEAM_COMPAT_DIR"
rm "$FILENAME"

echo "Proton-GE installed successfully!"
echo "Restart Steam to see it in compatibility tools"
EOF

chmod +x /usr/local/bin/install-proton-ge

# Create snapshot management helper script
cat > /usr/local/bin/snapshot-manager << 'EOF'
#!/bin/bash
# Simple snapshot management helper

case "$1" in
    create)
        echo "Creating manual snapshot..."
        snapper -c root create -d "${2:-Manual snapshot}" --userdata important=yes
        snapper -c home create -d "${2:-Manual snapshot}" --userdata important=yes
        echo "Snapshot created. Updating GRUB..."
        grub2-mkconfig -o /boot/grub2/grub.cfg
        echo "Done!"
        ;;
    list)
        echo "=== Root snapshots ==="
        snapper -c root list
        echo ""
        echo "=== Home snapshots ==="
        snapper -c home list
        ;;
    cleanup)
        echo "Cleaning up old snapshots..."
        snapper -c root cleanup number
        snapper -c home cleanup number
        echo "Updating GRUB..."
        grub2-mkconfig -o /boot/grub2/grub.cfg
        echo "Done!"
        ;;
    *)
        echo "Usage: snapshot-manager {create|list|cleanup} [description]"
        echo ""
        echo "  create [description]  - Create a new snapshot with optional description"
        echo "  list                  - List all snapshots"
        echo "  cleanup              - Clean up old snapshots according to policy"
        ;;
esac
EOF

chmod +x /usr/local/bin/snapshot-manager

# Create first-login setup script
cat > /etc/profile.d/gaming-first-login.sh << 'EOF'
#!/bin/bash
if [ ! -f ~/.gaming-setup-complete ] && [ -n "$DISPLAY" ]; then
    echo "Initializing gaming environment for $USER..."
    
    # Create gaming directories
    mkdir -p ~/Games
    mkdir -p ~/.local/share/applications
    mkdir -p ~/.config/MangoHud
    mkdir -p ~/.config/vkBasalt
    
    # Setup MangoHud config
    cat > ~/.config/MangoHud/MangoHud.conf << 'MHEOF'
toggle_fps_limit=F1
toggle_hud=Shift_R+F12
fps_limit=144,60,0
vsync=0
gpu_stats
gpu_temp
gpu_load_change
gpu_load_value=50,90
gpu_load_color=FFFFFF,FFAA7F,CC0000
gpu_text=GPU
cpu_stats
cpu_temp
cpu_load_change
core_load_change
cpu_load_value=50,90
cpu_load_color=FFFFFF,FFAA7F,CC0000
cpu_color=2e97cb
cpu_text=CPU
io_color=a491d3
vram
vram_color=ad64c1
ram
ram_color=c26693
fps
engine_color=eb5b5b
gpu_color=2e9762
wine_color=eb5b5b
frame_timing=1
frametime_color=00ff00
media_player_color=ffffff
background_alpha=0.3
font_size=24
background_color=020202
position=top-left
text_color=ffffff
round_corners=10
MHEOF
    
    # Setup vkBasalt config
    cat > ~/.config/vkBasalt/vkBasalt.conf << 'VKEOF'
effects = cas
cas = /usr/share/vkBasalt/shaders/cas.frag.spv
casSharpness = 0.5
VKEOF
    
    # Install Proton-GE automatically
    /usr/local/bin/install-proton-ge
    
    # Create Steam launch options helper
    cat > ~/Games/steam-launch-options.txt << 'SLEOF'
# Useful Steam Launch Options for Games:

# Enable GameMode and MangoHud:
gamemoderun mangohud %command%

# For Nvidia users with VRR/G-Sync:
__GL_GSYNC_ALLOWED=1 __GL_VRR_ALLOWED=1 %command%

# For better Proton compatibility:
PROTON_ENABLE_NVAPI=1 PROTON_HIDE_NVIDIA_GPU=0 VKD3D_CONFIG=dxr %command%

# Full combination example:
gamemoderun __GL_GSYNC_ALLOWED=1 __GL_VRR_ALLOWED=1 mangohud %command%

# For problematic games (try if game doesn't launch):
PROTON_USE_WINED3D=1 %command%
SLEOF
    
    # Create a desktop notification about gaming setup
    notify-send "Gaming Setup Complete" "Proton-GE installed. Check ~/Games/steam-launch-options.txt for tips!" -i applications-games
    
    touch ~/.gaming-setup-complete
fi
EOF

chmod +x /etc/profile.d/gaming-first-login.sh

# Configure GameMode
cat > /etc/gamemode.ini << 'EOF'
[general]
renice=10
inhibit_screensaver=1

[gpu]
apply_gpu_optimisations=accept-responsibility
gpu_device=0
amd_performance_level=high
nvidia_powermizer_mode=1
nvidia_perf_level_min=2
nvidia_perf_level_max=3

[cpu]
park_cores=no
pin_cores=yes

[custom]
start=notify-send "GameMode started"
end=notify-send "GameMode ended"
EOF

# Enable and configure services
systemctl enable tuned
systemctl enable earlyoom
systemctl enable irqbalance
systemctl enable sddm

# Set tuned profile for balanced performance
tuned-adm profile balanced

# Configure zram
cat > /etc/systemd/zram-generator.conf << 'EOF'
[zram0]
zram-size = min(ram / 2, 4096)
compression-algorithm = zstd
EOF

# Configure swappiness for gaming
echo "vm.swappiness=10" >> /etc/sysctl.d/99-gaming.conf
echo "vm.vfs_cache_pressure=50" >> /etc/sysctl.d/99-gaming.conf

# Increase file descriptor limits
cat > /etc/security/limits.d/99-gaming.conf << 'EOF'
* soft nofile 524288
* hard nofile 524288
EOF

# Add multilib repo configuration (for better 32-bit support)
echo "multilib_policy=best" >> /etc/dnf/dnf.conf
echo "max_parallel_downloads=10" >> /etc/dnf/dnf.conf
echo "fastestmirror=True" >> /etc/dnf/dnf.conf

# Configure SDDM for autologin (disabled by default)
cat > /etc/sddm.conf.d/kde_settings.conf << 'EOF'
[Theme]
Current=breeze

[Users]
MaximumUid=60000
MinimumUid=1000
EOF

# Create README for user
cat > /etc/skel/README-GAMING.txt << 'EOF'
Welcome to your Fedora KDE Gaming System!
==========================================

This system has been optimized for gaming with:

🎮 Gaming Components:
- Steam with Proton support
- Lutris for non-Steam games  
- GameMode for performance optimization
- MangoHud for performance monitoring
- Latest Proton-GE (installed on first login)
- Full multimedia codec support
- Vulkan and 32-bit libraries
- Auto-detected and installed GPU drivers

🖥️ System Features:
- KDE Plasma desktop environment
- Beautiful Vimix GRUB theme with snapshot support
- Automatic Btrfs snapshots with Snapper
- Clean, quiet boot process
- Optimized for gaming performance

📸 Snapshot Management:
- Automatic hourly/daily/weekly snapshots
- Boot directly into snapshots from GRUB menu
- Use 'snapshot-manager' command:
  • snapshot-manager create "Description" - Create manual snapshot
  • snapshot-manager list - List all snapshots
  • snapshot-manager cleanup - Clean old snapshots

🎯 Useful Commands:
- install-proton-ge - Update to latest Proton-GE
- gamemode-simulate - Test if GameMode is working
- mangohud glxgears - Test MangoHud overlay
- snapshot-manager - Manage system snapshots
- snapper-gui - GUI for snapshot management

🚀 For Steam games, add to launch options:
gamemoderun mangohud %command%

📝 Check ~/Games/steam-launch-options.txt for more launch option examples.

ProtonUp-Qt is available as a Flatpak for managing Proton versions.
Use Discover to find and install additional software.

Enjoy gaming on Fedora KDE!
EOF

# Create initial system snapshot
echo "Creating initial system snapshot..."
snapper -c root create -d "Initial system installation" --userdata important=yes
snapper -c home create -d "Initial system installation" --userdata important=yes

# Final GRUB update to include snapshots
grub2-mkconfig -o /boot/grub2/grub.cfg

echo "Post-installation configuration complete!"
echo "System will reboot into a beautiful, gaming-ready KDE environment!"

%end

# Reboot after installation
reboot